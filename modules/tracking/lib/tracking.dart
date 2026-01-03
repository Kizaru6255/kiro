/// Tracking module - public API exports.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/location_entity.dart';
export 'domain/entities/tracking_session_entity.dart';
export 'domain/repositories/tracking_repository.dart';

// Presentation (providers, screens, widgets)
export 'presentation/screens/tracking_screen.dart';
export 'presentation/screens/map_screen.dart';
export 'presentation/widgets/location_card.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
