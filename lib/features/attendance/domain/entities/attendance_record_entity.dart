import 'package:equatable/equatable.dart';

class AttendanceRecordEntity extends Equatable {
  final String recordId;
  final String sessionId;
  final String studentId;
  final String status; // 'present' or 'absent'
  final String note;
  final DateTime date;
  final String grade;
  final String group;
  final String syncStatus;

  const AttendanceRecordEntity({
    required this.recordId,
    required this.sessionId,
    required this.studentId,
    required this.status,
    required this.note,
    required this.date,
    required this.grade,
    required this.group,
    this.syncStatus = 'synced',
  });

  @override
  List<Object?> get props => [recordId, sessionId, studentId, status, date];
}
