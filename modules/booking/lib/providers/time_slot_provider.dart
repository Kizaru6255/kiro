/// Time slot provider using Riverpod.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/time_slot.dart';
import '../services/time_slot_service.dart';

/// Time slot service provider.
final timeSlotServiceProvider = Provider<TimeSlotService>((ref) {
  return TimeSlotService();
});

/// Available time slots provider.
final timeSlotsProvider = FutureProvider.family<List<TimeSlot>, Map<String, dynamic>>((ref, params) async {
  final service = ref.watch(timeSlotServiceProvider);
  final result = await service.getAvailableSlots(
    serviceId: params['serviceId'] as String,
    date: params['date'] as DateTime,
  );
  return result.fold(
    onSuccess: (slots) => slots,
    onFailure: (failure) => throw Exception(failure.message),
  );
});

