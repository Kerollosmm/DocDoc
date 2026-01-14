import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_app/features/attendance/data/models/attendance_record_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:doc_app/core/config/hive_boxes_config.dart';

class SyncService {
  final Connectivity connectivity;
  final FirebaseFirestore firestore;
  final HiveInterface hive;

  SyncService({
    required this.connectivity,
    required this.firestore,
    required this.hive,
  });

  void init() {
    connectivity.onConnectivityChanged.listen((results) {
        if (results.contains(ConnectivityResult.mobile) || results.contains(ConnectivityResult.wifi)) {
          syncPendingData();
        }
    });
  }

  Future<void> syncPendingData() async {
    print("SyncService: Checking for pending data...");
    await _syncAttendance();
    // await _syncStudents(); // If we implemented offline student creation
  }

  Future<void> _syncAttendance() async {
    final box = hive.box(HiveBoxesConfig.attendanceBox);
    final pendingRecords = box.values.where((e) {
      final map = Map<String, dynamic>.from(e);
      return map['syncStatus'] == 'pending';
    }).toList();

    if (pendingRecords.isEmpty) return;

    final batch = firestore.batch();
    final List<dynamic> syncedKeys = [];

    for (final recordData in pendingRecords) {
      final map = Map<String, dynamic>.from(recordData);
      final model = AttendanceRecordModel.fromJson(map);

      final docRef = firestore.collection('attendanceRecords').doc(model.recordId);

      // Update model status to synced before sending?
      // Usually we send data, then update local.
      // We send the data EXCEPT syncStatus (or set it to synced on server)
      final serverData = model.toJson();
      serverData['syncStatus'] = 'synced'; // Server sees it as synced

      batch.set(docRef, serverData);
      syncedKeys.add(model.recordId);
    }

    try {
      await batch.commit();

      // Update local storage
      for (final key in syncedKeys) {
        final localData = Map<String, dynamic>.from(box.get(key));
        localData['syncStatus'] = 'synced';
        await box.put(key, localData);
      }
      print("SyncService: Synced ${syncedKeys.length} attendance records.");
    } catch (e) {
      print("SyncService: Error syncing attendance: $e");
    }
  }
}
