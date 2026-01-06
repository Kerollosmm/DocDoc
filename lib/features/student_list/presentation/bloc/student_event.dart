// lib/features/student_list/presentation/bloc/student_event.dart
part of 'student_bloc.dart';

@freezed
class StudentEvent with _$StudentEvent {
  const factory StudentEvent.loadStudents(String grade) = LoadStudents;
  const factory StudentEvent.addStudent(Student student) = AddStudent;
}
