class AttendanceRecord {
  final String studentId;
  final String studentName;
  final bool isPresent;
  final String? note;

  const AttendanceRecord({
    required this.studentId,
    required this.studentName,
    required this.isPresent,
    this.note,
  });
}
