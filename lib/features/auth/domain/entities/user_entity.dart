class UserEntity {
  final String uid;
  final String email;
  final String role; // 'servant' or 'student'
  final String? name;

  const UserEntity({
    required this.uid,
    required this.email,
    required this.role,
    this.name,
  });
}
