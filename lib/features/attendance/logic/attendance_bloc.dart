import 'package:bloc/bloc.dart';
import 'package:doc_app/features/attendance/domain/entities/attendance_record.dart';

sealed class AttendanceEvent {
  const AttendanceEvent();
}

class LoadAttendanceSession extends AttendanceEvent {
  const LoadAttendanceSession();
}

class ToggleAttendance extends AttendanceEvent {
  final String studentId;
  final bool isPresent;

  const ToggleAttendance({required this.studentId, required this.isPresent});
}

sealed class AttendanceState {
  const AttendanceState();
}

class AttendanceLoading extends AttendanceState {
  const AttendanceLoading();
}

class AttendanceReady extends AttendanceState {
  final List<AttendanceRecord> records;

  const AttendanceReady(this.records);
}

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  AttendanceBloc() : super(const AttendanceLoading()) {
    on<LoadAttendanceSession>(_onLoad);
    on<ToggleAttendance>(_onToggle);
  }

  final List<AttendanceRecord> _records = [
    const AttendanceRecord(studentId: 'S1001', studentName: 'Sara Ali', isPresent: true),
    const AttendanceRecord(studentId: 'S1002', studentName: 'Omar Khaled', isPresent: false),
    const AttendanceRecord(studentId: 'S1003', studentName: 'Lina Adel', isPresent: true),
  ];

  void _onLoad(LoadAttendanceSession event, Emitter<AttendanceState> emit) {
    emit(AttendanceReady(List.of(_records)));
  }

  void _onToggle(ToggleAttendance event, Emitter<AttendanceState> emit) {
    final updated = _records.map((record) {
      if (record.studentId == event.studentId) {
        return AttendanceRecord(
          studentId: record.studentId,
          studentName: record.studentName,
          isPresent: event.isPresent,
          note: record.note,
        );
      }
      return record;
    }).toList();
    emit(AttendanceReady(updated));
  }
}
