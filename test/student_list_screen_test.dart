import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:csms_app/features/students/presentation/bloc/student_bloc.dart';
import 'package:csms_app/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:csms_app/features/students/presentation/screens/student_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class MockStudentBloc extends Mock implements StudentBloc {}
class MockAttendanceBloc extends Mock implements AttendanceBloc {}

void main() {
  setUpAll(() {
    registerFallbackValue(const StudentEvent.loadStudents(''));
    registerFallbackValue(const StudentState.initial());
    registerFallbackValue(const AttendanceEvent.loadAttendance('', ''));
    registerFallbackValue(const AttendanceState.initial());
  });

  tearDown(() {
    GetIt.instance.reset();
  });

  testWidgets('StudentListScreen renders correctly', (WidgetTester tester) async {
    final mockStudentBloc = MockStudentBloc();
    final mockAttendanceBloc = MockAttendanceBloc();

    when(() => mockStudentBloc.state).thenReturn(const StudentState.loaded([]));
    when(() => mockStudentBloc.stream).thenAnswer((_) => Stream.value(const StudentState.loaded([])));
    when(() => mockStudentBloc.add(any())).thenAnswer((_) async {});

    when(() => mockAttendanceBloc.state).thenReturn(const AttendanceState.loaded({}));
    when(() => mockAttendanceBloc.stream).thenAnswer((_) => Stream.value(const AttendanceState.loaded({})));
    when(() => mockAttendanceBloc.add(any())).thenAnswer((_) async {});

    // Register mocks in GetIt
    GetIt.instance.registerSingleton<StudentBloc>(mockStudentBloc);
    GetIt.instance.registerSingleton<AttendanceBloc>(mockAttendanceBloc);

    await tester.pumpWidget(MaterialApp(
      home: const StudentListScreen(grade: 'Grade 1'),
    ));

    expect(find.text('Students - Grade 1'), findsOneWidget);
    // Should see empty state message
    expect(find.text('No students found.'), findsOneWidget);
  });
}
