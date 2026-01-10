import 'package:equatable/equatable.dart';

class AttendanceRecordEntity extends Equatable {
  final String id;
  final String servantId;
  final String serviceId; // e.g., 'morning_prayer', 'sunday_mass'
  final DateTime date;
  final String status; // 'present', 'absent', 'late'
  final bool isSynced;
  final DateTime? syncedAt;

  const AttendanceRecordEntity({
    required this.id,
    required this.servantId,
    required this.serviceId,
    required this.date,
    required this.status,
    this.isSynced = false,
    this.syncedAt,
  });

  @override
  List<Object?> get props => [id, servantId, serviceId, date, status, isSynced, syncedAt];
}
