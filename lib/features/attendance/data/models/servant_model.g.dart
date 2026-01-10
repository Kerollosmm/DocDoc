// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'servant_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ServantModel _$ServantModelFromJson(Map<String, dynamic> json) => ServantModel(
  id: json['id'] as String,
  name: json['name'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  role: json['role'] as String,
);

Map<String, dynamic> _$ServantModelToJson(ServantModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
    };
