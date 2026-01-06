// lib/data/models/user_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const UserModel._();

  const factory UserModel({
    required String id,
    required String email,
    required String name,
    required UserRole role,
    required DateTime createdAt,
    @Default(true) bool isActive,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      email: user.email,
      name: user.name,
      role: user.role,
      createdAt: user.createdAt,
      isActive: user.isActive,
    );
  }

  User toEntity() {
    return User(
      id: id,
      email: email,
      name: name,
      role: role,
      createdAt: createdAt,
      isActive: isActive,
    );
  }
}
