# KIRO CLI - Production-Ready Automation Pipeline

## Overview

The KIRO CLI now includes a complete automation pipeline that handles module injection, route generation, provider registration, dependency validation, and more. This makes the CLI truly production-grade and hands-off.

## Features Implemented

### 1. Module Injection (`ModuleInjector`)
- **Location**: `kiro_cli/lib/src/generator/module_injector.dart`
- **Features**:
  - Validates module structure (Clean Architecture compliance)
  - Copies module files from `modules/` to `lib/modules/` in generated apps
  - Processes placeholders (`__MODULE_NAME__`, etc.)
  - Skips generated files (`.freezed.dart`, `.g.dart`)
  - Maintains directory structure

### 2. Dependency Validation (`DependencyValidator`)
- **Location**: `kiro_cli/lib/src/generator/dependency_validator.dart`
- **Features**:
  - Validates module dependencies against existing modules
  - Detects circular dependencies
  - Checks core dependencies (kiro_core, network, storage, permissions)
  - Provides clear error messages for missing dependencies

### 3. Route Generation (`RouteGenerator`)
- **Location**: `kiro_cli/lib/src/generator/route_generator.dart`
- **Features**:
  - Auto-generates `router.dart` from module metadata
  - Creates route constants (`AppRoutes`)
  - Handles authentication requirements
  - Generates GoRouter configuration
  - Updates routes when modules are added

### 4. Provider Registry (`ProviderRegistryGenerator`)
- **Location**: `kiro_cli/lib/src/generator/provider_registry.dart`
- **Features**:
  - Auto-generates `lib/core/providers.dart`
  - Registers all module providers
  - Creates provider override function for testing
  - Imports providers from correct paths

### 5. Pubspec Updater (`PubspecUpdater`)
- **Location**: `kiro_cli/lib/src/generator/pubspec_updater.dart`
- **Features**:
  - Updates `pubspec.yaml` with module dependencies
  - Adds `kiro_core` version if specified
  - Adds module-specific package dependencies
  - Handles optional dependencies

### 6. Test Skeleton Generator (`TestGenerator`)
- **Location**: `kiro_cli/lib/src/generator/test_generator.dart`
- **Features**:
  - Generates test skeletons for domain layer (usecases)
  - Generates test skeletons for data layer (repositories)
  - Generates test skeletons for presentation layer (providers)
  - Creates placeholder tests with TODOs

### 7. Environment Config Generator (`EnvConfigGenerator`)
- **Location**: `kiro_cli/lib/src/generator/env_config_generator.dart`
- **Features**:
  - Generates `.env.dev`, `.env.staging`, `.env.prod`
  - Generates `.env.example` template
  - Creates `lib/config/env_config.dart` loader
  - Supports Firebase configuration

### 8. Enhanced Add Command (`AddModuleCommand`)
- **Location**: `kiro_cli/lib/src/commands/add_command.dart`
- **Features**:
  - Complete automation pipeline
  - Validates project structure
  - Finds Kiro root directory
  - Loads module metadata
  - Validates dependencies
  - Injects module files
  - Updates routes and providers
  - Generates tests and env configs
  - Runs `flutter pub get`
  - Provides detailed success summary

## Usage

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

### Pipeline Flow

When you run `kiro add module <name>`, the CLI:

1. **Validates Project**: Checks if it's a valid Flutter/Kiro project
2. **Finds Kiro Root**: Locates the `modules/` directory
3. **Loads Metadata**: Reads `module.yaml` from the module
4. **Validates Dependencies**: Checks all module dependencies
5. **Injects Module**: Copies files to `lib/modules/<name>/`
6. **Updates Pubspec**: Adds required dependencies
7. **Generates Routes**: Updates `lib/config/router.dart`
8. **Registers Providers**: Updates `lib/core/providers.dart`
9. **Generates Tests**: Creates test skeletons (optional)
10. **Generates Env Configs**: Creates environment files (optional)
11. **Installs Dependencies**: Runs `flutter pub get`

## Module Metadata Structure

Each module must have a `module.yaml` file:

```yaml
name: auth
display_name: Authentication
version: 1.0.0

# Package dependencies
dependencies:
  - name: firebase_auth
    version: ^4.16.0
    optional: true

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
  kiro_core_version: ^0.1.0
```

## Generated Files

### Routes (`lib/config/router.dart`)
- Auto-generated from all module routes
- Includes route constants
- Handles authentication requirements
- Error handling

### Provider Registry (`lib/core/providers.dart`)
- Lists all module providers
- Provider override function for testing
- Auto-imports from correct paths

### Environment Config (`lib/config/env_config.dart`)
- Loads environment variables from `.env` files
- Type-safe getters (string, bool, int, double)
- Supports multiple environments

### Test Skeletons (`test/modules/<module>/`)
- Domain tests: `domain/usecases/`
- Data tests: `data/repositories/`
- Presentation tests: `presentation/providers/`

## Architecture Validation

The CLI enforces Clean Architecture rules:

- **Presentation** → can only depend on **Domain**
- **Domain** → cannot depend on **Data** or **Presentation**
- **Data** → can depend on **Domain**

Module structure is validated:
- Must have `domain/`, `data/`, `presentation/` directories
- Must have `module.yaml` file
- Must have `lib/` directory

## Error Handling

The CLI provides clear error messages:

- Missing dependencies
- Circular dependencies
- Invalid module structure
- Missing files
- Dependency conflicts

## Next Steps

### For Module Developers

1. Ensure your module follows Clean Architecture
2. Create a complete `module.yaml` file
3. Define all routes and providers
4. List all package dependencies
5. Test module injection locally

### For App Developers

1. Use `kiro add module <name>` to add modules
2. Review generated routes and providers
3. Implement tests using generated skeletons
4. Configure environment variables
5. Customize module settings as needed

### 9. Module Removal (`ModuleRemover`)
- **Location**: `kiro_cli/lib/src/generator/module_remover.dart`
- **Features**:
  - Validates module can be safely removed
  - Checks for dependent modules
  - Removes module files
  - Updates routes and providers
  - Removes test files
  - Cleans up dependencies

### 10. Module Update (`ModuleUpdater`)
- **Location**: `kiro_cli/lib/src/generator/module_updater.dart`
- **Features**:
  - Updates module to latest version
  - Backs up custom files
  - Injects updated files
  - Restores custom modifications
  - Updates routes and providers
  - Version compatibility checking

## Module Lifecycle Commands

### Removing a Module

```bash
# Remove a module
kiro remove module auth

# Force removal without confirmation
kiro remove module auth --force
```

**Pipeline:**
1. Validates module exists
2. Checks for dependent modules
3. Removes module files
4. Updates routes (removes module routes)
5. Updates providers (removes module providers)
6. Removes test files
7. Runs `flutter pub get`

### Updating a Module

```bash
# Update a module
kiro update module auth

# Force update without confirmation
kiro update module auth --force
```

**Pipeline:**
1. Validates module exists in project
2. Loads new module metadata from source
3. Backs up custom files
4. Removes old module files
5. Injects updated module files
6. Restores custom files
7. Updates routes and providers
8. Updates dependencies
9. Runs `flutter pub get`

## Future Enhancements

- [ ] AST-based dependency validation
- [ ] Automatic migration of old modules
- [x] Module removal command ✅
- [x] Module update command ✅
- [ ] CI/CD integration
- [ ] Mason template engine migration

## Summary

The KIRO CLI automation pipeline is now production-ready:

✅ **Module Injection** - Fully automated  
✅ **Route Generation** - Auto-updates on module add  
✅ **Provider Registration** - Centralized registry  
✅ **Dependency Validation** - Prevents conflicts  
✅ **Test Generation** - Skeleton tests ready  
✅ **Environment Config** - Multi-env support  
✅ **Pubspec Updates** - Automatic dependency management  

Developers can now focus on feature logic, not wiring!

