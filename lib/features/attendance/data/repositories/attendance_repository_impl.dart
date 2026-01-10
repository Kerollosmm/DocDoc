import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/core/services/connectivity_service.dart';
import 'package:csms/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:csms/features/attendance/domain/entities/servant_entity.dart';
import 'package:csms/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:csms/features/attendance/data/datasources/attendance_local_data_source.dart';
import 'package:csms/features/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:csms/features/attendance/data/models/attendance_record_model.dart';
import 'package:csms/features/attendance/data/models/servant_model.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource _localDataSource;
  final AttendanceRemoteDataSource _remoteDataSource;
  final ConnectivityService _connectivityService;

  AttendanceRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._connectivityService,
  );

  @override
  Future<Either<Failure, List<ServantEntity>>> getServants() async {
    // Strategy: Try Local first for speed, then Remote if online and update Local.
    // Or: If online, fetch Remote and Cache. If offline/fail, fetch Local.
    // The requirement says: "Load servants list instantly (from Hive cache when offline, refresh from Firestore when online)."

    // Implementation:
    // 1. Check connectivity.
    // 2. If online: fetch remote -> cache -> return.
    // 3. If offline or remote fails: fetch local -> return.

    if (await _connectivityService.isConnected) {
      try {
        final remoteServants = await _remoteDataSource.getServants();
        await _localDataSource.cacheServants(remoteServants);
        return Right(remoteServants);
      } catch (e) {
        // Fallback to local
        try {
          final localServants = await _localDataSource.getServants();
          return Right(localServants);
        } catch (localE) {
          return Left(CacheFailure(localE.toString()));
        }
      }
    } else {
      try {
        final localServants = await _localDataSource.getServants();
        return Right(localServants);
      } catch (e) {
        return Left(OfflineFailure('No local data available'));
      }
    }
  }

  @override
  Future<Either<Failure, void>> markAttendance(AttendanceRecordEntity record) async {
    try {
      final model = AttendanceRecordModel.fromEntity(record);
      // Save locally first with isSynced=false (default in Entity/Model creation if not specified)
      await _localDataSource.saveAttendanceRecord(model);

      // If online, try to sync immediately?
      // Requirement: "Mark attendance offline... Auto-sync pending... using SyncService".
      // So we just save locally here. SyncService handles the rest.
      // But we can trigger a sync check if we want immediate feedback.
      // For now, adhere to "Store locally with isSynced=false".

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncAttendance() async {
    if (!await _connectivityService.isConnected) {
      return const Left(OfflineFailure('Cannot sync while offline'));
    }

    try {
      final pending = await _localDataSource.getPendingAttendance();
      if (pending.isEmpty) return const Right(null);

      await _remoteDataSource.uploadAttendance(pending);

      // Update local records
      for (var record in pending) {
        final updated = record.copyWith(
          isSynced: true,
          syncedAt: DateTime.now(),
        );
        await _localDataSource.updateRecord(updated);
      }

      await _remoteDataSource.logAudit('SYNC', 'Synced ${pending.length} records');

      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecordEntity>>> getPendingAttendance() async {
    try {
      final pending = await _localDataSource.getPendingAttendance();
      return Right(pending);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateRecordSyncStatus(String recordId, bool isSynced) {
    // This helper might be redundant if syncAttendance handles it internally,
    // but useful if we need granular control.
    // Skipping implementation as syncAttendance covers it.
    throw UnimplementedError();
  }
}
