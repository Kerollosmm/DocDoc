import '../entities/attendance_record.dart';

class ConflictResolver {
  /// Resolves conflict between a local record and a remote record.
  /// Rules:
  /// 1. If status differs -> Conflict!
  /// 2. If conflict, default status to 'Absent'.
  /// 3. Mark isConflict = true.

  AttendanceRecord resolve(AttendanceRecord local, AttendanceRecord remote) {
    if (local.studentId != remote.studentId) {
      throw Exception('Cannot compare records for different students');
    }

    if (local.status == remote.status) {
      return local.copyWith(isConflict: false); // Or keep existing metadata
    }

    // Conflict detected
    return local.copyWith(
      status: AttendanceStatus.absent, // Default to absent
      isConflict: true,
      updatedBy: 'System (Conflict)',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

extension AttendanceRecordCopy on AttendanceRecord {
  AttendanceRecord copyWith({
    String? studentId,
    AttendanceStatus? status,
    String? date,
    String? updatedBy,
    int? timestamp,
    bool? isConflict,
  }) {
    return AttendanceRecord(
      studentId: studentId ?? this.studentId,
      status: status ?? this.status,
      date: date ?? this.date,
      updatedBy: updatedBy ?? this.updatedBy,
      timestamp: timestamp ?? this.timestamp,
      isConflict: isConflict ?? this.isConflict,
    );
  }
}
