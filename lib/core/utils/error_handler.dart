import 'dart:developer' as developer;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import '../error/exceptions.dart';
import '../error/failures.dart';

class ErrorHandler {
  /// Feature #4: Log errors for future analysis
  static void logError(Object error, StackTrace? stackTrace, {String context = 'Unknown'}) {
    // 1. Log to console (for you, the developer)
    developer.log(
      '❌ Error in $context',
      name: 'csms.error',
      error: error,
      stackTrace: stackTrace,
    );

    // 2. Log to Firebase Crashlytics (for the production team)
    // Note: Ensure Crashlytics is initialized in main.dart first!
    try {
      FirebaseCrashlytics.instance.recordError(error, stackTrace, reason: context);
    } catch (e) {
      // Fallback if Crashlytics isn't initialized yet or fails (e.g. in tests)
      developer.log('Failed to report to Crashlytics: $e');
    }
  }

  /// Feature #1 & #2: Identify types and provide user-friendly messages
  static Failure handle(Object error, [StackTrace? stackTrace]) {
    logError(error, stackTrace); // Always log first!

    if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is OfflineException) {
      return const OfflineFailure();
    } else if (error is CacheException) {
      return const CacheFailure();
    } else if (error is InvalidInputException) {
      return InputFailure(error.message);
    } else {
      // The catch-all for weird errors
      return const ServerFailure(
        'Something went wrong 🤔',
        suggestion: 'Try restarting the app. If it persists, call the developer!',
      );
    }
  }
}
