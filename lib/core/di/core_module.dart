import 'package:injectable/injectable.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@module
abstract class CoreModule {
  @lazySingleton
  InternetConnectionChecker get internetConnectionChecker => InternetConnectionChecker.createInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();
}
