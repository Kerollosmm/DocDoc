import 'package:go_router/go_router.dart';
import '../../domain/entities/student.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/classes/presentation/screens/dashboard_screen.dart';
import '../../features/students/presentation/screens/student_list_screen.dart';
import '../../features/students/presentation/screens/add_or_edit_student_screen.dart';
import 'app_routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.login,
  routes: [
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.dashboard,
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: AppRoutes.students,
      builder: (context, state) {
        final grade = state.pathParameters['grade']!;
        return StudentListScreen(grade: grade);
      },
    ),
    GoRoute(
      path: AppRoutes.addStudent,
      builder: (context, state) {
        final grade = state.pathParameters['grade']!;
        return AddOrEditStudentScreen(grade: grade);
      },
    ),
    GoRoute(
      path: AppRoutes.editStudent,
      builder: (context, state) {
        final grade = state.pathParameters['grade']!;
        final student = state.extra as Student?;
        return AddOrEditStudentScreen(grade: grade, student: student);
      },
    ),
  ],
);
