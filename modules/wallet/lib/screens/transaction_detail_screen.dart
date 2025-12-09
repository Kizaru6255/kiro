/// Transaction detail screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

/// Screen displaying transaction details.
class TransactionDetailScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailScreen({
    super.key,
    required this.transactionId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionProvider(transactionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
      ),
      body: transactionAsync.when(
        data: (transaction) => SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Status Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        _getStatusIcon(transaction.status),
                        size: 64,
                        color: _getStatusColor(transaction.status),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        transaction.status.name.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _getStatusColor(transaction.status),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transaction.formattedAmount,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: transaction.type == TransactionType.credit
                                  ? Colors.green
                                  : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Details
              _buildDetailRow(
                context,
                'Type',
                transaction.title,
              ),
              _buildDetailRow(
                context,
                'Date',
                _formatDateTime(transaction.createdAt),
              ),
              if (transaction.completedAt != null)
                _buildDetailRow(
                  context,
                  'Completed',
                  _formatDateTime(transaction.completedAt!),
                ),
              if (transaction.description != null)
                _buildDetailRow(
                  context,
                  'Description',
                  transaction.description!,
                ),
              if (transaction.referenceId != null)
                _buildDetailRow(
                  context,
                  'Reference ID',
                  transaction.referenceId!,
                ),
            ],
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading transaction',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getStatusIcon(TransactionStatus status) {
    return switch (status) {
      TransactionStatus.completed => Icons.check_circle,
      TransactionStatus.pending => Icons.pending,
      TransactionStatus.failed => Icons.error,
      TransactionStatus.cancelled => Icons.cancel,
    };
  }

  Color _getStatusColor(TransactionStatus status) {
    return switch (status) {
      TransactionStatus.completed => Colors.green,
      TransactionStatus.pending => Colors.orange,
      TransactionStatus.failed => Colors.red,
      TransactionStatus.cancelled => Colors.grey,
    };
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

