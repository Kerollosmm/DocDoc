import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'core/services/hive_cipher_service.dart';
import 'injection_container.dart';
import 'data/models/student_model.dart';
import 'data/models/attendance_record_model.dart';
import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hive Initialization
  await Hive.initFlutter();

  // Secure Key Setup
  final secureStorage = const FlutterSecureStorage();
  final cipherService = HiveCipherService(secureStorage);
  final cipher = await cipherService.getEncryptionCipher();

  if (cipher != null) {
      // We can register cipher globally if needed, or pass to specific boxes
      // But typically we pass it to openBox
  }

  // Register Adapters
  Hive.registerAdapter(StudentModelAdapter());
  Hive.registerAdapter(AttendanceRecordModelAdapter());
  Hive.registerAdapter(AttendanceStatusAdapterTypeAdapter());

  // Firebase Initialization
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
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
