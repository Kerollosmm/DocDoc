// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentModel _$StudentModelFromJson(Map<String, dynamic> json) => StudentModel(
  studentId: json['studentId'] as String,
  name: json['name'] as String,
  grade: json['grade'] as String,
  group: json['group'] as String,
  createdBy: json['createdBy'] as String,
);

Map<String, dynamic> _$StudentModelToJson(StudentModel instance) =>
    <String, dynamic>{
      'studentId': instance.studentId,
      'name': instance.name,
      'grade': instance.grade,
      'group': instance.group,
      'createdBy': instance.createdBy,
    };
