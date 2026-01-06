import 'package:equatable/equatable.dart';

enum AttendanceStatus { present, absent }

class AttendanceRecord extends Equatable {
  final String studentId;
  final AttendanceStatus status;
  final String date; // YYYY-MM-DD
  final String updatedBy;
  final int timestamp;
  final String grade;
  final bool isConflict;
  final bool needsAdminReview;
  final bool isSynced;

  const AttendanceRecord({
    required this.studentId,
    required this.status,
    required this.date,
    required this.updatedBy,
    required this.timestamp,
    required this.grade,
    this.isConflict = false,
    this.needsAdminReview = false,
    this.isSynced = false,
  });

  AttendanceRecord copyWith({
    String? studentId,
    AttendanceStatus? status,
    String? date,
    String? updatedBy,
    int? timestamp,
    String? grade,
    bool? isConflict,
    bool? needsAdminReview,
    bool? isSynced,
  }) {
    return AttendanceRecord(
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      date: date ?? this.date,
      updatedBy: updatedBy ?? this.updatedBy,
      timestamp: timestamp ?? this.timestamp,
      grade: grade ?? this.grade,
      isConflict: isConflict ?? this.isConflict,
      needsAdminReview: needsAdminReview ?? this.needsAdminReview,
      isSynced: isSynced ?? this.isSynced,
    );
  }

  @override
  List<Object?> get props => [studentId, status, date, updatedBy, timestamp, grade, isConflict, needsAdminReview, isSynced];
}
