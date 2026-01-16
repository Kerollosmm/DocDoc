part of 'attendance_bloc.dart';

abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}
class AttendanceSuccess extends AttendanceState {}
class AttendanceFailure extends AttendanceState {
  final String message;
  const AttendanceFailure(this.message);
  @override
  List<Object> get props => [message];
}
