class StudentEntity {
  final String id;
  final String name;
  final String grade;
  final String group;
  final String? parentPhone;

  const StudentEntity({
    required this.id,
    required this.name,
    required this.grade,
    required this.group,
    this.parentPhone,
  });
}
