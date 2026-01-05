import 'package:flutter_test/flutter_test.dart';
import 'package:csms_app/domain/entities/attendance_record.dart';

void main() {
  group('AttendanceRecord', () {
    test('supports conflict and needsAdminReview', () {
      final record = AttendanceRecord(
        studentId: '1',
        status: AttendanceStatus.present,
        date: '2023-10-27',
        updatedBy: 'ServantA',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        grade: 'G1',
        isConflict: true,
        needsAdminReview: true,
      );

      expect(record.isConflict, true);
      expect(record.needsAdminReview, true);
    });

    test('copyWith preserves values', () {
      final record = AttendanceRecord(
        studentId: '1',
        status: AttendanceStatus.present,
        date: '2023-10-27',
        updatedBy: 'ServantA',
        timestamp: DateTime.now().millisecondsSinceEpoch,
        grade: 'G1',
        isConflict: true,
        needsAdminReview: true,
      );

      final copy = record.copyWith(status: AttendanceStatus.absent);

      expect(copy.status, AttendanceStatus.absent);
      expect(copy.isConflict, true);
      expect(copy.needsAdminReview, true);
    });
  });
}
