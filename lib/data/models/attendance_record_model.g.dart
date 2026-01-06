// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceRecordModelImpl _$$AttendanceRecordModelImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendanceRecordModelImpl(
      id: json['id'] as String,
      studentId: json['studentId'] as String,
      date: DateTime.parse(json['date'] as String),
      gradeId: json['gradeId'] as String,
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      markedBy: json['markedBy'] as String,
      markedAt: DateTime.parse(json['markedAt'] as String),
      isConflict: json['isConflict'] as bool? ?? false,
    );

Map<String, dynamic> _$$AttendanceRecordModelImplToJson(
        _$AttendanceRecordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'date': instance.date.toIso8601String(),
      'gradeId': instance.gradeId,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'markedBy': instance.markedBy,
      'markedAt': instance.markedAt.toIso8601String(),
      'isConflict': instance.isConflict,
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
  AttendanceStatus.late: 'late',
  AttendanceStatus.excused: 'excused',
};
