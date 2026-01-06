// lib/data/datasources/local/hive_database.dart
import 'package:hive_flutter/hive_flutter.dart';
import '../../models/student_model.dart';
import '../../models/attendance_record_model.dart';
import '../../../domain/entities/attendance_record.dart';

class HiveDatabase {
  static const String studentsBox = 'students';
  static const String attendanceBox = 'attendance';

  Future<void> init() async {
    // Manually register adapters since generator is skipped
    Hive.registerAdapter(StudentModelAdapter());
    Hive.registerAdapter(AttendanceRecordModelAdapter());
    Hive.registerAdapter(AttendanceStatusAdapter());

    await Hive.openBox<StudentModel>(studentsBox);
    await Hive.openBox<AttendanceRecordModel>(attendanceBox);
  }
}

// Manual Adapters
class StudentModelAdapter extends TypeAdapter<StudentModel> {
  @override
  final int typeId = 1;

  @override
  StudentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentModel(
      id: fields[0] as String,
      name: fields[1] as String,
      grade: fields[2] as String,
      phoneNumber: fields[3] as String,
      address: fields[4] as String?,
      parentName: fields[5] as String?,
      parentPhone: fields[6] as String?,
      enrollmentDate: fields[7] as DateTime,
      isActive: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StudentModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.grade)
      ..writeByte(3)
      ..write(obj.phoneNumber)
      ..writeByte(4)
      ..write(obj.address)
      ..writeByte(5)
      ..write(obj.parentName)
      ..writeByte(6)
      ..write(obj.parentPhone)
      ..writeByte(7)
      ..write(obj.enrollmentDate)
      ..writeByte(8)
      ..write(obj.isActive);
  }
}

class AttendanceRecordModelAdapter extends TypeAdapter<AttendanceRecordModel> {
  @override
  final int typeId = 2;

  @override
  AttendanceRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceRecordModel(
      id: fields[0] as String,
      studentId: fields[1] as String,
      date: fields[2] as DateTime,
      gradeId: fields[3] as String,
      status: fields[4] as AttendanceStatus,
      markedBy: fields[5] as String,
      markedAt: fields[6] as DateTime,
      isConflict: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceRecordModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.gradeId)
      ..writeByte(4)
      ..write(obj.status)
      ..writeByte(5)
      ..write(obj.markedBy)
      ..writeByte(6)
      ..write(obj.markedAt)
      ..writeByte(7)
      ..write(obj.isConflict);
  }
}

class AttendanceStatusAdapter extends TypeAdapter<AttendanceStatus> {
  @override
  final int typeId = 3;

  @override
  AttendanceStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AttendanceStatus.present;
      case 1:
        return AttendanceStatus.absent;
      case 2:
        return AttendanceStatus.late;
      case 3:
        return AttendanceStatus.excused;
      default:
        return AttendanceStatus.present;
    }
  }

  @override
  void write(BinaryWriter writer, AttendanceStatus obj) {
    switch (obj) {
      case AttendanceStatus.present:
        writer.writeByte(0);
        break;
      case AttendanceStatus.absent:
        writer.writeByte(1);
        break;
      case AttendanceStatus.late:
        writer.writeByte(2);
        break;
      case AttendanceStatus.excused:
        writer.writeByte(3);
        break;
    }
  }
}
