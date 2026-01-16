// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordModel _$AttendanceRecordModelFromJson(
  Map<String, dynamic> json,
) => AttendanceRecordModel(
  recordId: json['recordId'] as String,
  sessionId: json['sessionId'] as String,
  studentId: json['studentId'] as String,
  status: json['status'] as String,
  note: json['note'] as String,
  date: DateTime.parse(json['date'] as String),
  grade: json['grade'] as String,
  group: json['group'] as String,
  syncStatus: json['syncStatus'] as String,
);

Map<String, dynamic> _$AttendanceRecordModelToJson(
  AttendanceRecordModel instance,
) => <String, dynamic>{
  'recordId': instance.recordId,
  'sessionId': instance.sessionId,
  'studentId': instance.studentId,
  'status': instance.status,
  'note': instance.note,
  'date': instance.date.toIso8601String(),
  'grade': instance.grade,
  'group': instance.group,
  'syncStatus': instance.syncStatus,
};
