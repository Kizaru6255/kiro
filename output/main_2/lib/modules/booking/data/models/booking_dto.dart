/// Booking DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/booking_entity.dart';

part 'booking_dto.freezed.dart';
part 'booking_dto.g.dart';

/// Booking data transfer object.
@freezed
class BookingDto with _$BookingDto {
  const factory BookingDto({
    required String id,
    required String userId,
    required String serviceId,
    String? serviceName,
    required DateTime startTime,
    required DateTime endTime,
    @Default(BookingStatus.pending) BookingStatus status,
    String? notes,
    String? location,
    double? price,
    String? currency,
    DateTime? cancelledAt,
    String? cancelledBy,
    DateTime? createdAt,
    Map<String, dynamic>? metadata,
  }) = _BookingDto;

  factory BookingDto.fromJson(Map<String, dynamic> json) =>
      _$BookingDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension BookingDtoExtension on BookingDto {
  /// Convert DTO to domain entity.
  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      userId: userId,
      serviceId: serviceId,
      serviceName: serviceName,
      startTime: startTime,
      endTime: endTime,
      status: status,
      notes: notes,
      location: location,
      price: price,
      currency: currency,
      cancelledAt: cancelledAt,
      cancelledBy: cancelledBy,
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}


