import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../../../core/services/hive_cipher_service.dart';
import '../../models/student_model.dart';

abstract class LocalStudentDataSource {
  Future<List<StudentModel>> getStudents(String grade);
  Future<void> addStudent(StudentModel student);
  Future<void> deleteStudent(String id);
}

@LazySingleton(as: LocalStudentDataSource)
class HiveStudentDataSource implements LocalStudentDataSource {
  static const String boxName = 'students';
  final FlutterSecureStorage _secureStorage;

  HiveStudentDataSource(this._secureStorage);

  Future<Box<StudentModel>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<StudentModel>(boxName);
    }
    final cipher = await HiveCipherService(_secureStorage).getEncryptionCipher();
    return Hive.openBox<StudentModel>(boxName, encryptionCipher: cipher);
  }

  @override
  Future<void> addStudent(StudentModel student) async {
    final box = await _openBox();
    await box.put(student.id, student);
  }

  @override
  Future<void> deleteStudent(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  @override
  Future<List<StudentModel>> getStudents(String grade) async {
    final box = await _openBox();
    return box.values.where((s) => s.grade == grade).toList();
  }
}
