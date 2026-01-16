import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:doc_app/features/attendance/domain/repos/attendance_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'attendance_state.dart';

class AttendanceBloc extends Cubit<AttendanceState> {
  final AttendanceRepository _repository;

  AttendanceBloc(this._repository) : super(AttendanceInitial());

  Future<void> submitAttendance(List<AttendanceRecordEntity> records) async {
    emit(AttendanceLoading());
    final result = await _repository.saveAttendance(records);
    result.fold(
      (failure) => emit(AttendanceFailure(failure.message)),
      (_) => emit(AttendanceSuccess()),
    );
  }
}
