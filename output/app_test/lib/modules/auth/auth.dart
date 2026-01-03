/// Auth module - public API exports.
/// 
/// This is the main entry point for the auth module.
/// Only exports public APIs that other modules/apps should use.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/user_entity.dart';
export 'domain/repositories/auth_repository.dart';
export 'domain/usecases/login_usecase.dart';
export 'domain/usecases/signup_usecase.dart';

// Presentation (providers, screens, widgets)
export 'presentation/providers/auth_provider.dart';
export 'presentation/models/auth_state.dart';
export 'presentation/screens/login_screen.dart';
export 'presentation/screens/signup_screen.dart';
export 'presentation/screens/forgot_password_screen.dart';
export 'presentation/screens/verify_otp_screen.dart';
export 'presentation/widgets/auth_form_field.dart';
export 'presentation/widgets/biometric_button.dart';
export 'presentation/widgets/social_login_button.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
