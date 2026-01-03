/// Wallet module - public API exports.
library;

// Domain (entities, repositories, usecases)
export 'domain/entities/wallet_entity.dart';
export 'domain/entities/transaction_entity.dart';
export 'domain/repositories/wallet_repository.dart';
export 'domain/usecases/get_wallet_usecase.dart';
export 'domain/usecases/add_money_usecase.dart';

// Presentation (providers, screens, widgets)
export 'presentation/providers/wallet_provider.dart';
export 'presentation/models/wallet_state.dart';
export 'presentation/screens/wallet_screen.dart';
export 'presentation/screens/add_money_screen.dart';
export 'presentation/screens/transactions_screen.dart';
export 'presentation/screens/transaction_detail_screen.dart';
export 'presentation/widgets/balance_card.dart';
export 'presentation/widgets/transaction_item.dart';
export 'presentation/widgets/amount_input_field.dart';

// Note: Data layer (DTOs, datasources, repository implementations) 
// are NOT exported - they are internal implementation details.
