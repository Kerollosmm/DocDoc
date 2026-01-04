import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../../models/student_model.dart';

abstract class LocalStudentDataSource {
  Future<List<StudentModel>> getStudents(String grade);
  Future<void> addStudent(StudentModel student);
  Future<void> deleteStudent(String id);
}

@LazySingleton(as: LocalStudentDataSource)
class HiveStudentDataSource implements LocalStudentDataSource {
  static const String boxName = 'students';

  @override
  Future<void> addStudent(StudentModel student) async {
    final box = await Hive.openBox<StudentModel>(boxName);
    await box.put(student.id, student);
  }

  @override
  Future<void> deleteStudent(String id) async {
    final box = await Hive.openBox<StudentModel>(boxName);
    await box.delete(id);
  }

  @override
  Future<List<StudentModel>> getStudents(String grade) async {
    final box = await Hive.openBox<StudentModel>(boxName);
    return box.values.where((s) => s.grade == grade).toList();
  }
}
