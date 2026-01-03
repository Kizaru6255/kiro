/// PaymentEntitymethod card widget.
library;

import 'package:flutter/material.dart';

import '../../domain/entities/payment_entity.dart';

/// Card widget for payment method selection.
class PaymentMethodCard extends StatelessWidget {
  final PaymentMethodType type;
  final String name;
  final bool isSelected;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.type,
    required this.name,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                _getIcon(type),
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIcon(PaymentMethodType type) {
    return switch (type) {
      PaymentMethodType.wallet => Icons.account_balance_wallet,
      PaymentMethodType.upi => Icons.qr_code,
      PaymentMethodType.card => Icons.credit_card,
      PaymentMethodType.netbanking => Icons.account_balance,
      PaymentMethodType.cash => Icons.money,
    };
  }
}

