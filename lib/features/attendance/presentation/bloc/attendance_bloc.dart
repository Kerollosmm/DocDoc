import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import '../../../../domain/entities/attendance_record.dart';
import '../../../../domain/repositories/attendance_repository.dart';

part 'attendance_bloc.freezed.dart';

@freezed
class AttendanceEvent with _$AttendanceEvent {
  const factory AttendanceEvent.loadAttendance(String date, String grade) = _LoadAttendance;
  const factory AttendanceEvent.markAttendance(AttendanceRecord record) = _MarkAttendance;
}

@freezed
class AttendanceState with _$AttendanceState {
  const factory AttendanceState.initial() = _Initial;
  const factory AttendanceState.loading() = _Loading;
  // Map of StudentID -> Record
  const factory AttendanceState.loaded(Map<String, AttendanceRecord> records) = _Loaded;
  const factory AttendanceState.error(String message) = _Error;
}

@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final AttendanceRepository _repository;

  AttendanceBloc(this._repository) : super(const AttendanceState.initial()) {
    on<_LoadAttendance>((event, emit) async {
      emit(const AttendanceState.loading());
      try {
        final records = await _repository.getAttendance(event.date, event.grade);
        final Map<String, AttendanceRecord> map = {
          for (var r in records) r.studentId: r
        };
        emit(AttendanceState.loaded(map));
      } catch (e) {
        emit(AttendanceState.error(e.toString()));
      }
    });

    on<_MarkAttendance>((event, emit) async {
      try {
        await _repository.markAttendance(event.record);
        // Optimistic update
        final currentState = state;
        if (currentState is _Loaded) {
          final newMap = Map<String, AttendanceRecord>.from(currentState.records);
          newMap[event.record.studentId] = event.record;
          emit(AttendanceState.loaded(newMap));
        }
      } catch (e) {
        emit(AttendanceState.error(e.toString()));
      }
    });
  }
}
