import 'package:injectable/injectable.dart';
import 'package:hive/hive.dart';
import '../../models/attendance_record_model.dart';

abstract class LocalAttendanceDataSource {
  Future<List<AttendanceRecordModel>> getAttendance(String date, String grade);
  Future<void> saveAttendance(AttendanceRecordModel record);
  Future<void> bulkSaveAttendance(List<AttendanceRecordModel> records);
}

@LazySingleton(as: LocalAttendanceDataSource)
class HiveAttendanceDataSource implements LocalAttendanceDataSource {
  // We use a box per date+grade or a single huge box?
  // Given Hive's speed, a single box 'attendance' with key 'date_grade_studentId' or similar is fine.
  // Or better: Key = 'grade_date', Value = List<AttendanceRecordModel> or Map<StudentId, Record>.
  // The Architecture doc says "Daily Class Document" for Firestore.
  // For Hive, let's store simple records with composite keys or just index them.
  // Easiest: Box<AttendanceRecordModel> named 'attendance'.

  static const String boxName = 'attendance';

  @override
  Future<List<AttendanceRecordModel>> getAttendance(String date, String grade) async {
    final box = await Hive.openBox<AttendanceRecordModel>(boxName);
    // This is O(N) scan. For a few hundred records it's instant.
    // If it grows to thousands, we might want a different structure.
    // Ideally, we filter by date.
    return box.values.where((r) => r.date == date).toList();
    // Wait, we don't have 'grade' in AttendanceRecord.
    // We rely on the caller to know which students belong to the grade,
    // and we filter the returned list against the student list.
    // Or we should add 'grade' to AttendanceRecordModel for easier querying.
    // Let's assume we filter by student IDs in the repository or BLOC.
  }

  @override
  Future<void> saveAttendance(AttendanceRecordModel record) async {
    final box = await Hive.openBox<AttendanceRecordModel>(boxName);
    // Key: date_studentId ensures unique record per student per day
    final key = '${record.date}_${record.studentId}';
    await box.put(key, record);
  }

  @override
  Future<void> bulkSaveAttendance(List<AttendanceRecordModel> records) async {
    final box = await Hive.openBox<AttendanceRecordModel>(boxName);
    final Map<String, AttendanceRecordModel> entries = {};
    for (var r in records) {
      entries['${r.date}_${r.studentId}'] = r;
    }
    await box.putAll(entries);
  }
}
