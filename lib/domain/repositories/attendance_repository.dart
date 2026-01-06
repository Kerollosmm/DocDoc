// lib/domain/repositories/attendance_repository.dart
import 'package:dartz/dartz.dart';
import '../../core/error/failures.dart';
import '../entities/attendance_record.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, void>> markAttendance(AttendanceRecord record);
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceSheet(String gradeId, DateTime date);
  Future<Either<Failure, void>> syncAttendance();
}
