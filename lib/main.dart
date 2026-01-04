import 'package:flutter/foundation.dart';
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

  // Hive Initialization
  // On Web, Hive stores data in IndexedDB.
  await Hive.initFlutter();

  // Register Adapters
  Hive.registerAdapter(StudentModelAdapter());
  Hive.registerAdapter(AttendanceRecordModelAdapter());
  Hive.registerAdapter(AttendanceStatusAdapterTypeAdapter());

  // Firebase Initialization
  // TODO: Add firebase_options.dart for Web/Mobile support
  // if (kIsWeb) {
  //   await Firebase.initializeApp(
  //     options: const FirebaseOptions(
  //       apiKey: "...",
  //       authDomain: "...",
  //       projectId: "...",
  //       storageBucket: "...",
  //       messagingSenderId: "...",
  //       appId: "...",
  //     ),
  //   );
  // } else {
  //   await Firebase.initializeApp();
  // }

  try {
    await Firebase.initializeApp();
    // Placeholder for Firebase Hosting
    // if (kIsWeb) {
    //   // Firebase Hosting is handled via CLI deployment, no specific dart code needed
    //   // unless using customized rewrite rules handled in firebase.json
    // }
  } catch (e) {
    if (kDebugMode) {
      print('Firebase Init Failed: $e');
    }
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
