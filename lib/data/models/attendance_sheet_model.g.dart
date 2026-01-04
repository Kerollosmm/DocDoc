// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_sheet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AttendanceSheetModelAdapter extends TypeAdapter<AttendanceSheetModel> {
  @override
  final int typeId = 3;

  @override
  AttendanceSheetModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AttendanceSheetModel(
      id: fields[0] as String,
      classId: fields[1] as String,
      date: fields[2] as DateTime,
      records: (fields[3] as Map).cast<String, AttendanceStatus>(),
    );
  }

  @override
  void write(BinaryWriter writer, AttendanceSheetModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.classId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.records);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceSheetModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AttendanceSheetModel _$AttendanceSheetModelFromJson(
        Map<String, dynamic> json) =>
    AttendanceSheetModel(
      id: json['id'] as String,
      classId: json['classId'] as String,
      date: DateTime.parse(json['date'] as String),
      records: (json['records'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$AttendanceStatusEnumMap, e)),
      ),
    );

Map<String, dynamic> _$AttendanceSheetModelToJson(
        AttendanceSheetModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'classId': instance.classId,
      'date': instance.date.toIso8601String(),
      'records': instance.records
          .map((k, e) => MapEntry(k, _$AttendanceStatusEnumMap[e]!)),
    };

const _$AttendanceStatusEnumMap = {
  AttendanceStatus.present: 'present',
  AttendanceStatus.absent: 'absent',
};
