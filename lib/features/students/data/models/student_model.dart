import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_model.g.dart';

@JsonSerializable()
class StudentModel extends StudentEntity {
  const StudentModel({
    required super.studentId,
    required super.name,
    required super.grade,
    required super.group,
    required super.createdBy,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);

  factory StudentModel.fromEntity(StudentEntity entity) {
    return StudentModel(
      studentId: entity.studentId,
      name: entity.name,
      grade: entity.grade,
      group: entity.group,
      createdBy: entity.createdBy,
    );
  }
}
