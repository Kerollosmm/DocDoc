import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import '../../core/error/failures.dart';
import '../../core/utils/error_handler.dart';
import '../../core/network/network_info.dart';
import '../../core/services/excel_service.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/local/local_student_datasource.dart';
import '../models/student_model.dart';

@LazySingleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final LocalStudentDataSource localDataSource;
  final NetworkInfo networkInfo;
  final ExcelService excelService;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache validity duration
  static const Duration cacheValidity = Duration(hours: 24);

  StudentRepositoryImpl(this.localDataSource, this.networkInfo, this.excelService);

  @override
  Future<Either<Failure, void>> addStudent(Student student) async {
    try {
      await localDataSource.addStudent(StudentModel.fromEntity(student));

      if (await networkInfo.isConnected) {
        try {
          await _firestore.collection('students').doc(student.id).set(
            StudentModel.fromEntity(student).toJson()
          );
        } catch (e, s) {
           ErrorHandler.logError(e, s, context: 'AddStudent Remote Sync');
        }
      }
      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  Future<Either<Failure, void>> updateStudent(Student student) async {
    try {
      // Reuse add logic since Hive put overwrites based on key (ID)
      return await addStudent(student);
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
    if (await networkInfo.isConnected) {
      try {
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

        final snapshot = await _firestore
            .collection('students')
            .where('grade', isEqualTo: grade)
            .get();

        final remoteStudents = snapshot.docs
            .map((doc) => StudentModel.fromJson(doc.data()))
            .toList();

        final updatedStudents = remoteStudents.map((s) => s.copyWith(lastFetchTime: DateTime.now())).toList();

        for (var s in updatedStudents) {
          await localDataSource.addStudent(s);
        }

        return Right(updatedStudents);
      } catch (error, stackTrace) {
        ErrorHandler.logError(error, stackTrace, context: 'GetStudents Remote');

        try {
          final localStudents = await localDataSource.getStudents(grade);
          return Right(localStudents);
        } catch (cacheError) {
           return Left(ErrorHandler.handle(cacheError));
        }
      }
    } else {
      try {
        final localStudents = await localDataSource.getStudents(grade);
        return Right(localStudents);
      } catch (error) {
        return Left(const OfflineFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Student>>> importStudentsFromExcel(String filePath, String grade) async {
    try {
      final bytes = await File(filePath).readAsBytes();
      final students = await excelService.parseStudents(bytes, grade);

      for (var student in students) {
        await addStudent(student); // Saves to local and attempts remote
      }

      return Right(students);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }
}
