/// Add money screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/wallet_provider.dart';
import '../widgets/amount_input_field.dart';

/// Screen for adding money to wallet.
class AddMoneyScreen extends ConsumerStatefulWidget {
  const AddMoneyScreen({super.key});

  @override
  ConsumerState<AddMoneyScreen> createState() => _AddMoneyScreenState();
}

class _AddMoneyScreenState extends ConsumerState<AddMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  double _selectedAmount = 0;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _handleAddMoney() async {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    await ref.read(walletProvider.notifier).addMoney(amount: amount);

    final walletState = ref.read(walletProvider);
    if (walletState.maybeWhen(
      loaded: (_) => true,
      orElse: () => false,
    )) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Money added successfully!')),
        );
        context.pop();
      }
    }
  }

  void _selectQuickAmount(double amount) {
    setState(() {
      _selectedAmount = amount;
      _amountController.text = amount.toStringAsFixed(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Money'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Text(
                  'Add Money to Wallet',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                // Quick Amount Buttons
                Text(
                  'Quick Amount',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [100, 500, 1000, 2000, 5000]
                      .map((amount) => ChoiceChip(
                            label: Text('₹$amount'),
                            selected: _selectedAmount == amount,
                            onSelected: (_) => _selectQuickAmount(amount.toDouble()),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 32),
                // Custom Amount
                AmountInputField(
                  controller: _amountController,
                  label: 'Or Enter Custom Amount',
                  onChanged: (value) {
                    final amount = double.tryParse(value) ?? 0;
                    setState(() {
                      _selectedAmount = amount;
                    });
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: walletState.maybeWhen(
                    loading: () => false,
                    orElse: () => true,
                  ) ? null : _handleAddMoney,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: walletState.maybeWhen(
                    loading: () => const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    orElse: () => const Text('Add Money'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

