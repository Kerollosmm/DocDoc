import 'package:injectable/injectable.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasources/local/local_attendance_datasource.dart';
import '../models/attendance_record_model.dart';
import 'dart:developer' as developer;

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final LocalAttendanceDataSource _localDataSource;
  final SyncRepository _syncRepo;

  AttendanceRepositoryImpl(this._localDataSource, this._syncRepo);

  @override
  Future<List<AttendanceRecord>> getAttendance(String date, String grade) async {
    final models = await _localDataSource.getAttendance(date, grade);
    return models;
  }

  @override
  Future<void> markAttendance(AttendanceRecord record) async {
    await _localDataSource.saveAttendance(AttendanceRecordModel.fromEntity(record));

    // Auto-Sync (Fire & Forget)
    try {
      _syncRepo.syncAttendance(record.date, record.grade);
    } catch (e) {
      developer.log('Auto-Sync failed', error: e, name: 'AttendanceRepository');
    }
  }
}
