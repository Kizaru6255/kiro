# KIRO CLI - Complete Developer Guide

## Table of Contents

1. [Getting Started](#getting-started)
2. [Creating a New App](#creating-a-new-app)
3. [Module Lifecycle](#module-lifecycle)
4. [Module Development](#module-development)
5. [Troubleshooting](#troubleshooting)
6. [Best Practices](#best-practices)

---

## Getting Started

### Installation

```bash
# Install KIRO CLI globally
dart pub global activate kiro_cli

# Verify installation
kiro --version
```

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Git (optional, for version control)

### Quick Start

```bash
# Create a new app
kiro create app

# Add a module
kiro add module auth

# Check your environment
kiro doctor
```

---

## Creating a New App

### Interactive Mode

```bash
kiro create app
```

This will prompt you for:
- App name
- Organization identifier
- Target platforms (Android, iOS, Web, etc.)
- Modules to include
- State management (Riverpod)
- Primary color
- Firebase setup
- Git initialization

### Non-Interactive Mode

```bash
kiro create app \
  --name MyAwesomeApp \
  --org com.example \
  --modules auth,wallet,chat \
  --platforms android,ios,web \
  --color #6366F1 \
  --firebase
```

### Generated Structure

```
my_app/
├── lib/
│   ├── config/
│   │   ├── router.dart          # Auto-generated routes
│   │   ├── app_config.dart
│   │   └── theme.dart
│   ├── core/
│   │   ├── providers.dart       # Auto-generated provider registry
│   │   └── ...
│   ├── modules/                 # Module files
│   │   ├── auth/
│   │   ├── wallet/
│   │   └── chat/
│   └── main.dart
├── test/
│   └── modules/                 # Test skeletons
├── .env.dev                     # Environment configs
├── .env.staging
├── .env.prod
└── pubspec.yaml
```

---

## Module Lifecycle

### Adding a Module

```bash
# Add a module to existing project
kiro add module auth

# Skip test generation
kiro add module auth --skip-tests

# Skip environment config generation
kiro add module auth --skip-env

# Specify project path
kiro add module auth --project /path/to/project
```

**What happens:**
1. Validates module structure
2. Checks dependencies
3. Copies module files to `lib/modules/<name>/`
4. Updates routes in `lib/config/router.dart`
5. Registers providers in `lib/core/providers.dart`
6. Updates `pubspec.yaml` with dependencies
7. Generates test skeletons (optional)
8. Generates environment configs (optional)
9. Runs `flutter pub get`

### Removing a Module

```bash
# Remove a module
kiro remove module auth

# Force removal without confirmation
kiro remove module auth --force
```

**What happens:**
1. Checks if module exists
2. Validates no other modules depend on it
3. Removes module files from `lib/modules/<name>/`
4. Updates routes (removes module routes)
5. Updates providers (removes module providers)
6. Removes test files
7. Runs `flutter pub get`

**Note:** You may need to manually remove unused dependencies from `pubspec.yaml`.

### Updating a Module

```bash
# Update a module to latest version
kiro update module auth

# Force update without confirmation
kiro update module auth --force
```

**What happens:**
1. Checks if module exists in project
2. Loads new module metadata from source
3. Backs up custom files (if any)
4. Removes old module files
5. Injects updated module files
6. Restores custom files
7. Updates routes and providers
8. Updates `pubspec.yaml` dependencies
9. Runs `flutter pub get`

**Note:** Custom modifications to module files will be lost. Consider forking the module if you need customizations.

---

## Module Development

### Module Structure

A KIRO module must follow Clean Architecture:

```
module_name/
├── lib/
│   ├── domain/
│   │   ├── entities/           # Domain entities
│   │   ├── repositories/        # Repository interfaces
│   │   └── usecases/           # Business logic
│   ├── data/
│   │   ├── models/             # Data models
│   │   ├── repositories/       # Repository implementations
│   │   └── datasources/        # Data sources (API, local)
│   ├── presentation/
│   │   ├── screens/            # UI screens
│   │   ├── widgets/            # UI widgets
│   │   └── providers/         # State management
│   └── core/
│       └── errors/             # Error handling
├── module.yaml                  # Module metadata
└── pubspec.yaml
```

### Creating module.yaml

```yaml
# Module Configuration
name: auth
display_name: Authentication
description: User authentication with email, phone, and social login
version: 1.0.0

# Compatibility
kiro_core_version: ^0.1.0
kiro_cli_version: ^0.1.0

# Package dependencies (added to pubspec.yaml)
dependencies:
  - name: firebase_auth
    version: ^4.16.0
    optional: true
  - name: google_sign_in
    version: ^6.2.1
    optional: true

# Core dependencies (from kiro_core)
core_dependencies:
  - network
  - storage
  - permissions

# Routes (auto-generated into router.dart)
routes:
  - path: /login
    name: login
    screen: LoginScreen
    requires_auth: false
  - path: /signup
    name: signup
    screen: SignupScreen
    requires_auth: false

# Providers (Riverpod providers to register)
providers:
  - name: AuthProvider
    path: providers/auth_provider.dart
  - name: AuthState
    path: providers/auth_provider.dart

# Configuration options
config:
  enable_biometric:
    type: bool
    default: false
    description: Enable biometric authentication
  enable_social_login:
    type: bool
    default: true
    description: Enable Google/Apple sign-in
```

### Module Dependencies

Modules can depend on:
- **Other modules**: List in `dependencies` (e.g., `- wallet`)
- **Core packages**: List in `core_dependencies` (e.g., `- network`)
- **External packages**: List in `dependencies` with `name` and `version`

**Rules:**
- No circular dependencies
- Dependencies must exist before module can be added
- Core dependencies are always available

---

## Troubleshooting

### Common Errors

#### 1. "Module directory not found"

**Problem:** CLI cannot find the `modules/` directory.

**Solution:**
- Ensure you're running from a KIRO workspace
- Check that `modules/` directory exists at the root
- Use `--project` flag to specify project path

#### 2. "Dependency not satisfied"

**Problem:** Module requires another module that isn't installed.

**Solution:**
```bash
# Add the required module first
kiro add module <required_module>
# Then add your module
kiro add module <your_module>
```

#### 3. "Circular dependency detected"

**Problem:** Two modules depend on each other.

**Solution:**
- Refactor to remove circular dependency
- Extract shared code to a common module
- Use dependency injection instead

#### 4. "Module structure invalid"

**Problem:** Module doesn't follow Clean Architecture.

**Solution:**
- Ensure `domain/`, `data/`, `presentation/` directories exist
- Check that `module.yaml` is valid YAML
- Verify all required files are present

#### 5. "Routes not generated"

**Problem:** Routes file is missing or outdated.

**Solution:**
```bash
# Re-add the module to regenerate routes
kiro remove module <name>
kiro add module <name>
```

### Debug Mode

Enable verbose logging:

```bash
kiro add module auth --verbose
```

This will show:
- Detailed error messages
- Stack traces
- File operations
- Dependency resolution steps

---

## Best Practices

### 1. Module Design

- **Keep modules independent**: Minimize inter-module dependencies
- **Follow Clean Architecture**: Strict layer separation
- **Version your modules**: Use semantic versioning
- **Document your module**: Include README.md

### 2. Dependency Management

- **Minimize dependencies**: Only depend on what you need
- **Use core packages**: Prefer `kiro_core` packages over external ones
- **Version constraints**: Use caret (^) for flexibility

### 3. Testing

- **Write tests**: Use generated test skeletons
- **Test each layer**: Domain, data, presentation
- **Mock dependencies**: Use dependency injection

### 4. Environment Configuration

- **Use .env files**: Never commit secrets
- **Multiple environments**: Dev, staging, production
- **Type-safe access**: Use `EnvConfig` class

### 5. Route Management

- **Use route constants**: `AppRoutes.login` instead of strings
- **Handle auth**: Set `requires_auth: true` for protected routes
- **Nested routes**: Use GoRouter's nested routing

### 6. Provider Registration

- **Central registry**: All providers in `lib/core/providers.dart`
- **Override for tests**: Use `getProviderOverrides()`
- **Lazy loading**: Register providers only when needed

---

## Advanced Usage

### Custom Module Paths

If your modules are in a different location:

```bash
# Set KIRO_MODULES_PATH environment variable
export KIRO_MODULES_PATH=/path/to/modules
kiro add module auth
```

### CI/CD Integration

```yaml
# .github/workflows/ci.yml
- name: Add modules
  run: |
    kiro add module auth
    kiro add module wallet
    flutter pub get
    flutter test
```

### Scripting

```bash
#!/bin/bash
# setup_app.sh

kiro create app --name MyApp --modules auth,wallet,chat
cd my_app
kiro add module payments
flutter pub get
flutter analyze
```

---

## Command Reference

### Global Flags

- `--version, -v`: Print version information
- `--verbose`: Enable verbose output
- `--help, -h`: Show help for a command

### Commands

| Command | Description |
|---------|-------------|
| `kiro create app` | Create a new KIRO app |
| `kiro add module <name>` | Add a module to project |
| `kiro remove module <name>` | Remove a module from project |
| `kiro update module <name>` | Update a module to latest version |
| `kiro doctor` | Check development environment |

### Available Modules

- `auth` - Authentication
- `wallet` - Digital wallet
- `chat` - Messaging
- `booking` - Appointment booking
- `payments` - Payment processing
- `notifications` - Push notifications
- `tracking` - Location tracking
- `profile` - User profile

---

## Support

- **Documentation**: See `CLI_AUTOMATION_PIPELINE.md`
- **Issues**: Report on GitHub
- **Examples**: Check `examples/` directory

---

## Next Steps

1. **Create your first app**: `kiro create app`
2. **Add modules**: `kiro add module auth`
3. **Customize**: Modify generated code as needed
4. **Test**: Use generated test skeletons
5. **Deploy**: Build and deploy your app

Happy coding with KIRO! 🚀


