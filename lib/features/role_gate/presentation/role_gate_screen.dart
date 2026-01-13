import 'package:doc_app/core/models/user_role.dart';
import 'package:doc_app/core/routing/routes.dart';
import 'package:flutter/material.dart';

class RoleGateScreen extends StatelessWidget {
  const RoleGateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose Role')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _RoleCard(
              role: UserRole.servant,
              description: 'Manage students, attendance, and results.',
              onTap: () => Navigator.pushNamed(context, Routes.servantDashboard),
            ),
            const SizedBox(height: 16),
            _RoleCard(
              role: UserRole.student,
              description: 'View your profile, attendance, and results.',
              onTap: () => Navigator.pushNamed(context, Routes.studentDashboard),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.role,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(role == UserRole.servant ? Icons.admin_panel_settings : Icons.school),
        title: Text(role.label),
        subtitle: Text(description),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
