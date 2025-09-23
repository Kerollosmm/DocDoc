enum Environment { development, production }

class AppConfig {
  static Environment _environment = Environment.development;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static bool get isDevelopment => _environment == Environment.development;
  static bool get isProduction => _environment == Environment.production;

  // API Configuration
  static String get baseUrl {
    switch (_environment) {
      case Environment.development:
        return 'https://dev-api.docapp.com';
      case Environment.production:
        return 'https://api.docapp.com';
    }
  }

  // App Configuration
  static String get appName {
    switch (_environment) {
      case Environment.development:
        return 'Doc App Dev';
      case Environment.production:
        return 'Doc App';
    }
  }

  // Debug Configuration
  static bool get enableLogging {
    switch (_environment) {
      case Environment.development:
        return true;
      case Environment.production:
        return false;
    }
  }

  // Feature Flags
  static bool get enableDebugFeatures {
    switch (_environment) {
      case Environment.development:
        return true;
      case Environment.production:
        return false;
    }
  }
}
