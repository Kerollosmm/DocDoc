// lib/data/models/student_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import '../../domain/entities/student.dart';

part 'student_model.freezed.dart';
part 'student_model.g.dart';

@freezed
class StudentModel with _$StudentModel {
  const StudentModel._();

  @HiveType(typeId: 1)
  const factory StudentModel({
    @HiveField(0) required String id,
    @HiveField(1) required String name,
    @HiveField(2) required String grade,
    @HiveField(3) required String phoneNumber,
    @HiveField(4) String? address,
    @HiveField(5) String? parentName,
    @HiveField(6) String? parentPhone,
    @HiveField(7) required DateTime enrollmentDate,
    @HiveField(8) @Default(true) bool isActive,
  }) = _StudentModel;

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      name: student.name,
      grade: student.grade,
      phoneNumber: student.phoneNumber,
      address: student.address,
      parentName: student.parentName,
      parentPhone: student.parentPhone,
      enrollmentDate: student.enrollmentDate,
      isActive: student.isActive,
    );
  }

  Student toEntity() {
    return Student(
      id: id,
      name: name,
      grade: grade,
      phoneNumber: phoneNumber,
      address: address,
      parentName: parentName,
      parentPhone: parentPhone,
      enrollmentDate: enrollmentDate,
      isActive: isActive,
    );
  }
}
