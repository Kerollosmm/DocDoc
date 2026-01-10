// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => AttendanceRecordModel(
  id: json['id'] as String,
  servantId: json['servantId'] as String,
  serviceId: json['serviceId'] as String,
  date: DateTime.parse(json['date'] as String),
  status: json['status'] as String,
  isSynced: json['isSynced'] as bool? ?? false,
  syncedAt: json['syncedAt'] == null
      ? null
      : DateTime.parse(json['syncedAt'] as String),
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  AttendanceRecordModel instance,
) => <String, dynamic>{
  'id': instance.id,
  'servantId': instance.servantId,
  'serviceId': instance.serviceId,
  'date': instance.date.toIso8601String(),
  'status': instance.status,
  'isSynced': instance.isSynced,
  'syncedAt': instance.syncedAt?.toIso8601String(),
};
