/// Permission manager for handling runtime permissions.
library;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

import '../errors/errors.dart';
import 'permission_types.dart';

/// Manager for requesting and checking runtime permissions.
///
/// Features:
/// - Request single or multiple permissions
/// - Check permission status
/// - Show rationale dialogs
/// - Open app settings
///
/// Example:
/// ```dart
/// final permissions = PermissionManager();
///
/// // Check and request
/// final result = await permissions.request(KiroPermission.camera);
/// if (result == PermissionResult.granted) {
///   openCamera();
/// }
///
/// // Request multiple
/// final results = await permissions.requestMultiple([
///   KiroPermission.camera,
///   KiroPermission.microphone,
/// ]);
/// ```
class PermissionManager {
  /// Context provider for showing dialogs.
  final BuildContext Function()? _contextProvider;

  /// Custom rationale messages per permission.
  final Map<KiroPermission, String> _customRationales;

  /// Cache of permission statuses.
  final Map<KiroPermission, PermissionResult> _statusCache = {};

  /// Create a permission manager.
  ///
  /// [contextProvider] - Function to get current BuildContext for dialogs.
  /// [customRationales] - Custom rationale messages for permissions.
  PermissionManager({
    BuildContext Function()? contextProvider,
    Map<KiroPermission, String>? customRationales,
  })  : _contextProvider = contextProvider,
        _customRationales = customRationales ?? {};

  /// Request a single permission.
  ///
  /// [permission] - The permission to request.
  /// [showRationale] - Whether to show rationale dialog if previously denied.
  Future<PermissionResult> request(
    KiroPermission permission, {
    bool showRationale = true,
  }) async {
    // Check current status
    final currentStatus = await checkStatus(permission);

    // Already granted
    if (currentStatus == PermissionResult.granted ||
        currentStatus == PermissionResult.limited) {
      return currentStatus;
    }

    // Permanently denied - can only open settings
    if (currentStatus == PermissionResult.permanentlyDenied) {
      return PermissionResult.permanentlyDenied;
    }

    // Show rationale if previously denied and context available
    if (showRationale &&
        currentStatus == PermissionResult.denied &&
        _contextProvider != null) {
      final shouldProceed = await _showRationale(permission);
      if (!shouldProceed) {
        return PermissionResult.denied;
      }
    }

    // Request permission
    final status = await permission.toPermission().request();
    final result = status.toResult();

    // Update cache
    _statusCache[permission] = result;

    return result;
  }

  /// Request multiple permissions at once.
  Future<Map<KiroPermission, PermissionResult>> requestMultiple(
    List<KiroPermission> permissions, {
    bool showRationale = true,
  }) async {
    final results = <KiroPermission, PermissionResult>{};

    // Check which permissions need requesting
    final toRequest = <KiroPermission>[];
    for (final permission in permissions) {
      final status = await checkStatus(permission);
      if (status == PermissionResult.granted ||
          status == PermissionResult.limited) {
        results[permission] = status;
      } else {
        toRequest.add(permission);
      }
    }

    // Show rationale if needed
    if (showRationale && toRequest.isNotEmpty && _contextProvider != null) {
      final shouldProceed = await _showMultipleRationale(toRequest);
      if (!shouldProceed) {
        for (final permission in toRequest) {
          results[permission] = PermissionResult.denied;
        }
        return results;
      }
    }

    // Request remaining permissions
    final phPermissions = toRequest.map((p) => p.toPermission()).toList();
    final statuses = await phPermissions.request();

    for (var i = 0; i < toRequest.length; i++) {
      final permission = toRequest[i];
      final phPermission = phPermissions[i];
      final result = statuses[phPermission]?.toResult() ?? PermissionResult.denied;

      results[permission] = result;
      _statusCache[permission] = result;
    }

    return results;
  }

  /// Request a permission group.
  Future<Map<KiroPermission, PermissionResult>> requestGroup(
    PermissionGroup group, {
    bool showRationale = true,
  }) async {
    return requestMultiple(group.permissions, showRationale: showRationale);
  }

  /// Check current permission status.
  Future<PermissionResult> checkStatus(KiroPermission permission) async {
    final status = await permission.toPermission().status;
    final result = status.toResult();
    _statusCache[permission] = result;
    return result;
  }

  /// Check multiple permission statuses.
  Future<Map<KiroPermission, PermissionResult>> checkMultiple(
    List<KiroPermission> permissions,
  ) async {
    final results = <KiroPermission, PermissionResult>{};
    for (final permission in permissions) {
      results[permission] = await checkStatus(permission);
    }
    return results;
  }

  /// Whether permission is granted.
  Future<bool> isGranted(KiroPermission permission) async {
    final status = await checkStatus(permission);
    return status == PermissionResult.granted ||
        status == PermissionResult.limited;
  }

  /// Whether permission is denied.
  Future<bool> isDenied(KiroPermission permission) async {
    final status = await checkStatus(permission);
    return status == PermissionResult.denied;
  }

  /// Whether permission is permanently denied.
  Future<bool> isPermanentlyDenied(KiroPermission permission) async {
    final status = await checkStatus(permission);
    return status == PermissionResult.permanentlyDenied;
  }

  /// Open app settings.
  ///
  /// Use when permission is permanently denied.
  Future<bool> openSettings() async {
    return await ph.openAppSettings();
  }

  /// Check if a service is enabled (location, bluetooth).
  Future<bool> isServiceEnabled(KiroPermission permission) async {
    return switch (permission) {
      KiroPermission.location ||
      KiroPermission.locationAlways =>
        await ph.Permission.location.serviceStatus.isEnabled,
      KiroPermission.bluetooth =>
        await ph.Permission.bluetooth.serviceStatus.isEnabled,
      _ => true,
    };
  }

  /// Request permission or throw exception.
  Future<void> requirePermission(KiroPermission permission) async {
    final result = await request(permission);

    if (result == PermissionResult.permanentlyDenied) {
      throw PermissionPermanentlyDeniedException(
        permission: permission.displayName,
        message:
            '${permission.displayName} permission is permanently denied. Please enable in settings.',
      );
    }

    if (result != PermissionResult.granted &&
        result != PermissionResult.limited) {
      throw PermissionDeniedException(
        permission: permission.displayName,
        message: '${permission.displayName} permission is required',
      );
    }
  }

  /// Get cached status (or check if not cached).
  Future<PermissionResult> getCachedStatus(KiroPermission permission) async {
    return _statusCache[permission] ?? await checkStatus(permission);
  }

  /// Clear cached statuses.
  void clearCache() {
    _statusCache.clear();
  }

  Future<bool> _showRationale(KiroPermission permission) async {
    final context = _contextProvider!();
    final rationale =
        _customRationales[permission] ?? _getDefaultRationale(permission);

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Row(
              children: [
                Icon(permission.icon, color: Theme.of(context).primaryColor),
                const SizedBox(width: 12),
                Text(permission.displayName),
              ],
            ),
            content: Text(rationale),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Not Now'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ??
        false;
  }

  Future<bool> _showMultipleRationale(List<KiroPermission> permissions) async {
    final context = _contextProvider!();

    final permissionWidgets = permissions
        .map((p) => ListTile(
              leading: Icon(p.icon),
              title: Text(p.displayName),
              subtitle: Text(p.description),
              dense: true,
            ))
        .toList();

    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Permissions Required'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('This app needs the following permissions:'),
                  const SizedBox(height: 16),
                  ...permissionWidgets,
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Not Now'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Continue'),
              ),
            ],
          ),
        ) ??
        false;
  }

  String _getDefaultRationale(KiroPermission permission) {
    return 'We need ${permission.displayName.toLowerCase()} permission to '
        '${permission.description.toLowerCase()}.';
  }
}

