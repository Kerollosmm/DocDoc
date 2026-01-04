import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/logic/conflict_resolver.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../domain/repositories/sync_repository.dart';
import '../models/attendance_record_model.dart';
import 'dart:developer' as developer;

@LazySingleton(as: SyncRepository)
class SyncRepositoryImpl implements SyncRepository {
  final AttendanceRepository _localRepo;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConflictResolver _resolver = ConflictResolver();

  SyncRepositoryImpl(this._localRepo);

  @override
  Future<void> syncAttendance(String date, String grade) async {
    final docRef = _firestore.collection('attendance_sheets').doc('${grade}_$date');

    try {
      final docSnap = await docRef.get();

      final localRecords = await _localRepo.getAttendance(date, grade);
      final localMap = {for (var r in localRecords) r.studentId: r};

      if (!docSnap.exists) {
        return;
      }

      final data = docSnap.data()!;
      final Map<String, dynamic> remoteRecordsJson = data['records'] as Map<String, dynamic>? ?? {};

      bool hasChanges = false;

      remoteRecordsJson.forEach((studentId, recordJson) {
        final remoteRecord = AttendanceRecordModel.fromJson(recordJson as Map<String, dynamic>);

        if (localMap.containsKey(studentId)) {
          final localRecord = localMap[studentId]!;

          if (localRecord.status != remoteRecord.status) {
            final resolved = _resolver.resolve(localRecord, remoteRecord);
            localMap[studentId] = resolved;
            hasChanges = true;
          }
        } else {
          _localRepo.markAttendance(remoteRecord);
        }
      });

      if (hasChanges) {
        for (var record in localMap.values) {
          if (record.isConflict) {
            await _localRepo.markAttendance(record);
          }
        }
      }

    } catch (e) {
      developer.log('Sync failed: $e', name: 'SyncRepository');
    }
  }
}
