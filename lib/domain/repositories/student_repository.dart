import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/student.dart';

abstract class StudentRepository {
  Future<Either<Failure, List<Student>>> getStudents(String grade, {bool forceRefresh = false});
  Future<Either<Failure, void>> addStudent(Student student);
  Future<Either<Failure, void>> deleteStudent(String id);
}
