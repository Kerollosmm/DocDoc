import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:csms/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:csms/features/auth/presentation/bloc/auth_bloc.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  @override
  void initState() {
    super.initState();
    context.read<AttendanceBloc>().add(LoadServantsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
               context.read<AttendanceBloc>().add(SyncAttendanceEvent());
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthBloc>().add(LogoutEvent());
              // Listener in AppRouter or here will handle navigation
            },
          ),
        ],
      ),
      body: BlocConsumer<AttendanceBloc, AttendanceState>(
        listener: (context, state) {
          if (state is AttendanceError) {
             ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          if (state is AttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is AttendanceLoaded) {
            if (state.servants.isEmpty) {
              return const Center(child: Text('No servants found.'));
            }
            return ListView.builder(
              itemCount: state.servants.length,
              itemBuilder: (context, index) {
                final servant = state.servants[index];
                return Card(
                  child: ListTile(
                    title: Text(servant.name),
                    subtitle: Text(servant.role),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.check_circle_outline, color: Colors.green),
                          onPressed: () {
                            context.read<AttendanceBloc>().add(
                              MarkAttendanceEvent(
                                servantId: servant.id,
                                serviceId: 'daily_service', // Hardcoded for now
                                status: 'present',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked Present'), duration: Duration(milliseconds: 500)));
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel_outlined, color: Colors.red),
                          onPressed: () {
                            context.read<AttendanceBloc>().add(
                              MarkAttendanceEvent(
                                servantId: servant.id,
                                serviceId: 'daily_service',
                                status: 'absent',
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marked Absent'), duration: Duration(milliseconds: 500)));
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
      ),
    );
  }
}
