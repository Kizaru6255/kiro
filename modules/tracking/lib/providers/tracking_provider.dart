/// Tracking provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracking_session.dart';
import '../services/tracking_service.dart';

/// Tracking service provider.
final trackingServiceProvider = Provider<TrackingService>((ref) {
  return TrackingService();
});

/// Active tracking session provider.
final activeTrackingSessionProvider =
    FutureProvider<TrackingSession?>((ref) async {
  // TODO: Get active session from service
  return null;
});

