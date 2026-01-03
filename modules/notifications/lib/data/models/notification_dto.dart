/// Notification DTO (data transfer object).
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/notification_entity.dart';

part 'notification_dto.freezed.dart';
part 'notification_dto.g.dart';

/// Notification data transfer object.
@freezed
class NotificationDto with _$NotificationDto {
  const factory NotificationDto({
    required String id,
    required String title,
    required String body,
    @Default(NotificationType.info) NotificationType type,
    String? imageUrl,
    String? actionUrl,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
    Map<String, dynamic>? data,
  }) = _NotificationDto;

  factory NotificationDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationDtoFromJson(json);
}

/// Extension to convert DTO to Entity.
extension NotificationDtoExtension on NotificationDto {
  /// Convert DTO to domain entity.
  NotificationEntity toEntity() {
    return NotificationEntity(
      id: id,
      title: title,
      body: body,
      type: type,
      imageUrl: imageUrl,
      actionUrl: actionUrl,
      isRead: isRead,
      readAt: readAt,
      createdAt: createdAt,
      data: data,
    );
  }
}


