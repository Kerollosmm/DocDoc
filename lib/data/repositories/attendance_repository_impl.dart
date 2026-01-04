import 'package:injectable/injectable.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/local/local_attendance_datasource.dart';
import '../models/attendance_record_model.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final LocalAttendanceDataSource _localDataSource;

  AttendanceRepositoryImpl(this._localDataSource);

  @override
  Future<List<AttendanceRecord>> getAttendance(String date, String grade) async {
    final models = await _localDataSource.getAttendance(date, grade);
    return models;
  }

  @override
  Future<void> markAttendance(AttendanceRecord record) async {
    await _localDataSource.saveAttendance(AttendanceRecordModel.fromEntity(record));
    // TODO: Trigger background sync to Firestore
  }
}
