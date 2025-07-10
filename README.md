# 🌊 AquaConecta - Mobile IoT Water Monitoring

A Flutter-based mobile application for real-time water tank monitoring and management in IoT environments. AquaConecta provides comprehensive water quality analytics, supply request management, and user profile management for residential water monitoring systems.

## 🏗️ Architecture

### 📁 Core Structure

```
lib/
├── main.dart                    # Application entry point
├── l10n/                       # Localization files
├── core/                       # Core configuration
│   └── config/
│       ├── env.dart           # Environment configuration
│       └── env.g.dart         # Generated environment file
└── shared/                     # Shared utilities and widgets
    ├── exceptions/            # Custom exceptions
    ├── helpers/               # Helper services
    └── widgets/               # Reusable UI components
```

### 📁 Feature Modules

#### 🔐 IAM (Identity & Access Management)
```
iam/
├── application/               # Use cases
├── domain/                    # Entities and business logic
├── infrastructure/            # API services and repositories
└── presentation/              # UI screens and BLoC
```

#### 📊 Analytics
```
analytics/
├── application/               # Report and water request use cases
├── domain/                    # Entities and business logic
├── infrastructure/            # API services and repositories
└── presentation/              # Dashboard, reports, and water requests UI
```

#### 📡 Monitoring
```
monitoring/
├── application/               # Device use cases
├── domain/                    # Event entities and logic
├── infrastructure/            # Device API services
└── presentation/              # Tank events monitoring UI
```

#### 👤 Profiles
```
profiles/
├── application/               # Profile and resident use cases
├── domain/                    # Profile entities and validation
├── infrastructure/            # Profile API services
└── presentation/              # Profile management UI
```

## 🛠️ Technology Stack

- **Framework**: Flutter 3.5.4+
- **State Management**: BLoC (flutter_bloc)
- **HTTP Client**: http package
- **Local Storage**: shared_preferences, flutter_secure_storage
- **Environment Management**: envied
- **Localization**: flutter_localizations with intl
- **UI Components**: Material Design with custom theming

## 📱 Key Screens

### Dashboard
- Real-time water level visualization with circular progress indicator
- Water quality status and pH level display
- Quick access to water supply requests
- Recent activity tracking

### Water Monitoring
- Tank events monitoring
- Event history with search functionality
- Water quality status indicators (Excellent, Good, Acceptable, Bad, Non-potable, Contaminated)

### Reports
- Issue reporting system
- Report creation and management
- Status tracking (Received, In Progress, Closed)

### Water Supply Requests
- Request water delivery
- Track request history
- Status monitoring (Requested, Delivered)

### Profile Management
- User profile editing
- Resident information management
- Secure data handling

## 🔧 Setup & Installation

### Prerequisites
- Flutter SDK 3.5.4 or higher
- Dart SDK
- Android Studio / VS Code
- Android SDK (for Android builds)
- Xcode (for iOS builds)

## 🌐 API Integration

The application integrates with a backend API for:
- User authentication and session management
- Water tank monitoring data
- Report creation and management
- Water supply request handling
- User profile management

### Environment Variables
- `API_URL`: Base API endpoint
- `AUTHENTICATION_ENDPOINT`: Login endpoint
- `DEVICES_ENDPOINT`: Device monitoring endpoint
- `WATER_SUPPLY_REQUESTS_ENDPOINT`: Water requests endpoint
- `ISSUE_REPORTS_ENDPOINT`: Reports endpoint
- `PROFILE_ENDPOINT`: User profile endpoint
- `RESIDENTS_ENDPOINT`: Resident management endpoint

## 🎨 UI/UX Features

- **Modern Design**: Clean Material Design implementation
- **Color Scheme**: Blue-based theme with consistent branding
- **Responsive Layout**: Adapts to different screen sizes
- **Loading States**: Proper loading indicators and error handling
- **Accessibility**: Support for different text sizes and contrast

## 🔒 Security Features

- **Secure Storage**: Sensitive data stored using flutter_secure_storage
- **Token Management**: JWT token handling with automatic refresh
- **Session Management**: Automatic logout on session expiration
- **Input Validation**: Comprehensive form validation

## 📊 State Management

The application uses BLoC pattern for state management:
- **Authentication BLoC**: Handles login/logout states
- **Dashboard BLoC**: Manages water monitoring data
- **Reports BLoC**: Handles report creation and listing
- **Profile BLoC**: Manages user profile operations
- **Water Requests BLoC**: Handles water supply requests

## 🌍 Localization

Supports multiple languages:
- **English** (en)
- **Spanish** (es)

Localization files are located in `lib/l10n/` with ARB format.

## 📦 Build & Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

## 📄 License

This project is proprietary software. All rights reserved.

## 📞 Support

For technical support or questions, please contact the development team.

**AquaConecta** - Connecting communities through smart water monitoring 🌊
