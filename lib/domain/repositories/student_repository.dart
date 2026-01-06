// lib/domain/repositories/student_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/student.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<Student>>> getStudents(String grade);
  Future<Either<Failure, void>> addStudent(Student student);
  Future<Either<Failure, void>> updateStudent(Student student);
  Future<Either<Failure, void>> deleteStudent(String id);
}
