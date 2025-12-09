/// Wallet module for Kiro.
///
/// Provides digital wallet functionality including:
/// - Balance management
/// - Transaction history
/// - Add money
/// - Send/receive money
/// - Transaction details
///
/// ## Quick Start
///
/// ```dart
/// import 'package:wallet/wallet.dart';
///
/// // In your app
/// final walletProvider = WalletProvider();
/// final balance = await walletProvider.getBalance();
/// ```
library;

// Models
export 'models/wallet.dart';
export 'models/transaction.dart';

// Services
export 'services/wallet_service.dart';
export 'services/transaction_service.dart';

// Providers
export 'providers/wallet_provider.dart';
export 'providers/transaction_provider.dart';

// Screens
export 'screens/wallet_screen.dart';
export 'screens/add_money_screen.dart';
export 'screens/transactions_screen.dart';
export 'screens/transaction_detail_screen.dart';

// Widgets
export 'widgets/balance_card.dart';
export 'widgets/transaction_item.dart';
export 'widgets/amount_input_field.dart';

