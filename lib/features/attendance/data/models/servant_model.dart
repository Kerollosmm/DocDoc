import 'package:json_annotation/json_annotation.dart';
import 'package:hive/hive.dart';
import 'package:csms/features/attendance/domain/entities/servant_entity.dart';

part 'servant_model.g.dart';

@JsonSerializable()
class ServantModel extends ServantEntity {
  const ServantModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phoneNumber,
    required super.role,
  });

  factory ServantModel.fromJson(Map<String, dynamic> json) =>
      _$ServantModelFromJson(json);

  Map<String, dynamic> toJson() => _$ServantModelToJson(this);

  factory ServantModel.fromEntity(ServantEntity entity) {
    return ServantModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      phoneNumber: entity.phoneNumber,
      role: entity.role,
    );
  }
}
