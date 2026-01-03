/// Message entity (domain layer).
library;

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

/// Message entity.
class MessageEntity {
  final String id;
  final String chatId;
  final String senderId;
  final String content;
  final MessageType type;
  final MessageStatus status;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? thumbnailUrl;
  final DateTime? readAt;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  const MessageEntity({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    required this.type,
    this.status = MessageStatus.sent,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.thumbnailUrl,
    this.readAt,
    required this.createdAt,
    this.metadata,
  });

  /// Check if message is read.
  bool get isRead => status == MessageStatus.read;

  /// Check if message is delivered.
  bool get isDelivered => status == MessageStatus.delivered || isRead;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageEntity &&
          runtimeType == other.runtimeType &&
          id == other.id;

  /// Check if message is media (image/video/audio).
  bool get isMedia =>
      type == MessageType.image ||
      type == MessageType.video ||
      type == MessageType.audio;

  /// Formatted file size.
  String? get formattedFileSize {
    if (fileSize == null) return null;
    if (fileSize! < 1024) return '${fileSize}B';
    if (fileSize! < 1024 * 1024) {
      return '${(fileSize! / 1024).toStringAsFixed(1)}KB';
    }
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)}MB';
  }

  @override
  int get hashCode => id.hashCode;
}

