import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doc_app/core/config/hive_boxes_config.dart';
import 'package:doc_app/core/error/failures.dart';
import 'package:doc_app/features/attendance/data/models/attendance_record_model.dart';
import 'package:doc_app/features/attendance/domain/entities/attendance_record_entity.dart';
import 'package:doc_app/features/attendance/domain/repos/attendance_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final FirebaseFirestore _firestore;
  final Box _attendanceBox;

  AttendanceRepositoryImpl(this._firestore, this._attendanceBox);

  @override
  Future<Either<Failure, void>> saveAttendance(List<AttendanceRecordEntity> records) async {
    try {
      for (final record in records) {
        final model = AttendanceRecordModel.fromEntity(record);
        // Save to Hive with pending status
         await _attendanceBox.put(record.recordId, {
          ...model.toJson(),
          'syncStatus': 'pending',
          'date': record.date.toIso8601String(), // Handle date serialization for Hive
        });
      }
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<AttendanceRecordEntity>>> getAttendanceForSession(String sessionId) async {
     try {
      final localData = _attendanceBox.values.toList();
      final records = localData
          .map((e) {
             final map = Map<String, dynamic>.from(e);
             // Fix date parsing if stored as string in Hive manually
             // But JsonSerializable handles DateTime usually if standard
             return AttendanceRecordModel.fromJson(map);
          })
          .where((r) => r.sessionId == sessionId)
          .toList();

      return Right(records);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
