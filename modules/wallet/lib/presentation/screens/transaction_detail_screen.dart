/// TransactionEntitydetail screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/transaction_entity.dart' as entity;
import '../../providers/transaction_provider.dart';
import '../../models/transaction.dart';

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
        data: (transaction) {
          final transactionEntity = transaction.toEntity();
          return SingleChildScrollView(
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
                        _getStatusIcon(transactionEntity.status),
                        size: 64,
                        color: _getStatusColor(transactionEntity.status),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        transactionEntity.status.name.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _getStatusColor(transactionEntity.status),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        transactionEntity.formattedAmount,
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              color: transactionEntity.type == entity.TransactionType.credit
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
                transactionEntity.title,
              ),
              _buildDetailRow(
                context,
                'Date',
                _formatDateTime(transactionEntity.createdAt),
              ),
              if (transactionEntity.completedAt != null)
                _buildDetailRow(
                  context,
                  'Completed',
                  _formatDateTime(transactionEntity.completedAt!),
                ),
              if (transactionEntity.description != null)
                _buildDetailRow(
                  context,
                  'Description',
                  transactionEntity.description!,
                ),
              if (transactionEntity.referenceId != null)
                _buildDetailRow(
                  context,
                  'Reference ID',
                  transactionEntity.referenceId!,
                ),
            ],
          ),
          );
        },
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

  IconData _getStatusIcon(entity.TransactionStatus status) {
    return switch (status) {
      entity.TransactionStatus.completed => Icons.check_circle,
      entity.TransactionStatus.pending => Icons.pending,
      entity.TransactionStatus.failed => Icons.error,
      entity.TransactionStatus.cancelled => Icons.cancel,
    };
  }

  Color _getStatusColor(entity.TransactionStatus status) {
    return switch (status) {
      entity.TransactionStatus.completed => Colors.green,
      entity.TransactionStatus.pending => Colors.orange,
      entity.TransactionStatus.failed => Colors.red,
      entity.TransactionStatus.cancelled => Colors.grey,
    };
  }

  String _formatDateTime(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}

