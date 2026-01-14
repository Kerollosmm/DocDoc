import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:fpdart/fpdart.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, void>> saveAttendance(List<AttendanceRecordEntity> records);
  Future<Either<Failure, List<AttendanceRecordEntity>>> getAttendanceForSession(String sessionId);
}
