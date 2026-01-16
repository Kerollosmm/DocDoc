import 'package:doc_app/core/di/service_locator.dart';
import 'package:doc_app/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:doc_app/features/attendance/presentation/logic/attendance_bloc.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:doc_app/features/students/presentation/logic/students_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class TakeAttendanceScreen extends StatefulWidget {
  final String grade;
  final String group;

  const TakeAttendanceScreen({
    super.key,
    required this.grade,
    required this.group,
  });

  @override
  State<TakeAttendanceScreen> createState() => _TakeAttendanceScreenState();
}

class _TakeAttendanceScreenState extends State<TakeAttendanceScreen> {
  final Map<String, String> _attendanceStatus = {}; // studentId -> status (present/absent)
  final String _sessionId = const Uuid().v4();

  @override
  void initState() {
    super.initState();
    // Load students for this grade/group
    // We assume StudentsBloc is available or we create one
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<StudentsBloc>()..loadStudents(
            grade: widget.grade,
            group: widget.group,
          ),
        ),
        BlocProvider(create: (context) => getIt<AttendanceBloc>()),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("Attendance: ${widget.grade} - ${widget.group}")),
        body: BlocBuilder<StudentsBloc, StudentsState>(
          builder: (context, state) {
            if (state is StudentsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentsLoaded) {
              if (state.students.isEmpty) {
                return const Center(child: Text("No students found in this group."));
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: state.students.length,
                      itemBuilder: (context, index) {
                        final student = state.students[index];
                        final status = _attendanceStatus[student.studentId] ?? 'absent';

                        return ListTile(
                          title: Text(student.name),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Present"),
                              Checkbox(
                                value: status == 'present',
                                onChanged: (val) {
                                  setState(() {
                                    _attendanceStatus[student.studentId] = val == true ? 'present' : 'absent';
                                  });
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: BlocConsumer<AttendanceBloc, AttendanceState>(
                      listener: (context, state) {
                        if (state is AttendanceSuccess) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Attendance Saved!")));
                          Navigator.pop(context);
                        } else if (state is AttendanceFailure) {
                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: ${state.message}")));
                        }
                      },
                      builder: (context, state) {
                        if (state is AttendanceLoading) {
                          return const CircularProgressIndicator();
                        }
                        return ElevatedButton(
                          onPressed: () {
                            _submitAttendance(context, state is StudentsLoaded ? (state).students : []);
                          },
                          child: const Text("Submit Attendance"),
                        );
                      },
                    ),
                  )
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _submitAttendance(BuildContext context, List<StudentEntity> students) {
    final records = students.map((student) {
      final status = _attendanceStatus[student.studentId] ?? 'absent';
      return AttendanceRecordEntity(
        recordId: const Uuid().v4(),
        sessionId: _sessionId,
        studentId: student.studentId,
        status: status,
        note: '', // Could add note field
        date: DateTime.now(),
        grade: widget.grade,
        group: widget.group,
        syncStatus: 'pending',
      );
    }).toList();

    context.read<AttendanceBloc>().submitAttendance(records);
  }
}
