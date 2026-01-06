import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../../../core/services/hive_cipher_service.dart';
import '../../models/attendance_record_model.dart';

abstract class LocalAttendanceDataSource {
  Future<List<AttendanceRecordModel>> getAttendance(String date, String grade);
  Future<void> saveAttendance(AttendanceRecordModel record);
  Future<void> bulkSaveAttendance(List<AttendanceRecordModel> records);
}

@LazySingleton(as: LocalAttendanceDataSource)
class HiveAttendanceDataSource implements LocalAttendanceDataSource {
  static const String boxName = 'attendance';
  final FlutterSecureStorage _secureStorage;

  HiveAttendanceDataSource(this._secureStorage);

  Future<Box<AttendanceRecordModel>> _openBox() async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<AttendanceRecordModel>(boxName);
    }
    final cipher = await HiveCipherService(_secureStorage).getEncryptionCipher();
    return Hive.openBox<AttendanceRecordModel>(boxName, encryptionCipher: cipher);
  }

  @override
  Future<List<AttendanceRecordModel>> getAttendance(String date, String grade) async {
    final box = await _openBox();
    return box.values.where((r) => r.date == date).toList();
  }

  @override
  Future<void> saveAttendance(AttendanceRecordModel record) async {
    final box = await _openBox();
    final key = '${record.date}_${record.studentId}';
    await box.put(key, record);
  }

  @override
  Future<void> bulkSaveAttendance(List<AttendanceRecordModel> records) async {
    final box = await _openBox();
    final Map<String, AttendanceRecordModel> entries = {};
    for (var r in records) {
      entries['${r.date}_${r.studentId}'] = r;
    }
    await box.putAll(entries);
  }
}
