enum UserRole {
  servant,
  student;

  String get label {
    switch (this) {
      case UserRole.servant:
        return 'Servant';
      case UserRole.student:
        return 'Student';
    }
  }
}
