import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/features/attendance/data/models/servant_model.dart';
import 'package:csms/features/attendance/data/models/attendance_record_model.dart';
import 'package:csms/core/error/failures.dart';

abstract class AttendanceRemoteDataSource {
  Future<List<ServantModel>> getServants();
  Future<void> uploadAttendance(List<AttendanceRecordModel> records);
  Future<void> logAudit(String action, String details);
}

@LazySingleton(as: AttendanceRemoteDataSource)
class FirestoreAttendanceDataSource implements AttendanceRemoteDataSource {
  final FirebaseFirestore _firestore;

  FirestoreAttendanceDataSource(this._firestore);

  @override
  Future<List<ServantModel>> getServants() async {
    try {
      final snapshot = await _firestore.collection('servants').get();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Ensure ID is part of the map
        return ServantModel.fromJson(data);
      }).toList();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  @override
  Future<void> uploadAttendance(List<AttendanceRecordModel> records) async {
    final batch = _firestore.batch();

    for (var record in records) {
      final docRef = _firestore.collection('attendancerecords').doc(record.id);
      final data = record.toJson();
      // Remove local-only fields if needed, or keeping isSynced=true is fine.
      // Ideally, in Firestore we don't need 'isSynced' flag, but 'syncedAt' is good.
      data['isSynced'] = true;
      data['syncedAt'] = DateTime.now().toIso8601String();

      batch.set(docRef, data, SetOptions(merge: true));
    }

    await batch.commit();
  }

  @override
  Future<void> logAudit(String action, String details) async {
    await _firestore.collection('auditlogs').add({
      'action': action,
      'details': details,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
