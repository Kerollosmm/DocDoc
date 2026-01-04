import '../entities/attendance_record.dart';

class ConflictResolver {
  /// Resolves conflict between a local record and a remote record.
  ///
  /// **Strict Rule:**
  /// If statuses differ (Present vs Absent), the result is **Absent**.
  /// The `isConflict` flag is set to `true`.
  ///
  /// The logic ignores timestamps for the status decision to enforce safety (better safe/absent than false present).
  AttendanceRecord resolve(AttendanceRecord local, AttendanceRecord remote) {
    if (local.studentId != remote.studentId) {
      throw ArgumentError('Cannot compare records for different students');
    }

    // 1. If Same Status -> No Conflict (Use remote as base to ensure metadata sync, but keep local flags if needed)
    if (local.status == remote.status) {
      return remote.copyWith(
        isConflict: false,
        // We might want to keep the latest timestamp or updatedBy
        timestamp: (local.timestamp > remote.timestamp) ? local.timestamp : remote.timestamp,
        updatedBy: (local.timestamp > remote.timestamp) ? local.updatedBy : remote.updatedBy,
      );
    }

    // 2. Statuses Differ -> Conflict!
    // Rule: Default to Absent.
    return local.copyWith( // We return a new record based on local ID but forced values
      status: AttendanceStatus.absent,
      isConflict: true,
      updatedBy: 'System (Conflict)',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
  }
}
