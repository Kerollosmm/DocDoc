# CSMS App (Church Servants Management System) ✝️

A unified offline-first application for Church Servants to manage attendance and results. This system ensures efficient data handling and role-based access for managing church activities.

## ✨ Features

- 📶 **Offline-first** - Powered by Hive for local storage, ensuring functionality without internet.
- 🔄 **Firebase Sync** - Automatic background synchronization with Firestore when online.
- 👥 **Role-based Access** - Secure access control for different servant roles.
- 📅 **Attendance Tracking** - Efficient daily attendance management with conflict resolution.
- 📊 **Results Management** - Track and manage student results.

## 🏗️ Architecture

This project follows **Clean Architecture** principles with a feature-based folder structure:

- **BLoC** for state management
- **Repository Pattern** for data layer
- **Dependency Injection** using GetIt & Injectable
- **Hive** for local database
- **Firebase** for backend services (Firestore, Auth)

## 🛠️ Tech Stack

### Framework & Language

- **Flutter** (Dart SDK ^3.9.0)
- **Dart** programming language

### Key Dependencies

- `flutter_bloc` - State management
- `hive` & `hive_flutter` - Local database
- `firebase_core`, `cloud_firestore`, `firebase_auth` - Backend services
- `get_it`, `injectable` - Dependency injection
- `freezed`, `json_serializable` - Code generation
- `go_router` - Navigation
- `excel` - Data export/import

## 🚀 Getting Started

### Prerequisites

- Flutter SDK ^3.9.0
- Dart SDK ^3.9.0

### Installation

1. **Clone the repository**

   ```bash
   git clone <repository_url>
   cd csms_app
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate code**

   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**

   ```bash
   flutter run
   ```

## 🔧 Development Commands

### Code Generation

```bash
# Run code generation (after modifying models)
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

**Built with ❤️ for the Church Service**
