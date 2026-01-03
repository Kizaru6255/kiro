/// Booking module - public API exports.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/booking_entity.dart';
export 'domain/entities/time_slot_entity.dart';
export 'domain/repositories/booking_repository.dart';
export 'domain/usecases/get_bookings_usecase.dart';
export 'domain/usecases/create_booking_usecase.dart';

// Presentation (providers, screens, widgets)
export 'presentation/providers/booking_provider.dart';
export 'presentation/models/booking_state.dart';
export 'presentation/screens/bookings_screen.dart';
export 'presentation/screens/create_booking_screen.dart';
export 'presentation/screens/booking_detail_screen.dart';
export 'presentation/widgets/booking_item.dart';
export 'presentation/widgets/booking_calendar.dart';
export 'presentation/widgets/time_slot_picker.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
