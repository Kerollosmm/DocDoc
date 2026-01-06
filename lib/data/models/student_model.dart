import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/student.dart';

part 'student_model.g.dart';

/// A data model representing a student, compatible with Hive and JSON.
///
/// This model extends the [Student] entity and adds serialization support
/// for local storage (Hive) and remote synchronization (JSON/Firestore).
/// It also includes [lastFetchTime] for implementing cache-first strategies
/// to minimize Firestore reads.
@HiveType(typeId: 0)
@JsonSerializable()
class StudentModel extends Student {
  /// The unique identifier of the student.
  @override
  @HiveField(0)
  final String id;

  /// The full name of the student.
  @override
  @HiveField(1)
  final String name;

  /// The grade level of the student (e.g., "Grade 10").
  @override
  @HiveField(2)
  final String grade;

  /// The primary phone number for contact.
  @override
  @HiveField(3)
  final String phoneNumber;

  /// The physical address of the student (optional).
  @override
  @HiveField(4)
  final String? address;

  /// The timestamp when this record was last fetched from the server.
  /// Used to determine if the local cache is stale (typically 24-hour expiry).
  @HiveField(5)
  final DateTime? lastFetchTime; // For cache expiry

  const StudentModel({
    required this.id,
    required this.name,
    required this.grade,
    required this.phoneNumber,
    this.address,
    this.lastFetchTime,
  }) : super(
          id: id,
          name: name,
          grade: grade,
          phoneNumber: phoneNumber,
          address: address,
        );

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      name: student.name,
      grade: student.grade,
      phoneNumber: student.phoneNumber,
      address: student.address,
      lastFetchTime: DateTime.now(),
    );
  }

  StudentModel copyWith({DateTime? lastFetchTime}) {
    return StudentModel(
      id: id,
      name: name,
      grade: grade,
      phoneNumber: phoneNumber,
      address: address,
      lastFetchTime: lastFetchTime ?? this.lastFetchTime,
    );
  }
}
