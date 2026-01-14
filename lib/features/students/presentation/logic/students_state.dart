part of 'students_bloc.dart';

abstract class StudentsState extends Equatable {
  const StudentsState();
  @override
  List<Object> get props => [];
}

class StudentsInitial extends StudentsState {}
class StudentsLoading extends StudentsState {}
class StudentsLoaded extends StudentsState {
  final List<StudentEntity> students;
  const StudentsLoaded(this.students);
  @override
  List<Object> get props => [students];
}
class StudentsFailure extends StudentsState {
  final String message;
  const StudentsFailure(this.message);
  @override
  List<Object> get props => [message];
}
