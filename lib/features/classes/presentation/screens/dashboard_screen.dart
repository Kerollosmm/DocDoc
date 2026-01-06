import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/presentation/widgets/online_status_indicator.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/role.dart';
import '../../../attendance/presentation/screens/attendance_tab.dart';
import '../../../servants/presentation/screens/servant_directory_screen.dart';
import '../../../data/presentation/screens/data_tab.dart'; // New Import

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(AppRoutes.login);
        }
      },
      builder: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          final isAdmin = user.role == UserRole.admin;

          // Define tabs based on role
          final List<Widget> pages = [];
          final List<BottomNavigationBarItem> navItems = [];

          // 1. Attendance Tab
          pages.add(const AttendanceTab());
          navItems.add(const BottomNavigationBarItem(
            icon: Icon(Icons.check_circle_outline),
            label: 'Attendance',
          ));

          if (isAdmin) {
            // 2. Servants Tab
            pages.add(const ServantDirectoryScreen());
            navItems.add(const BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Servants',
            ));

            // 3. Data Tab
            pages.add(const DataTab());
            navItems.add(const BottomNavigationBarItem(
              icon: Icon(Icons.dataset),
              label: 'Data',
            ));
          }

          // Ensure index is valid
          if (_currentIndex >= pages.length) {
            _currentIndex = 0;
          }

          return Scaffold(
            appBar: AppBar(
              title: Row(
                children: [
                   const CircleAvatar(
                     backgroundColor: Colors.purple,
                     radius: 16,
                     child: Icon(Icons.church, size: 16, color: Colors.white),
                   ),
                   const SizedBox(width: 8),
                   Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('CSMS', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(
                        isAdmin ? 'Administrator' : 'Servant',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                const OnlineStatusIndicator(),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        child: Text(user.name.isNotEmpty ? user.name[0].toUpperCase() : '?', style: const TextStyle(fontSize: 12)),
                      ),
                      const SizedBox(width: 4),
                      Text(user.name, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Logout',
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutRequested());
                  },
                ),
              ],
            ),
            body: pages[_currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: (index) => setState(() => _currentIndex = index),
              items: navItems,
            ),
          );
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
