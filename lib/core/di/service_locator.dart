import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:doc_app/core/services/sync_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:doc_app/features/auth/di/auth_di.dart';
import 'package:doc_app/features/students/di/students_di.dart';
import 'package:doc_app/features/attendance/di/attendance_di.dart';

import 'package:doc_app/core/config/hive_boxes_config.dart';

final getIt = GetIt.instance;

Future<void> setupGetIt() async {
  // External
  getIt.registerLazySingleton(() => FirebaseAuth.instance);
  getIt.registerLazySingleton(() => FirebaseFirestore.instance);
  getIt.registerLazySingleton(() => Hive);
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => InternetConnection());

  // Services
  getIt.registerLazySingleton(() => SyncService(
    connectivity: getIt(),
    firestore: getIt(),
    hive: getIt(),
  ));

  // Features
  setupAuthDependencies();
  setupStudentsDependencies();
  setupAttendanceDependencies();
}
