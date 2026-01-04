import 'package:flutter_test/flutter_test.dart';
import 'package:doc_app/features/students/presentation/bloc/student_bloc.dart';
import 'package:doc_app/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:doc_app/domain/entities/student.dart';
import 'package:doc_app/domain/entities/attendance_record.dart';
import 'package:mocktail/mocktail.dart';
import 'package:doc_app/domain/repositories/student_repository.dart';
import 'package:doc_app/domain/repositories/attendance_repository.dart';

// Mocks
class MockStudentRepository extends Mock implements StudentRepository {}
class MockAttendanceRepository extends Mock implements AttendanceRepository {}

void main() {
  group('Full Flow Logic Test', () {
    late StudentBloc studentBloc;
    late AttendanceBloc attendanceBloc;
    late MockStudentRepository mockStudentRepo;
    late MockAttendanceRepository mockAttendanceRepo;

    setUp(() {
      mockStudentRepo = MockStudentRepository();
      mockAttendanceRepo = MockAttendanceRepository();
      studentBloc = StudentBloc(mockStudentRepo);
      attendanceBloc = AttendanceBloc(mockAttendanceRepo);

      // Register fallbacks
      registerFallbackValue(const Student(id: '1', name: 'Test', grade: 'G1'));
      registerFallbackValue(const AttendanceRecord(
          studentId: '1',
          status: AttendanceStatus.present,
          date: '2023-01-01',
          updatedBy: 'me',
          timestamp: 0));
    });

    test('Add Student -> Mark Present -> Verify State', () async {
      // 1. Add Student
      final student = const Student(id: '101', name: 'John Doe', grade: 'Grade 5');
      when(() => mockStudentRepo.addStudent(any())).thenAnswer((_) async {});
      when(() => mockStudentRepo.getStudents('Grade 5')).thenAnswer((_) async => [student]);

      studentBloc.add(StudentEvent.addStudent(student));

      // Wait for async
      await untilCalled(() => mockStudentRepo.addStudent(any()));

      // Verify Loaded State
      await expectLater(
        studentBloc.stream,
        emitsThrough(isA<StudentState>().having(
          (s) => s.maybeWhen(loaded: (l) => l.first.name == 'John Doe', orElse: () => false),
          'has John Doe',
          true,
        )),
      );

      // 2. Mark Attendance
      final record = AttendanceRecord(
        studentId: '101',
        status: AttendanceStatus.present,
        date: '2023-10-27',
        updatedBy: 'ServantA',
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );

      when(() => mockAttendanceRepo.markAttendance(any())).thenAnswer((_) async {});

      attendanceBloc.add(AttendanceEvent.markAttendance(record));

      // Verify Attendance State Loaded with correct record
      await expectLater(
        attendanceBloc.stream,
        emitsThrough(isA<AttendanceState>().having(
          (s) => s.maybeWhen(
            loaded: (map) => map['101']?.status == AttendanceStatus.present,
            orElse: () => false,
          ),
          'Marked as Present',
          true,
        )),
      );
    });
  });
}
