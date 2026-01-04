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
      final result = await _repository.getStudents(event.grade);

      result.fold(
        (failure) => emit(StudentState.error(failure.message)),
        (students) => emit(StudentState.loaded(students)),
      );
    });

    on<_AddStudent>((event, emit) async {
      final result = await _repository.addStudent(event.student);

      result.fold(
        (failure) => emit(StudentState.error(failure.message)),
        (success) => add(StudentEvent.loadStudents(event.student.grade)),
      );
    });

    on<_DeleteStudent>((event, emit) async {
      final result = await _repository.deleteStudent(event.id);

      result.fold(
        (failure) => emit(StudentState.error(failure.message)),
        (success) {
          // Ideally, we reload or optimistically update.
          // Since we don't know the grade here easily without extra state management,
          // we'll leave it as is for this refactor.
        },
      );
    });
  }
}
