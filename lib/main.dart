import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'injection_container.dart';
import 'data/models/student_model.dart';
import 'data/models/attendance_record_model.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
// import 'firebase_options.dart'; // Assuming this would be generated

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(StudentModelAdapter());
  Hive.registerAdapter(AttendanceRecordModelAdapter());
  Hive.registerAdapter(AttendanceStatusAdapterTypeAdapter());

  // Initialize Firebase (Try/Catch for environments without config)
  try {
    // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    await Firebase.initializeApp();
  } catch (e) {
    // Ignore error in dev/mock environments without google-services.json
    print('Firebase Init Failed (Expected in test env): $e');
  }

  // Initialize Dependency Injection
  configureDependencies();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Church Attendance',
      theme: AppTheme.lightTheme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
