import 'package:doc_app/core/di/service_locator.dart';
import 'package:doc_app/features/students/presentation/logic/students_bloc.dart';
import 'package:doc_app/features/students/presentation/screens/add_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentsBloc>()..loadStudents(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Students"),
          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => context.read<StudentsBloc>().loadStudents(),
                );
              }
            )
          ],
        ),
        floatingActionButton: Builder(
          builder: (context) {
            return FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddStudentScreen()),
                );
                // Refresh list after returning
                if (context.mounted) {
                   context.read<StudentsBloc>().loadStudents();
                }
              },
              child: const Icon(Icons.add),
            );
          }
        ),
        body: BlocBuilder<StudentsBloc, StudentsState>(
          builder: (context, state) {
            if (state is StudentsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StudentsLoaded) {
              if (state.students.isEmpty) {
                return const Center(child: Text("No students found."));
              }
              return ListView.builder(
                itemCount: state.students.length,
                itemBuilder: (context, index) {
                  final student = state.students[index];
                  return ListTile(
                    title: Text(student.name),
                    subtitle: Text("${student.grade} - ${student.group}"),
                  );
                },
              );
            } else if (state is StudentsFailure) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
