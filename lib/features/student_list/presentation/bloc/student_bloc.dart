// lib/features/student_list/presentation/bloc/student_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/repositories/student_repository.dart';

part 'student_bloc.freezed.dart';
part 'student_state.dart';
part 'student_event.dart';

@injectable
class StudentBloc extends Bloc<StudentEvent, StudentState> {
  final StudentRepository _repository;

  StudentBloc(this._repository) : super(const StudentState.initial()) {
    on<LoadStudents>(_onLoadStudents);
    on<AddStudent>(_onAddStudent);
  }

  Future<void> _onLoadStudents(LoadStudents event, Emitter<StudentState> emit) async {
    emit(const StudentState.loading());
    final result = await _repository.getStudents(event.grade);
    result.fold(
      (failure) => emit(StudentState.error(failure.message)),
      (students) => emit(StudentState.loaded(students)),
    );
  }

  Future<void> _onAddStudent(AddStudent event, Emitter<StudentState> emit) async {
    // Optimistic update or reload strategy would go here
    // For MVP, simply call repo and reload
    final result = await _repository.addStudent(event.student);
    result.fold(
      (failure) => emit(StudentState.error(failure.message)),
      (_) => add(LoadStudents(event.student.grade)),
    );
  }
}
