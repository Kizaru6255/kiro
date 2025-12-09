/// Transaction item widget.
library;

import 'package:flutter/material.dart';

import '../models/transaction.dart';

/// List item widget for displaying a transaction.
class TransactionItem extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionItem({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    final color = isCredit ? Colors.green : Colors.red;

    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(
          _getTransactionIcon(transaction.type),
          color: color,
        ),
      ),
      title: Text(transaction.title),
      subtitle: Text(
        transaction.description ?? transaction.referenceId ?? '',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            transaction.formattedAmount,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatDate(transaction.createdAt),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    return switch (type) {
      TransactionType.credit => Icons.add_circle_outline,
      TransactionType.debit => Icons.remove_circle_outline,
      TransactionType.transfer => Icons.swap_horiz,
      TransactionType.refund => Icons.refresh,
    };
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

