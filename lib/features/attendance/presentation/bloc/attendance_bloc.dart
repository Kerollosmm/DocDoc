import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:csms/features/attendance/domain/entities/servant_entity.dart';
import 'package:csms/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:csms/features/attendance/domain/usecases/get_servants_usecase.dart';
import 'package:csms/features/attendance/domain/usecases/mark_attendance_usecase.dart';
import 'package:csms/features/attendance/domain/usecases/sync_attendance_usecase.dart';
import 'package:uuid/uuid.dart';

// Events
abstract class AttendanceEvent extends Equatable {
  const AttendanceEvent();
  @override
  List<Object> get props => [];
}

class LoadServantsEvent extends AttendanceEvent {}

class MarkAttendanceEvent extends AttendanceEvent {
  final String servantId;
  final String serviceId;
  final String status;
  const MarkAttendanceEvent({required this.servantId, required this.serviceId, required this.status});
  @override
  List<Object> get props => [servantId, serviceId, status];
}

class SyncAttendanceEvent extends AttendanceEvent {}

// States
abstract class AttendanceState extends Equatable {
  const AttendanceState();
  @override
  List<Object?> get props => [];
}

class AttendanceInitial extends AttendanceState {}
class AttendanceLoading extends AttendanceState {}
class AttendanceLoaded extends AttendanceState {
  final List<ServantEntity> servants;
  // We could also store today's attendance records to show UI state
  const AttendanceLoaded(this.servants);
  @override
  List<Object?> get props => [servants];
}
class AttendanceError extends AttendanceState {
  final String message;
  const AttendanceError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLoC
@injectable
class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final GetServantsUseCase _getServantsUseCase;
  final MarkAttendanceUseCase _markAttendanceUseCase;
  final SyncAttendanceUseCase _syncAttendanceUseCase;
  final Uuid _uuid = const Uuid();

  AttendanceBloc(
    this._getServantsUseCase,
    this._markAttendanceUseCase,
    this._syncAttendanceUseCase,
  ) : super(AttendanceInitial()) {
    on<LoadServantsEvent>(_onLoadServants);
    on<MarkAttendanceEvent>(_onMarkAttendance);
    on<SyncAttendanceEvent>(_onSyncAttendance);
  }

  Future<void> _onLoadServants(LoadServantsEvent event, Emitter<AttendanceState> emit) async {
    emit(AttendanceLoading());
    final result = await _getServantsUseCase();
    result.fold(
      (failure) => emit(AttendanceError(failure.message)),
      (servants) => emit(AttendanceLoaded(servants)),
    );
  }

  Future<void> _onMarkAttendance(MarkAttendanceEvent event, Emitter<AttendanceState> emit) async {
    // Optimistic update could happen here, but for now we just process logic.
    // If we want to show 'Success' snackbar, we might need a side-effect or different state.
    // Ideally we keep the list loaded.

    final currentState = state;
    if (currentState is AttendanceLoaded) {
       final record = AttendanceRecordEntity(
         id: _uuid.v4(),
         servantId: event.servantId,
         serviceId: event.serviceId,
         date: DateTime.now(),
         status: event.status,
         isSynced: false,
       );

       final result = await _markAttendanceUseCase(record);
       result.fold(
         (failure) => emit(AttendanceError(failure.message)),
         (_) {
           // Success. We might want to refresh UI or just stay Loaded.
           // Ideally we emit a specific state to trigger a snackbar, then go back to Loaded.
           // Or using BlocListener in UI.
           // Here we just stay Loaded.
           // In a real app we'd update the local list of 'marked' servants.
           emit(AttendanceLoaded(currentState.servants));
         },
       );
    }
  }

  Future<void> _onSyncAttendance(SyncAttendanceEvent event, Emitter<AttendanceState> emit) async {
     await _syncAttendanceUseCase();
     // Reload to reflect sync status if we were showing it
     add(LoadServantsEvent());
  }
}
