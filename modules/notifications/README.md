# Notifications Module

Push and local notifications module for Kiro-powered Flutter applications.

## Features

- ✅ Push notifications (FCM)
- ✅ Local notifications
- ✅ Notification history
- ✅ Mark as read/unread
- ✅ Notification types (info, success, warning, error, promotion)
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module notifications
```

### 2. Import in your app

```dart
import 'package:notifications/notifications.dart';
```

## API Endpoints

The module expects these endpoints:

- `GET /notifications` - Get all notifications
- `POST /notifications/:id/read` - Mark as read
- `POST /notifications/read-all` - Mark all as read

## Configuration

Edit `module.yaml` to configure:

- Enable/disable push notifications
- Enable/disable local notifications

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `firebase_messaging` (optional) - Push notifications
- `flutter_local_notifications` - Local notifications

