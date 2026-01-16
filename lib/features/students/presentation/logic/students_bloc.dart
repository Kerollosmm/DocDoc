import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';
import 'package:doc_app/features/students/domain/repos/students_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'students_state.dart';

class StudentsBloc extends Cubit<StudentsState> {
  final StudentsRepository _repository;

  StudentsBloc(this._repository) : super(StudentsInitial());

  Future<void> loadStudents({String? grade, String? group}) async {
    emit(StudentsLoading());
    final result = await _repository.getStudents(grade: grade, group: group);
    result.fold(
      (failure) => emit(StudentsFailure(failure.message)),
      (students) => emit(StudentsLoaded(students)),
    );
  }

  Future<void> addStudent(StudentEntity student) async {
    // emit(StudentsLoading()); // Optional, or just optimistic add
    final result = await _repository.addStudent(student);
    result.fold(
      (failure) => emit(StudentsFailure(failure.message)),
      (_) {
        // Reload list
        loadStudents(grade: student.grade, group: student.group);
      },
    );
  }
}
