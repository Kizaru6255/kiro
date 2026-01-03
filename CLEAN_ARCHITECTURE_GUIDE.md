# Clean Architecture Implementation Guide

## Overview

All Kiro modules now follow **Clean Architecture** with strict layer separation:

```
modules/{module_name}/lib/
├── {module_name}.dart          # Public API (barrel file)
│
├── data/                        # Data Layer
│   ├── datasources/            # API & local storage
│   ├── models/                 # DTOs (data transfer objects)
│   └── repositories/           # Repository implementations
│
├── domain/                      # Domain Layer (Pure Dart)
│   ├── entities/               # Business entities
│   ├── repositories/           # Repository interfaces
│   └── usecases/               # Business logic
│
├── presentation/                # Presentation Layer
│   ├── providers/              # Riverpod providers
│   ├── models/                 # UI state models
│   ├── screens/                # UI screens
│   └── widgets/                # Reusable widgets
│
└── core/                        # Module-specific core
    └── errors/                  # Error re-exports
```

## Dependency Rules

### ✅ Allowed Dependencies

| Layer | Can Depend On |
|-------|---------------|
| **presentation** | `domain`, `kiro_core` |
| **domain** | `nothing` (pure Dart) |
| **data** | `domain`, `kiro_core` |
| **core** | `kiro_core` |

### ❌ Forbidden Dependencies

- ❌ `presentation` → `data` (UI must never call data layer directly)
- ❌ `domain` → `data` or `presentation` (domain is pure)
- ❌ `data` → `presentation` (data doesn't know about UI)
- ❌ Feature → Feature (modules are independent)

## Layer Responsibilities

### Domain Layer

**Pure Dart classes** - no external dependencies.

- **Entities**: Business objects (e.g., `UserEntity`)
- **Repositories**: Interfaces defining contracts
- **Use Cases**: Business logic and validation

```dart
// domain/entities/user_entity.dart
class UserEntity {
  final String id;
  final String email;
  // Pure Dart - no Freezed, no JSON
}

// domain/repositories/auth_repository.dart
abstract class AuthRepository {
  Future<Result<UserEntity>> loginWithEmail({...});
}

// domain/usecases/login_usecase.dart
class LoginUseCase {
  final AuthRepository _repository;
  
  Future<Result<UserEntity>> call({...}) {
    // Domain validation
    // Delegate to repository
  }
}
```

### Data Layer

**Handles external data sources** (API, local storage).

- **Data Sources**: API calls, local storage
- **DTOs**: Data transfer objects (Freezed models)
- **Repository Implementations**: Implement domain interfaces

```dart
// data/models/user_dto.dart
@freezed
class UserDto {
  // JSON serializable
  factory UserDto.fromJson(...);
  
  // Convert to entity
  UserEntity toEntity();
}

// data/datasources/auth_remote_datasource.dart
class AuthRemoteDataSourceImpl {
  Future<ApiResponse<Map<String, dynamic>>> loginWithEmail(...);
}

// data/repositories/auth_repository_impl.dart
class AuthRepositoryImpl implements AuthRepository {
  // Implements domain interface
  // Converts DTOs to Entities
}
```

### Presentation Layer

**UI and state management** (Riverpod).

- **Providers**: Riverpod providers (DI container)
- **State Models**: UI state (Freezed)
- **Screens**: UI pages
- **Widgets**: Reusable UI components

```dart
// presentation/providers/auth_provider.dart
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(...);
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.watch(authRepositoryProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(
    loginUseCase: ref.watch(loginUseCaseProvider),
  );
});

// presentation/screens/login_screen.dart
class LoginScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final authNotifier = ref.read(authProvider.notifier);
    
    // UI code
  }
}
```

## Migration Checklist

For existing modules:

- [ ] Create `domain/entities/` - move models to entities (remove Freezed)
- [ ] Create `domain/repositories/` - extract repository interfaces
- [ ] Create `domain/usecases/` - extract business logic
- [ ] Create `data/models/` - create DTOs (Freezed models)
- [ ] Create `data/datasources/` - split services into remote/local
- [ ] Create `data/repositories/` - implement domain interfaces
- [ ] Move `providers/` → `presentation/providers/`
- [ ] Move `screens/` → `presentation/screens/`
- [ ] Move `widgets/` → `presentation/widgets/`
- [ ] Update `{module}.dart` barrel file to export only public APIs
- [ ] Update imports throughout module

## Example: Auth Module

The auth module has been restructured as a reference implementation:

- ✅ Domain entities (`UserEntity`)
- ✅ Repository interface (`AuthRepository`)
- ✅ Use cases (`LoginUseCase`, `SignUpUseCase`)
- ✅ Data DTOs (`UserDto`)
- ✅ Data sources (remote & local)
- ✅ Repository implementation
- ✅ Presentation providers
- ✅ Presentation screens/widgets

See `modules/auth/lib/` for the complete structure.

## Benefits

1. **Testability**: Domain layer is pure Dart - easy to test
2. **Independence**: Domain doesn't depend on frameworks
3. **Flexibility**: Can swap data sources without changing domain
4. **Clarity**: Clear separation of concerns
5. **Scalability**: Easy to add new features

## Next Steps

1. Migrate remaining modules to Clean Architecture
2. Update CLI templates to generate Clean Architecture structure
3. Add lint rules to enforce dependency rules
4. Update documentation


