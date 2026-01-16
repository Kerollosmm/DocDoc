import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class StudentsRepository {
  Future<Either<Failure, List<StudentEntity>>> getStudents({String? grade, String? group});
  Future<Either<Failure, void>> addStudent(StudentEntity student);
}
