# Chat Module

Real-time messaging module for Kiro-powered Flutter applications.

## Features

- ✅ One-on-one chats
- ✅ Group chats
- ✅ Text messages
- ✅ Image sharing
- ✅ File sharing
- ✅ Message status (sent, delivered, read)
- ✅ Unread count
- ✅ Real-time updates (with Firestore)
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module chat
```

### 2. Import in your app

```dart
import 'package:chat/chat.dart';
```

### 3. Use in your router

```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatListScreen(),
    ),
    GoRoute(
      path: '/chat/:chatId',
      builder: (context, state) => ChatDetailScreen(
        chatId: state.pathParameters['chatId']!,
      ),
    ),
  ],
);
```

## API Endpoints

The module expects these endpoints:

- `GET /chats` - Get all chats
- `GET /chats/:id` - Get chat details
- `POST /chats` - Create new chat
- `POST /chats/:id/read` - Mark chat as read
- `GET /chats/:id/messages` - Get messages
- `POST /chats/:id/messages` - Send message
- `POST /chats/:id/messages/:messageId/read` - Mark message as read
- `DELETE /chats/:id/messages/:messageId` - Delete message

## Configuration

Edit `module.yaml` to configure:

- Enable/disable file sharing
- Maximum file size

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `cloud_firestore` (optional) - Real-time database
- `firebase_storage` (optional) - File storage
- `image_picker` - Image selection
- `cached_network_image` - Image caching

