import 'package:flutter/material.dart';

class AttendanceHistoryScreen extends StatelessWidget {
  const AttendanceHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Attendance History')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final date = DateTime.now().subtract(Duration(days: index * 7));
          return ListTile(
            leading: const Icon(Icons.event_note),
            title: Text('Session ${index + 1}'),
            subtitle: Text('Date: ${date.toString().split(' ').first}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          );
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: 5,
      ),
    );
  }
}
