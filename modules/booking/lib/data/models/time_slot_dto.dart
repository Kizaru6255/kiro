/// Time slot DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/time_slot_entity.dart';

part 'time_slot_dto.freezed.dart';
part 'time_slot_dto.g.dart';

/// Time slot data transfer object.
@freezed
class TimeSlotDto with _$TimeSlotDto {
  const factory TimeSlotDto({
    required DateTime startTime,
    required DateTime endTime,
    @Default(SlotAvailability.available) SlotAvailability availability,
    String? bookingId,
  }) = _TimeSlotDto;

  factory TimeSlotDto.fromJson(Map<String, dynamic> json) =>
      _$TimeSlotDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension TimeSlotDtoExtension on TimeSlotDto {
  /// Convert DTO to domain entity.
  TimeSlotEntity toEntity() {
    return TimeSlotEntity(
      startTime: startTime,
      endTime: endTime,
      availability: availability,
      bookingId: bookingId,
    );
  }
}


