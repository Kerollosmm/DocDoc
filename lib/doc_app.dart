import 'package:doc_app/core/routing/app_router.dart';
import 'package:doc_app/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DocApp extends StatelessWidget {
  final AppRouter appRouter;
  DocApp({super.key, required this.appRouter});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      child: MaterialApp.router(
        title: 'Attendance App',
        theme: ThemeData(primaryColor: ColorsManager.mainBlue),
        debugShowCheckedModeBanner: false,
        routerConfig: appRouter.router,
      ),
    );
  }
}
