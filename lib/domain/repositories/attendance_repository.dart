import '../../domain/entities/attendance_record.dart';

abstract class AttendanceRepository {
  Future<List<AttendanceRecord>> getAttendance(String date, String grade);
  Future<void> markAttendance(AttendanceRecord record);
}
