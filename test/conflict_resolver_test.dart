import 'package:flutter_test/flutter_test.dart';
import 'package:csms_app/domain/logic/conflict_resolver.dart';
import 'package:csms_app/domain/entities/attendance_record.dart';

void main() {
  group('ConflictResolver', () {
    final resolver = ConflictResolver();

    final baseRecord = AttendanceRecord(
      studentId: '123',
      status: AttendanceStatus.present,
      date: '2023-10-27',
      updatedBy: 'ServantA',
      timestamp: 1000,
      grade: 'Grade 5',
    );

    test('should return Remote record if statuses match (Present/Present)', () {
      final local = baseRecord; // Present
      final remote = baseRecord.copyWith(updatedBy: 'ServantB', timestamp: 2000); // Present

      final result = resolver.resolve(local, remote);

      expect(result.status, AttendanceStatus.present);
      expect(result.isConflict, false);
      expect(result.updatedBy, 'ServantB'); // Should take latest/remote props
    });

    test('should flag Conflict and default to Absent if statuses differ (Local Present vs Remote Absent)', () {
      final local = baseRecord; // Present
      final remote = baseRecord.copyWith(
        status: AttendanceStatus.absent,
        updatedBy: 'ServantB',
        timestamp: 2000
      );

      final result = resolver.resolve(local, remote);

      expect(result.status, AttendanceStatus.absent);
      expect(result.isConflict, true);
      expect(result.updatedBy, 'System (Conflict)');
    });

    test('should flag Conflict and default to Absent if statuses differ (Local Absent vs Remote Present)', () {
      final local = baseRecord.copyWith(status: AttendanceStatus.absent);
      final remote = baseRecord.copyWith(
        status: AttendanceStatus.present,
        updatedBy: 'ServantB',
        timestamp: 2000
      );

      final result = resolver.resolve(local, remote);

      expect(result.status, AttendanceStatus.absent);
      expect(result.isConflict, true);
      expect(result.updatedBy, 'System (Conflict)');
    });

    test('should throw error if student IDs differ', () {
      final local = baseRecord;
      final remote = baseRecord.copyWith(studentId: '999');

      expect(() => resolver.resolve(local, remote), throwsArgumentError);
    });
  });
}
