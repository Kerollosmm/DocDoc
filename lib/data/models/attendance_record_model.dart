import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/attendance_record.dart';

part 'attendance_record_model.g.dart';

@HiveType(typeId: 1)
@JsonSerializable()
class AttendanceRecordModel extends AttendanceRecord {
  @override
  @HiveField(0)
  final String studentId;
  @override
  @HiveField(1)
  final AttendanceStatus status;
  @override
  @HiveField(2)
  final String date;
  @override
  @HiveField(3)
  final String updatedBy;
  @override
  @HiveField(4)
  final int timestamp;
  @override
  @HiveField(5)
  final bool isConflict;
  @override
  @HiveField(6)
  final bool isSynced;

  const AttendanceRecordModel({
    required this.studentId,
    required this.status,
    required this.date,
    required this.updatedBy,
    required this.timestamp,
    this.isConflict = false,
    this.isSynced = false,
  }) : super(
          studentId: studentId,
          status: status,
          date: date,
          updatedBy: updatedBy,
          timestamp: timestamp,
          isConflict: isConflict,
          isSynced: isSynced,
        );

  factory AttendanceRecordModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceRecordModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceRecordModelToJson(this);

  factory AttendanceRecordModel.fromEntity(AttendanceRecord record) {
    return AttendanceRecordModel(
      studentId: record.studentId,
      status: record.status,
      date: record.date,
      updatedBy: record.updatedBy,
      timestamp: record.timestamp,
      isConflict: record.isConflict,
      isSynced: record.isSynced,
    );
  }
}

@HiveType(typeId: 2)
enum AttendanceStatusAdapterType {
  @HiveField(0)
  present,
  @HiveField(1)
  absent,
}
