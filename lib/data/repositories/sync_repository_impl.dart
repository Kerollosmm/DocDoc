import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/logic/conflict_resolver.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasources/local/local_attendance_datasource.dart';
import '../models/attendance_record_model.dart';
import 'dart:developer' as developer;

@LazySingleton(as: SyncRepository)
class SyncRepositoryImpl implements SyncRepository {
  final LocalAttendanceDataSource _localDataSource;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ConflictResolver _resolver = ConflictResolver();

  SyncRepositoryImpl(this._localDataSource);

  @override
  Future<void> syncAttendance(String date, String grade) async {
    final docRef = _firestore.collection('attendance_sheets').doc('${grade}_$date');

    try {
      final docSnap = await docRef.get();

      final localRecords = await _localDataSource.getAttendance(date, grade);
      final localMap = {for (var r in localRecords) r.studentId: r};

      bool hasChanges = false;

      if (docSnap.exists) {
        final data = docSnap.data()!;
        final Map<String, dynamic> remoteRecordsJson = data['records'] as Map<String, dynamic>? ?? {};

        remoteRecordsJson.forEach((studentId, recordJson) {
          final remoteRecord = AttendanceRecordModel.fromJson(recordJson as Map<String, dynamic>);

          if (localMap.containsKey(studentId)) {
            final localRecord = localMap[studentId]!;

            if (localRecord.status != remoteRecord.status) {
              // resolve returns AttendanceRecord (Entity)
              final resolvedEntity = _resolver.resolve(localRecord, remoteRecord);
              // Convert back to Model to store
              final resolvedModel = AttendanceRecordModel.fromEntity(resolvedEntity);
              localMap[studentId] = resolvedModel;
              hasChanges = true;
            }
          } else {
            // New from remote
            localMap[studentId] = remoteRecord;
            hasChanges = true;
          }
        });
      } else {
        // No remote doc? Push local (implicitly hasChanges if local > 0)
        if (localMap.isNotEmpty) hasChanges = true;
      }

      // 1. Save Resolved back to Local
      if (hasChanges) {
        for (var record in localMap.values) {
          await _localDataSource.saveAttendance(record);
        }
      }

      // 2. Write Back to Firestore (Critical Fix)
      // Convert Map<StudentId, Model> to Map<StudentId, Json>
      final Map<String, dynamic> mergedRecordsJson = {};
      localMap.forEach((key, value) {
        mergedRecordsJson[key] = value.toJson();
      });

      await docRef.set({
        'date': date,
        'class_id': grade,
        'records': mergedRecordsJson,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

    } catch (e) {
      developer.log('Sync failed: $e', name: 'SyncRepository');
    }
  }
}
