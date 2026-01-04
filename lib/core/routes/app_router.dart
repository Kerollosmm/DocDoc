import 'package:go_router/go_router.dart';
import '../../domain/entities/student.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/classes/presentation/screens/dashboard_screen.dart';
import '../../features/students/presentation/screens/student_list_screen.dart';
import '../../features/students/presentation/screens/add_or_edit_student_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/students/:grade',
      builder: (context, state) {
        final grade = state.pathParameters['grade']!;
        return StudentListScreen(grade: grade);
      },
    ),
    GoRoute(
      path: '/add-student/:grade',
      builder: (context, state) {
        final grade = state.pathParameters['grade']!;
        return AddOrEditStudentScreen(grade: grade);
      },
    ),
    GoRoute(
      path: '/edit-student/:grade',
      builder: (context, state) {
        final grade = state.pathParameters['grade']!;
        final student = state.extra as Student?;
        return AddOrEditStudentScreen(grade: grade, student: student);
      },
    ),
  ],
);
