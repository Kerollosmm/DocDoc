# Project Structure

## Root Level

- `lib/` - Main application code
- `android/` - Android platform-specific code
- `ios/` - iOS platform-specific code
- `web/` - Web platform-specific code
- `windows/`, `macos/`, `linux/` - Desktop platform code
- `assets/` - Static assets (images, SVGs)
- `test/` - Unit and widget tests

## Core Architecture (`lib/`)

### Entry Points

- `main_development.dart` - Development flavor entry point
- `main_production.dart` - Production flavor entry point
- `doc_app.dart` - Main app widget

### Core Layer (`lib/core/`)

- `di/` - Dependency injection setup (GetIt)
- `networking/` - API services, error handling, HTTP client
- `routing/` - App navigation and route management
- `theming/` - Colors, text styles, design tokens
- `widgets/` - Reusable UI components
- `helpers/` - Utility functions and extensions

### Features Layer (`lib/features/`)

Each feature follows clean architecture:

```
feature_name/
├── data/
│   ├── models/          # Data models with JSON serialization
│   └── repos/           # Repository implementations
├── logic/
│   └── cubit/          # BLoC/Cubit state management
└── ui/
    ├── feature_screen.dart
    └── widgets/        # Feature-specific widgets
```

### Current Features

- `login/` - User authentication
- `sign_up/` - User registration
- `onboarding/` - App introduction flow

## Naming Conventions

### Files & Directories

- Use `snake_case` for all file and directory names
- Feature screens: `feature_name_screen.dart`
- Widgets: `descriptive_widget_name.dart`
- Models: `model_name.dart`
- Repositories: `feature_name_repo.dart`
- Cubits: `feature_name_cubit.dart`

### Classes & Variables

- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` with descriptive names
- Private members: prefix with `_`

## Asset Organization

- `assets/images/` - PNG/JPG images
- `assets/svgs/` - SVG vector graphics
- Reference in pubspec.yaml under `flutter.assets`

## Code Generation Files

- `.g.dart` - JSON serialization (json_serializable)
- `.freezed.dart` - Immutable classes (freezed)
- Generated files are gitignored and recreated via build_runner
