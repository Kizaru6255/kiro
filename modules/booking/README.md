# Booking Module

Appointment booking module for Kiro-powered Flutter applications.

## Features

- ✅ Calendar view for date selection
- ✅ Time slot selection
- ✅ Create bookings
- ✅ View booking history
- ✅ Cancel bookings
- ✅ Reschedule bookings
- ✅ Booking status tracking
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module booking
```

### 2. Import in your app

```dart
import 'package:booking/booking.dart';
```

### 3. Use in your router

```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const BookingsScreen(),
    ),
    GoRoute(
      path: '/bookings/create',
      builder: (context, state) => const CreateBookingScreen(),
    ),
    GoRoute(
      path: '/bookings/:id',
      builder: (context, state) => BookingDetailScreen(
        bookingId: state.pathParameters['id']!,
      ),
    ),
  ],
);
```

## API Endpoints

The module expects these endpoints:

- `GET /bookings` - Get all bookings
- `GET /bookings/:id` - Get booking details
- `POST /bookings` - Create booking
- `POST /bookings/:id/cancel` - Cancel booking
- `POST /bookings/:id/reschedule` - Reschedule booking
- `GET /services/:id/time-slots` - Get available time slots

## Configuration

Edit `module.yaml` to configure:

- Default booking duration
- Enable/disable recurring bookings

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `table_calendar` - Calendar widget
- `intl` - Date formatting

