import 'package:injectable/injectable.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/local/local_student_datasource.dart';
import '../models/student_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

@LazySingleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final LocalStudentDataSource localDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Cache validity duration
  static const Duration cacheValidity = Duration(hours: 24);

  StudentRepositoryImpl(this.localDataSource);

  @override
  Future<void> addStudent(Student student) async {
    await localDataSource.addStudent(StudentModel.fromEntity(student));
    // Background sync to Firestore would happen here or via SyncRepo
    try {
      await _firestore.collection('students').doc(student.id).set(
        StudentModel.fromEntity(student).toJson()
      );
    } catch (e) {
      developer.log('Failed to sync new student to Firestore', error: e);
    }
  }

  @override
  Future<void> deleteStudent(String id) {
    return localDataSource.deleteStudent(id);
  }

  @override
  Future<List<Student>> getStudents(String grade, {bool forceRefresh = false}) async {
    // 1. Check Local Cache
    final localStudents = await localDataSource.getStudents(grade);

    if (localStudents.isNotEmpty && !forceRefresh) {
      final oldestFetch = localStudents.map((s) => s.lastFetchTime).whereType<DateTime>().fold(
        DateTime.now(),
        (a, b) => a.isBefore(b) ? a : b
      );

      final isExpired = DateTime.now().difference(oldestFetch) > cacheValidity;

      if (!isExpired) {
        return localStudents;
      }
    }

    // 2. Fetch from Firestore (Cache Miss or Expired)
    try {
      final snapshot = await _firestore
          .collection('students')
          .where('grade', isEqualTo: grade)
          .get();

      final remoteStudents = snapshot.docs
          .map((doc) => StudentModel.fromJson(doc.data()))
          .toList();

      // Update Local Cache
      // We need to preserve 'lastFetchTime' as Now
      final updatedStudents = remoteStudents.map((s) => s.copyWith(lastFetchTime: DateTime.now())).toList();

      // Bulk save (assuming addStudent handles upsert or we loop)
      for (var s in updatedStudents) {
        await localDataSource.addStudent(s);
      }

      return updatedStudents;

    } catch (e) {
      developer.log('Remote fetch failed, returning local cache', error: e);
      return localStudents;
    }
  }
}
