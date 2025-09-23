# Flutter Flavors Setup

This project is configured with two flavors: **Development** and **Production**.

## 🏗️ Architecture

### Environment Configuration

- `lib/core/config/app_config.dart` - Central configuration for environments
- Supports different API URLs, app names, and feature flags per environment

### Entry Points

- `lib/main_development.dart` - Development flavor entry point
- `lib/main_production.dart` - Production flavor entry point

## 🚀 Running the App

### Development Flavor

```bash
flutter run --flavor development -t lib/main_development.dart
```

### Production Flavor

```bash
flutter run --flavor production -t lib/main_production.dart
```

## 📱 Platform Configuration

### Android

Flavors are configured in `android/app/build.gradle.kts`:

- **Development**: App ID suffix `.dev`, displays as "Doc App Dev"
- **Production**: Standard app ID, displays as "Doc App"

### iOS

Flavor configurations in `ios/Flutter/`:

- `Development.xcconfig` - Development flavor settings
- `Production.xcconfig` - Production flavor settings

## 🔧 VS Code Integration

Launch configurations are available in `.vscode/launch.json`:

- Development (Debug)
- Production (Debug)
- Development (Profile)
- Production (Profile)

## 🏭 Building for Release

### Android APK

```bash
# Development
flutter build apk --flavor development -t lib/main_development.dart

# Production
flutter build apk --flavor production -t lib/main_production.dart
```

### Android App Bundle

```bash
# Development
flutter build appbundle --flavor development -t lib/main_development.dart

# Production
flutter build appbundle --flavor production -t lib/main_production.dart
```

### iOS

```bash
# Development
flutter build ios --flavor development -t lib/main_development.dart

# Production
flutter build ios --flavor production -t lib/main_production.dart
```

## 🌐 Environment-Specific Configuration

### API URLs

- **Development**: `https://dev-api.docapp.com`
- **Production**: `https://api.docapp.com`

### Features

- **Development**: Debug logging enabled, debug features available
- **Production**: Optimized for release, minimal logging

### App Names

- **Development**: "Doc App Dev"
- **Production**: "Doc App"

## 🛠️ Development Workflow

1. **Code Generation**: Run after modifying models

   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **Clean Build**: When switching between flavors

   ```bash
   flutter clean && flutter pub get
   ```

3. **Testing**: Run tests for both environments
   ```bash
   flutter test
   ```

## 📋 Quick Commands Reference

See `scripts/build_commands.md` for a comprehensive list of build commands.

## 🔍 Troubleshooting

### Common Issues

1. **Build Runner Errors**: Clean and regenerate

   ```bash
   flutter clean
   flutter pub get
   dart run build_runner clean
   dart run build_runner build --delete-conflicting-outputs
   ```

2. **iOS Build Issues**: Clean iOS build folder

   ```bash
   flutter clean
   cd ios && rm -rf build && cd ..
   flutter build ios --flavor [development|production] -t lib/main_[development|production].dart
   ```

3. **Android Build Issues**: Clean Android build
   ```bash
   flutter clean
   cd android && ./gradlew clean && cd ..
   flutter build apk --flavor [development|production] -t lib/main_[development|production].dart
   ```

## 📝 Adding New Environments

To add a new environment (e.g., staging):

1. Add to `Environment` enum in `app_config.dart`
2. Update `AppConfig` class with new environment settings
3. Create `main_staging.dart` entry point
4. Add Android flavor in `build.gradle.kts`
5. Create `ios/Flutter/Staging.xcconfig`
6. Update VS Code launch configurations

## 🔐 Environment Variables

For sensitive configuration (API keys, etc.), consider using:

- `flutter_dotenv` package
- Platform-specific secure storage
- CI/CD environment variables for builds
