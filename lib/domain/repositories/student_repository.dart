import '../../domain/entities/student.dart';

abstract class StudentRepository {
  Future<List<Student>> getStudents(String grade, {bool forceRefresh = false});
  Future<void> addStudent(Student student);
  Future<void> deleteStudent(String id);
}
