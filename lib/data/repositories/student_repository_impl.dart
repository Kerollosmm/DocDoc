// lib/data/repositories/student_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/local/hive_database.dart';
import '../models/student_model.dart';

@LazySingleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final Box<StudentModel> _studentBox = Hive.box<StudentModel>(HiveDatabase.studentsBox);

  @override
  Future<Either<Failure, List<Student>>> getStudents(String grade) async {
    try {
      final students = _studentBox.values
          .where((s) => s.grade == grade && s.isActive)
          .map((s) => s.toEntity())
          .toList();
      return Right(students);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addStudent(Student student) async {
    try {
      final model = StudentModel.fromEntity(student);
      await _studentBox.put(student.id, model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateStudent(Student student) async {
    try {
      final model = StudentModel.fromEntity(student);
      await _studentBox.put(student.id, model);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteStudent(String id) async {
    try {
      final student = _studentBox.get(id);
      if (student != null) {
        final updated = student.copyWith(isActive: false);
        await _studentBox.put(id, updated);
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
