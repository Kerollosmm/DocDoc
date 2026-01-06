// lib/domain/entities/attendance_record.dart
import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, absent, late, excused }

class AttendanceRecord extends Equatable {
  final String id;
  final String studentId;
  final DateTime date;
  final String gradeId;
  final AttendanceStatus status;
  final String markedBy;
  final DateTime markedAt;
  final bool isConflict;

  const AttendanceRecord({
    required this.id,
    required this.studentId,
    required this.date,
    required this.gradeId,
    required this.status,
    required this.markedBy,
    required this.markedAt,
    this.isConflict = false,
  });

  @override
  List<Object?> get props =>
      [id, studentId, date, gradeId, status, markedBy, markedAt, isConflict];
}
