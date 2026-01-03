/// Profile module - public API exports.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/user_profile_entity.dart';
export 'domain/repositories/profile_repository.dart';
export 'domain/usecases/get_profile_usecase.dart';
export 'domain/usecases/update_profile_usecase.dart';

// Presentation (providers, screens, widgets)
export 'presentation/providers/profile_provider.dart';
export 'presentation/models/profile_state.dart';
export 'presentation/screens/profile_screen.dart';
export 'presentation/screens/edit_profile_screen.dart';
export 'presentation/screens/settings_screen.dart';
export 'presentation/widgets/profile_avatar.dart';
export 'presentation/widgets/profile_info_card.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
