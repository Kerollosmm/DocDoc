# Technology Stack

## Framework & Language

- **Flutter** (Dart SDK ^3.9.0)
- **Dart** programming language

## Architecture & Patterns

- **BLoC/Cubit** for state management (flutter_bloc ^9.1.1)
- **Repository pattern** for data layer
- **Dependency Injection** using GetIt (get_it ^8.2.0)
- **Clean Architecture** with feature-based folder structure

## Key Dependencies

- **flutter_screenutil** ^5.9.3 - Responsive UI scaling
- **dio** with **retrofit** ^4.7.2 - HTTP client and API service generation
- **freezed** ^3.2.0 - Code generation for immutable classes
- **json_annotation** ^4.9.0 + **json_serializable** ^6.11.0 - JSON serialization
- **flutter_svg** ^2.2.1 - SVG asset support
- **flutter_native_splash** ^2.4.6 - Native splash screen

## Development Tools

- **build_runner** ^2.7.1 - Code generation
- **flutter_lints** ^5.0.0 - Linting rules
- **pretty_dio_logger** ^1.4.0 - Network request logging

## Build & Development Commands

### Common Flutter Commands

```bash
# Get dependencies
flutter pub get

# Run code generation
flutter packages pub run build_runner build

# Run development flavor
flutter run --flavor development -t lib/main_development.dart

# Run production flavor
flutter run --flavor production -t lib/main_production.dart

# Build for release
flutter build apk --flavor production -t lib/main_production.dart
flutter build appbundle --flavor production -t lib/main_production.dart

# Clean build
flutter clean && flutter pub get

# Run tests
flutter test
```

### Code Generation

Always run after modifying models with @JsonSerializable or @freezed:

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Platform Support

- **Primary**: Android
- **Secondary**: iOS, Web
- **Available**: Windows, macOS, Linux
