import 'package:excel/excel.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/student.dart';
import 'package:uuid/uuid.dart';

@lazySingleton
class ExcelService {
  final Uuid _uuid = const Uuid();

  Future<List<Student>> parseStudents(List<int> bytes, String grade) async {
    final excel = Excel.decodeBytes(bytes);
    final List<Student> students = [];

    for (var table in excel.tables.keys) {
      // Assume the first sheet is the one we want, or iterate all
      // Assume columns: Name, PhoneNumber
      // Skip header row
      final sheet = excel.tables[table];
      if (sheet == null) continue;

      bool isHeader = true;
      for (var row in sheet.rows) {
        if (isHeader) {
          isHeader = false;
          continue;
        }

        // Safety check for empty rows
        if (row.isEmpty) continue;

        // Column 0: Name
        final nameCell = row.elementAtOrNull(0);
        if (nameCell == null || nameCell.value == null) continue;

        final name = nameCell.value.toString();

        // Column 1: Phone (Optional)
        final phoneCell = row.elementAtOrNull(1);
        final phone = phoneCell?.value?.toString();

        students.add(Student(
          id: _uuid.v4(),
          name: name,
          grade: grade,
          phoneNumber: phone,
        ));
      }
    }

    return students;
  }
}
