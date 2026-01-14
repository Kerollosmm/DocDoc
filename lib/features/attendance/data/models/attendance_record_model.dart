import 'package:doc_app/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'attendance_record_model.g.dart';

@JsonSerializable()
class AttendanceRecordModel extends AttendanceRecordEntity {
  const AttendanceRecordModel({
    required super.recordId,
    required super.sessionId,
    required super.studentId,
    required super.status,
    required super.note,
    required super.date,
    required super.grade,
    required super.group,
    required super.syncStatus,
  });

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRecordModelToJson(this);

  factory AttendanceRecordModel.fromEntity(AttendanceRecordEntity entity) {
    return AttendanceRecordModel(
      recordId: entity.recordId,
      sessionId: entity.sessionId,
      studentId: entity.studentId,
      status: entity.status,
      note: entity.note,
      date: entity.date,
      grade: entity.grade,
      group: entity.group,
      syncStatus: entity.syncStatus,
    );
  }
}
