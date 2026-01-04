import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/error/failures.dart';
import '../../core/utils/error_handler.dart';
import '../../core/network/network_info.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/local/local_student_datasource.dart';
import '../models/student_model.dart';

@LazySingleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final LocalStudentDataSource localDataSource;
  final NetworkInfo networkInfo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache validity duration
  static const Duration cacheValidity = Duration(hours: 24);

  StudentRepositoryImpl(this.localDataSource, this.networkInfo);

  @override
  Future<Either<Failure, void>> addStudent(Student student) async {
    try {
      await localDataSource.addStudent(StudentModel.fromEntity(student));

      // Try to sync if online, otherwise just return success (local)
      // The SyncRepository is responsible for background sync, but we attempt an immediate push here as best-effort
      if (await networkInfo.isConnected) {
        try {
          await _firestore.collection('students').doc(student.id).set(
            StudentModel.fromEntity(student).toJson()
          );
        } catch (e, s) {
           // If remote fails, we just log it. The student is saved locally.
           // Future sync (SyncRepository) should pick this up.
           ErrorHandler.logError(e, s, context: 'AddStudent Remote Sync');
        }
      }
      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(String id) async {
     try {
       await localDataSource.deleteStudent(id);
       if (await networkInfo.isConnected) {
         try {
           await _firestore.collection('students').doc(id).delete();
         } catch (e, s) {
           ErrorHandler.logError(e, s, context: 'DeleteStudent Remote Sync');
         }
       }
       return const Right(null);
     } catch (e, s) {
       return Left(ErrorHandler.handle(e, s));
     }
  }

  @override
  Future<Either<Failure, List<Student>>> getStudents(String grade, {bool forceRefresh = false}) async {
    // Feature #5: Fallback Mechanism

    // Step 1: Check Internet
    if (await networkInfo.isConnected) {
      try {
        // Check cache validity first if not forced
        if (!forceRefresh) {
          final localStudents = await localDataSource.getStudents(grade);
          if (localStudents.isNotEmpty) {
             final oldestFetch = localStudents.map((s) => s.lastFetchTime).whereType<DateTime>().fold(
              DateTime.now(),
              (a, b) => a.isBefore(b) ? a : b
            );
            final isExpired = DateTime.now().difference(oldestFetch) > cacheValidity;
            if (!isExpired) {
              return Right(localStudents);
            }
          }
        }

        // Happy Path: Fetch from Server
        final snapshot = await _firestore
            .collection('students')
            .where('grade', isEqualTo: grade)
            .get();

        final remoteStudents = snapshot.docs
            .map((doc) => StudentModel.fromJson(doc.data()))
            .toList();

        // Save to Local Cache (Hive) for next time
        // We need to preserve 'lastFetchTime' as Now
        final updatedStudents = remoteStudents.map((s) => s.copyWith(lastFetchTime: DateTime.now())).toList();

        for (var s in updatedStudents) {
          await localDataSource.addStudent(s);
        }

        return Right(updatedStudents);
      } catch (error, stackTrace) {
        // If Server fails, Log it but don't crash!
        ErrorHandler.logError(error, stackTrace, context: 'GetStudents Remote');

        // FALLBACK: Try to fetch from Local Cache instead
        try {
          final localStudents = await localDataSource.getStudents(grade);
          return Right(localStudents);
        } catch (cacheError) {
           // If both fail, return the Failure
           return Left(ErrorHandler.handle(cacheError));
        }
      }
    } else {
      // Offline Mode: Go straight to Cache
      try {
        final localStudents = await localDataSource.getStudents(grade);
        return Right(localStudents);
      } catch (error) {
        return Left(const OfflineFailure());
      }
    }
  }
}
