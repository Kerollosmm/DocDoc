import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, absent }

class AttendanceRecord extends Equatable {
  final String studentId;
  final AttendanceStatus status;
  final String date; // YYYY-MM-DD
  final String updatedBy;
  final int timestamp;
  final bool isConflict;
  final bool isSynced;

  const AttendanceRecord({
    required this.studentId,
    required this.status,
    required this.date,
    required this.updatedBy,
    required this.timestamp,
    this.isConflict = false,
    this.isSynced = false,
  });

  @override
  List<Object?> get props => [studentId, status, date, updatedBy, timestamp, isConflict, isSynced];
}
