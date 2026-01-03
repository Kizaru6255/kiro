/// Chat module - public API exports.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/chat_entity.dart';
export 'domain/entities/message_entity.dart';
export 'domain/repositories/chat_repository.dart';

// Presentation (providers, screens, widgets)
export 'presentation/screens/chat_list_screen.dart';
export 'presentation/screens/chat_detail_screen.dart';
export 'presentation/widgets/chat_item.dart';
export 'presentation/widgets/message_bubble.dart';
export 'presentation/widgets/message_input.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
