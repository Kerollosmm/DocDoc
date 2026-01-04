import 'package:injectable/injectable.dart';
import '../../domain/entities/student.dart';
import '../../domain/repositories/student_repository.dart';
import '../datasources/local/local_student_datasource.dart';
import '../models/student_model.dart';

@LazySingleton(as: StudentRepository)
class StudentRepositoryImpl implements StudentRepository {
  final LocalStudentDataSource localDataSource;

  StudentRepositoryImpl(this.localDataSource);

  @override
  Future<void> addStudent(Student student) {
    return localDataSource.addStudent(StudentModel.fromEntity(student));
  }

  @override
  Future<void> deleteStudent(String id) {
    return localDataSource.deleteStudent(id);
  }

  @override
  Future<List<Student>> getStudents(String grade) async {
    final models = await localDataSource.getStudents(grade);
    return models;
  }
}
