/// Location provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/location.dart';
/// Location service provider.
/// Current location provider.
final currentLocationProvider =
    FutureProvider<Location>((ref) async {
  throw UnimplementedError('Service removed - implement repository provider');
});

/// Location stream provider.
final locationStreamProvider = StreamProvider<Location>((ref) {
  throw UnimplementedError('Service removed - implement repository provider');
});