# KIRO CLI - Complete Documentation

## Table of Contents

1. [Overview](#overview)
2. [Installation](#installation)
3. [Quick Start](#quick-start)
4. [Commands Reference](#commands-reference)
5. [Module Development](#module-development)
6. [Architecture](#architecture)
7. [CI/CD](#cicd)
8. [Best Practices](#best-practices)
9. [Troubleshooting](#troubleshooting)
10. [Phase Summary](#phase-summary)

---

## Overview

KIRO CLI is a production-ready Flutter application generator that enforces Clean Architecture and provides a modular, scalable foundation for Flutter apps.

### Key Features

- ✅ **Clean Architecture** - Enforced layer separation
- ✅ **Module System** - Add, remove, update modules seamlessly
- ✅ **Auto-Generated Routes** - Routes generated from module metadata
- ✅ **Provider Registry** - Centralized state management
- ✅ **Dependency Validation** - Prevents conflicts and circular dependencies
- ✅ **Version Management** - Module version compatibility checking
- ✅ **Architecture Validation** - Detects violations automatically
- ✅ **CI/CD Ready** - Auto-generated pipelines
- ✅ **Multi-Platform** - Web, Mobile, Desktop support
- ✅ **Sample Apps** - Pre-configured example applications

---

## Installation

### Prerequisites

- Flutter SDK 3.0.0 or higher
- Dart SDK 3.0.0 or higher
- Git (optional, for version control)

### Install CLI

```bash
# Install globally
dart pub global activate kiro_cli

# Verify installation
kiro --version
```

### Verify Environment

```bash
# Check your setup
kiro doctor
```

---

## Quick Start

### Create a New App

```bash
# Interactive mode (recommended)
kiro create app

# Non-interactive mode
kiro create app --name MyApp --modules auth,wallet,chat

# Sample app with pre-configured modules
kiro create app --name SampleApp --sample
```

### Add a Module

```bash
# Add authentication module
kiro add module auth

# Skip optional steps
kiro add module auth --skip-tests --skip-env
```

### Remove a Module

```bash
# Remove module
kiro remove module auth

# Force removal
kiro remove module auth --force
```

### Update a Module

```bash
# Update to latest version
kiro update module auth

# Force update
kiro update module auth --force
```

### Check Project Health

```bash
# Check environment
kiro doctor

# Check architecture
kiro doctor --architecture

# Check versions
kiro doctor --versions

# Check everything
kiro doctor --architecture --versions
```

---

## Commands Reference

### `kiro create app`

Create a new Flutter application with KIRO architecture.

**Options:**
- `--name, -n` - App name
- `--org, -o` - Organization identifier (default: com.example)
- `--output, -d` - Output directory (default: .)
- `--platforms, -p` - Target platforms (android, ios, web, macos, windows, linux)
- `--modules, -m` - Modules to include
- `--state, -s` - State management (riverpod, bloc, provider)
- `--color` - Primary color (hex)
- `--firebase` - Include Firebase setup
- `--git` - Initialize Git repository
- `--interactive, -i` - Interactive mode
- `--sample` - Generate sample app

**Examples:**
```bash
kiro create app
kiro create app --name MyApp --modules auth,wallet
kiro create app --sample
```

### `kiro add module <name>`

Add a module to existing project.

**Options:**
- `--project, -p` - Project path (default: .)
- `--skip-tests` - Skip test generation
- `--skip-env` - Skip environment config generation

**Examples:**
```bash
kiro add module auth
kiro add module wallet --skip-tests
```

### `kiro remove module <name>`

Remove a module from project.

**Options:**
- `--project, -p` - Project path (default: .)
- `--force, -f` - Force removal without confirmation

**Examples:**
```bash
kiro remove module auth
kiro remove module wallet --force
```

### `kiro update module <name>`

Update a module to latest version.

**Options:**
- `--project, -p` - Project path (default: .)
- `--force, -f` - Force update without confirmation

**Examples:**
```bash
kiro update module auth
kiro update module wallet --force
```

### `kiro doctor`

Check development environment and project health.

**Options:**
- `--project, -p` - Project path (default: .)
- `--architecture, -a` - Check Clean Architecture compliance
- `--versions, -v` - Check module versions

**Examples:**
```bash
kiro doctor
kiro doctor --architecture
kiro doctor --versions
kiro doctor --architecture --versions
```

---

## Module Development

### Module Structure

A KIRO module must follow Clean Architecture:

```
module_name/
├── lib/
│   ├── domain/
│   │   ├── entities/           # Domain entities
│   │   ├── repositories/      # Repository interfaces
│   │   └── usecases/          # Business logic
│   ├── data/
│   │   ├── models/            # Data models
│   │   ├── repositories/      # Repository implementations
│   │   └── datasources/       # Data sources
│   ├── presentation/
│   │   ├── screens/           # UI screens
│   │   ├── widgets/           # UI widgets
│   │   └── providers/         # State management
│   └── core/
│       └── errors/            # Error handling
├── module.yaml                 # Module metadata
└── pubspec.yaml
```

### Creating module.yaml

```yaml
name: auth
display_name: Authentication
description: User authentication module
version: 1.0.0

# Compatibility
kiro_core_version: ^0.1.0
kiro_cli_version: ^0.1.0

# Package dependencies
dependencies:
  - name: firebase_auth
    version: ^4.16.0
    optional: true

# Core dependencies
core_dependencies:
  - network
  - storage

# Routes
routes:
  - path: /login
    name: login
    screen: LoginScreen
    requires_auth: false

# Providers
providers:
  - name: AuthProvider
    path: providers/auth_provider.dart

# Configuration
config:
  enable_biometric:
    type: bool
    default: false
```

### Module Dependencies

- **Other modules**: List in `dependencies` (e.g., `- wallet`)
- **Core packages**: List in `core_dependencies` (e.g., `- network`)
- **External packages**: List in `dependencies` with `name` and `version`

**Rules:**
- No circular dependencies
- Dependencies must exist before module can be added
- Core dependencies are always available

---

## Architecture

### Clean Architecture Layers

1. **Presentation Layer**
   - Screens, widgets, providers
   - Can only depend on Domain layer
   - Handles UI and user interactions

2. **Domain Layer**
   - Entities, use cases, repository interfaces
   - Cannot depend on Data or Presentation
   - Contains business logic

3. **Data Layer**
   - Models, repository implementations, data sources
   - Can depend on Domain layer
   - Handles data operations

### Architecture Validation

The CLI automatically validates architecture:

```bash
kiro doctor --architecture
```

**Checks:**
- Layer structure (domain/, data/, presentation/)
- Import violations
- Cross-module dependencies
- Circular dependencies

---

## CI/CD

### Auto-Generated Files

When creating a new app, CI/CD files are automatically generated:

- **GitHub Actions**: `.github/workflows/ci.yml`
- **GitLab CI**: `.gitlab-ci.yml`
- **Analysis Options**: `analysis_options.yaml`

### GitHub Actions

```yaml
name: CI

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main, develop ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - run: flutter build apk --release
```

### GitLab CI

```yaml
image: cirrusci/flutter:stable

stages:
  - test
  - build

test:
  stage: test
  script:
    - flutter pub get
    - flutter analyze
    - flutter test
```

---

## Best Practices

### 1. Module Design

- Keep modules independent
- Minimize inter-module dependencies
- Follow Clean Architecture strictly
- Version your modules
- Document your module

### 2. Dependency Management

- Minimize dependencies
- Use core packages when possible
- Use version constraints (^)
- Check compatibility before adding

### 3. Testing

- Write tests for each layer
- Use generated test skeletons
- Mock dependencies
- Test business logic in domain layer

### 4. Environment Configuration

- Use .env files
- Never commit secrets
- Multiple environments (dev, staging, prod)
- Type-safe access via EnvConfig

### 5. Route Management

- Use route constants (AppRoutes.login)
- Handle authentication requirements
- Use nested routes for complex navigation

### 6. Provider Registration

- Central registry in lib/core/providers.dart
- Override for tests
- Lazy loading when possible

---

## Troubleshooting

### Common Errors

#### "Module directory not found"
**Solution:** Ensure you're in a KIRO workspace with `modules/` directory.

#### "Dependency not satisfied"
**Solution:** Add required modules first:
```bash
kiro add module <required_module>
kiro add module <your_module>
```

#### "Circular dependency detected"
**Solution:** Refactor to remove circular dependency or extract shared code.

#### "Architecture violation"
**Solution:** Fix import violations:
- Presentation should only import from Domain
- Domain should not import from Data or Presentation
- Data can import from Domain

#### "Version incompatible"
**Solution:** Update modules or kiro_core:
```bash
kiro update module <name>
```

### Debug Mode

Enable verbose logging:
```bash
kiro add module auth --verbose
```

---

## Phase Summary

### Phase 1: Stabilization & CLI Polishing ✅

**Completed:**
- Module lifecycle commands (add, remove, update)
- Comprehensive documentation
- Enhanced logging and validation
- Error handling improvements

**Deliverables:**
- Remove module command
- Update module command
- Complete developer guide
- Troubleshooting documentation

### Phase 2: Template Engine & Quality Automation ✅

**Completed:**
- Architecture validation
- Version management
- Enhanced doctor command
- CI/CD pipeline templates
- Analysis options

**Deliverables:**
- Architecture validator
- Version manager
- CI/CD templates (GitHub Actions, GitLab CI)
- Enhanced doctor with validation

### Phase 3: Enterprise Features & Ecosystem Expansion ✅

**Completed:**
- Sample app generator
- Module registry foundation
- Cross-platform templates
- Platform detection utilities

**Deliverables:**
- Sample app generator
- Module registry structure
- Cross-platform support
- Platform-specific configurations

---

## Available Modules

- **auth** - Authentication (login, signup, OTP)
- **wallet** - Digital wallet with transactions
- **chat** - Real-time messaging
- **booking** - Appointment booking system
- **payments** - Payment processing
- **notifications** - Push notifications
- **tracking** - Location tracking
- **profile** - User profile management

---

## Generated Project Structure

```
my_app/
├── lib/
│   ├── config/
│   │   ├── router.dart          # Auto-generated routes
│   │   ├── app_config.dart
│   │   ├── theme.dart
│   │   └── env_config.dart      # Environment loader
│   ├── core/
│   │   ├── providers.dart        # Provider registry
│   │   ├── config/              # Platform configs
│   │   └── utils/               # Platform detector
│   ├── modules/                 # Module files
│   │   ├── auth/
│   │   ├── wallet/
│   │   └── chat/
│   └── main.dart
├── test/
│   └── modules/                 # Test skeletons
├── .github/
│   └── workflows/
│       └── ci.yml               # GitHub Actions
├── .gitlab-ci.yml               # GitLab CI
├── analysis_options.yaml        # Linting rules
├── .env.dev                     # Environment configs
├── .env.staging
├── .env.prod
└── pubspec.yaml
```

---

## Resources

- **KIRO CLI Guide**: `KIRO_CLI_GUIDE.md`
- **Automation Pipeline**: `CLI_AUTOMATION_PIPELINE.md`
- **Phase 1 Summary**: `PHASE_1_COMPLETE.md`
- **Phase 2 Progress**: `PHASE_2_PROGRESS.md`
- **Flutter Docs**: https://flutter.dev/docs
- **Riverpod Docs**: https://riverpod.dev

---

## Support

For issues and questions:
- Check documentation files
- Review troubleshooting section
- Enable verbose mode for debugging
- Check architecture with `kiro doctor --architecture`

---

## Summary

KIRO CLI is now a **complete, production-ready** Flutter application generator with:

✅ **Full Module Lifecycle** - Add, remove, update modules  
✅ **Architecture Enforcement** - Clean Architecture validation  
✅ **Version Management** - Compatibility checking  
✅ **CI/CD Integration** - Auto-generated pipelines  
✅ **Multi-Platform Support** - Web, Mobile, Desktop  
✅ **Sample Apps** - Pre-configured examples  
✅ **Comprehensive Documentation** - Complete guides  

**Ready for enterprise use!** 🚀

---

*Last Updated: Phase 3 Complete*


