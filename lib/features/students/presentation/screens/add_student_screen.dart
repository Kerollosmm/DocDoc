import 'package:doc_app/core/di/service_locator.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:doc_app/features/students/presentation/logic/students_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _nameController = TextEditingController();
  final _gradeController = TextEditingController();
  final _groupController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<StudentsBloc>(),
      child: Scaffold(
        appBar: AppBar(title: const Text("Add Student")),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Builder(
            builder: (context) {
              return Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: _gradeController,
                    decoration: const InputDecoration(labelText: "Grade"),
                  ),
                  TextField(
                    controller: _groupController,
                    decoration: const InputDecoration(labelText: "Group"),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      final student = StudentEntity(
                        studentId: const Uuid().v4(),
                        name: _nameController.text,
                        grade: _gradeController.text,
                        group: _groupController.text,
                        createdBy: 'current_user_id_placeholder',
                      );
                      context.read<StudentsBloc>().addStudent(student);
                      Navigator.pop(context);
                    },
                    child: const Text("Save"),
                  ),
                ],
              );
            }
          ),
        ),
      ),
    );
  }
}
