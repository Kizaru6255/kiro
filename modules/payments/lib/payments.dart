/// Payments module - public API exports.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/payment_entity.dart';
export 'domain/entities/payment_method_entity.dart';
export 'domain/repositories/payment_repository.dart';
export 'domain/usecases/process_payment_usecase.dart';

// Presentation (providers, screens, widgets)
export 'presentation/providers/payment_provider.dart';
export 'presentation/models/payment_state.dart';
export 'presentation/screens/payments_screen.dart';
export 'presentation/screens/checkout_screen.dart';
export 'presentation/widgets/payment_method_card.dart';
export 'presentation/widgets/payment_summary.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
