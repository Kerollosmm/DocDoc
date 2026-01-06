// lib/data/models/attendance_record_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/attendance_record.dart';

part 'attendance_record_model.freezed.dart';
part 'attendance_record_model.g.dart';

@freezed
class AttendanceRecordModel with _$AttendanceRecordModel {
  const AttendanceRecordModel._();

  @HiveType(typeId: 2)
  const factory AttendanceRecordModel({
    @HiveField(0) required String id,
    @HiveField(1) required String studentId,
    @HiveField(2) required DateTime date,
    @HiveField(3) required String gradeId,
    @HiveField(4) required AttendanceStatus status,
    @HiveField(5) required String markedBy,
    @HiveField(6) required DateTime markedAt,
    @HiveField(7) @Default(false) bool isConflict,
  }) = _AttendanceRecordModel;

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  factory AttendanceRecordModel.fromEntity(AttendanceRecord record) {
    return AttendanceRecordModel(
      id: record.id,
      studentId: record.studentId,
      date: record.date,
      gradeId: record.gradeId,
      status: record.status,
      markedBy: record.markedBy,
      markedAt: record.markedAt,
      isConflict: record.isConflict,
    );
  }

  AttendanceRecord toEntity() {
    return AttendanceRecord(
      id: id,
      studentId: studentId,
      date: date,
      gradeId: gradeId,
      status: status,
      markedBy: markedBy,
      markedAt: markedAt,
      isConflict: isConflict,
    );
  }
}
