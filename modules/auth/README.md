# Auth Module

Complete authentication module for Kiro-powered Flutter applications.

## Features

- ✅ Email/Password authentication
- ✅ Phone OTP authentication
- ✅ Social login (Google, Apple)
- ✅ Password reset
- ✅ Session management
- ✅ Biometric authentication support
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module auth
```

### 2. Import in your app

```dart
import 'package:auth/auth.dart';
```

### 3. Use in your router

```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupScreen(),
    ),
    // ... other routes
  ],
);
```

### 4. Use AuthProvider

```dart
final authState = ref.watch(authStateProvider);

if (authState.isAuthenticated) {
  final user = authState.user!;
  // Show authenticated UI
} else {
  // Show login screen
}
```

## API Endpoints

The module expects these endpoints:

- `POST /auth/login` - Email/password login
- `POST /auth/signup` - User registration
- `POST /auth/phone/send-otp` - Send OTP to phone
- `POST /auth/phone/verify-otp` - Verify OTP
- `GET /auth/me` - Get current user
- `POST /auth/password/reset` - Request password reset

## Configuration

Edit `module.yaml` to configure:

- Enable/disable biometric auth
- Enable/disable social login
- OTP expiry time

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `firebase_auth` (optional) - Firebase authentication
- `google_sign_in` (optional) - Google Sign-In

