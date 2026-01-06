// lib/features/student_list/presentation/bloc/student_state.dart
part of 'student_bloc.dart';

@freezed
class StudentState with _$StudentState {
  const factory StudentState.initial() = _Initial;
  const factory StudentState.loading() = _Loading;
  const factory StudentState.loaded(List<Student> students) = _Loaded;
  const factory StudentState.error(String message) = _Error;
}
