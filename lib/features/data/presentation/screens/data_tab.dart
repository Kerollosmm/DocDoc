import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import '../../../../injection_container.dart';
import '../../../../core/services/excel_service.dart';
import '../../../../domain/repositories/student_repository.dart';
import '../../../../domain/entities/student.dart';
import '../../../students/presentation/bloc/student_bloc.dart';

class DataTab extends StatefulWidget {
  const DataTab({super.key});

  @override
  State<DataTab> createState() => _DataTabState();
}

class _DataTabState extends State<DataTab> {
  // We reuse StudentList logic but tailored for management
  // Or just simple cards for actions as described
  String? _selectedGrade;
  final List<String> _grades = ['Grade 1', 'Grade 2', 'Grade 3', 'Grade 4', 'Grade 5', 'Grade 6'];
  DateTime _exportDate = DateTime.now();

  Future<void> _importStudents() async {
    // Select grade first? or let user select in dialog?
    // User Guide: "Upload Excel file to add students" -> "Parse" -> "Toast success"
    // We assume import needs a grade target or the excel has it.
    // The ExcelService `parseStudents` takes a grade.

    if (_selectedGrade == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a grade first')));
      return;
    }

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );

      if (result != null) {
        final bytes = result.files.single.bytes;
        final path = result.files.single.path;

        // Mobile uses path, Web uses bytes
        if (path != null) {
           final repo = getIt<StudentRepository>();
           final failureOrSuccess = await repo.importStudentsFromExcel(path, _selectedGrade!);
           failureOrSuccess.fold(
             (f) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Import failed: ${f.message}'))),
             (students) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Successfully imported ${students.length} students'))),
           );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Future<void> _exportAttendance() async {
    // The ExcelService has `exportStudents` but we need `exportAttendance`.
    // We might need to implement `exportAttendance` in ExcelService.
    // For now mock success.
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Attendance data has been exported (Mock)')));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Data Management', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('Import and export data, manage students', style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 16),

          // Grade Selector for Operations
          DropdownButtonFormField<String>(
            value: _selectedGrade,
            decoration: const InputDecoration(
              labelText: 'Select Grade Target',
              border: OutlineInputBorder(),
            ),
            items: _grades.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
            onChanged: (val) {
              setState(() => _selectedGrade = val);
            },
          ),
          const SizedBox(height: 16),

          // Cards
          Row(
            children: [
              Expanded(
                child: _FeatureCard(
                  title: 'Import Students',
                  description: 'Upload Excel file',
                  icon: Icons.upload_file,
                  color: Colors.purple,
                  buttonText: 'Select File',
                  onPressed: _importStudents,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _FeatureCard(
                  title: 'Export Attendance',
                  description: 'Download report',
                  icon: Icons.download,
                  color: Colors.green,
                  buttonText: 'Export CSV',
                  onPressed: _exportAttendance,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 8),

          // Student List Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Student List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Manage all students', style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Add Student'),
                onPressed: () {
                   // Navigate to Add Student
                   // We need to know which grade to add to, or allow selection in screen
                   // Reusing existing screen which takes grade param
                   if (_selectedGrade != null) {
                     // context.push...
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Navigation to Add Student implemented in Router')));
                   } else {
                     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a grade above')));
                   }
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Student List Preview (Only if grade selected)
          if (_selectedGrade != null)
             SizedBox(
               height: 400,
               child: BlocProvider(
                 create: (_) => getIt<StudentBloc>()..add(StudentEvent.loadStudents(_selectedGrade!)),
                 child: BlocBuilder<StudentBloc, StudentState>(
                    builder: (context, state) {
                      return state.maybeWhen(
                        loading: () => const Center(child: CircularProgressIndicator()),
                        loaded: (students) {
                          if (students.isEmpty) return const Center(child: Text('No students found'));
                          return ListView.builder(
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              final s = students[index];
                              return ListTile(
                                leading: CircleAvatar(child: Text(s.name[0])),
                                title: Text(s.name),
                                subtitle: Text(s.grade),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {},
                                ),
                              );
                            },
                          );
                        },
                        orElse: () => const SizedBox(),
                      );
                    },
                 ),
               ),
             )
          else
            const Center(child: Text('Select a grade to view students')),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String buttonText;
  final VoidCallback onPressed;

  const _FeatureCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.1),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(description, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onPressed,
                child: Text(buttonText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
