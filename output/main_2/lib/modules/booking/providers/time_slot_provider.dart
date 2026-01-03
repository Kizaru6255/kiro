/// Time slot provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/time_slot.dart';
/// Time slot service provider.
/// Available time slots provider.
final timeSlotsProvider = FutureProvider.family<List<TimeSlot>, Map<String, dynamic>>((ref, params) async {
  throw UnimplementedError('Service removed - implement repository provider');