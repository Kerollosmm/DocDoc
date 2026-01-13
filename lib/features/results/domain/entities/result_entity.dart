class ResultEntity {
  final String id;
  final String studentId;
  final String subject;
  final double score;
  final DateTime date;

  const ResultEntity({
    required this.id,
    required this.studentId,
    required this.subject,
    required this.score,
    required this.date,
  });
}
