/// Permissions module for Kiro Core.
///
/// Provides:
/// - [PermissionManager] - Request and manage permissions
/// - [KiroPermission] - Permission type definitions
/// - [PermissionResult] - Request result statuses
/// - [PermissionGroup] - Groups of related permissions
///
/// ## Quick Start
///
/// ```dart
/// final permissions = PermissionManager(
///   contextProvider: () => context,
/// );
///
/// // Request single permission
/// final result = await permissions.request(KiroPermission.camera);
/// if (result == PermissionResult.granted) {
///   openCamera();
/// } else if (result == PermissionResult.permanentlyDenied) {
///   await permissions.openSettings();
/// }
///
/// // Request multiple
/// final results = await permissions.requestMultiple([
///   KiroPermission.camera,
///   KiroPermission.microphone,
/// ]);
///
/// // Require permission (throws if denied)
/// await permissions.requirePermission(KiroPermission.location);
/// ```
library;

export 'permission_manager.dart';
export 'permission_types.dart';

