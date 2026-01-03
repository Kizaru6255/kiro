/// Notifications module - public API exports.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/notification_entity.dart';
export 'domain/repositories/notification_repository.dart';
export 'domain/usecases/get_notifications_usecase.dart';
export 'domain/usecases/mark_as_read_usecase.dart';
export 'domain/usecases/mark_all_as_read_usecase.dart';

// Presentation (providers, screens, widgets)
export 'presentation/providers/notification_provider.dart';
export 'presentation/models/notification_state.dart';
export 'presentation/screens/notifications_screen.dart';
export 'presentation/widgets/notification_item.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
