/// Wallet screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/wallet_provider.dart';
import '../providers/transaction_provider.dart';
import '../widgets/balance_card.dart';
import '../widgets/transaction_item.dart';

/// Main wallet screen.
class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(walletNotifierProvider);
    final transactionsAsync = ref.watch(
      transactionsProvider({'limit': 10, 'offset': 0}),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(walletNotifierProvider.notifier).refresh();
              ref.invalidate(transactionsProvider({'limit': 10, 'offset': 0}));
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.read(walletNotifierProvider.notifier).refresh();
          ref.invalidate(transactionsProvider({'limit': 10, 'offset': 0}));
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Balance Card
              walletAsync.when(
                data: (wallet) => BalanceCard(wallet: wallet),
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error: ${error.toString()}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () => context.push('/wallet/add-money'),
                        icon: const Icon(Icons.add),
                        label: const Text('Add Money'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // TODO: Implement send money
                        },
                        icon: const Icon(Icons.send),
                        label: const Text('Send'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              // Recent Transactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recent Transactions',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextButton(
                      onPressed: () => context.push('/wallet/transactions'),
                      child: const Text('View All'),
                    ),
                  ],
                ),
              ),
              transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(32),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 64,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No transactions yet',
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Theme.of(context).colorScheme.outline,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      return TransactionItem(
                        transaction: transaction,
                        onTap: () => context.push(
                          '/wallet/transaction/${transaction.id}',
                        ),
                      );
                    },
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(32),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (error, stack) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Card(
                    color: Colors.red.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        'Error loading transactions: ${error.toString()}',
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

