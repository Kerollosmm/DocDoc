# Flutter Flavor Build Commands

## Development Flavor

### Run Development

```bash
flutter run --flavor development -t lib/main_development.dart
```

### Build Development APK

```bash
flutter build apk --flavor development -t lib/main_development.dart
```

### Build Development App Bundle

```bash
flutter build appbundle --flavor development -t lib/main_development.dart
```

### Build Development iOS

```bash
flutter build ios --flavor development -t lib/main_development.dart
```

## Production Flavor

### Run Production

```bash
flutter run --flavor production -t lib/main_production.dart
```

### Build Production APK

```bash
flutter build apk --flavor production -t lib/main_production.dart
```

### Build Production App Bundle

```bash
flutter build appbundle --flavor production -t lib/main_production.dart
```

### Build Production iOS

```bash
flutter build ios --flavor production -t lib/main_production.dart
```

## Release Builds

### Production Release APK

```bash
flutter build apk --release --flavor production -t lib/main_production.dart
```

### Production Release App Bundle

```bash
flutter build appbundle --release --flavor production -t lib/main_production.dart
```

### Production Release iOS

```bash
flutter build ios --release --flavor production -t lib/main_production.dart
```

## Useful Commands

### Clean and Get Dependencies

```bash
flutter clean && flutter pub get
```

### Run Code Generation

```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Install on Device

```bash
# Development
flutter install --flavor development -t lib/main_development.dart

# Production
flutter install --flavor production -t lib/main_production.dart
```
