# Kiro Module System — Technical Specification

> **Version:** 1.0.0  
> **Last Updated:** December 2024

---

## Table of Contents

1. [Module Overview](#1-module-overview)
2. [Module Architecture](#2-module-architecture)
3. [Auth Module](#3-auth-module)
4. [Wallet Module](#4-wallet-module)
5. [Chat Module](#5-chat-module)
6. [Booking Module](#6-booking-module)
7. [Payments Module](#7-payments-module)
8. [Notifications Module](#8-notifications-module)
9. [Tracking Module](#9-tracking-module)
10. [Module Injection Process](#10-module-injection-process)
11. [Creating Custom Modules](#11-creating-custom-modules)

---

## 1. Module Overview

### 1.1 What is a Kiro Module?

A Kiro Module is a **self-contained feature package** that can be optionally added to generated applications. Each module includes:

- **Screens**: UI components and pages
- **Providers**: State management (Riverpod)
- **Services**: Business logic and API calls
- **Models**: Data structures
- **Widgets**: Reusable UI components
- **Assets**: Module-specific assets (images, icons)

### 1.2 Module Design Principles

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         MODULE DESIGN PRINCIPLES                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   1. SELF-CONTAINED    - Each module is independent and complete            │
│   2. INJECTABLE        - Can be added without breaking existing code        │
│   3. CONFIGURABLE      - Behavior controlled via configuration              │
│   4. TESTABLE          - Includes unit and integration tests                │
│   5. DOCUMENTED        - Clear API and usage documentation                  │
│   6. VERSIONED         - Semantic versioning for compatibility              │
│   7. THEMED            - Respects app theme and styling                     │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.3 Module Categories

| Category | Modules | Description |
|----------|---------|-------------|
| **Identity** | Auth | User authentication and authorization |
| **Finance** | Wallet, Payments | Money management and transactions |
| **Communication** | Chat, Notifications | Real-time messaging and alerts |
| **Scheduling** | Booking | Appointments and reservations |
| **Location** | Tracking | GPS and location services |

---

## 2. Module Architecture

### 2.1 Standard Module Structure

Every module follows this consistent structure:

```
modules/{module_name}/
│
├── lib/
│   │
│   ├── {module_name}.dart          # Module entry point (barrel file)
│   │
│   ├── screens/
│   │   ├── {screen_name}_screen.dart
│   │   └── ...
│   │
│   ├── providers/
│   │   ├── {feature}_provider.dart
│   │   ├── {feature}_state.dart
│   │   └── ...
│   │
│   ├── services/
│   │   ├── {module}_service.dart
│   │   ├── {module}_repository.dart
│   │   └── ...
│   │
│   ├── models/
│   │   ├── {model_name}.dart
│   │   ├── {model_name}.freezed.dart
│   │   ├── {model_name}.g.dart
│   │   └── ...
│   │
│   ├── widgets/
│   │   ├── {widget_name}.dart
│   │   └── ...
│   │
│   └── utils/
│       ├── {module}_constants.dart
│       ├── {module}_validators.dart
│       └── ...
│
├── assets/
│   ├── images/
│   └── icons/
│
├── l10n/
│   ├── {module}_en.arb
│   └── {module}_hi.arb
│
├── test/
│   ├── providers/
│   ├── services/
│   └── widgets/
│
├── module.yaml                     # Module metadata
└── README.md                       # Module documentation
```

### 2.2 Module Metadata (module.yaml)

```yaml
# module.yaml
name: auth
display_name: Authentication
description: User authentication and authorization module
version: 1.0.0
author: Kiro Team

# Kiro compatibility
kiro_core_version: ">=1.0.0 <2.0.0"
kiro_cli_version: ">=1.0.0 <2.0.0"

# Dependencies (added to pubspec.yaml)
dependencies:
  firebase_auth: ^4.15.0
  google_sign_in: ^6.1.0
  local_auth: ^2.1.0

# Required permissions
permissions:
  - notification  # For OTP notifications

# Routes to register
routes:
  - path: /auth
    name: auth
    builder: AuthScreen
  - path: /auth/login
    name: login
    builder: LoginScreen
  - path: /auth/register
    name: register
    builder: RegisterScreen
  - path: /auth/forgot-password
    name: forgotPassword
    builder: ForgotPasswordScreen
  - path: /auth/otp
    name: otp
    builder: OtpVerificationScreen

# Providers to register
providers:
  - AuthProvider
  - UserProvider

# Configuration options
config:
  enable_social_login:
    type: bool
    default: true
    description: Enable social login options
  
  enable_biometric:
    type: bool
    default: false
    description: Enable biometric authentication
  
  session_timeout_minutes:
    type: int
    default: 30
    description: Session timeout in minutes
  
  require_email_verification:
    type: bool
    default: true
    description: Require email verification before login
```

### 2.3 Module Entry Point

```dart
/// auth.dart (Module barrel file)
///
/// Public API exports for the Auth module.

library kiro_auth;

// Screens
export 'screens/auth_screen.dart';
export 'screens/login_screen.dart';
export 'screens/register_screen.dart';
export 'screens/forgot_password_screen.dart';
export 'screens/otp_verification_screen.dart';
export 'screens/profile_screen.dart';

// Providers
export 'providers/auth_provider.dart';
export 'providers/auth_state.dart';
export 'providers/user_provider.dart';

// Services
export 'services/auth_service.dart';
export 'services/auth_repository.dart';

// Models
export 'models/user.dart';
export 'models/auth_credentials.dart';
export 'models/auth_result.dart';

// Widgets
export 'widgets/social_login_buttons.dart';
export 'widgets/otp_input_field.dart';
export 'widgets/password_strength_indicator.dart';

// Utils
export 'utils/auth_validators.dart';
```

---

## 3. Auth Module

### 3.1 Module Structure

```
modules/auth/
├── lib/
│   ├── auth.dart
│   │
│   ├── screens/
│   │   ├── auth_screen.dart              # Entry point with login/register toggle
│   │   ├── login_screen.dart             # Email/phone login
│   │   ├── register_screen.dart          # New user registration
│   │   ├── forgot_password_screen.dart   # Password reset flow
│   │   ├── otp_verification_screen.dart  # OTP input and verification
│   │   └── profile_screen.dart           # User profile management
│   │
│   ├── providers/
│   │   ├── auth_provider.dart            # Main auth state
│   │   ├── auth_state.dart               # Auth state model
│   │   ├── user_provider.dart            # Current user state
│   │   └── social_auth_provider.dart     # Social login handlers
│   │
│   ├── services/
│   │   ├── auth_service.dart             # Auth business logic
│   │   ├── auth_repository.dart          # API calls
│   │   ├── token_service.dart            # Token management
│   │   └── biometric_service.dart        # Biometric auth
│   │
│   ├── models/
│   │   ├── user.dart                     # User model
│   │   ├── auth_credentials.dart         # Login credentials
│   │   ├── auth_result.dart              # Auth operation result
│   │   ├── otp_request.dart              # OTP request model
│   │   └── social_profile.dart           # Social provider profile
│   │
│   ├── widgets/
│   │   ├── social_login_buttons.dart     # Google, Apple, etc.
│   │   ├── otp_input_field.dart          # 6-digit OTP input
│   │   ├── password_strength_indicator.dart
│   │   ├── auth_form_field.dart          # Custom styled input
│   │   └── biometric_prompt.dart         # Fingerprint/Face ID
│   │
│   └── utils/
│       ├── auth_constants.dart
│       └── auth_validators.dart
│
├── l10n/
│   ├── auth_en.arb
│   └── auth_hi.arb
│
└── module.yaml
```

### 3.2 Auth Provider Implementation

```dart
/// auth_provider.dart
///
/// Main authentication state management using Riverpod.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiro_core/kiro_core.dart';

// Auth state
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated({required User user}) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error({required AppException exception}) = _Error;
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;
  final TokenService _tokenService;
  final SecureStorage _storage;
  
  AuthNotifier({
    required AuthService authService,
    required TokenService tokenService,
    required SecureStorage storage,
  }) : _authService = authService,
       _tokenService = tokenService,
       _storage = storage,
       super(const AuthState.initial());
  
  /// Check if user is already logged in
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    
    try {
      final token = await _storage.getString(StorageKeys.accessToken);
      
      if (token == null) {
        state = const AuthState.unauthenticated();
        return;
      }
      
      // Validate token
      if (_tokenService.isTokenExpired(token)) {
        // Try refresh
        final refreshed = await _tokenService.refreshToken();
        if (!refreshed) {
          await _clearAuthData();
          state = const AuthState.unauthenticated();
          return;
        }
      }
      
      // Get user profile
      final user = await _authService.getCurrentUser();
      state = AuthState.authenticated(user: user);
    } on AppException catch (e) {
      state = AuthState.error(exception: e);
    }
  }
  
  /// Login with email and password
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    state = const AuthState.loading();
    
    try {
      final result = await _authService.loginWithEmail(
        email: email,
        password: password,
      );
      
      await _saveAuthData(result);
      state = AuthState.authenticated(user: result.user);
    } on AppException catch (e) {
      state = AuthState.error(exception: e);
    }
  }
  
  /// Login with phone and OTP
  Future<void> loginWithPhone({
    required String phone,
    required String otp,
  }) async {
    state = const AuthState.loading();
    
    try {
      final result = await _authService.verifyOtp(
        phone: phone,
        otp: otp,
      );
      
      await _saveAuthData(result);
      state = AuthState.authenticated(user: result.user);
    } on AppException catch (e) {
      state = AuthState.error(exception: e);
    }
  }
  
  /// Register new user
  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    state = const AuthState.loading();
    
    try {
      final result = await _authService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      
      await _saveAuthData(result);
      state = AuthState.authenticated(user: result.user);
    } on AppException catch (e) {
      state = AuthState.error(exception: e);
    }
  }
  
  /// Login with social provider
  Future<void> loginWithSocial(SocialProvider provider) async {
    state = const AuthState.loading();
    
    try {
      final result = await _authService.loginWithSocial(provider);
      await _saveAuthData(result);
      state = AuthState.authenticated(user: result.user);
    } on AppException catch (e) {
      state = AuthState.error(exception: e);
    }
  }
  
  /// Logout
  Future<void> logout() async {
    try {
      await _authService.logout();
    } finally {
      await _clearAuthData();
      state = const AuthState.unauthenticated();
    }
  }
  
  Future<void> _saveAuthData(AuthResult result) async {
    await _storage.setString(StorageKeys.accessToken, result.accessToken);
    await _storage.setString(StorageKeys.refreshToken, result.refreshToken);
    await _storage.setString(StorageKeys.userId, result.user.id);
  }
  
  Future<void> _clearAuthData() async {
    await _storage.remove(StorageKeys.accessToken);
    await _storage.remove(StorageKeys.refreshToken);
    await _storage.remove(StorageKeys.userId);
  }
}

// Providers
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthServiceImpl(
    apiService: ref.watch(apiServiceProvider),
  );
});

final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenServiceImpl(
    storage: ref.watch(secureStorageProvider),
    apiService: ref.watch(apiServiceProvider),
  );
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    authService: ref.watch(authServiceProvider),
    tokenService: ref.watch(tokenServiceProvider),
    storage: ref.watch(secureStorageProvider),
  );
});

// Convenience selectors
final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
});

final currentUserProvider = Provider<User?>((ref) {
  return ref.watch(authProvider).maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
});
```

### 3.3 Auth Service Implementation

```dart
/// auth_service.dart
///
/// Authentication business logic and API calls.

abstract class AuthService {
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  });
  
  Future<void> sendOtp({required String phone});
  
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  });
  
  Future<AuthResult> register({
    required String name,
    required String email,
    required String password,
    String? phone,
  });
  
  Future<AuthResult> loginWithSocial(SocialProvider provider);
  
  Future<User> getCurrentUser();
  
  Future<void> logout();
  
  Future<void> forgotPassword({required String email});
  
  Future<void> resetPassword({
    required String token,
    required String newPassword,
  });
  
  Future<void> updateProfile(UserUpdateRequest request);
  
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });
}

class AuthServiceImpl implements AuthService {
  final ApiService _apiService;
  
  AuthServiceImpl({required ApiService apiService}) 
    : _apiService = apiService;
  
  @override
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    final response = await _apiService.request<AuthResult>(
      endpoint: '/auth/login',
      method: HttpMethod.post,
      body: {
        'email': email,
        'password': password,
      },
      fromJson: AuthResult.fromJson,
    );
    
    return response.fold(
      onSuccess: (success) => success.data,
      onFailure: (failure) => throw failure.exception,
    );
  }
  
  @override
  Future<void> sendOtp({required String phone}) async {
    final response = await _apiService.request<void>(
      endpoint: '/auth/otp/send',
      method: HttpMethod.post,
      body: {'phone': phone},
      fromJson: (_) {},
    );
    
    response.fold(
      onSuccess: (_) {},
      onFailure: (failure) => throw failure.exception,
    );
  }
  
  @override
  Future<AuthResult> verifyOtp({
    required String phone,
    required String otp,
  }) async {
    final response = await _apiService.request<AuthResult>(
      endpoint: '/auth/otp/verify',
      method: HttpMethod.post,
      body: {
        'phone': phone,
        'otp': otp,
      },
      fromJson: AuthResult.fromJson,
    );
    
    return response.fold(
      onSuccess: (success) => success.data,
      onFailure: (failure) => throw failure.exception,
    );
  }
  
  @override
  Future<AuthResult> loginWithSocial(SocialProvider provider) async {
    String? idToken;
    
    switch (provider) {
      case SocialProvider.google:
        idToken = await _getGoogleIdToken();
        break;
      case SocialProvider.apple:
        idToken = await _getAppleIdToken();
        break;
      case SocialProvider.facebook:
        idToken = await _getFacebookAccessToken();
        break;
      default:
        throw UnsupportedError('Provider $provider not supported');
    }
    
    final response = await _apiService.request<AuthResult>(
      endpoint: '/auth/social',
      method: HttpMethod.post,
      body: {
        'provider': provider.name,
        'id_token': idToken,
      },
      fromJson: AuthResult.fromJson,
    );
    
    return response.fold(
      onSuccess: (success) => success.data,
      onFailure: (failure) => throw failure.exception,
    );
  }
  
  Future<String> _getGoogleIdToken() async {
    final googleSignIn = GoogleSignIn(scopes: ['email']);
    final account = await googleSignIn.signIn();
    
    if (account == null) {
      throw AuthException('Google sign-in cancelled');
    }
    
    final auth = await account.authentication;
    return auth.idToken ?? '';
  }
  
  // ... other implementations
}
```

### 3.4 Auth Models

```dart
/// user.dart

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
    required bool isEmailVerified,
    required bool isPhoneVerified,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

/// auth_result.dart

@freezed
class AuthResult with _$AuthResult {
  const factory AuthResult({
    required User user,
    required String accessToken,
    required String refreshToken,
    required DateTime expiresAt,
  }) = _AuthResult;
  
  factory AuthResult.fromJson(Map<String, dynamic> json) => _$AuthResultFromJson(json);
}

/// auth_credentials.dart

@freezed
class EmailCredentials with _$EmailCredentials {
  const factory EmailCredentials({
    required String email,
    required String password,
  }) = _EmailCredentials;
}

@freezed
class PhoneCredentials with _$PhoneCredentials {
  const factory PhoneCredentials({
    required String phone,
    required String otp,
  }) = _PhoneCredentials;
}
```

---

## 4. Wallet Module

### 4.1 Module Structure

```
modules/wallet/
├── lib/
│   ├── wallet.dart
│   │
│   ├── screens/
│   │   ├── wallet_screen.dart            # Main wallet view
│   │   ├── add_money_screen.dart         # Add money flow
│   │   ├── transaction_history_screen.dart
│   │   ├── transaction_detail_screen.dart
│   │   └── transfer_screen.dart          # P2P transfer
│   │
│   ├── providers/
│   │   ├── wallet_provider.dart
│   │   ├── wallet_state.dart
│   │   └── transaction_provider.dart
│   │
│   ├── services/
│   │   ├── wallet_service.dart
│   │   └── wallet_repository.dart
│   │
│   ├── models/
│   │   ├── wallet.dart
│   │   ├── transaction.dart
│   │   └── balance.dart
│   │
│   └── widgets/
│       ├── wallet_card.dart
│       ├── transaction_tile.dart
│       ├── balance_display.dart
│       └── quick_actions.dart
│
└── module.yaml
```

### 4.2 Wallet Models

```dart
/// wallet.dart

@freezed
class Wallet with _$Wallet {
  const factory Wallet({
    required String id,
    required String userId,
    required Balance balance,
    required List<Transaction> recentTransactions,
    required WalletStatus status,
    required DateTime createdAt,
    DateTime? lastTransactionAt,
  }) = _Wallet;
  
  factory Wallet.fromJson(Map<String, dynamic> json) => _$WalletFromJson(json);
}

@freezed
class Balance with _$Balance {
  const factory Balance({
    required double amount,
    required String currency,
    required double holdAmount,  // Pending transactions
  }) = _Balance;
  
  const Balance._();
  
  double get available => amount - holdAmount;
  
  String get formatted => '${currency.currencySymbol}${amount.toStringAsFixed(2)}';
  
  factory Balance.fromJson(Map<String, dynamic> json) => _$BalanceFromJson(json);
}

enum WalletStatus { active, suspended, closed }

/// transaction.dart

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String walletId,
    required TransactionType type,
    required double amount,
    required String currency,
    required TransactionStatus status,
    String? description,
    String? referenceId,
    Map<String, dynamic>? metadata,
    required DateTime createdAt,
    DateTime? completedAt,
  }) = _Transaction;
  
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

enum TransactionType {
  credit,   // Money added
  debit,    // Money deducted
  transfer, // P2P transfer
  payment,  // Payment for service
  refund,   // Refund
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
}
```

---

## 5. Chat Module

### 5.1 Module Structure

```
modules/chat/
├── lib/
│   ├── chat.dart
│   │
│   ├── screens/
│   │   ├── conversations_screen.dart     # List of chats
│   │   ├── chat_screen.dart              # Individual chat
│   │   ├── group_info_screen.dart        # Group details
│   │   └── media_preview_screen.dart     # Image/video preview
│   │
│   ├── providers/
│   │   ├── chat_provider.dart
│   │   ├── conversation_provider.dart
│   │   ├── message_provider.dart
│   │   └── socket_provider.dart
│   │
│   ├── services/
│   │   ├── chat_service.dart
│   │   ├── socket_service.dart
│   │   ├── message_queue.dart
│   │   └── media_upload_service.dart
│   │
│   ├── models/
│   │   ├── conversation.dart
│   │   ├── message.dart
│   │   ├── participant.dart
│   │   └── media_attachment.dart
│   │
│   └── widgets/
│       ├── message_bubble.dart
│       ├── message_input.dart
│       ├── conversation_tile.dart
│       ├── typing_indicator.dart
│       └── message_status_icon.dart
│
└── module.yaml
```

### 5.2 Chat Socket Service

```dart
/// socket_service.dart
///
/// WebSocket connection management for real-time messaging.

class SocketService {
  Socket? _socket;
  final StreamController<SocketEvent> _eventController;
  final String _baseUrl;
  final TokenService _tokenService;
  
  SocketConnectionState _state = SocketConnectionState.disconnected;
  Timer? _reconnectTimer;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 5;
  
  SocketService({
    required String baseUrl,
    required TokenService tokenService,
  }) : _baseUrl = baseUrl,
       _tokenService = tokenService,
       _eventController = StreamController<SocketEvent>.broadcast();
  
  Stream<SocketEvent> get eventStream => _eventController.stream;
  SocketConnectionState get state => _state;
  
  Future<void> connect() async {
    if (_state == SocketConnectionState.connected) return;
    
    _state = SocketConnectionState.connecting;
    _eventController.add(const SocketEvent.connecting());
    
    try {
      final token = await _tokenService.getAccessToken();
      
      _socket = io(
        _baseUrl,
        OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': token})
          .enableAutoConnect()
          .enableReconnection()
          .build(),
      );
      
      _setupListeners();
    } catch (e) {
      _state = SocketConnectionState.error;
      _eventController.add(SocketEvent.error(e.toString()));
      _scheduleReconnect();
    }
  }
  
  void _setupListeners() {
    _socket!
      ..onConnect((_) {
        _state = SocketConnectionState.connected;
        _reconnectAttempts = 0;
        _eventController.add(const SocketEvent.connected());
      })
      ..onDisconnect((_) {
        _state = SocketConnectionState.disconnected;
        _eventController.add(const SocketEvent.disconnected());
        _scheduleReconnect();
      })
      ..on('message', (data) {
        final message = Message.fromJson(data as Map<String, dynamic>);
        _eventController.add(SocketEvent.messageReceived(message));
      })
      ..on('message:delivered', (data) {
        _eventController.add(SocketEvent.messageDelivered(data['messageId']));
      })
      ..on('message:read', (data) {
        _eventController.add(SocketEvent.messageRead(data['messageId']));
      })
      ..on('typing:start', (data) {
        _eventController.add(SocketEvent.typingStarted(
          conversationId: data['conversationId'],
          userId: data['userId'],
        ));
      })
      ..on('typing:stop', (data) {
        _eventController.add(SocketEvent.typingStopped(
          conversationId: data['conversationId'],
          userId: data['userId'],
        ));
      })
      ..onError((error) {
        _eventController.add(SocketEvent.error(error.toString()));
      });
  }
  
  void sendMessage(Message message) {
    _socket?.emit('message:send', message.toJson());
  }
  
  void markAsRead(String conversationId, String messageId) {
    _socket?.emit('message:read', {
      'conversationId': conversationId,
      'messageId': messageId,
    });
  }
  
  void startTyping(String conversationId) {
    _socket?.emit('typing:start', {'conversationId': conversationId});
  }
  
  void stopTyping(String conversationId) {
    _socket?.emit('typing:stop', {'conversationId': conversationId});
  }
  
  void joinConversation(String conversationId) {
    _socket?.emit('conversation:join', {'conversationId': conversationId});
  }
  
  void leaveConversation(String conversationId) {
    _socket?.emit('conversation:leave', {'conversationId': conversationId});
  }
  
  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      _eventController.add(const SocketEvent.reconnectFailed());
      return;
    }
    
    final delay = Duration(seconds: pow(2, _reconnectAttempts).toInt());
    _reconnectTimer = Timer(delay, () {
      _reconnectAttempts++;
      connect();
    });
  }
  
  Future<void> disconnect() async {
    _reconnectTimer?.cancel();
    _socket?.disconnect();
    _socket = null;
    _state = SocketConnectionState.disconnected;
  }
  
  void dispose() {
    disconnect();
    _eventController.close();
  }
}

enum SocketConnectionState {
  disconnected,
  connecting,
  connected,
  error,
}

@freezed
class SocketEvent with _$SocketEvent {
  const factory SocketEvent.connecting() = _Connecting;
  const factory SocketEvent.connected() = _Connected;
  const factory SocketEvent.disconnected() = _Disconnected;
  const factory SocketEvent.error(String message) = _Error;
  const factory SocketEvent.reconnectFailed() = _ReconnectFailed;
  const factory SocketEvent.messageReceived(Message message) = _MessageReceived;
  const factory SocketEvent.messageDelivered(String messageId) = _MessageDelivered;
  const factory SocketEvent.messageRead(String messageId) = _MessageRead;
  const factory SocketEvent.typingStarted({
    required String conversationId,
    required String userId,
  }) = _TypingStarted;
  const factory SocketEvent.typingStopped({
    required String conversationId,
    required String userId,
  }) = _TypingStopped;
}
```

---

## 6-9. Additional Modules

_(Booking, Payments, Notifications, and Tracking modules follow the same detailed pattern with their respective models, providers, services, and widgets. Full specifications are included in supplementary documentation.)_

---

## 10. Module Injection Process

### 10.1 Injection Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                         MODULE INJECTION FLOW                                │
└─────────────────────────────────────────────────────────────────────────────┘

    ┌──────────────────┐
    │ User Selects     │
    │ Module           │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Load module.yaml │
    │ Validate config  │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Copy module      │
    │ to features/     │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Update pubspec   │
    │ Add dependencies │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Register routes  │
    │ in app_router    │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Register         │
    │ providers        │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Copy assets and  │
    │ localizations    │
    └────────┬─────────┘
             │
             ▼
    ┌──────────────────┐
    │ Update config    │
    │ kiro.config.json │
    └────────┬─────────┘
             │
             ▼
         ┌───────┐
         │ Done  │
         └───────┘
```

### 10.2 Module Injector Implementation

```dart
/// module_injector.dart

class ModuleInjector {
  final String projectPath;
  final FileUtils _fileUtils;
  final Logger _logger;
  
  ModuleInjector({
    required this.projectPath,
    FileUtils? fileUtils,
    Logger? logger,
  }) : _fileUtils = fileUtils ?? FileUtils(),
       _logger = logger ?? Logger();
  
  Future<void> inject(KiroModule module) async {
    _logger.info('Injecting module: ${module.displayName}');
    
    // Step 1: Load and validate module
    final moduleConfig = await _loadModuleConfig(module);
    _validateModuleConfig(moduleConfig);
    
    // Step 2: Copy module files
    await _copyModuleFiles(module);
    
    // Step 3: Update pubspec.yaml
    await _updatePubspec(moduleConfig);
    
    // Step 4: Register routes
    await _registerRoutes(moduleConfig);
    
    // Step 5: Register providers
    await _registerProviders(moduleConfig);
    
    // Step 6: Copy assets
    await _copyAssets(module);
    
    // Step 7: Copy localizations
    await _copyLocalizations(module);
    
    // Step 8: Update exports
    await _updateExports(module);
    
    _logger.success('Module ${module.displayName} injected successfully');
  }
  
  Future<ModuleConfig> _loadModuleConfig(KiroModule module) async {
    final configPath = path.join(
      _getModulesPath(),
      module.name,
      'module.yaml',
    );
    
    final configContent = await File(configPath).readAsString();
    final yaml = loadYaml(configContent);
    return ModuleConfig.fromYaml(yaml);
  }
  
  Future<void> _copyModuleFiles(KiroModule module) async {
    final sourcePath = path.join(_getModulesPath(), module.name, 'lib');
    final destPath = path.join(projectPath, 'lib', 'features', module.name);
    
    await _fileUtils.copyDirectory(sourcePath, destPath);
  }
  
  Future<void> _updatePubspec(ModuleConfig config) async {
    final pubspecPath = path.join(projectPath, 'pubspec.yaml');
    final modifier = PubspecModifier(pubspecPath);
    
    for (final dep in config.dependencies) {
      await modifier.addDependency(dep.name, dep.version);
    }
    
    await modifier.save();
  }
  
  Future<void> _registerRoutes(ModuleConfig config) async {
    final routerPath = path.join(projectPath, 'lib', 'routing', 'app_router.dart');
    final routeGenerator = RouteGenerator(routerPath);
    
    for (final route in config.routes) {
      await routeGenerator.addRoute(
        path: route.path,
        name: route.name,
        builder: route.builder,
        moduleName: config.name,
      );
    }
    
    await routeGenerator.save();
  }
  
  Future<void> _registerProviders(ModuleConfig config) async {
    // Add provider imports to main providers file
    final providersPath = path.join(projectPath, 'lib', 'providers', 'providers.dart');
    final content = await File(providersPath).readAsString();
    
    final imports = config.providers
        .map((p) => "export 'package:${config.name}/${p.toLowerCase()}.dart';")
        .join('\n');
    
    final updatedContent = '$imports\n$content';
    await File(providersPath).writeAsString(updatedContent);
  }
  
  String _getModulesPath() {
    // This could be from embedded resources or a separate modules directory
    return path.join(Directory.current.path, 'modules');
  }
}
```

---

## 11. Creating Custom Modules

### 11.1 Module Template

```
my_custom_module/
├── lib/
│   ├── my_custom_module.dart     # Exports
│   ├── screens/
│   │   └── ...
│   ├── providers/
│   │   └── ...
│   ├── services/
│   │   └── ...
│   ├── models/
│   │   └── ...
│   └── widgets/
│       └── ...
├── module.yaml                    # Required metadata
├── README.md
└── test/
```

### 11.2 module.yaml Schema

```yaml
# Required fields
name: string              # Unique identifier (lowercase, no spaces)
display_name: string      # Human-readable name
description: string       # Brief description
version: string           # Semantic version (e.g., 1.0.0)

# Compatibility (required)
kiro_core_version: string # Required kiro_core version
kiro_cli_version: string  # Required kiro_cli version

# Dependencies (optional)
dependencies:
  - name: package_name
    version: ^1.0.0

# Permissions (optional)
permissions:
  - permission_name

# Routes (required if module has screens)
routes:
  - path: /route/path
    name: routeName
    builder: ScreenClassName

# Providers (optional)
providers:
  - ProviderName

# Configuration options (optional)
config:
  option_name:
    type: bool|int|string|list
    default: value
    description: Option description
```

---

**Next Document**: [05_template_engine.md](./05_template_engine.md)

