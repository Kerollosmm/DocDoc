import 'dart:io';
import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import '../../domain/entities/student.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class ExcelService {
  final Uuid _uuid = const Uuid();

  Future<List<Student>> parseStudents(List<int> bytes, String grade) async {
    try {
      final excel = Excel.decodeBytes(bytes);
      final List<Student> students = [];

      for (var table in excel.tables.keys) {
        final sheet = excel.tables[table];
        if (sheet == null) continue;

        bool isHeader = true;
        for (var row in sheet.rows) {
          if (isHeader) {
            isHeader = false;
            continue;
          }

          if (row.isEmpty) continue;

          final nameCell = row.elementAtOrNull(0);
          if (nameCell == null || nameCell.value == null) continue;

          final name = nameCell.value.toString();

          final phoneCell = row.elementAtOrNull(1);
          final phone = phoneCell?.value?.toString() ?? '';

          final addressCell = row.elementAtOrNull(2);
          final address = addressCell?.value?.toString();

          students.add(Student(
            id: _uuid.v4(),
            name: name,
            grade: grade,
            phoneNumber: phone,
            address: address,
          ));
        }
      }
      return students;
    } catch (e) {
      // Return empty list or rethrow custom exception
      return [];
    }
  }

  Future<File> exportStudents(List<Student> students) async {
    final excel = Excel.createExcel();
    final sheet = excel['Students'];

    // Add header
    sheet.appendRow([
      TextCellValue('Name'),
      TextCellValue('Phone'),
      TextCellValue('Grade'),
      TextCellValue('Address'),
    ]);

    for (var student in students) {
      sheet.appendRow([
        TextCellValue(student.name),
        TextCellValue(student.phoneNumber),
        TextCellValue(student.grade),
        TextCellValue(student.address ?? ''),
      ]);
    }

    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/students_export.xlsx');
    await file.writeAsBytes(excel.encode() ?? []);

    return file;
  }
}
