/// Chat module for Kiro.
///
/// Provides real-time messaging functionality including:
/// - One-on-one chats
/// - Group chats
/// - Text messages
/// - Image sharing
/// - File sharing
/// - Message status (sent, delivered, read)
///
/// ## Quick Start
///
/// ```dart
/// import 'package:chat/chat.dart';
///
/// // In your app
/// final chatProvider = ChatProvider();
/// ```
library;

// Models
export 'models/chat.dart';
export 'models/message.dart';

// Services
export 'services/chat_service.dart';
export 'services/message_service.dart';

// Providers
export 'providers/chat_provider.dart';
export 'providers/message_provider.dart';

// Screens
export 'screens/chat_list_screen.dart';
export 'screens/chat_detail_screen.dart';

// Widgets
export 'widgets/message_bubble.dart';
export 'widgets/chat_item.dart';
export 'widgets/message_input.dart';

