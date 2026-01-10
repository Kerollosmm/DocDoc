import 'package:json_annotation/json_annotation.dart';
import 'package:csms/features/attendance/domain/entities/attendance_record_entity.dart';

part 'attendance_record_model.g.dart';

@JsonSerializable()
class AttendanceRecordModel extends AttendanceRecordEntity {
  const AttendanceRecordModel({
    required super.id,
    required super.servantId,
    required super.serviceId,
    required super.date,
    required super.status,
    super.isSynced,
    super.syncedAt,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRecordModelToJson(this);

  factory AttendanceRecordModel.fromEntity(AttendanceRecordEntity entity) {
    return AttendanceRecordModel(
      id: entity.id,
      servantId: entity.servantId,
      serviceId: entity.serviceId,
      date: entity.date,
      status: entity.status,
      isSynced: entity.isSynced,
      syncedAt: entity.syncedAt,
    );
  }

  AttendanceRecordModel copyWith({
    String? id,
    String? servantId,
    String? serviceId,
    DateTime? date,
    String? status,
    bool? isSynced,
    DateTime? syncedAt,
  }) {
    return AttendanceRecordModel(
      id: id ?? this.id,
      servantId: servantId ?? this.servantId,
      serviceId: serviceId ?? this.serviceId,
      date: date ?? this.date,
      status: status ?? this.status,
      isSynced: isSynced ?? this.isSynced,
      syncedAt: syncedAt ?? this.syncedAt,
    );
  }
}
