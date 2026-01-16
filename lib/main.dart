import 'package:doc_app/core/config/hive_boxes_config.dart';
import 'package:doc_app/core/di/service_locator.dart';
import 'package:doc_app/core/services/sync_service.dart';
import 'package:doc_app/core/routing/app_router.dart';
import 'package:doc_app/doc_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Assuming options are handled or auto-configured)
  // await Firebase.initializeApp(); // Uncomment when actual firebase config is present

  await Hive.initFlutter();
  await Hive.openBox(HiveBoxesConfig.authBox);
  await Hive.openBox(HiveBoxesConfig.studentsBox);
  await Hive.openBox(HiveBoxesConfig.attendanceBox);
  await Hive.openBox(HiveBoxesConfig.sessionsBox);
  await Hive.openBox(HiveBoxesConfig.metadataBox);

  await setupGetIt();

  // Initialize Sync Service
  getIt<SyncService>().init();

  runApp(DocApp(appRouter: AppRouter()));
}
