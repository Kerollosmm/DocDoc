import 'package:bloc/bloc.dart';
import 'package:doc_app/features/students/domain/entities/student_entity.dart';

sealed class StudentsEvent {
  const StudentsEvent();
}

class LoadStudents extends StudentsEvent {
  const LoadStudents();
}

class FilterStudentsByGrade extends StudentsEvent {
  final String grade;

  const FilterStudentsByGrade(this.grade);
}

sealed class StudentsState {
  const StudentsState();
}

class StudentsLoading extends StudentsState {
  const StudentsLoading();
}

class StudentsLoaded extends StudentsState {
  final List<StudentEntity> students;

  const StudentsLoaded(this.students);
}

class StudentsEmpty extends StudentsState {
  const StudentsEmpty();
}

class StudentsBloc extends Bloc<StudentsEvent, StudentsState> {
  StudentsBloc() : super(const StudentsLoading()) {
    on<LoadStudents>(_onLoadStudents);
    on<FilterStudentsByGrade>(_onFilterStudentsByGrade);
  }

  final List<StudentEntity> _allStudents = const [
    StudentEntity(id: 'S1001', name: 'Sara Ali', grade: 'Grade 10', group: 'A'),
    StudentEntity(id: 'S1002', name: 'Omar Khaled', grade: 'Grade 10', group: 'A'),
    StudentEntity(id: 'S1003', name: 'Lina Adel', grade: 'Grade 9', group: 'B'),
  ];

  void _onLoadStudents(LoadStudents event, Emitter<StudentsState> emit) {
    if (_allStudents.isEmpty) {
      emit(const StudentsEmpty());
    } else {
      emit(StudentsLoaded(List.of(_allStudents)));
    }
  }

  void _onFilterStudentsByGrade(
    FilterStudentsByGrade event,
    Emitter<StudentsState> emit,
  ) {
    final filtered =
        _allStudents.where((student) => student.grade == event.grade).toList();
    if (filtered.isEmpty) {
      emit(const StudentsEmpty());
    } else {
      emit(StudentsLoaded(filtered));
    }
  }
}
