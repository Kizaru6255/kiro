# Profile Module

User profile management module for Kiro-powered Flutter applications.

## Features

- ✅ View profile
- ✅ Edit profile
- ✅ Profile picture upload
- ✅ Settings screen
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module profile
```

### 2. Import in your app

```dart
import 'package:profile/profile.dart';
```

## API Endpoints

The module expects these endpoints:

- `GET /profile` - Get user profile
- `PUT /profile` - Update profile
- `POST /profile/picture` - Upload profile picture

## Configuration

Edit `module.yaml` to configure:

- Enable/disable profile picture upload

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `image_picker` - Image selection
- `cached_network_image` - Image caching

