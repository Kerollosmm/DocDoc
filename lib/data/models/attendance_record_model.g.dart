// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_record_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceRecordModelAdapter extends TypeAdapter<AttendanceRecordModel> {
  @override
  final int typeId = 1;

  @override
  AttendanceRecordModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceRecordModel(
      studentId: fields[0] as String,
      status: fields[1] as AttendanceStatus,
      date: fields[2] as String,
      updatedBy: fields[3] as String,
      timestamp: fields[4] as int,
      isConflict: fields[5] as bool,
      isSynced: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceRecordModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.studentId)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.updatedBy)
      ..writeByte(4)
      ..write(obj.timestamp)
      ..writeByte(5)
      ..write(obj.isConflict)
      ..writeByte(6)
      ..write(obj.isSynced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceRecordModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AttendanceStatusAdapterTypeAdapter
    extends TypeAdapter<AttendanceStatusAdapterType> {
  @override
  final int typeId = 2;

  @override
  AttendanceStatusAdapterType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AttendanceStatusAdapterType.present;
      case 1:
        return AttendanceStatusAdapterType.absent;
      default:
        return AttendanceStatusAdapterType.present;
    }
  }

  @override
  void write(BinaryWriter writer, AttendanceStatusAdapterType obj) {
    switch (obj) {
      case AttendanceStatusAdapterType.present:
        writer.writeByte(0);
        break;
      case AttendanceStatusAdapterType.absent:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceStatusAdapterTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceRecordModel _$AttendanceRecordModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceRecordModel(
      studentId: json['studentId'] as String,
      status: $enumDecode(_$AttendanceStatusEnumMap, json['status']),
      date: json['date'] as String,
      updatedBy: json['updatedBy'] as String,
      timestamp: (json['timestamp'] as num).toInt(),
      isConflict: json['isConflict'] as bool? ?? false,
      isSynced: json['isSynced'] as bool? ?? false,
    );

Map<String, dynamic> _$AttendanceRecordModelToJson(
        AttendanceRecordModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'status': _$AttendanceStatusEnumMap[instance.status]!,
      'date': instance.date,
      'updatedBy': instance.updatedBy,
      'timestamp': instance.timestamp,
      'isConflict': instance.isConflict,
      'isSynced': instance.isSynced,
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
};
