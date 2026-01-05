import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';
import '../../../../injection_container.dart';
import '../../../../domain/entities/user.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../../../students/presentation/bloc/student_bloc.dart';
import '../bloc/attendance_bloc.dart';
import '../widgets/summary_card.dart';

class AttendanceTab extends StatefulWidget {
  const AttendanceTab({super.key});

  @override
  State<AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<AttendanceTab> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedGrade;
  final List<String> _grades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6'];

  @override
  void initState() {
    super.initState();
    // Initialize with user's grade if servant
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated && authState.user.role == UserRole.servant) {
      _selectedGrade = authState.user.grade;
      if (_selectedGrade != null) {
        _loadData();
      }
    } else {
      // Admin defaults to Grade 1 or "Select Grade"
      _selectedGrade = _grades.first;
      _loadData();
    }
  }

  void _loadData() {
    if (_selectedGrade == null) return;
    final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);

    // Ensure blocs are available
    // We will wrap this widget with BlocProviders in the Dashboard or here?
    // Let's assume BlocProviders are handled at screen level or via DI + MultiBlocProvider

    context.read<StudentBloc>().add(StudentEvent.loadStudents(_selectedGrade!));
    context.read<AttendanceBloc>().add(AttendanceEvent.loadAttendance(dateStr, _selectedGrade!));
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! AuthAuthenticated) return const SizedBox.shrink();
        final isAdmin = authState.user.role == UserRole.admin;

        return Column(
          children: [
            // Controls (Date + Grade)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text(DateFormat('yyyy-MM-dd').format(_selectedDate)),
                      onPressed: _pickDate,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (isAdmin)
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedGrade,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        ),
                        items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setState(() => _selectedGrade = val);
                            _loadData();
                          }
                        },
                      ),
                    )
                  else
                    Expanded(
                      child: Center(child: Text(_selectedGrade ?? 'No Grade Assigned')),
                    ),
                ],
              ),
            ),

            // Summary
            BlocBuilder<AttendanceBloc, AttendanceState>(
              builder: (context, state) {
                return state.maybeWhen(
                  loaded: (attendanceMap) {
                    final total = attendanceMap.length; // This is not total students, but total records.
                    // To get total students we need StudentBloc state.
                    // But we can count statuses from the map.
                    int present = 0;
                    int absent = 0;
                    int excused = 0;

                    attendanceMap.values.forEach((r) {
                      if (r.status == AttendanceStatus.present) present++;
                      if (r.status == AttendanceStatus.absent) absent++;
                      // excused not in enum yet? Let's check.
                    });

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SummaryCard(title: 'Present', value: '$present', color: Colors.green, icon: Icons.check_circle),
                        SummaryCard(title: 'Absent', value: '$absent', color: Colors.red, icon: Icons.cancel),
                        // SummaryCard(title: 'Excused', value: '$excused', color: Colors.purple, icon: Icons.watch_later),
                      ],
                    );
                  },
                  orElse: () => const SizedBox(),
                );
              },
            ),

            const Divider(),

            // List
            Expanded(
              child: BlocBuilder<StudentBloc, StudentState>(
                builder: (context, studentState) {
                  return studentState.maybeWhen(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (msg) => Center(child: Text('Error: $msg')),
                    loaded: (students) {
                      if (students.isEmpty) return const Center(child: Text('No students found.'));

                      return BlocBuilder<AttendanceBloc, AttendanceState>(
                        builder: (context, attendanceState) {
                          final attendanceMap = attendanceState.maybeWhen(
                            loaded: (map) => map,
                            orElse: () => <String, AttendanceRecord>{},
                          );

                          return ListView.builder(
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final student = students[index];
                              final record = attendanceMap[student.id];

                              return _StudentListItem(
                                student: student,
                                record: record,
                                date: DateFormat('yyyy-MM-dd').format(_selectedDate),
                                grade: _selectedGrade!,
                              );
                            },
                          );
                        },
                      );
                    },
                    orElse: () => const SizedBox(),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _StudentListItem extends StatelessWidget {
  final Student student;
  final AttendanceRecord? record;
  final String date;
  final String grade;

  const _StudentListItem({
    required this.student,
    required this.record,
    required this.date,
    required this.grade,
  });

  @override
  Widget build(BuildContext context) {
    final status = record?.status;
    final isConflict = record?.isConflict == true || record?.needsAdminReview == true;

    return ListTile(
      leading: CircleAvatar(child: Text(student.name[0])),
      title: Text(student.name),
      subtitle: isConflict
          ? const Text('Conflict Detected!', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Present
          IconButton(
            icon: Icon(Icons.check_circle, color: status == AttendanceStatus.present ? Colors.green : Colors.grey[300]),
            onPressed: () => _mark(context, AttendanceStatus.present),
          ),
          // Absent
          IconButton(
            icon: Icon(Icons.cancel, color: status == AttendanceStatus.absent ? Colors.red : Colors.grey[300]),
            onPressed: () => _mark(context, AttendanceStatus.absent),
          ),
           // Warning/Conflict Button
          if (isConflict)
             IconButton(
               icon: const Icon(Icons.warning, color: Colors.red),
               onPressed: () {
                 // Open Conflict Dialog
                 showDialog(
                   context: context,
                   builder: (_) => ConflictResolutionDialog(
                     studentName: student.name,
                     record: record!,
                     onResolve: (status) => _mark(context, status),
                   ),
                 );
               },
             ),
          // Sync Status
          if (record != null)
             Icon(
               record!.isSynced ? Icons.cloud_done : Icons.cloud_upload,
               size: 16,
               color: record!.isSynced ? Colors.green : Colors.grey,
             )
        ],
      ),
    );
  }

  void _mark(BuildContext context, AttendanceStatus status) {
    context.read<AttendanceBloc>().add(
      AttendanceEvent.markAttendance(
        AttendanceRecord(
          studentId: student.id,
          status: status,
          date: date,
          updatedBy: 'current_user', // TODO: Get actual user ID
          timestamp: DateTime.now().millisecondsSinceEpoch,
          grade: grade,
          isConflict: false, // Resolving conflict if marking new
          needsAdminReview: false,
        ),
      ),
    );
  }
}

// Simple Conflict Dialog placeholder for now
class ConflictResolutionDialog extends StatelessWidget {
  final String studentName;
  final AttendanceRecord record;
  final Function(AttendanceStatus) onResolve;

  const ConflictResolutionDialog({
    super.key,
    required this.studentName,
    required this.record,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
         children: [Icon(Icons.warning, color: Colors.orange), SizedBox(width: 8), Text('Attendance Conflict')],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Multiple servants have marked different attendance for $studentName.'),
          const SizedBox(height: 16),
          const Text('Please resolve the conflict:'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onResolve(AttendanceStatus.present);
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.green),
          child: const Text('Mark Present'),
        ),
        TextButton(
          onPressed: () {
            onResolve(AttendanceStatus.absent);
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Mark Absent'),
        ),
      ],
    );
  }
}
