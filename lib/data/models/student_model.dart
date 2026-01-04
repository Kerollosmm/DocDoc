import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/student.dart';

part 'student_model.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class StudentModel extends Student {
  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String grade;
  @override
  @HiveField(3)
  final String? phoneNumber;

  const StudentModel({
    required this.id,
    required this.name,
    required this.grade,
    this.phoneNumber,
  }) : super(id: id, name: name, grade: grade, phoneNumber: phoneNumber);

  factory StudentModel.fromJson(Map<String, dynamic> json) =>
      _$StudentModelFromJson(json);

  Map<String, dynamic> toJson() => _$StudentModelToJson(this);

  factory StudentModel.fromEntity(Student student) {
    return StudentModel(
      id: student.id,
      name: student.name,
      grade: student.grade,
      phoneNumber: student.phoneNumber,
    );
  }
}
