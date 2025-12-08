# Kiro — System Architecture Documentation

> **Version:** 1.0.0  
> **Author:** Chaitanya Mhetre  
> **Last Updated:** December 2024  
> **Status:** Active Development

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [System Overview](#2-system-overview)
3. [Core Components](#3-core-components)
4. [Data Flow Architecture](#4-data-flow-architecture)
5. [Package Dependencies](#5-package-dependencies)
6. [Security Architecture](#6-security-architecture)
7. [Error Handling Strategy](#7-error-handling-strategy)
8. [Scalability Considerations](#8-scalability-considerations)

---

## 1. Executive Summary

### What is Kiro?

Kiro is a **modular Flutter application generator framework** that enables rapid creation of production-ready mobile applications. It follows a three-tier architecture:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              KIRO ECOSYSTEM                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌───────────────┐    ┌───────────────┐    ┌───────────────────────────┐   │
│   │   kiro_core   │    │   kiro_cli    │    │   templates/ + modules/   │   │
│   │               │    │               │    │                           │   │
│   │  • Network    │    │  • Commands   │    │  • flutter_app template   │   │
│   │  • Storage    │    │  • Generator  │    │  • auth module            │   │
│   │  • Themes     │    │  • Injector   │    │  • wallet module          │   │
│   │  • Utils      │    │  • Config     │    │  • chat module            │   │
│   │  • Platform   │    │  • Validator  │    │  • payments module        │   │
│   └───────────────┘    └───────────────┘    └───────────────────────────┘   │
│          ▲                    │                          │                   │
│          │                    │                          │                   │
│          └────────────────────┴──────────────────────────┘                   │
│                              │                                               │
│                              ▼                                               │
│                    ┌─────────────────────┐                                   │
│                    │   Generated App     │                                   │
│                    │   (output/my_app)   │                                   │
│                    └─────────────────────┘                                   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Design Principles

1. **Separation of Concerns**: Core logic is isolated from UI customization
2. **Modularity**: Features are plug-and-play modules
3. **Immutability**: Core package is read-only for generated apps
4. **Extensibility**: New modules can be added without system changes
5. **Production-Ready**: All generated code follows best practices

---

## 2. System Overview

### 2.1 Component Hierarchy

```
kiro/
│
├── kiro_core/              # TIER 1: Foundation Layer
│   └── lib/
│       ├── core/           # Core infrastructure
│       └── kiro_core.dart  # Public API exports
│
├── kiro_cli/               # TIER 2: Generator Layer
│   ├── bin/                # CLI entry points
│   └── lib/
│       └── cli/            # CLI implementation
│
├── templates/              # TIER 3: Template Layer
│   └── flutter_app/        # Base Flutter template
│
├── modules/                # TIER 3: Module Layer
│   ├── auth/
│   ├── wallet/
│   ├── chat/
│   └── ...
│
└── docs/                   # Documentation
```

### 2.2 Tier Descriptions

#### Tier 1: Foundation Layer (`kiro_core`)

- **Purpose**: Provides all core business logic and infrastructure
- **Visibility**: Private/Protected — users cannot modify
- **Contents**:
  - Network layer (HTTP client, interceptors, API handling)
  - Storage layer (SharedPreferences, SecureStorage, caching)
  - Permission management (runtime permissions)
  - Platform services (camera, GPS, connectivity)
  - Theme management (dynamic theming)
  - Localization engine (i18n support)
  - Error handling (exceptions, recovery)
  - Logging system (debug, analytics)
  - Utilities (validators, formatters, helpers)

#### Tier 2: Generator Layer (`kiro_cli`)

- **Purpose**: Orchestrates app generation process
- **Visibility**: Internal tool — not included in generated apps
- **Contents**:
  - Command handlers (create, add, doctor, help)
  - Template processor (placeholder replacement)
  - Module injector (feature integration)
  - Configuration manager (user preferences)
  - Validation engine (input verification)
  - File system operations (copy, modify, generate)

#### Tier 3: Asset Layer (`templates/` + `modules/`)

- **Purpose**: Provides raw materials for app generation
- **Visibility**: Source files — processed during generation
- **Contents**:
  - Base Flutter app template with placeholders
  - Individual feature modules (auth, wallet, etc.)
  - Platform-specific configurations

---

## 3. Core Components

### 3.1 kiro_core Internal Architecture

```
kiro_core/lib/
│
├── core/
│   │
│   ├── network/
│   │   ├── dio_client.dart           # Singleton HTTP client
│   │   ├── api_service.dart          # REST API abstraction
│   │   ├── api_endpoints.dart        # Centralized endpoints
│   │   ├── api_response.dart         # Response wrapper model
│   │   └── interceptors/
│   │       ├── auth_interceptor.dart       # Token injection
│   │       ├── logging_interceptor.dart    # Request/Response logging
│   │       ├── error_interceptor.dart      # Error transformation
│   │       ├── retry_interceptor.dart      # Automatic retry logic
│   │       └── cache_interceptor.dart      # Response caching
│   │
│   ├── storage/
│   │   ├── storage_service.dart      # Abstract storage interface
│   │   ├── pref_storage.dart         # SharedPreferences implementation
│   │   ├── secure_storage.dart       # FlutterSecureStorage implementation
│   │   ├── cache_manager.dart        # In-memory + disk caching
│   │   └── storage_keys.dart         # Centralized key constants
│   │
│   ├── permissions/
│   │   ├── permission_manager.dart   # Permission request orchestrator
│   │   ├── permission_status.dart    # Status enum and helpers
│   │   └── permission_rationale.dart # User-facing permission explanations
│   │
│   ├── platform/
│   │   ├── device_info.dart          # Device information service
│   │   ├── connectivity_manager.dart # Network connectivity monitoring
│   │   ├── app_lifecycle.dart        # App state management
│   │   └── platform_channel.dart     # Native bridge utilities
│   │
│   ├── theme/
│   │   ├── theme_manager.dart        # Dynamic theme controller
│   │   ├── app_colors.dart           # Color palette definitions
│   │   ├── app_typography.dart       # Text style definitions
│   │   ├── app_dimensions.dart       # Spacing and sizing
│   │   └── theme_extensions.dart     # Custom theme extensions
│   │
│   ├── localization/
│   │   ├── locale_manager.dart       # Locale switching controller
│   │   ├── translation_loader.dart   # JSON/ARB file loader
│   │   └── localization_delegate.dart # Flutter localization delegate
│   │
│   ├── routing/
│   │   ├── app_router.dart           # Route definitions
│   │   ├── route_guard.dart          # Navigation guards
│   │   └── deep_link_handler.dart    # Deep link processing
│   │
│   ├── errors/
│   │   ├── app_exception.dart        # Base exception classes
│   │   ├── error_handler.dart        # Global error handling
│   │   ├── error_codes.dart          # Standardized error codes
│   │   └── failure.dart              # Functional error representation
│   │
│   ├── logger/
│   │   ├── kiro_logger.dart          # Main logger interface
│   │   ├── log_level.dart            # Log level enum
│   │   ├── console_printer.dart      # Debug console output
│   │   └── file_logger.dart          # Persistent log storage
│   │
│   └── utils/
│       ├── validators.dart           # Input validation utilities
│       ├── formatters.dart           # Data formatting utilities
│       ├── date_time_utils.dart      # DateTime helpers
│       ├── string_extensions.dart    # String extension methods
│       ├── collection_extensions.dart # List/Map extensions
│       └── debouncer.dart            # Debounce/Throttle utilities
│
└── kiro_core.dart                    # Public API barrel file
```

### 3.2 kiro_cli Internal Architecture

```
kiro_cli/
│
├── bin/
│   └── kiro.dart                     # CLI entry point
│
└── lib/
    │
    ├── cli/
    │   │
    │   ├── commands/
    │   │   ├── command_runner.dart   # Command dispatcher
    │   │   ├── base_command.dart     # Abstract command class
    │   │   ├── create_app_command.dart    # 'kiro create app'
    │   │   ├── add_module_command.dart    # 'kiro add module <name>'
    │   │   ├── doctor_command.dart        # 'kiro doctor'
    │   │   ├── upgrade_command.dart       # 'kiro upgrade'
    │   │   └── help_command.dart          # 'kiro help'
    │   │
    │   ├── generator/
    │   │   ├── project_generator.dart     # Main generation orchestrator
    │   │   ├── template_processor.dart    # Placeholder replacement
    │   │   ├── module_injector.dart       # Module integration
    │   │   ├── pubspec_modifier.dart      # Dependency management
    │   │   └── permission_injector.dart   # Platform permission setup
    │   │
    │   ├── config/
    │   │   ├── app_config.dart       # Configuration model
    │   │   ├── config_loader.dart    # JSON config reader
    │   │   ├── config_validator.dart # Configuration validation
    │   │   └── defaults.dart         # Default configuration values
    │   │
    │   ├── prompts/
    │   │   ├── prompt_runner.dart    # Interactive prompt handler
    │   │   ├── app_name_prompt.dart
    │   │   ├── category_prompt.dart
    │   │   ├── theme_prompt.dart
    │   │   ├── modules_prompt.dart
    │   │   ├── permissions_prompt.dart
    │   │   └── localization_prompt.dart
    │   │
    │   ├── placeholders/
    │   │   ├── placeholder_registry.dart  # All placeholder definitions
    │   │   ├── placeholder_replacer.dart  # Replacement engine
    │   │   └── placeholder_validator.dart # Validation logic
    │   │
    │   ├── utils/
    │   │   ├── file_utils.dart       # File system operations
    │   │   ├── string_utils.dart     # String manipulation
    │   │   ├── console_utils.dart    # Terminal output helpers
    │   │   └── progress_indicator.dart # Progress bar/spinner
    │   │
    │   └── exceptions/
    │       ├── cli_exception.dart    # CLI-specific exceptions
    │       └── validation_exception.dart
    │
    └── kiro_cli.dart                 # Library entry point
```

### 3.3 Template Structure

```
templates/flutter_app/
│
├── lib/
│   ├── main.dart                     # Entry point with placeholders
│   │
│   ├── app/
│   │   ├── app.dart                  # MaterialApp configuration
│   │   ├── app_bindings.dart         # Dependency injection setup
│   │   └── app_config.dart           # Runtime configuration
│   │
│   ├── config/
│   │   ├── __APP_NAME___config.dart  # App-specific configuration
│   │   ├── environment.dart          # Environment variables
│   │   └── constants.dart            # App constants
│   │
│   ├── theme/
│   │   ├── app_theme.dart            # Theme data
│   │   ├── colors.dart               # Color constants
│   │   └── typography.dart           # Text styles
│   │
│   ├── localization/
│   │   ├── l10n/                     # ARB files
│   │   └── localization.dart         # Localization setup
│   │
│   ├── routing/
│   │   ├── routes.dart               # Route definitions
│   │   └── route_observer.dart       # Navigation observer
│   │
│   ├── features/                     # Module injection point
│   │   └── .gitkeep
│   │
│   ├── shared/
│   │   ├── widgets/                  # Reusable widgets
│   │   ├── extensions/               # Extension methods
│   │   └── mixins/                   # Reusable mixins
│   │
│   └── screens/
│       ├── splash/                   # Splash screen
│       └── home/                     # Home screen
│
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml       # Permissions placeholders
│
├── ios/
│   └── Runner/
│       └── Info.plist                # iOS permissions
│
├── web/
│   └── index.html
│
├── pubspec.yaml                      # Dependencies with placeholders
├── analysis_options.yaml
└── README.md
```

---

## 4. Data Flow Architecture

### 4.1 App Generation Flow

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        APP GENERATION PIPELINE                               │
└─────────────────────────────────────────────────────────────────────────────┘

    ┌──────────┐
    │  START   │
    └────┬─────┘
         │
         ▼
┌─────────────────────┐
│ 1. USER INPUT PHASE │
├─────────────────────┤
│ • App name          │
│ • Category          │
│ • Theme/Colors      │
│ • Permissions       │
│ • Languages         │
│ • Modules           │
│ • State Management  │
│ • Auth Type         │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 2. VALIDATION PHASE │
├─────────────────────┤
│ • Validate app name │
│ • Check conflicts   │
│ • Verify modules    │
│ • Validate colors   │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 3. CONFIG CREATION  │
├─────────────────────┤
│ Generate config.json│
│ with all settings   │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 4. TEMPLATE COPY    │
├─────────────────────┤
│ Clone flutter_app   │
│ to output directory │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 5. PLACEHOLDER      │
│    REPLACEMENT      │
├─────────────────────┤
│ __APP_NAME__        │
│ __PRIMARY_COLOR__   │
│ __PACKAGE_NAME__    │
│ __LANGUAGES__       │
│ ...etc              │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 6. MODULE INJECTION │
├─────────────────────┤
│ Copy selected       │
│ modules to          │
│ features/ folder    │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 7. PERMISSION SETUP │
├─────────────────────┤
│ Update Manifest.xml │
│ Update Info.plist   │
│ Add rationale       │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 8. PUBSPEC UPDATE   │
├─────────────────────┤
│ Add required deps   │
│ Configure assets    │
│ Set version info    │
└─────────┬───────────┘
          │
          ▼
┌─────────────────────┐
│ 9. POST-PROCESSING  │
├─────────────────────┤
│ Generate routes     │
│ Update imports      │
│ Clean up temp files │
└─────────┬───────────┘
          │
          ▼
    ┌──────────┐
    │   DONE   │
    │          │
    │ output/  │
    │ my_app/  │
    └──────────┘
```

### 4.2 Runtime Data Flow (Generated App)

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        RUNTIME DATA FLOW                                     │
└─────────────────────────────────────────────────────────────────────────────┘

┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│     UI      │────▶│   Provider  │────▶│   Service   │────▶│    Core     │
│   (Screen)  │     │  (Riverpod) │     │   (Module)  │     │ (kiro_core) │
└─────────────┘     └─────────────┘     └─────────────┘     └──────┬──────┘
       ▲                                                           │
       │                                                           ▼
       │                                              ┌─────────────────────┐
       │                                              │   External APIs     │
       │                                              │   Local Storage     │
       │                                              │   Platform Services │
       │                                              └──────────┬──────────┘
       │                                                         │
       └─────────────────────────────────────────────────────────┘
                              (Response Flow)
```

---

## 5. Package Dependencies

### 5.1 kiro_core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| dio | ^5.4.0 | HTTP client |
| flutter_secure_storage | ^9.0.0 | Secure key-value storage |
| shared_preferences | ^2.2.0 | Simple key-value storage |
| permission_handler | ^11.0.0 | Runtime permissions |
| connectivity_plus | ^5.0.0 | Network connectivity |
| device_info_plus | ^9.0.0 | Device information |
| path_provider | ^2.1.0 | File system paths |
| logger | ^2.0.0 | Logging framework |
| equatable | ^2.0.5 | Value equality |
| freezed | ^2.4.0 | Immutable models (dev) |
| json_serializable | ^6.7.0 | JSON serialization (dev) |

### 5.2 kiro_cli Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| args | ^2.4.0 | Command-line argument parsing |
| dcli | ^3.0.0 | CLI utilities and prompts |
| mason | ^0.1.0 | Template processing |
| path | ^1.9.0 | Path manipulation |
| yaml | ^3.1.0 | YAML parsing |
| json_annotation | ^4.8.0 | JSON handling |
| archive | ^3.4.0 | File compression |
| ansi_styles | ^0.3.2 | Terminal styling |

### 5.3 Template Dependencies (Dynamic)

These are added based on user selection:

| Package | Condition | Purpose |
|---------|-----------|---------|
| flutter_riverpod | Always | State management |
| go_router | Always | Navigation |
| google_fonts | Optional | Custom typography |
| firebase_core | If Firebase modules | Firebase base |
| firebase_messaging | If Notifications | Push notifications |
| google_maps_flutter | If Location module | Maps integration |
| razorpay_flutter | If Razorpay selected | Payment processing |
| stripe_flutter | If Stripe selected | Payment processing |

---

## 6. Security Architecture

### 6.1 Storage Security

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                          STORAGE SECURITY LAYERS                             │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                    SECURE STORAGE (Encrypted)                        │   │
│   │   • Auth tokens          • API keys                                  │   │
│   │   • User credentials     • Encryption keys                           │   │
│   │   • Sensitive PII        • Payment tokens                            │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                  PREFERENCE STORAGE (Unencrypted)                    │   │
│   │   • User settings        • Theme preference                          │   │
│   │   • Language choice      • Onboarding status                         │   │
│   │   • Feature flags        • Non-sensitive cache                       │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
│   ┌─────────────────────────────────────────────────────────────────────┐   │
│   │                    CACHE STORAGE (Temporary)                         │   │
│   │   • API responses        • Image cache                               │   │
│   │   • Computed data        • Session data                              │   │
│   └─────────────────────────────────────────────────────────────────────┘   │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### 6.2 Network Security

- **HTTPS Only**: All API calls enforce TLS
- **Certificate Pinning**: Optional SSL pinning support
- **Token Refresh**: Automatic token refresh mechanism
- **Request Signing**: Optional request signature verification
- **Rate Limiting**: Client-side rate limit handling

### 6.3 Code Protection

- **Core Package Isolation**: Business logic in separate package
- **Obfuscation Ready**: Build configuration for code obfuscation
- **No Hardcoded Secrets**: Environment-based configuration

---

## 7. Error Handling Strategy

### 7.1 Exception Hierarchy

```
AppException (Base)
├── NetworkException
│   ├── NoInternetException
│   ├── TimeoutException
│   ├── ServerException
│   └── UnauthorizedException
├── StorageException
│   ├── ReadException
│   ├── WriteException
│   └── NotFoundException
├── ValidationException
│   ├── InvalidInputException
│   └── MissingFieldException
├── PermissionException
│   ├── PermissionDeniedException
│   └── PermissionPermanentlyDeniedException
└── PlatformException
    ├── CameraException
    ├── LocationException
    └── FileSystemException
```

### 7.2 Error Recovery Flow

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│   Error     │────▶│   Error     │────▶│   Logging   │────▶│   User      │
│   Thrown    │     │   Handler   │     │   Service   │     │   Feedback  │
└─────────────┘     └──────┬──────┘     └─────────────┘     └─────────────┘
                           │
                           ▼
                   ┌───────────────┐
                   │   Recovery    │
                   │   Strategy    │
                   ├───────────────┤
                   │ • Retry       │
                   │ • Fallback    │
                   │ • Cache       │
                   │ • Graceful    │
                   └───────────────┘
```

---

## 8. Scalability Considerations

### 8.1 Module Scalability

- **Independent Modules**: Each module is self-contained
- **Lazy Loading**: Modules can be loaded on demand
- **Feature Flags**: Runtime module enable/disable
- **Version Compatibility**: Semantic versioning for modules

### 8.2 Generated App Scalability

- **Clean Architecture**: Separation of concerns
- **Dependency Injection**: Loose coupling
- **State Management**: Riverpod for reactive state
- **Caching Strategy**: Multi-level caching

### 8.3 Future Extensions

1. **Cloud Build Pipeline**: Generate APK/IPA on server
2. **Plugin System**: Third-party module contributions
3. **Theme Marketplace**: Downloadable themes
4. **Analytics Dashboard**: Usage insights
5. **CI/CD Integration**: GitHub Actions templates

---

## Document History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0.0 | Dec 2024 | Chaitanya Mhetre | Initial architecture document |

---

**Next Document**: [02_kiro_core_spec.md](./02_kiro_core_spec.md)

