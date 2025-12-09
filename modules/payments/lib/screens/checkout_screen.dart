/// Checkout screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/payment.dart';
import '../widgets/payment_method_card.dart';
import '../widgets/payment_summary.dart';

/// Checkout screen for payments.
class CheckoutScreen extends ConsumerStatefulWidget {
  final double amount;
  final String? orderId;
  final String? description;

  const CheckoutScreen({
    super.key,
    required this.amount,
    this.orderId,
    this.description,
  });

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  PaymentMethodType? _selectedMethod;

  Future<void> _handlePayment() async {
    if (_selectedMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a payment method')),
      );
      return;
    }

    // TODO: Implement actual payment gateway integration
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Payment processing...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PaymentSummary(
              amount: widget.amount,
              description: widget.description,
            ),
            const SizedBox(height: 24),
            Text(
              'Select Payment Method',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            PaymentMethodCard(
              type: PaymentMethodType.wallet,
              name: 'Wallet',
              isSelected: _selectedMethod == PaymentMethodType.wallet,
              onTap: () {
                setState(() {
                  _selectedMethod = PaymentMethodType.wallet;
                });
              },
            ),
            const SizedBox(height: 12),
            PaymentMethodCard(
              type: PaymentMethodType.upi,
              name: 'UPI',
              isSelected: _selectedMethod == PaymentMethodType.upi,
              onTap: () {
                setState(() {
                  _selectedMethod = PaymentMethodType.upi;
                });
              },
            ),
            const SizedBox(height: 12),
            PaymentMethodCard(
              type: PaymentMethodType.card,
              name: 'Credit/Debit Card',
              isSelected: _selectedMethod == PaymentMethodType.card,
              onTap: () {
                setState(() {
                  _selectedMethod = PaymentMethodType.card;
                });
              },
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: _selectedMethod == null ? null : _handlePayment,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }
}

