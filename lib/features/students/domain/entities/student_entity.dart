import 'package:equatable/equatable.dart';

class StudentEntity extends Equatable {
  final String studentId;
  final String name;
  final String grade;
  final String group;
  final String createdBy;

  const StudentEntity({
    required this.studentId,
    required this.name,
    required this.grade,
    required this.group,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [studentId, name, grade, group, createdBy];
}
