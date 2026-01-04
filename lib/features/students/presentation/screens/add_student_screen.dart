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
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final addressController = TextEditingController();

    return BlocProvider(
      create: (context) => getIt<StudentBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text('Add Student to $grade')),
        body: Builder(
          builder: (context) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Student Profile', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),

                  // Name
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Phone (Required)
                  TextField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Address (Optional)
                  TextField(
                    controller: addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Actions
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      final name = nameController.text.trim();
                      final phone = phoneController.text.trim();
                      final address = addressController.text.trim();

                      if (name.isEmpty || phone.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Name and Phone are required!')),
                        );
                        return;
                      }

                      context.read<StudentBloc>().add(
                        StudentEvent.addStudent(Student(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: name,
                          grade: grade,
                          phoneNumber: phone,
                          address: address.isNotEmpty ? address : null,
                        )),
                      );

                      // Signal success
                      if (context.mounted) {
                        Future.delayed(const Duration(milliseconds: 100), () {
                          if (context.mounted) {
                            context.pop(true);
                          }
                        });
                      }
                    },
                    child: const Text('Save Student'),
                  ),

                  const SizedBox(height: 20),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.table_chart),
                    label: const Text('Import from Excel'),
                    onPressed: () {
                       // ... logic for Excel import
                       if (context.mounted) {
                         context.pop(true);
                       }
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
