import 'package:doc_app/core/routing/routes.dart';
import 'package:flutter/material.dart';

class StudentDashboardScreen extends StatelessWidget {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DashboardCard(
            title: 'My Profile',
            subtitle: 'View your student profile',
            icon: Icons.person,
            onTap: () => Navigator.pushNamed(context, Routes.studentProfileScreen),
          ),
          _DashboardCard(
            title: 'Attendance History',
            subtitle: 'Track your attendance record',
            icon: Icons.event_available,
            onTap: () => Navigator.pushNamed(context, Routes.attendanceHistoryScreen),
          ),
          _DashboardCard(
            title: 'Results',
            subtitle: 'View your latest scores',
            icon: Icons.school,
            onTap: () => Navigator.pushNamed(context, Routes.resultsScreen),
          ),
        ],
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
