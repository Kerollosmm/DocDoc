import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/attendance_record.dart';

part 'attendance_sheet_model.g.dart';

/// A model representing a daily attendance sheet for a class.
///
/// This model is designed to optimize Firestore reads by aggregating
/// attendance records for an entire class for a specific day into a single document.
/// Instead of reading one document per student, we read one document per class per day.
@HiveType(typeId: 3)
@JsonSerializable()
class AttendanceSheetModel {
  /// Unique ID for the sheet, typically formatted as `classID_date`.
  @HiveField(0)
  final String id;

  /// The ID of the class this sheet belongs to.
  @HiveField(1)
  final String classId;

  /// The date of the attendance sheet.
  @HiveField(2)
  final DateTime date;

  /// A map of student IDs to their attendance status.
  ///
  /// This allows O(1) lookup of a student's status and efficient storage.
  @HiveField(3)
  final Map<String, AttendanceStatus> records;

  const AttendanceSheetModel({
    required this.id,
    required this.classId,
    required this.date,
    required this.records,
  });

  factory AttendanceSheetModel.fromJson(Map<String, dynamic> json) =>
      _$AttendanceSheetModelFromJson(json);

  Map<String, dynamic> toJson() => _$AttendanceSheetModelToJson(this);
}
