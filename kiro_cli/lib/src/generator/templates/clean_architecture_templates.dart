/// Clean Architecture module templates.
/// 
/// Templates for generating modules following Clean Architecture:
/// - data/ (datasources, models/DTOs, repositories)
/// - domain/ (entities, repositories/interfaces, usecases)
/// - presentation/ (providers, screens, widgets)
library;

/// Generate Clean Architecture folder structure for a module.
String generateCleanArchitectureStructure(String moduleName) {
  return '''
# Clean Architecture Structure for $moduleName Module

lib/
├── ${moduleName}.dart                    # Public API exports
│
├── data/                                 # Data Layer
│   ├── datasources/
│   │   ├── ${moduleName}_remote_datasource.dart
│   │   └── ${moduleName}_local_datasource.dart
│   ├── models/
│   │   └── ${moduleName}_dto.dart
│   └── repositories/
│       └── ${moduleName}_repository_impl.dart
│
├── domain/                               # Domain Layer
│   ├── entities/
│   │   └── ${moduleName}_entity.dart
│   ├── repositories/
│   │   └── ${moduleName}_repository.dart
│   └── usecases/
│       ├── get_${moduleName}_usecase.dart
│       └── create_${moduleName}_usecase.dart
│
├── presentation/                         # Presentation Layer
│   ├── providers/
│   │   └── ${moduleName}_provider.dart
│   ├── models/
│   │   └── ${moduleName}_state.dart
│   ├── screens/
│   │   └── ${moduleName}_screen.dart
│   └── widgets/
│       └── ${moduleName}_item.dart
│
└── core/                                 # Module-specific core
    └── errors/
        └── errors.dart
''';
}

/// Generate domain entity template.
String generateEntityTemplate(String moduleName, String entityName) {
  final className = '${entityName}Entity';
  return '''
/// $entityName entity (domain layer).
/// 
/// Pure Dart class representing $entityName in the domain layer.
/// No dependencies on external packages.
library;

/// $entityName entity.
class $className {
  final String id;
  
  const $className({
    required this.id,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is $className &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
''';
}

/// Generate repository interface template.
String generateRepositoryInterfaceTemplate(
  String moduleName,
  String entityName,
) {
  final repoName = '${moduleName}Repository';
  final entityClassName = '${entityName}Entity';
  return '''
/// $moduleName repository interface (domain layer).
/// 
/// Defines the contract for $moduleName operations.
/// Implementations are in the data layer.
library;

import '../entities/${moduleName}_entity.dart';
import '../../core/errors/errors.dart';

/// $moduleName repository interface.
abstract class $repoName {
  /// Get $moduleName by id.
  Future<Result<$entityClassName>> getById(String id);
  
  /// Get all ${moduleName}s.
  Future<Result<List<$entityClassName>>> getAll();
  
  /// Create $moduleName.
  Future<Result<$entityClassName>> create($entityClassName entity);
  
  /// Update $moduleName.
  Future<Result<$entityClassName>> update($entityClassName entity);
  
  /// Delete $moduleName.
  Future<Result<void>> delete(String id);
}
''';
}

/// Generate use case template.
String generateUseCaseTemplate(
  String moduleName,
  String useCaseName,
  String entityName,
) {
  final useCaseClassName = '${useCaseName}UseCase';
  final entityClassName = '${entityName}Entity';
  final repoName = '${moduleName}Repository';
  
  return '''
/// $useCaseName use case (domain layer).
/// 
/// Business logic for $useCaseName.
library;

import '../entities/${moduleName}_entity.dart';
import '../repositories/${moduleName}_repository.dart';
import '../../core/errors/errors.dart';

/// Use case for $useCaseName.
class $useCaseClassName {
  final $repoName _repository;

  $useCaseClassName(this._repository);

  /// Execute $useCaseName.
  Future<Result<$entityClassName>> call(String id) async {
    // Domain validation
    if (id.isEmpty) {
      return Result.failure(
        Failure.validation(message: 'ID cannot be empty'),
      );
    }

    // Delegate to repository
    return await _repository.getById(id);
  }
}
''';
}

/// Generate DTO template.
String generateDtoTemplate(String moduleName, String entityName) {
  final dtoClassName = '${entityName}Dto';
  final entityClassName = '${entityName}Entity';
  
  return '''
/// $entityName DTO (data transfer object).
/// 
/// Data layer model for API responses.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/${moduleName}_entity.dart';

part '${moduleName}_dto.freezed.dart';
part '${moduleName}_dto.g.dart';

/// $entityName data transfer object.
@freezed
class $dtoClassName with _\$$dtoClassName {
  const factory $dtoClassName({
    required String id,
  }) = _$dtoClassName;

  factory $dtoClassName.fromJson(Map<String, dynamic> json) =>
      _\$${dtoClassName}FromJson(json);
}

/// Extension to convert DTO to Entity.
extension ${dtoClassName}Extension on $dtoClassName {
  /// Convert DTO to domain entity.
  $entityClassName toEntity() {
    return $entityClassName(
      id: id,
    );
  }
}
''';
}

/// Generate repository implementation template.
String generateRepositoryImplTemplate(String moduleName, String entityName) {
  final repoName = '${moduleName}Repository';
  final repoImplName = '${repoName}Impl';
  final entityClassName = '${entityName}Entity';
  final dtoClassName = '${entityName}Dto';
  
  return '''
/// $moduleName repository implementation (data layer).
/// 
/// Implements the domain repository interface.
library;

import '../../domain/entities/${moduleName}_entity.dart';
import '../../domain/repositories/${moduleName}_repository.dart';
import '../../core/errors/errors.dart';
import '../datasources/${moduleName}_remote_datasource.dart';
import '../datasources/${moduleName}_local_datasource.dart';
import '../models/${moduleName}_dto.dart';

/// Implementation of $moduleName repository.
class $repoImplName implements $repoName {
  final ${moduleName}RemoteDataSource _remoteDataSource;
  final ${moduleName}LocalDataSource _localDataSource;

  $repoImplName({
    required ${moduleName}RemoteDataSource remoteDataSource,
    required ${moduleName}LocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Result<$entityClassName>> getById(String id) async {
    try {
      final response = await _remoteDataSource.getById(id);

      return response.fold(
        onSuccess: (data) {
          final dto = $dtoClassName.fromJson(data);
          return Result.success(dto.toEntity());
        },
        onFailure: (failure) {
          return Result.failure(
            Failure.network(
              message: failure.message,
              statusCode: failure.statusCode,
            ),
          );
        },
      );
    } catch (e) {
      return Result.failure(
        Failure.network(message: 'Failed to get $moduleName: \$e'),
      );
    }
  }

  @override
  Future<Result<List<$entityClassName>>> getAll() async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<$entityClassName>> create($entityClassName entity) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<$entityClassName>> update($entityClassName entity) async {
    // TODO: Implement
    throw UnimplementedError();
  }

  @override
  Future<Result<void>> delete(String id) async {
    // TODO: Implement
    throw UnimplementedError();
  }
}
''';
}

/// Generate provider template.
String generateProviderTemplate(String moduleName, String entityName) {
  final providerName = '${moduleName}Provider';
  final stateName = '${moduleName}State';
  final repoName = '${moduleName}Repository';
  final repoImplName = '${repoName}Impl';
  
  return '''
/// $moduleName provider (presentation layer).
/// 
/// Uses Riverpod to manage $moduleName state.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/${moduleName}_repository.dart';
import '../../data/repositories/${moduleName}_repository_impl.dart';
import '../../data/datasources/${moduleName}_remote_datasource.dart';
import '../../data/datasources/${moduleName}_local_datasource.dart';
import '../models/${moduleName}_state.dart';

// ============================================================================
// Data Sources (Riverpod Providers)
// ============================================================================

/// Remote data source provider.
final ${moduleName}RemoteDataSourceProvider = Provider<${moduleName}RemoteDataSource>((ref) {
  return ${moduleName}RemoteDataSourceImpl();
});

/// Local data source provider.
final ${moduleName}LocalDataSourceProvider = Provider<${moduleName}LocalDataSource>((ref) {
  return ${moduleName}LocalDataSourceImpl();
});

// ============================================================================
// Repository (Riverpod Provider)
// ============================================================================

/// $moduleName repository provider.
final ${moduleName}RepositoryProvider = Provider<$repoName>((ref) {
  return $repoImplName(
    remoteDataSource: ref.watch(${moduleName}RemoteDataSourceProvider),
    localDataSource: ref.watch(${moduleName}LocalDataSourceProvider),
  );
});

// ============================================================================
// State (Riverpod StateNotifier)
// ============================================================================

/// $moduleName state notifier.
class ${moduleName}Notifier extends StateNotifier<$stateName> {
  final $repoName _repository;

  ${moduleName}Notifier({
    required $repoName repository,
  })  : _repository = repository,
        super(const $stateName.initial());

  /// Load $moduleName.
  Future<void> load(String id) async {
    state = const $stateName.loading();

    final result = await _repository.getById(id);

    result.fold(
      onSuccess: (entity) => state = $stateName.loaded(entity),
      onFailure: (failure) => state = $stateName.error(failure.message),
    );
  }
}

/// $moduleName state provider.
final $providerName = StateNotifierProvider<${moduleName}Notifier, $stateName>((ref) {
  return ${moduleName}Notifier(
    repository: ref.watch(${moduleName}RepositoryProvider),
  );
});
''';
}

/// Generate module barrel file template.
String generateModuleBarrelFile(String moduleName) {
  return '''
/// $moduleName module - public API exports.
/// 
/// This is the main entry point for the $moduleName module.
/// Only exports public APIs that other modules/apps should use.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/${moduleName}_entity.dart';
export 'domain/repositories/${moduleName}_repository.dart';
export 'domain/usecases/get_${moduleName}_usecase.dart';

// Presentation (providers, screens, widgets)
export 'presentation/providers/${moduleName}_provider.dart';
export 'presentation/models/${moduleName}_state.dart';
export 'presentation/screens/${moduleName}_screen.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
''';
}

