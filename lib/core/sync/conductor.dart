import 'package:csms_app/core/network/network_info.dart';
import 'package:csms_app/domain/entities/attendance_record.dart';
import 'package:csms_app/domain/repositories/attendance_repository.dart';
import 'package:csms_app/domain/repositories/sync_repository.dart';
import 'package:injectable/injectable.dart';
import 'package:csms_app/core/error/failures.dart';
import 'package:dartz/dartz.dart';

/// The [ConductorService] orchestrates the flow of data between the UI,
/// local storage (Hive), and remote database (Firestore).
///
/// It implements the "Offline-First" philosophy:
/// 1. All writes go to local storage immediately.
/// 2. Background sync is triggered if online.
/// 3. Reads return local data first, then refresh from remote if possible.
@lazySingleton
class ConductorService {
  final NetworkInfo _networkInfo;
  final AttendanceRepository _attendanceRepository;
  final SyncRepository _syncRepository;

  ConductorService(
    this._networkInfo,
    this._attendanceRepository,
    this._syncRepository,
  );

  /// Main entry point for retrieving data.
  ///
  /// Logic:
  /// 1. Fetch from Local Repository immediately.
  /// 2. If [isConnected], trigger a sync to update local cache from remote.
  ///    The Repository should handle the merging/conflict resolution.
  Future<Either<Failure, List<AttendanceRecord>>> getAttendance(String date, String grade) async {
    try {
      // 1. Fetch current local/cached state
      final localRecords = await _attendanceRepository.getAttendance(date, grade);

      // 2. Trigger background sync if online
      if (await _networkInfo.isConnected) {
         // Fire-and-forget logic for refreshing data "in the background".
         // We do NOT await this, so the UI gets the local data instantly.
         // If the sync updates the Hive box, the UI should be listening to the box changes
         // (via StreamBuilder or similar) to update automatically.
         // OR, if the UI expects a "refresh" indicator to stop, we might want to await.
         // But per "Offline First" speed goals, we return local first.

         // However, to ensure the UI eventually sees the *new* data if it wasn't streaming,
         // we might execute the sync.
         // For this implementation, we will NOT await the sync to ensure speed,
         // assuming the UI subscribes to the data source or the user pulls to refresh.
         _syncRepository.syncAttendance(date, grade).then((_) {
            // Optional: Notification or Event Bus event "DataSynced" could go here.
         }).catchError((e) {
            // Log error silently
         });
      }

      return Right(localRecords);
    } catch (e) {
      return Left(CacheFailure(message: "Failed to load attendance: $e"));
    }
  }

  /// Main entry point for marking attendance.
  ///
  /// Logic:
  /// 1. Saves locally immediately.
  /// 2. If online, triggers background sync (fire-and-forget).
  Future<Either<Failure, void>> markAttendance(AttendanceRecord record) async {
    try {
      // 1. Save to Local Storage immediately
      await _attendanceRepository.markAttendance(record);

      // 2. Check Network and Sync
      // We do NOT await the network call. This ensures the UI remains responsive ("Instant").
      _networkInfo.isConnected.then((isConnected) {
        if (isConnected) {
           _syncRepository.syncAttendance(record.date, record.grade).catchError((e) {
             // Log sync failure, but data is safe locally.
           });
        }
      });

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(message: "Failed to save locally: $e"));
    }
  }

  /// Orchestrates the full sync process explicitly (e.g., Pull-to-Refresh).
  /// This method waits for the sync to complete.
  Future<Either<Failure, void>> syncNow(String date, String grade) async {
    if (await _networkInfo.isConnected) {
      try {
        await _syncRepository.syncAttendance(date, grade);
        return const Right(null);
      } catch (e) {
        return Left(ServerFailure(message: "Sync failed: $e"));
      }
    } else {
      return const Left(OfflineFailure(message: "Cannot sync while offline."));
    }
  }
}
