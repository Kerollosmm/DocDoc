# Conductor Developer Guide

## Overview
The **Conductor** (`ConductorService`) is the central orchestration layer for the CSMS application. It manages the complex data flow between the user interface, local storage (Hive), and the remote database (Firestore).

**Core Philosophy:** "Offline-First, Zero Data Loss."

The Conductor ensures that:
1.  **User Actions are Instant:** Writes go to local storage immediately.
2.  **Data is Durable:** Background synchronization handles upload/download without blocking the UI.
3.  **Conflicts are Managed:** Discrepancies between local and remote data are resolved deterministically.

## Architecture & Integration

The Conductor sits in the `core` layer (`lib/core/sync/conductor.dart`) and interacts with:
*   `NetworkInfo`: To detect online/offline status.
*   `AttendanceRepository`: For CRUD operations on attendance records.
*   `SyncRepository`: To trigger background synchronization.

### Data Flow (Simplified)
1.  **UI Event (Mark Attendance):**
    *   Call `Conductor.markAttendance(...)`.
    *   Conductor writes to Hive (via Repository).
    *   Returns success to UI immediately.
    *   If Online: Triggers background sync (fire-and-forget).
    *   If Offline: Data remains safe in Hive.

2.  **UI Event (View Results):**
    *   Call `Conductor.getAttendance(...)`.
    *   Returns Local Data immediately.
    *   If Online: Triggers `SyncRepository.syncAttendance(...)`.
    *   Repository fetches Remote, compares, merges, and updates Local.
    *   UI should listen to the local data stream (if available) or rely on the background sync to update the cache for the *next* read.

## Class Structure

```dart
class ConductorService {
  final NetworkInfo _networkInfo;
  final AttendanceRepository _attendanceRepository;
  final SyncRepository _syncRepository;

  // Constructor with Dependency Injection
  ConductorService(
    this._networkInfo,
    this._attendanceRepository,
    this._syncRepository,
  );

  /// Main entry point for marking attendance.
  /// 1. Saves locally immediately.
  /// 2. If online, triggers background sync.
  /// Returns Either<Failure, void>.
  Future<Either<Failure, void>> markAttendance(AttendanceRecord record) async { ... }

  /// Main entry point for retrieving data.
  /// 1. Returns local data immediately.
  /// 2. If online, triggers sync to ensure data is fresh.
  /// Returns Either<Failure, List<AttendanceRecord>>.
  Future<Either<Failure, List<AttendanceRecord>>> getAttendance(String date, String grade) async { ... }

  /// Orchestrates the full sync process explicitly (e.g., Pull-to-Refresh).
  /// This method waits for the sync to complete.
  Future<Either<Failure, void>> syncNow(String date, String grade) async { ... }
}
```

## Error Handling

*   **OfflineException:** The Conductor generally suppresses offline errors for "Write" operations (since we saved locally).
*   **Sync Conflicts:** Handled by the Repository/DataSource layer, but the Conductor orchestrates the *timing* of the resolution.

## Performance Optimization

*   **Non-blocking Sync:** `markAttendance` does not await the sync operation, keeping the UI responsive.
*   **Lazy Loading:** Only sync the requested `grade` and `date` to minimize Firestore reads.

## Future Extensions
*   Queue management for failed syncs.
*   Detailed sync status streams (Syncing, Up-to-Date, Error).
