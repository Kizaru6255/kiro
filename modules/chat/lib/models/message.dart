/// Message model.
library;

import 'package:freezed_annotation/freezed_annotation.dart';

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
}

