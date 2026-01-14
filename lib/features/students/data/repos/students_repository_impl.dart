import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_app/core/config/hive_boxes_config.dart';
import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/students/data/models/student_model.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:doc_app/features/students/domain/repos/students_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudentsRepositoryImpl implements StudentsRepository {
  final FirebaseFirestore _firestore;
  final Box _studentsBox;

  StudentsRepositoryImpl(this._firestore, this._studentsBox);

  @override
  Future<Either<Failure, void>> addStudent(StudentEntity student) async {
    try {
      final model = StudentModel.fromEntity(student);
      // Optimistic update: Save to Hive first
      await _studentsBox.put(student.studentId, {
        ...model.toJson(),
        'syncStatus': 'pending', // Mark as pending sync
      });

      // Try to save to Firestore if online (handled by sync service or direct try-catch)
      // Here we will try to write directly, and if it fails, it remains in Hive with 'pending'
      // Ideally SyncService handles the background sync, but for immediate feedback we can try.

      // For simplicity in this step, we just save to Hive. The SyncService will pick it up.
      // But let's try a direct write to simulate "online first" or "hybrid".
      // Actually, plan says "Offline first", so Hive is primary.

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<StudentEntity>>> getStudents({String? grade, String? group}) async {
    try {
      // Read from Hive
      final localData = _studentsBox.values.toList();
      final students = localData.map((e) => StudentModel.fromJson(Map<String, dynamic>.from(e))).toList();

      // Filter if needed
      var filtered = students;
      if (grade != null) filtered = filtered.where((s) => s.grade == grade).toList();
      if (group != null) filtered = filtered.where((s) => s.group == group).toList();

      return Right(filtered);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
