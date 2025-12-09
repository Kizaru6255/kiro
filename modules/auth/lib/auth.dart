/// Auth module for Kiro.
///
/// Provides complete authentication functionality including:
/// - Email/Password authentication
/// - Phone OTP authentication
/// - Social login (Google, Apple)
/// - Biometric authentication
/// - Session management
///
/// ## Quick Start
///
/// ```dart
/// import 'package:auth/auth.dart';
///
/// // In your app
/// final authProvider = AuthProvider();
/// await authProvider.login(email: 'user@example.com', password: 'password');
/// ```
library;

// Models
export 'models/user.dart';
export 'models/auth_state.dart';

// Services
export 'services/auth_service.dart';
export 'services/otp_service.dart';

// Providers
export 'providers/auth_provider.dart';

// Screens
export 'screens/login_screen.dart';
export 'screens/signup_screen.dart';
export 'screens/forgot_password_screen.dart';
export 'screens/verify_otp_screen.dart';

// Widgets
export 'widgets/auth_form_field.dart';
export 'widgets/social_login_button.dart';
export 'widgets/biometric_button.dart';

