import 'package:hive/hive.dart';

part 'role.g.dart';

@HiveType(typeId: 2) // Assuming 0 and 1 are used by User/Student
enum UserRole {
  @HiveField(0)
  admin,
  @HiveField(1)
  servant,
  @HiveField(2)
  student,
}

class RolePermissions {
  static bool canAddStudent(UserRole role) => role == UserRole.admin;
  static bool canDeleteStudent(UserRole role) => role == UserRole.admin;
  static bool canEditStudent(UserRole role) => role == UserRole.admin;
  static bool canManageServants(UserRole role) => role == UserRole.admin;
  static bool canResolveConflicts(UserRole role) => role == UserRole.admin;
  static bool canViewReports(UserRole role) => role == UserRole.admin;

  static bool canMarkAttendance(UserRole role) =>
      role == UserRole.admin || role == UserRole.servant;
  static bool canViewAttendance(UserRole role) => true; // Everyone can view their own or grade's
}
