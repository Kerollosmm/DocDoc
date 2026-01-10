import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:csms/firebase_options.dart';
import 'package:csms/core/di/service_locator.dart';
import 'package:csms/core/routing/app_router.dart';
import 'package:csms/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:csms/features/attendance/presentation/bloc/attendance_bloc.dart';
import 'package:csms/core/services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();

  await configureDependencies();

  // Initialize SyncService (singleton) to start listening
  getIt<SyncService>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>()..add(CheckAuthStatusEvent()),
        ),
        BlocProvider<AttendanceBloc>(
          create: (context) => getIt<AttendanceBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'CSMS Phase 1',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
