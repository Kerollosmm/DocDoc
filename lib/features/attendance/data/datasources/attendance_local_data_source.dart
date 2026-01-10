import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/core/config/hive_boxes_config.dart';
import 'package:csms/features/attendance/data/models/servant_model.dart';
import 'package:csms/features/attendance/data/models/attendance_record_model.dart';

abstract class AttendanceLocalDataSource {
  Future<void> cacheServants(List<ServantModel> servants);
  Future<List<ServantModel>> getServants();
  Future<void> saveAttendanceRecord(AttendanceRecordModel record);
  Future<List<AttendanceRecordModel>> getPendingAttendance();
  Future<void> updateRecord(AttendanceRecordModel record);
  Future<List<AttendanceRecordModel>> getAllRecords();
}

@LazySingleton(as: AttendanceLocalDataSource)
class HiveAttendanceDataSource implements AttendanceLocalDataSource {

  Future<Box> get _servantsBox async => Hive.openBox(HiveBoxesConfig.servantsBox);
  Future<Box> get _attendanceBox async => Hive.openBox(HiveBoxesConfig.attendanceBox);

  @override
  Future<void> cacheServants(List<ServantModel> servants) async {
    final box = await _servantsBox;
    await box.clear(); // Overwrite cache
    for (var servant in servants) {
      await box.put(servant.id, jsonEncode(servant.toJson()));
    }
  }

  @override
  Future<List<ServantModel>> getServants() async {
    final box = await _servantsBox;
    return box.values.map((e) => ServantModel.fromJson(jsonDecode(e))).toList();
  }

  @override
  Future<void> saveAttendanceRecord(AttendanceRecordModel record) async {
    final box = await _attendanceBox;
    await box.put(record.id, jsonEncode(record.toJson()));
  }

  @override
  Future<List<AttendanceRecordModel>> getPendingAttendance() async {
    final box = await _attendanceBox;
    final all = box.values.map((e) => AttendanceRecordModel.fromJson(jsonDecode(e))).toList();
    return all.where((e) => e.isSynced == false).toList();
  }

  @override
  Future<void> updateRecord(AttendanceRecordModel record) async {
    final box = await _attendanceBox;
    await box.put(record.id, jsonEncode(record.toJson()));
  }

  @override
  Future<List<AttendanceRecordModel>> getAllRecords() async {
    final box = await _attendanceBox;
    return box.values.map((e) => AttendanceRecordModel.fromJson(jsonDecode(e))).toList();
  }
}
