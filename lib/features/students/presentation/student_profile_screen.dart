import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:flutter/material.dart';

class StudentProfileScreen extends StatelessWidget {
  final StudentEntity student;

  const StudentProfileScreen({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(student.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(radius: 36, child: Icon(Icons.person)),
            const SizedBox(height: 16),
            Text('Student ID: ${student.id}', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Grade: ${student.grade}'),
            Text('Group: ${student.group}'),
            const SizedBox(height: 16),
            const Text('Attendance Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Present: 12 • Absent: 1'),
            const SizedBox(height: 16),
            const Text('Latest Results', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Math Midterm: 88'),
          ],
        ),
      ),
    );
  }
}
