import 'package:doc_app/core/routing/routes.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:doc_app/features/students/logic/students_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StudentsBloc()..add(const LoadStudents()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Students'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (grade) {
                context.read<StudentsBloc>().add(FilterStudentsByGrade(grade));
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'Grade 10', child: Text('Grade 10')),
                PopupMenuItem(value: 'Grade 9', child: Text('Grade 9')),
              ],
            ),
          ],
        ),
        body: BlocBuilder<StudentsBloc, StudentsState>(
          builder: (context, state) {
            if (state is StudentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StudentsEmpty) {
              return const Center(child: Text('No students found.'));
            }
            if (state is StudentsLoaded) {
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) {
                  final student = state.students[index];
                  return _StudentTile(student: student);
                },
                separatorBuilder: (_, __) => const Divider(),
                itemCount: state.students.length,
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.person_add_alt_1),
        ),
      ),
    );
  }
}

class _StudentTile extends StatelessWidget {
  final StudentEntity student;

  const _StudentTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student.name),
      subtitle: Text('${student.grade} • Group ${student.group}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Navigator.pushNamed(
          context,
          Routes.studentProfileScreen,
          arguments: student,
        );
      },
    );
  }
}
