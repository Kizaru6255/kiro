# Tracking Module

GPS tracking and maps module for Kiro-powered Flutter applications.

## Features

- ✅ Current location
- ✅ Location updates stream
- ✅ Google Maps integration
- ✅ Distance calculation
- ✅ Background tracking (optional)
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module tracking
```

### 2. Import in your app

```dart
import 'package:tracking/tracking.dart';
```

## Configuration

Edit `module.yaml` to configure:

- Location update interval
- Enable/disable background tracking

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `google_maps_flutter` - Maps widget
- `geolocator` - Location services

## Permissions

The module requires:
- Location permission (when in use)
- Location permission (always) - for background tracking

