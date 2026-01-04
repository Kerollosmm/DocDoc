import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../injection_container.dart';
import '../../../../domain/entities/student.dart';
import '../bloc/student_bloc.dart';

class AddOrEditStudentScreen extends StatefulWidget {
  final String grade;
  final Student? student;

  const AddOrEditStudentScreen({super.key, required this.grade, this.student});

  @override
  State<AddOrEditStudentScreen> createState() => _AddOrEditStudentScreenState();
}

class _AddOrEditStudentScreenState extends State<AddOrEditStudentScreen> {
  late TextEditingController nameController;
  late TextEditingController phoneController;
  late TextEditingController addressController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.student?.name ?? '');
    phoneController = TextEditingController(text: widget.student?.phoneNumber ?? '');
    addressController = TextEditingController(text: widget.student?.address ?? '');
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.student != null;

    return BlocProvider(
      create: (context) => getIt<StudentBloc>(),
      child: Scaffold(
        appBar: AppBar(title: Text(isEditing ? 'Edit Student' : 'Add Student to ${widget.grade}')),
        body: Builder(
          builder: (context) {
            return BlocListener<StudentBloc, StudentState>(
              listener: (context, state) {
                state.whenOrNull(
                  error: (msg) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  },
                  loaded: (_) {
                    if (context.mounted) context.pop(true);
                  },
                );
              },
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(isEditing ? 'Edit Profile' : 'Student Profile', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

                        if (isEditing) {
                          final updatedStudent = Student(
                            id: widget.student!.id,
                            name: name,
                            grade: widget.grade,
                            phoneNumber: phone,
                            address: address.isNotEmpty ? address : null,
                          );
                          context.read<StudentBloc>().add(StudentEvent.updateStudent(updatedStudent));
                        } else {
                           context.read<StudentBloc>().add(
                            StudentEvent.addStudent(Student(
                              id: DateTime.now().millisecondsSinceEpoch.toString(), // Or use UUID if available
                              name: name,
                              grade: widget.grade,
                              phoneNumber: phone,
                              address: address.isNotEmpty ? address : null,
                            )),
                          );
                        }
                      },
                      child: Text(isEditing ? 'Update Student' : 'Save Student'),
                    ),

                    if (!isEditing) ...[
                      const SizedBox(height: 20),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.table_chart),
                        label: const Text('Import from Excel'),
                        onPressed: () async {
                           final result = await FilePicker.platform.pickFiles(
                             type: FileType.custom,
                             allowedExtensions: ['xlsx'],
                           );

                           if (result != null && result.files.single.path != null) {
                             if (context.mounted) {
                               context.read<StudentBloc>().add(StudentEvent.importStudents(result.files.single.path!, widget.grade));
                             }
                           }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
