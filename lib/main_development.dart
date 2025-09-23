import 'package:doc_app/core/config/app_config.dart';
import 'package:doc_app/core/di/dependency_injection.dart';
import 'package:doc_app/doc_app.dart';
import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set environment
  AppConfig.setEnvironment(Environment.development);

  setupGetIt();
  // To fix texts being hidden bug in flutter_screenutil in release mode.
  await ScreenUtil.ensureScreenSize();
  runApp(DocApp(appRouter: AppRouter()));
}
