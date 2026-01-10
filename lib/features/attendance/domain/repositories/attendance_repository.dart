import 'package:fpdart/fpdart.dart';
import 'package:csms/core/error/failures.dart';
import 'package:csms/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:csms/features/attendance/domain/entities/servant_entity.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, List<ServantEntity>>> getServants();
  Future<Either<Failure, void>> markAttendance(AttendanceRecordEntity record);
  Future<Either<Failure, void>> syncAttendance();
  Future<Either<Failure, List<AttendanceRecordEntity>>> getPendingAttendance();
  Future<Either<Failure, void>> updateRecordSyncStatus(String recordId, bool isSynced);
}
