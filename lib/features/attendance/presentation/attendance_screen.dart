import 'package:doc_app/features/attendance/logic/attendance_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AttendanceScreen extends StatelessWidget {
  const AttendanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AttendanceBloc()..add(const LoadAttendanceSession()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Take Attendance')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: 'Grade 10',
                      items: const [
                        DropdownMenuItem(value: 'Grade 10', child: Text('Grade 10')),
                        DropdownMenuItem(value: 'Grade 9', child: Text('Grade 9')),
                      ],
                      onChanged: (_) {},
                      decoration: const InputDecoration(labelText: 'Grade'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: 'A',
                      items: const [
                        DropdownMenuItem(value: 'A', child: Text('Group A')),
                        DropdownMenuItem(value: 'B', child: Text('Group B')),
                      ],
                      onChanged: (_) {},
                      decoration: const InputDecoration(labelText: 'Group'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 18),
                  const SizedBox(width: 8),
                  Text('Session Date: ${DateTime.now().toString().split(' ').first}'),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<AttendanceBloc, AttendanceState>(
                  builder: (context, state) {
                    if (state is AttendanceLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is AttendanceReady) {
                      return ListView.separated(
                        itemCount: state.records.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final record = state.records[index];
                          return SwitchListTile(
                            title: Text(record.studentName),
                            subtitle: Text('ID: ${record.studentId}'),
                            value: record.isPresent,
                            onChanged: (value) {
                              context.read<AttendanceBloc>().add(
                                    ToggleAttendance(
                                      studentId: record.studentId,
                                      isPresent: value,
                                    ),
                                  );
                            },
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          label: const Text('Save Attendance'),
          icon: const Icon(Icons.check_circle_outline),
        ),
      ),
    );
  }
}
