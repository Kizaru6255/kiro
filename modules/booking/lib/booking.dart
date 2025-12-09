/// Booking module for Kiro.
///
/// Provides appointment booking functionality including:
/// - Calendar view
/// - Time slot selection
/// - Create bookings
/// - View booking history
/// - Cancel/modify bookings
///
/// ## Quick Start
///
/// ```dart
/// import 'package:booking/booking.dart';
///
/// // In your app
/// final bookingProvider = BookingProvider();
/// ```
library;

// Models
export 'models/booking.dart';
export 'models/time_slot.dart';

// Services
export 'services/booking_service.dart';
export 'services/time_slot_service.dart';

// Providers
export 'providers/booking_provider.dart';
export 'providers/time_slot_provider.dart';

// Screens
export 'screens/bookings_screen.dart';
export 'screens/create_booking_screen.dart';
export 'screens/booking_detail_screen.dart';

// Widgets
export 'widgets/booking_calendar.dart';
export 'widgets/time_slot_picker.dart';
export 'widgets/booking_item.dart';

