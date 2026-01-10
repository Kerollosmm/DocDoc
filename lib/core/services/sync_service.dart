import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:csms/core/services/connectivity_service.dart';
import 'package:csms/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:csms/core/util/app_logger.dart';

@lazySingleton
class SyncService {
  final ConnectivityService _connectivityService;
  final AttendanceRepository _attendanceRepository;
  StreamSubscription<bool>? _subscription;

  SyncService(this._connectivityService, this._attendanceRepository) {
    _init();
  }

  void _init() {
    _subscription = _connectivityService.onConnectivityChanged.listen((isOnline) {
      if (isOnline) {
        AppLogger.i('Device is online. Triggering sync...');
        syncPendingData();
      }
    });
  }

  Future<void> syncPendingData() async {
    final result = await _attendanceRepository.syncAttendance();
    result.fold(
      (failure) => AppLogger.e('Sync failed: ${failure.message}'),
      (_) => AppLogger.i('Sync completed successfully'),
    );
  }

  void dispose() {
    _subscription?.cancel();
  }
}
