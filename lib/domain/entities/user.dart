// lib/domain/entities/user.dart
import 'package:equatable/equatable.dart';

enum UserRole { admin, servant, student }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final DateTime createdAt;
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.createdAt,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, email, name, role, createdAt, isActive];
}
