# Kiro Coding Standards & Conventions

> **Version:** 1.0.0  
> **Last Updated:** December 2024

---

## Table of Contents

1. [General Principles](#1-general-principles)
2. [Dart & Flutter Style Guide](#2-dart--flutter-style-guide)
3. [Project Structure](#3-project-structure)
4. [Naming Conventions](#4-naming-conventions)
5. [Documentation Standards](#5-documentation-standards)
6. [Error Handling](#6-error-handling)
7. [State Management](#7-state-management)
8. [Testing Standards](#8-testing-standards)
9. [Git Workflow](#9-git-workflow)
10. [Code Review Checklist](#10-code-review-checklist)

---

## 1. General Principles

### 1.1 Core Values

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                           KIRO CODE PRINCIPLES                               │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   1. CLARITY        Code should be self-documenting and easy to read        │
│   2. SIMPLICITY     Prefer simple solutions over clever ones                │
│   3. CONSISTENCY    Follow established patterns throughout                  │
│   4. TESTABILITY    Write code that's easy to test                          │
│   5. MAINTAINABILITY Future developers should understand easily             │
│   6. PERFORMANCE    Don't prematurely optimize, but don't be wasteful       │
│   7. SECURITY       Always consider security implications                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 1.2 The Rule of Three

> When you find yourself copying code for the third time, extract it into a reusable abstraction.

### 1.3 SOLID Principles

- **S**ingle Responsibility: Each class/function does one thing
- **O**pen/Closed: Open for extension, closed for modification
- **L**iskov Substitution: Subclasses can replace base classes
- **I**nterface Segregation: Many specific interfaces over one general
- **D**ependency Inversion: Depend on abstractions, not concretions

---

## 2. Dart & Flutter Style Guide

### 2.1 Formatting

Always use `dart format` with default settings. Configure your IDE to format on save.

```dart
// ✅ Good: Properly formatted
class UserService {
  final ApiClient _apiClient;
  final CacheManager _cache;

  UserService({
    required ApiClient apiClient,
    required CacheManager cache,
  })  : _apiClient = apiClient,
        _cache = cache;

  Future<User> getUser(String id) async {
    final cached = await _cache.get<User>('user_$id');
    if (cached != null) return cached;

    final response = await _apiClient.get('/users/$id');
    return User.fromJson(response.data);
  }
}

// ❌ Bad: Poor formatting
class UserService{
  final ApiClient _apiClient;final CacheManager _cache;
  UserService({required ApiClient apiClient,required CacheManager cache}):_apiClient=apiClient,_cache=cache;
  Future<User> getUser(String id)async{final cached=await _cache.get<User>('user_$id');if(cached!=null)return cached;final response=await _apiClient.get('/users/$id');return User.fromJson(response.data);}
}
```

### 2.2 Line Length

Maximum line length: **80 characters** (Dart default)

```dart
// ✅ Good: Wrapped properly
final result = await someVeryLongFunctionName(
  firstParameter: value1,
  secondParameter: value2,
  thirdParameter: value3,
);

// ❌ Bad: Too long
final result = await someVeryLongFunctionName(firstParameter: value1, secondParameter: value2, thirdParameter: value3);
```

### 2.3 Imports

Order imports in the following groups, separated by blank lines:

1. `dart:` imports
2. `package:` imports (external packages)
3. `package:` imports (internal/project packages)
4. Relative imports

```dart
// ✅ Good: Properly organized imports
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:kiro_core/kiro_core.dart';

import '../models/user.dart';
import '../providers/auth_provider.dart';
import 'login_form.dart';
```

### 2.4 Types

Always specify types explicitly for:
- Public APIs
- Instance variables
- Return types

```dart
// ✅ Good: Explicit types
class AuthService {
  final ApiClient _apiClient;
  
  Future<AuthResult> login(LoginCredentials credentials) async {
    final Map<String, dynamic> response = await _apiClient.post(
      '/auth/login',
      data: credentials.toJson(),
    );
    return AuthResult.fromJson(response);
  }
}

// ❌ Bad: Missing types
class AuthService {
  final _apiClient;
  
  login(credentials) async {
    final response = await _apiClient.post(
      '/auth/login',
      data: credentials.toJson(),
    );
    return AuthResult.fromJson(response);
  }
}
```

### 2.5 Null Safety

Embrace null safety fully. Avoid `!` operator when possible.

```dart
// ✅ Good: Safe null handling
String getDisplayName(User? user) {
  return user?.name ?? 'Guest';
}

final userName = user?.name;
if (userName != null && userName.isNotEmpty) {
  // userName is now non-null
  print(userName.toUpperCase());
}

// ❌ Bad: Dangerous null handling
String getDisplayName(User? user) {
  return user!.name; // Can throw
}
```

### 2.6 Late Initialization

Use `late` only when necessary and safe.

```dart
// ✅ Good: Valid use of late
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late final AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }
}

// ❌ Bad: Unnecessary late
class SomeClass {
  late String name; // Should be nullable or initialized
  
  void setName(String value) {
    name = value;
  }
}
```

### 2.7 Const Constructors

Use `const` constructors wherever possible.

```dart
// ✅ Good: Const widgets
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}

// ❌ Bad: Missing const
class MyApp extends StatelessWidget {
  MyApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Hello'),
        ),
      ),
    );
  }
}
```

### 2.8 Enums

Use enhanced enums with properties when appropriate.

```dart
// ✅ Good: Enhanced enum
enum TransactionType {
  credit('Credit', '+', Colors.green),
  debit('Debit', '-', Colors.red),
  transfer('Transfer', '↔', Colors.blue);
  
  const TransactionType(this.label, this.symbol, this.color);
  
  final String label;
  final String symbol;
  final Color color;
}

// Usage
final type = TransactionType.credit;
print(type.label); // "Credit"
```

### 2.9 Switch Expressions

Use switch expressions (Dart 3.0+) for pattern matching.

```dart
// ✅ Good: Switch expression
String getStatusMessage(Status status) {
  return switch (status) {
    Status.idle => 'Waiting...',
    Status.loading => 'Loading...',
    Status.success => 'Done!',
    Status.error => 'Something went wrong',
  };
}

// Also good: Pattern matching on sealed classes
sealed class AuthState {}
class AuthInitial extends AuthState {}
class AuthLoading extends AuthState {}
class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}
class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}

Widget buildAuthWidget(AuthState state) {
  return switch (state) {
    AuthInitial() => const LoginScreen(),
    AuthLoading() => const LoadingIndicator(),
    AuthSuccess(:final user) => HomeScreen(user: user),
    AuthError(:final message) => ErrorScreen(message: message),
  };
}
```

---

## 3. Project Structure

### 3.1 Feature-First Organization

```
lib/
├── app/                      # App configuration
│   ├── app.dart
│   └── app_config.dart
│
├── core/                     # Core utilities (if not using kiro_core)
│   ├── constants/
│   ├── extensions/
│   └── utils/
│
├── features/                 # Feature modules
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── sources/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── providers/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   ├── wallet/
│   └── ...
│
├── routing/                  # Navigation
│   ├── app_router.dart
│   └── routes.dart
│
├── shared/                   # Shared components
│   ├── widgets/
│   └── mixins/
│
└── main.dart
```

### 3.2 File Organization Rules

1. **One public class per file** (with exceptions for small related classes)
2. **File name matches class name** in snake_case
3. **Group related files** in directories
4. **Keep files under 300 lines** (split if larger)

```dart
// ✅ Good: user_repository.dart
class UserRepository {
  // Implementation
}

// ❌ Bad: repositories.dart with multiple classes
class UserRepository { ... }
class ProductRepository { ... }
class OrderRepository { ... }
```

---

## 4. Naming Conventions

### 4.1 Quick Reference

| Type | Convention | Example |
|------|------------|---------|
| Classes | PascalCase | `UserRepository` |
| Mixins | PascalCase | `LoggerMixin` |
| Extensions | PascalCase | `StringExtension` |
| Enums | PascalCase | `AuthStatus` |
| Enum values | camelCase | `AuthStatus.loggedIn` |
| Functions | camelCase | `fetchUserData()` |
| Variables | camelCase | `userName` |
| Constants | camelCase or SCREAMING_SNAKE | `maxRetries` or `MAX_RETRIES` |
| Private | _prefixed | `_internalValue` |
| Files | snake_case | `user_repository.dart` |
| Directories | snake_case | `auth_module/` |
| Type parameters | Single uppercase | `T`, `E`, `K`, `V` |

### 4.2 Descriptive Names

```dart
// ✅ Good: Descriptive names
class UserAuthenticationService { ... }
Future<User?> fetchActiveUserById(String userId) { ... }
bool isValidEmailAddress(String email) { ... }
final remainingAttempts = 3;

// ❌ Bad: Abbreviated or unclear names
class UAS { ... }
Future<User?> fetch(String id) { ... }
bool check(String e) { ... }
final r = 3;
```

### 4.3 Boolean Naming

Use `is`, `has`, `can`, `should` prefixes.

```dart
// ✅ Good
bool isLoading = false;
bool hasPermission = true;
bool canEdit = user.isAdmin;
bool shouldRefresh = lastUpdate.isBefore(threshold);

// ❌ Bad
bool loading = false;
bool permission = true;
bool edit = user.isAdmin;
```

### 4.4 Collection Naming

Use plural nouns for collections.

```dart
// ✅ Good
List<User> users = [];
Map<String, Product> productsById = {};
Set<String> selectedIds = {};

// ❌ Bad
List<User> userList = [];
Map<String, Product> productMap = {};
Set<String> selectedIdSet = {};
```

### 4.5 Function Naming

Use verb phrases that describe the action.

```dart
// ✅ Good
Future<void> fetchUsers() async { ... }
void updateProfile(User user) { ... }
bool validateEmail(String email) { ... }
User? findUserById(String id) { ... }
List<Order> filterOrdersByStatus(Status status) { ... }

// ❌ Bad
Future<void> users() async { ... }
void profile(User user) { ... }
bool email(String email) { ... }
```

---

## 5. Documentation Standards

### 5.1 Class Documentation

```dart
/// A service for managing user authentication.
///
/// This service handles login, logout, token refresh, and session management.
/// It requires an [ApiClient] for network requests and a [SecureStorage]
/// for storing authentication tokens.
///
/// Example:
/// ```dart
/// final authService = AuthService(
///   apiClient: apiClient,
///   storage: secureStorage,
/// );
///
/// final result = await authService.login(
///   email: 'user@example.com',
///   password: 'password123',
/// );
/// ```
///
/// See also:
/// - [User] for the user model
/// - [AuthResult] for the login result
class AuthService {
  // Implementation
}
```

### 5.2 Method Documentation

```dart
/// Authenticates a user with email and password.
///
/// Sends a login request to the authentication server and returns
/// an [AuthResult] containing the user data and tokens.
///
/// Throws:
/// - [AuthException] if credentials are invalid
/// - [NetworkException] if the server is unreachable
/// - [RateLimitException] if too many login attempts
///
/// Example:
/// ```dart
/// try {
///   final result = await authService.login(
///     email: 'user@example.com',
///     password: 'password123',
///   );
///   print('Welcome, ${result.user.name}!');
/// } on AuthException catch (e) {
///   print('Login failed: ${e.message}');
/// }
/// ```
Future<AuthResult> login({
  required String email,
  required String password,
}) async {
  // Implementation
}
```

### 5.3 Parameter Documentation

```dart
/// Creates a new user account.
///
/// Parameters:
/// - [name]: The user's full name (2-100 characters)
/// - [email]: A valid email address (must be unique)
/// - [password]: Password (minimum 8 characters, must include number)
/// - [phone]: Optional phone number in international format
///
/// Returns the created [User] on success.
Future<User> register({
  required String name,
  required String email,
  required String password,
  String? phone,
}) async {
  // Implementation
}
```

### 5.4 TODO Comments

```dart
// TODO(chaitanya): Implement retry logic for failed requests
// TODO: Add caching layer - https://github.com/org/repo/issues/123
// FIXME: This breaks when user has no profile picture
// HACK: Temporary workaround until API v2 is ready
// NOTE: This assumes UTC timezone
```

---

## 6. Error Handling

### 6.1 Exception Hierarchy

```dart
/// Base exception for all Kiro errors
abstract class KiroException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
  
  const KiroException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });
  
  @override
  String toString() => 'KiroException: $message (code: $code)';
}

/// Network-related exceptions
class NetworkException extends KiroException {
  final int? statusCode;
  
  const NetworkException({
    required super.message,
    super.code,
    this.statusCode,
    super.originalError,
    super.stackTrace,
  });
}

// Specific network exceptions
class NoInternetException extends NetworkException { ... }
class TimeoutException extends NetworkException { ... }
class ServerException extends NetworkException { ... }
class UnauthorizedException extends NetworkException { ... }
```

### 6.2 Error Handling Patterns

```dart
// ✅ Good: Specific error handling
Future<User> getUser(String id) async {
  try {
    final response = await _apiClient.get('/users/$id');
    return User.fromJson(response.data);
  } on DioException catch (e) {
    throw switch (e.type) {
      DioExceptionType.connectionTimeout => 
        const TimeoutException(message: 'Connection timed out'),
      DioExceptionType.receiveTimeout => 
        const TimeoutException(message: 'Response timed out'),
      DioExceptionType.badResponse => 
        _handleBadResponse(e.response),
      _ => NetworkException(
          message: 'Network error occurred',
          originalError: e,
        ),
    };
  }
}

NetworkException _handleBadResponse(Response? response) {
  final statusCode = response?.statusCode;
  return switch (statusCode) {
    401 => const UnauthorizedException(message: 'Session expired'),
    404 => const NotFoundException(message: 'User not found'),
    429 => const RateLimitException(message: 'Too many requests'),
    >= 500 => const ServerException(message: 'Server error'),
    _ => NetworkException(
        message: 'Request failed',
        statusCode: statusCode,
      ),
  };
}

// ❌ Bad: Generic error handling
Future<User> getUser(String id) async {
  try {
    final response = await _apiClient.get('/users/$id');
    return User.fromJson(response.data);
  } catch (e) {
    throw Exception('Something went wrong'); // Too generic!
  }
}
```

### 6.3 Result Type Pattern

```dart
/// Represents either a success or failure
sealed class Result<T, E> {
  const Result();
}

final class Success<T, E> extends Result<T, E> {
  final T value;
  const Success(this.value);
}

final class Failure<T, E> extends Result<T, E> {
  final E error;
  const Failure(this.error);
}

// Extension for easier handling
extension ResultExtension<T, E> on Result<T, E> {
  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(E error) onFailure,
  }) {
    return switch (this) {
      Success(:final value) => onSuccess(value),
      Failure(:final error) => onFailure(error),
    };
  }
  
  T? get valueOrNull => switch (this) {
    Success(:final value) => value,
    Failure() => null,
  };
}

// Usage
Future<Result<User, AuthError>> login(Credentials credentials) async {
  try {
    final user = await _authService.login(credentials);
    return Success(user);
  } on AuthException catch (e) {
    return Failure(AuthError.fromException(e));
  }
}
```

---

## 7. State Management

### 7.1 Riverpod Best Practices

```dart
// ✅ Good: Proper provider structure

// State model (immutable)
@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.error(String message) = _Error;
}

// Notifier (business logic)
@riverpod
class Auth extends _$Auth {
  @override
  AuthState build() => const AuthState.initial();
  
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    
    try {
      final authService = ref.read(authServiceProvider);
      final user = await authService.login(email: email, password: password);
      state = AuthState.authenticated(user);
    } on AuthException catch (e) {
      state = AuthState.error(e.message);
    }
  }
  
  Future<void> logout() async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    state = const AuthState.initial();
  }
}

// Derived providers
@riverpod
bool isAuthenticated(IsAuthenticatedRef ref) {
  return ref.watch(authProvider).maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
}

@riverpod
User? currentUser(CurrentUserRef ref) {
  return ref.watch(authProvider).maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
}
```

### 7.2 Provider Organization

```dart
// providers/providers.dart - Barrel file
export 'auth/auth_provider.dart';
export 'auth/auth_service_provider.dart';
export 'user/user_provider.dart';
export 'theme/theme_provider.dart';

// Feature-specific providers in feature directories
// features/auth/providers/auth_provider.dart
```

### 7.3 Avoiding Common Mistakes

```dart
// ❌ Bad: Reading providers in build
@override
Widget build(BuildContext context, WidgetRef ref) {
  // This rebuilds the widget on every auth state change
  final authState = ref.read(authProvider); // Should be watch!
  return Text(authState.user.name);
}

// ✅ Good: Watch for UI, read for actions
@override
Widget build(BuildContext context, WidgetRef ref) {
  // Watch for reactive updates
  final authState = ref.watch(authProvider);
  
  return ElevatedButton(
    onPressed: () {
      // Read for one-time actions
      ref.read(authProvider.notifier).logout();
    },
    child: Text('Logout'),
  );
}

// ❌ Bad: Unnecessary rebuilds
@override
Widget build(BuildContext context, WidgetRef ref) {
  final auth = ref.watch(authProvider); // Watches entire state
  return Text('Hello ${auth.user.name}');
}

// ✅ Good: Select only what you need
@override
Widget build(BuildContext context, WidgetRef ref) {
  final userName = ref.watch(
    authProvider.select((state) => state.maybeWhen(
      authenticated: (user) => user.name,
      orElse: () => 'Guest',
    )),
  );
  return Text('Hello $userName');
}
```

---

## 8. Testing Standards

### 8.1 Test Organization

```
test/
├── unit/
│   ├── services/
│   │   └── auth_service_test.dart
│   ├── providers/
│   │   └── auth_provider_test.dart
│   └── utils/
│       └── validators_test.dart
│
├── widget/
│   ├── screens/
│   │   └── login_screen_test.dart
│   └── widgets/
│       └── auth_button_test.dart
│
├── integration/
│   └── auth_flow_test.dart
│
├── fixtures/
│   └── user_fixtures.dart
│
├── mocks/
│   ├── mock_auth_service.dart
│   └── mocks.dart
│
└── helpers/
    └── test_helpers.dart
```

### 8.2 Test Naming

```dart
// Use descriptive, behavior-focused names
group('AuthService', () {
  group('login', () {
    test('returns user when credentials are valid', () async {
      // Test implementation
    });
    
    test('throws AuthException when password is incorrect', () async {
      // Test implementation
    });
    
    test('throws NetworkException when server is unreachable', () async {
      // Test implementation
    });
  });
});
```

### 8.3 Arrange-Act-Assert Pattern

```dart
test('adds item to cart and updates total', () {
  // Arrange
  final cart = ShoppingCart();
  final product = Product(id: '1', name: 'Test', price: 10.0);
  
  // Act
  cart.addItem(product, quantity: 2);
  
  // Assert
  expect(cart.items.length, equals(1));
  expect(cart.items.first.quantity, equals(2));
  expect(cart.total, equals(20.0));
});
```

### 8.4 Mocking

```dart
// Using Mocktail
import 'package:mocktail/mocktail.dart';

class MockAuthService extends Mock implements AuthService {}
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockAuthService mockAuthService;
  late AuthNotifier authNotifier;
  
  setUp(() {
    mockAuthService = MockAuthService();
    authNotifier = AuthNotifier(authService: mockAuthService);
  });
  
  test('login success updates state to authenticated', () async {
    // Arrange
    final user = User(id: '1', name: 'Test User', email: 'test@test.com');
    when(() => mockAuthService.login(
      email: any(named: 'email'),
      password: any(named: 'password'),
    )).thenAnswer((_) async => user);
    
    // Act
    await authNotifier.login('test@test.com', 'password');
    
    // Assert
    expect(authNotifier.state, isA<AuthAuthenticated>());
    verify(() => mockAuthService.login(
      email: 'test@test.com',
      password: 'password',
    )).called(1);
  });
}
```

---

## 9. Git Workflow

### 9.1 Branch Naming

```
feature/add-payment-module
fix/auth-token-refresh
refactor/network-layer
docs/api-documentation
chore/update-dependencies
test/auth-service-tests
```

### 9.2 Commit Messages

Follow Conventional Commits:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation
- `style`: Code style (formatting)
- `refactor`: Code refactoring
- `test`: Adding tests
- `chore`: Maintenance

Examples:
```
feat(auth): add biometric authentication support

Implement fingerprint and face ID login options using local_auth package.

Closes #123
```

```
fix(network): handle token refresh race condition

Multiple simultaneous requests could trigger multiple refresh attempts.
Added mutex lock to ensure only one refresh occurs at a time.
```

### 9.3 Pull Request Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Refactoring
- [ ] Documentation

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed
- [ ] Added tests
- [ ] Documentation updated
- [ ] No linter warnings

## Screenshots (if UI changes)

## Related Issues
Closes #123
```

---

## 10. Code Review Checklist

### 10.1 For Authors

Before submitting:
- [ ] Code compiles without errors
- [ ] All tests pass
- [ ] No linter warnings
- [ ] Self-reviewed changes
- [ ] Documentation added/updated
- [ ] Commit messages are clear
- [ ] PR description is complete

### 10.2 For Reviewers

Check for:

**Correctness**
- [ ] Logic is correct
- [ ] Edge cases handled
- [ ] Error handling appropriate

**Code Quality**
- [ ] Follows style guide
- [ ] No code duplication
- [ ] Functions are focused
- [ ] Names are descriptive

**Testing**
- [ ] Tests are meaningful
- [ ] Edge cases tested
- [ ] Mocks used appropriately

**Performance**
- [ ] No unnecessary rebuilds
- [ ] Efficient algorithms
- [ ] Memory leaks avoided

**Security**
- [ ] No hardcoded secrets
- [ ] Input validated
- [ ] Sensitive data protected

---

## Appendix: Analysis Options

```yaml
# analysis_options.yaml

include: package:flutter_lints/flutter.yaml

analyzer:
  language:
    strict-casts: true
    strict-raw-types: true
  errors:
    missing_required_param: error
    missing_return: error
    must_be_immutable: error
    avoid_web_libraries_in_flutter: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"

linter:
  rules:
    # Error rules
    avoid_print: true
    avoid_type_to_string: true
    cancel_subscriptions: true
    close_sinks: true
    literal_only_boolean_expressions: true
    throw_in_finally: true
    unnecessary_statements: true
    
    # Style rules
    always_declare_return_types: true
    avoid_bool_literals_in_conditional_expressions: true
    avoid_catches_without_on_clauses: true
    avoid_catching_errors: true
    avoid_double_and_int_checks: true
    avoid_field_initializers_in_const_classes: true
    avoid_implementing_value_types: true
    avoid_positional_boolean_parameters: true
    avoid_returning_this: true
    avoid_unused_constructor_parameters: true
    avoid_void_async: true
    cascade_invocations: true
    directives_ordering: true
    eol_at_end_of_file: true
    missing_whitespace_between_adjacent_strings: true
    no_runtimeType_toString: true
    noop_primitive_operations: true
    prefer_asserts_in_initializer_lists: true
    prefer_const_constructors: true
    prefer_const_declarations: true
    prefer_const_literals_to_create_immutables: true
    prefer_constructors_over_static_methods: true
    prefer_final_in_for_each: true
    prefer_final_locals: true
    prefer_if_elements_to_conditional_expressions: true
    prefer_int_literals: true
    prefer_null_aware_method_calls: true
    prefer_single_quotes: true
    require_trailing_commas: true
    sort_constructors_first: true
    sort_unnamed_constructors_first: true
    type_annotate_public_apis: true
    unawaited_futures: true
    unnecessary_await_in_return: true
    unnecessary_lambdas: true
    unnecessary_null_checks: true
    unnecessary_parenthesis: true
    unnecessary_raw_strings: true
    use_colored_box: true
    use_decorated_box: true
    use_enums: true
    use_if_null_to_convert_nulls_to_bools: true
    use_is_even_rather_than_modulo: true
    use_late_for_private_fields_and_variables: true
    use_named_constants: true
    use_raw_strings: true
    use_setters_to_change_properties: true
    use_string_buffers: true
    use_super_parameters: true
    use_to_and_as_if_applicable: true
```

---

**End of Coding Standards Document**

