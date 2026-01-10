import 'package:fpdart/fpdart.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SyncAttendanceUseCase {
  final AttendanceRepository repository;

  SyncAttendanceUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.syncAttendance();
  }
}
