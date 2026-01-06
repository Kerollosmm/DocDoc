// lib/data/repositories/attendance_repository_impl.dart
import 'package:dartz/dartz.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import '../../core/error/failures.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../datasources/local/hive_database.dart';
import '../models/attendance_record_model.dart';

@LazySingleton(as: AttendanceRepository)
class AttendanceRepositoryImpl implements AttendanceRepository {
  final Box<AttendanceRecordModel> _attendanceBox = Hive.box<AttendanceRecordModel>(HiveDatabase.attendanceBox);

  @override
  Future<Either<Failure, void>> markAttendance(AttendanceRecord record) async {
    try {
      final model = AttendanceRecordModel.fromEntity(record);
      await _attendanceBox.put(record.id, model);
      // Here we would also queue sync
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecord>>> getAttendanceSheet(String gradeId, DateTime date) async {
    try {
      final records = _attendanceBox.values
          .where((r) =>
            r.gradeId == gradeId &&
            r.date.year == date.year &&
            r.date.month == date.month &&
            r.date.day == date.day
          )
          .map((r) => r.toEntity())
          .toList();
      return Right(records);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> syncAttendance() async {
    // TODO: Implement sync logic
    return const Right(null);
  }
}
