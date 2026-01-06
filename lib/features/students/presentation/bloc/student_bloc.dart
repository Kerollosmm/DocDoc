import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/services/excel_service.dart';
import '../../../../domain/entities/student.dart';
import '../../../../domain/repositories/student_repository.dart';

part 'student_bloc.freezed.dart';

@freezed
class StudentEvent with _$StudentEvent {
  const factory StudentEvent.loadStudents(String grade) = _LoadStudents;
  const factory StudentEvent.addStudent(Student student) = _AddStudent;
  const factory StudentEvent.deleteStudent(String id) = _DeleteStudent;
  const factory StudentEvent.updateStudent(Student student) = _UpdateStudent;
  const factory StudentEvent.importStudents(String path, String grade) = _ImportStudents;
  const factory StudentEvent.exportStudents(String grade) = _ExportStudents;
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
  final ExcelService _excelService; // Directly use service for export as repo might not need to handle file generation logic directly if it's UI/Service related, but repo handles data. The requirement said "Add exportStudents... Save the file... return File path" in ExcelService. And Bloc uses Share.

  String? _currentGrade;

  StudentBloc(this._repository, this._excelService) : super(const StudentState.initial()) {
    on<_LoadStudents>((event, emit) async {
      _currentGrade = event.grade;
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

    on<_UpdateStudent>((event, emit) async {
       final result = await _repository.updateStudent(event.student);

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
           if (_currentGrade != null) {
             add(StudentEvent.loadStudents(_currentGrade!));
           } else {
             // Fallback if somehow deleted without load
             emit(const StudentState.initial());
           }
        },
      );
    });

    on<_ImportStudents>((event, emit) async {
      emit(const StudentState.loading());
      final result = await _repository.importStudentsFromExcel(event.path, event.grade);

      result.fold(
        (failure) => emit(StudentState.error(failure.message)),
        (students) => add(StudentEvent.loadStudents(event.grade)),
      );
    });

    on<_ExportStudents>((event, emit) async {
       // Logic: Get current students (from state or repo), generate file, share.
       // We can fetch fresh data first.
       final result = await _repository.getStudents(event.grade);

       await result.fold(
         (failure) async => emit(StudentState.error(failure.message)),
         (students) async {
            try {
              final file = await _excelService.exportStudents(students);
              await Share.shareXFiles([XFile(file.path)], text: 'Students Export - ${event.grade}');
              emit(StudentState.loaded(students)); // Maintain state
            } catch (e) {
              emit(StudentState.error('Failed to export: $e'));
            }
         }
       );
    });
  }
}
