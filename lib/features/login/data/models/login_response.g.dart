// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      massage: json['massage'] as String?,
      code: (json['code'] as num?)?.toInt(),
      statues: json['statues'] as bool?,
      userData: json['data'] == null
          ? null
          : UserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'massage': instance.massage,
      'data': instance.userData,
      'statues': instance.statues,
      'code': instance.code,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
  token: json['token'] as String?,
  userName: json['name'] as String?,
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'token': instance.token,
  'name': instance.userName,
};
