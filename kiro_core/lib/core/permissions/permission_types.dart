/// Permission types and status definitions.
library;

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

/// Kiro permission types.
///
/// Wraps permission_handler permissions with additional metadata.
enum KiroPermission {
  /// Camera access.
  camera(
    displayName: 'Camera',
    description: 'Take photos and record videos',
    icon: Icons.camera_alt,
  ),

  /// Microphone access.
  microphone(
    displayName: 'Microphone',
    description: 'Record audio and voice messages',
    icon: Icons.mic,
  ),

  /// Photo library access.
  photos(
    displayName: 'Photos',
    description: 'Access your photo library',
    icon: Icons.photo_library,
  ),

  /// Storage access.
  storage(
    displayName: 'Storage',
    description: 'Read and write files',
    icon: Icons.folder,
  ),

  /// Location access (when in use).
  location(
    displayName: 'Location',
    description: 'Access your current location',
    icon: Icons.location_on,
  ),

  /// Location access (always).
  locationAlways(
    displayName: 'Background Location',
    description: 'Access location in the background',
    icon: Icons.location_searching,
  ),

  /// Contacts access.
  contacts(
    displayName: 'Contacts',
    description: 'Access your contacts',
    icon: Icons.contacts,
  ),

  /// Calendar access.
  calendar(
    displayName: 'Calendar',
    description: 'Access your calendar',
    icon: Icons.calendar_today,
  ),

  /// Notification permission.
  notification(
    displayName: 'Notifications',
    description: 'Send you notifications',
    icon: Icons.notifications,
  ),

  /// Phone permission.
  phone(
    displayName: 'Phone',
    description: 'Make and manage phone calls',
    icon: Icons.phone,
  ),

  /// SMS permission.
  sms(
    displayName: 'SMS',
    description: 'Send and read SMS messages',
    icon: Icons.sms,
  ),

  /// Sensors permission.
  sensors(
    displayName: 'Sensors',
    description: 'Access device sensors',
    icon: Icons.sensors,
  ),

  /// Bluetooth permission.
  bluetooth(
    displayName: 'Bluetooth',
    description: 'Connect to Bluetooth devices',
    icon: Icons.bluetooth,
  ),

  /// Media library permission.
  mediaLibrary(
    displayName: 'Media Library',
    description: 'Access your music and media',
    icon: Icons.library_music,
  ),

  /// Speech recognition permission.
  speech(
    displayName: 'Speech Recognition',
    description: 'Recognize your voice',
    icon: Icons.record_voice_over,
  );

  const KiroPermission({
    required this.displayName,
    required this.description,
    required this.icon,
  });

  /// Human-readable name.
  final String displayName;

  /// Description of why permission is needed.
  final String description;

  /// Icon for UI display.
  final IconData icon;

  /// Convert to permission_handler Permission.
  ph.Permission toPermission() {
    return switch (this) {
      KiroPermission.camera => ph.Permission.camera,
      KiroPermission.microphone => ph.Permission.microphone,
      KiroPermission.photos => ph.Permission.photos,
      KiroPermission.storage => ph.Permission.storage,
      KiroPermission.location => ph.Permission.location,
      KiroPermission.locationAlways => ph.Permission.locationAlways,
      KiroPermission.contacts => ph.Permission.contacts,
      KiroPermission.calendar => ph.Permission.calendar,
      KiroPermission.notification => ph.Permission.notification,
      KiroPermission.phone => ph.Permission.phone,
      KiroPermission.sms => ph.Permission.sms,
      KiroPermission.sensors => ph.Permission.sensors,
      KiroPermission.bluetooth => ph.Permission.bluetooth,
      KiroPermission.mediaLibrary => ph.Permission.mediaLibrary,
      KiroPermission.speech => ph.Permission.speech,
    };
  }
}

/// Permission request result.
enum PermissionResult {
  /// Permission was granted.
  granted,

  /// Permission was denied.
  denied,

  /// Permission was permanently denied.
  permanentlyDenied,

  /// Permission is restricted (iOS parental controls).
  restricted,

  /// Limited access granted (iOS 14+ photos).
  limited,
}

/// Extension to convert permission_handler status.
extension PermissionStatusX on ph.PermissionStatus {
  /// Convert to Kiro permission result.
  PermissionResult toResult() {
    return switch (this) {
      ph.PermissionStatus.granted => PermissionResult.granted,
      ph.PermissionStatus.denied => PermissionResult.denied,
      ph.PermissionStatus.permanentlyDenied => PermissionResult.permanentlyDenied,
      ph.PermissionStatus.restricted => PermissionResult.restricted,
      ph.PermissionStatus.limited => PermissionResult.limited,
      ph.PermissionStatus.provisional => PermissionResult.granted,
    };
  }
}

/// Group of related permissions.
class PermissionGroup {
  /// Group name.
  final String name;

  /// Permissions in this group.
  final List<KiroPermission> permissions;

  /// Description of the group.
  final String description;

  const PermissionGroup({
    required this.name,
    required this.permissions,
    required this.description,
  });

  /// Common permission groups.
  static const camera = PermissionGroup(
    name: 'Camera & Microphone',
    permissions: [KiroPermission.camera, KiroPermission.microphone],
    description: 'For taking photos, videos, and voice messages',
  );

  static const location = PermissionGroup(
    name: 'Location',
    permissions: [KiroPermission.location],
    description: 'For showing nearby places and navigation',
  );

  static const locationBackground = PermissionGroup(
    name: 'Location (Background)',
    permissions: [KiroPermission.location, KiroPermission.locationAlways],
    description: 'For tracking and live location sharing',
  );

  static const media = PermissionGroup(
    name: 'Media',
    permissions: [KiroPermission.photos, KiroPermission.storage],
    description: 'For accessing and saving photos and files',
  );

  static const communication = PermissionGroup(
    name: 'Communication',
    permissions: [KiroPermission.contacts, KiroPermission.phone, KiroPermission.sms],
    description: 'For calling and messaging contacts',
  );
}

