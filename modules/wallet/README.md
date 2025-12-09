# Wallet Module

Digital wallet module for Kiro-powered Flutter applications.

## Features

- ✅ Wallet balance management
- ✅ Add money to wallet
- ✅ Withdraw money
- ✅ Transfer money to other users
- ✅ Transaction history
- ✅ Transaction details
- ✅ Real-time balance updates
- ✅ Riverpod state management

## Usage

### 1. Add to your app

```bash
kiro add module wallet
```

### 2. Import in your app

```dart
import 'package:wallet/wallet.dart';
```

### 3. Use in your router

```dart
final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/wallet',
      builder: (context, state) => const WalletScreen(),
    ),
    GoRoute(
      path: '/wallet/add-money',
      builder: (context, state) => const AddMoneyScreen(),
    ),
    // ... other routes
  ],
);
```

### 4. Use WalletProvider

```dart
final walletAsync = ref.watch(walletNotifierProvider);

walletAsync.when(
  data: (wallet) => Text('Balance: ${wallet.formattedBalance}'),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

## API Endpoints

The module expects these endpoints:

- `GET /wallet` - Get wallet balance
- `POST /wallet/add-money` - Add money to wallet
- `POST /wallet/withdraw` - Withdraw money
- `POST /wallet/transfer` - Transfer money
- `GET /wallet/transactions` - Get transaction history
- `GET /wallet/transactions/:id` - Get transaction details

## Configuration

Edit `module.yaml` to configure:

- Default currency
- Minimum balance
- Enable/disable transactions

## Dependencies

- `kiro_core` - Core infrastructure
- `flutter_riverpod` - State management
- `go_router` - Navigation
- `intl` - Internationalization

