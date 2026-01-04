import '../../domain/entities/attendance_record.dart';

/// Repository interface for managing attendance records.
///
/// This repository abstracts the underlying data sources (Local Hive DB and Remote Firestore).
/// It handles data fetching, caching strategies, and synchronization of attendance data.
///
/// Key strategies:
/// - **Offline-first**: Reads from local Hive cache first.
/// - **Daily Class Document**: Optimizes Firestore reads by aggregating records into daily sheets.
abstract class AttendanceRepository {
  /// Retrieves attendance records for a specific date and grade.
  ///
  /// This method should prioritize local cache and only fetch from remote
  /// if the cache is expired or missing.
  ///
  /// [date] - The date for which attendance is requested (format YYYY-MM-DD).
  /// [grade] - The grade level to filter students.
  Future<List<AttendanceRecord>> getAttendance(String date, String grade);

  /// Marks a student's attendance.
  ///
  /// This updates the local database immediately and triggers a background sync
  /// to Firestore. The [record] contains the student's ID, status, and other metadata.
  Future<void> markAttendance(AttendanceRecord record);
}
