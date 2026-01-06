// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StudentModelImpl _$$StudentModelImplFromJson(Map<String, dynamic> json) =>
    _$StudentModelImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      grade: json['grade'] as String,
      phoneNumber: json['phoneNumber'] as String,
      address: json['address'] as String?,
      parentName: json['parentName'] as String?,
      parentPhone: json['parentPhone'] as String?,
      enrollmentDate: DateTime.parse(json['enrollmentDate'] as String),
      isActive: json['isActive'] as bool? ?? true,
    );

Map<String, dynamic> _$$StudentModelImplToJson(_$StudentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'grade': instance.grade,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
      'parentName': instance.parentName,
      'parentPhone': instance.parentPhone,
      'enrollmentDate': instance.enrollmentDate.toIso8601String(),
      'isActive': instance.isActive,
    };
