import 'package:equatable/equatable.dart';

enum UserRole { admin, servant }

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final UserRole role;
  final String? grade; // Specific grade for servant, nullable for admin or general servant

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.grade,
  });

  @override
  List<Object?> get props => [id, email, name, role, grade];
}
