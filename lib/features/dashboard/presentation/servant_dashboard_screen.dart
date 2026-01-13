import 'package:doc_app/core/routing/routes.dart';
import 'package:flutter/material.dart';

class ServantDashboardScreen extends StatelessWidget {
  const ServantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Servant Dashboard')),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        children: [
          _DashboardTile(
            title: 'Students',
            icon: Icons.people,
            onTap: () => Navigator.pushNamed(context, Routes.studentsListScreen),
          ),
          _DashboardTile(
            title: 'Take Attendance',
            icon: Icons.check_circle,
            onTap: () => Navigator.pushNamed(context, Routes.attendanceScreen),
          ),
          _DashboardTile(
            title: 'Attendance History',
            icon: Icons.history,
            onTap: () => Navigator.pushNamed(context, Routes.attendanceHistoryScreen),
          ),
          _DashboardTile(
            title: 'Results',
            icon: Icons.school,
            onTap: () => Navigator.pushNamed(context, Routes.resultsScreen),
          ),
        ],
      ),
    );
  }
}

class _DashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _DashboardTile({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36),
            const SizedBox(height: 12),
            Text(title, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
