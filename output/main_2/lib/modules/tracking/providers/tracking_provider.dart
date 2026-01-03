/// Tracking provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/tracking_session.dart';
/// Tracking service provider.
/// Active tracking session provider.
final activeTrackingSessionProvider =
    FutureProvider<TrackingSession?>((ref) async {
  // TODO: Get active session from service
  return null;
});