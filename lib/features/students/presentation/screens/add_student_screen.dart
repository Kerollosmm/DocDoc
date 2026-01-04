import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../injection_container.dart';
import '../../../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';

class AddStudentScreen extends StatelessWidget {
  final String grade;

  const AddStudentScreen({super.key, required this.grade});

  @override
  Widget build(BuildContext context) {
    // We expect the Bloc to be passed via GoRouter extra or we create a new one
    // But since we want to add to the repository, a new instance is fine if it interacts with the same repo/DB.
    // However, for the LIST screen to update, it needs to reload.
    // We will just use a new instance here to perform the ADD.
    // The List screen will need to reload on pop.

    return BlocProvider(
      create: (context) => getIt<StudentBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Add Student to $grade')),
        body: Builder(
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const Text('Enter details manually or import from Excel.'),
                  const SizedBox(height: 20),
                  TextField(
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSubmitted: (name) {
                      if (name.isNotEmpty) {
                         context.read<StudentBloc>().add(
                            StudentEvent.addStudent(Student(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: name,
                              grade: grade,
                            )),
                          );
                          // Signal success and pop
                          // In real app, listen to state changes for Success/Error
                          // For now, pop after short delay or fire-and-forget
                          Future.delayed(const Duration(milliseconds: 100), () {
                            context.pop(true); // Return true to indicate change
                          });
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Import from Excel'),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Simulating Excel Import...')),
                      );

                      context.read<StudentBloc>().add(
                            StudentEvent.addStudent(Student(
                              id: DateTime.now().millisecondsSinceEpoch.toString(),
                              name: 'Imported Student',
                              grade: grade,
                            )),
                          );

                      Future.delayed(const Duration(milliseconds: 100), () {
                        context.pop(true);
                      });
                    },
                  ),
                ],
              ),
            );
          }
        ),
      ),
    );
  }
}
