import 'package:flutter/foundation.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class AppLogger {
  static void d(String message) {
    if (kDebugMode) {
      print('DEBUG: $message');
    }
  }

  static void i(String message) {
    if (kDebugMode) {
      print('INFO: $message');
    }
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    if (kDebugMode) {
      print('ERROR: $message');
      if (error != null) print(error);
      if (stackTrace != null) print(stackTrace);
    } else {
      // In production, log to Crashlytics
      FirebaseCrashlytics.instance.log(message);
      if (error != null) {
        FirebaseCrashlytics.instance.recordError(error, stackTrace);
      }
    }
  }
}
