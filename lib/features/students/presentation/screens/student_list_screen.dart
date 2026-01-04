import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';
import '../../../attendance/presentation/bloc/attendance_bloc.dart';

class StudentListScreen extends StatelessWidget {
  final String grade;

  const StudentListScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    // Current date for attendance
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<StudentBloc>()..add(StudentEvent.loadStudents(grade)),
        ),
        BlocProvider(
          create: (context) => getIt<AttendanceBloc>()..add(AttendanceEvent.loadAttendance(date, grade)),
        ),
      ],
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Students - $grade'),
            actions: [
              IconButton(
                icon: const Icon(Icons.share),
                tooltip: 'Export to Excel',
                onPressed: () {
                  context.read<StudentBloc>().add(StudentEvent.exportStudents(grade));
                }
              ),
              IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () async {
                   // Navigate to Add Student and wait for result
                   final result = await context.push<bool>('/add-student/$grade');
                   if (result == true) {
                     // Refresh list
                     if (context.mounted) {
                       context.read<StudentBloc>().add(StudentEvent.loadStudents(grade));
                     }
                   }
                }
              ),
            ],
          ),
          body: BlocListener<StudentBloc, StudentState>(
            listener: (context, state) {
               state.maybeWhen(
                 error: (msg) {
                   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                 },
                 orElse: () {},
               );
            },
            child: BlocBuilder<StudentBloc, StudentState>(
              builder: (context, studentState) {
                return studentState.maybeWhen(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (msg) => Center(child: Text('Error: $msg')),
                  loaded: (students) {
                    if (students.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('No students found.'),
                            TextButton(
                              onPressed: () async {
                                final result = await context.push<bool>('/add-student/$grade');
                                if (result == true && context.mounted) {
                                  context.read<StudentBloc>().add(StudentEvent.loadStudents(grade));
                                }
                              },
                              child: const Text('Add Student'),
                            )
                          ],
                        ),
                      );
                    }
                    return _StudentListView(students: students, date: date, grade: grade);
                  },
                  orElse: () => const SizedBox(),
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _StudentListView extends StatelessWidget {
  final List<Student> students;
  final String date;
  final String grade;

  const _StudentListView({required this.students, required this.date, required this.grade});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AttendanceBloc, AttendanceState>(
      builder: (context, state) {
        final attendanceMap = state.maybeWhen(
          loaded: (map) => map,
          orElse: () => <String, AttendanceRecord>{},
        );

        return ListView.builder(
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            final record = attendanceMap[student.id];
            final isPresent = record?.status == AttendanceStatus.present;
            final isAbsent = record?.status == AttendanceStatus.absent;
            final isConflict = record?.isConflict == true;

            return ListTile(
              title: Text(student.name),
              subtitle: isConflict
                ? const Text('Conflict Detected!', style: TextStyle(color: Colors.orange))
                : null,
              onTap: () async {
                 // Navigate to Edit
                 final result = await context.push<bool>('/edit-student/$grade', extra: student);
                 if (result == true && context.mounted) {
                   context.read<StudentBloc>().add(StudentEvent.loadStudents(grade));
                 }
              },
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.check_circle,
                      color: isPresent ? Colors.green : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<AttendanceBloc>().add(
                            AttendanceEvent.markAttendance(
                              AttendanceRecord(
                                studentId: student.id,
                                status: AttendanceStatus.present,
                                date: date,
                                updatedBy: 'user',
                                timestamp: DateTime.now().millisecondsSinceEpoch,
                                grade: grade,
                              ),
                            ),
                          );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.cancel,
                      color: isAbsent ? Colors.red : Colors.grey,
                    ),
                    onPressed: () {
                      context.read<AttendanceBloc>().add(
                            AttendanceEvent.markAttendance(
                              AttendanceRecord(
                                studentId: student.id,
                                status: AttendanceStatus.absent,
                                date: date,
                                updatedBy: 'user',
                                timestamp: DateTime.now().millisecondsSinceEpoch,
                                grade: grade,
                              ),
                            ),
                          );
                    },
                  ),
                  if (isConflict)
                    IconButton(
                      icon: const Icon(Icons.warning, color: Colors.orange),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Resolve conflict manually...')),
                        );
                      },
                    )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
