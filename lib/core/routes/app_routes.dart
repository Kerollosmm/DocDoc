class AppRoutes {
  static const String login = '/login';
  static const String dashboard = '/dashboard';
  static const String students = '/students/:grade';
  static const String addStudent = '/add-student/:grade';
  static const String editStudent = '/edit-student/:grade';

  static String studentList(String grade) => '/students/$grade';
  static String addStudentPath(String grade) => '/add-student/$grade';
  static String editStudentPath(String grade) => '/edit-student/$grade';
}
