import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/repositories/student_repository.dart';

part 'student_bloc.freezed.dart';

@freezed
class StudentEvent with _$StudentEvent {
  const factory StudentEvent.loadStudents(String grade) = _LoadStudents;
  const factory StudentEvent.addStudent(Student student) = _AddStudent;
  const factory StudentEvent.deleteStudent(String id) = _DeleteStudent;
}

@freezed
class StudentState with _$StudentState {
  const factory StudentState.initial() = _Initial;
  const factory StudentState.loading() = _Loading;
  const factory StudentState.loaded(List<Student> students) = _Loaded;
  const factory StudentState.error(String message) = _Error;
}

@injectable
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository _repository;

  StudentBloc(this._repository) : super(const StudentState.initial()) {
    on<_LoadStudents>((event, emit) async {
      emit(const StudentState.loading());
      try {
        final students = await _repository.getStudents(event.grade);
        emit(StudentState.loaded(students));
      } catch (e) {
        emit(StudentState.error(e.toString()));
      }
    });

    on<_AddStudent>((event, emit) async {
      try {
        await _repository.addStudent(event.student);
        // Reload students for the same grade
        add(StudentEvent.loadStudents(event.student.grade));
      } catch (e) {
        emit(StudentState.error(e.toString()));
      }
    });

    on<_DeleteStudent>((event, emit) async {
      try {
        await _repository.deleteStudent(event.id);
        // Note: In a real app we might need to know the grade to reload.
        // For now, we assume the UI handles reloading or optimistically updates.
        // Or we could store the current grade in the state.
      } catch (e) {
        emit(StudentState.error(e.toString()));
      }
    });
  }
}
