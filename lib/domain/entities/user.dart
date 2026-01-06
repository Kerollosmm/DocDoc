import 'package:equatable/equatable.dart';
import 'role.dart';

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

  // Helper methods using RolePermissions
  bool get canAddStudent => RolePermissions.canAddStudent(role);
  bool get canDeleteStudent => RolePermissions.canDeleteStudent(role);
  bool get canEditStudent => RolePermissions.canEditStudent(role);
  bool get canManageServants => RolePermissions.canManageServants(role);
}
