/// Message model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/entities/message_entity.dart' as entity;

part 'message.freezed.dart';
part 'message.g.dart';

/// Message type.
enum MessageType {
  text,
  image,
  file,
  audio,
  video,
}

/// Message status.
enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed,
}

/// Message model.
@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String chatId,
    required String senderId,
    required String content,
    required MessageType type,
    @Default(MessageStatus.sent) MessageStatus status,
    String? fileUrl,
    String? fileName,
    int? fileSize,
    String? thumbnailUrl,
    DateTime? readAt,
    required DateTime createdAt,
    Map<String, dynamic>? metadata,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);
}

/// Message extensions.
extension MessageExtension on Message {
  /// Check if message is text.
  bool get isText => type == MessageType.text;

  /// Check if message is media (image/video/audio).
  bool get isMedia =>
      type == MessageType.image ||
      type == MessageType.video ||
      type == MessageType.audio;

  /// Check if message is file.
  bool get isFile => type == MessageType.file;

  /// Check if message is read.
  bool get isRead => status == MessageStatus.read;

  /// Check if message is delivered.
  bool get isDelivered =>
      status == MessageStatus.delivered || status == MessageStatus.read;

  /// Check if message failed to send.
  bool get isFailed => status == MessageStatus.failed;

  /// Formatted file size.
  String? get formattedFileSize {
    if (fileSize == null) return null;
    if (fileSize! < 1024) return '${fileSize}B';
    if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    }
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  /// Convert to MessageEntity.
  entity.MessageEntity toEntity() {
    // Convert enum types
    final entityType = switch (type) {
      MessageType.text => entity.MessageType.text,
      MessageType.image => entity.MessageType.image,
      MessageType.file => entity.MessageType.file,
      MessageType.audio => entity.MessageType.audio,
      MessageType.video => entity.MessageType.video,
    };
    
    final entityStatus = switch (status) {
      MessageStatus.sending => entity.MessageStatus.sending,
      MessageStatus.sent => entity.MessageStatus.sent,
      MessageStatus.delivered => entity.MessageStatus.delivered,
      MessageStatus.read => entity.MessageStatus.read,
      MessageStatus.failed => entity.MessageStatus.failed,
    };
    
    return entity.MessageEntity(
      id: id,
      chatId: chatId,
      senderId: senderId,
      content: content,
      type: entityType,
      status: entityStatus,
      fileUrl: fileUrl,
      fileName: fileName,
      fileSize: fileSize,
      thumbnailUrl: thumbnailUrl,
      readAt: readAt,
      createdAt: createdAt,
      metadata: metadata,
    );
  }
}

