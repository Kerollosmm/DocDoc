# CSMS Phase 1 Run Guide

## Prerequisites
- Flutter SDK 3.x
- Firebase Account

## Setup

1. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

2. **Code Generation:**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. **Firebase Configuration:**
   - Create a Firebase Project.
   - Run `flutterfire configure` to generate `lib/firebase_options.dart`.
   - Enable Authentication (Email/Password).
   - Enable Firestore Database.
   - Deploy Rules: Copy `firestore.rules` to Firebase Console.

4. **Seed Data:**
   - Use `seed_data.json` as a reference to create initial collections in Firestore manually or write a seed script.

## Running the App

```bash
flutter run
```

## Testing

```bash
flutter test
```

## Architecture Notes
- **Clean Architecture:** `lib/core`, `lib/features/{feature}/{domain,data,presentation}`.
- **Offline-First:** Hive is used for local storage. `SyncService` (in `lib/core/services`) handles synchronization when connectivity returns.
- **State Management:** BLoC pattern.
- **DI:** `get_it` and `injectable`.
