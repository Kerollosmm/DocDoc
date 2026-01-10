import 'package:fpdart/fpdart.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:csms/features/attendance/domain/repositories/attendance_repository.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class MarkAttendanceUseCase {
  final AttendanceRepository repository;

  MarkAttendanceUseCase(this.repository);

  Future<Either<Failure, void>> call(AttendanceRecordEntity record) async {
    return await repository.markAttendance(record);
  }
}
