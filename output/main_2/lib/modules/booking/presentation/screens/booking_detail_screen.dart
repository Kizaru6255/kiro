/// Booking detail screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/booking_entity.dart';
import '../providers/booking_provider.dart';

/// Screen displaying booking details.
class BookingDetailScreen extends ConsumerWidget {
  final String bookingId;

  const BookingDetailScreen({
    super.key,
    required this.bookingId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingState = ref.watch(bookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
      ),
      body: bookingState.maybeWhen(
        loaded: (bookings) {
          final booking = bookings.firstWhere(
            (b) => b.id == bookingId,
            orElse: () => throw Exception('Booking not found'),
          );
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
                        _getStatusIcon(booking.status),
                        size: 64,
                        color: _getStatusColor(booking.status),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        booking.status.name.toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: _getStatusColor(booking.status),
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Details
              _buildDetailRow(context, 'Service', booking.serviceName ?? 'N/A'),
              _buildDetailRow(context, 'Date', booking.formattedDate),
              _buildDetailRow(context, 'Time', booking.formattedTimeRange),
              if (booking.location != null)
                _buildDetailRow(context, 'Location', booking.location!),
              if (booking.price != null)
                _buildDetailRow(
                  context,
                  'Price',
                  '${booking.currency ?? 'INR'} ${booking.price!.toStringAsFixed(2)}',
                ),
              if (booking.notes != null)
                _buildDetailRow(context, 'Notes', booking.notes!),
              const SizedBox(height: 32),
              // Actions
              if (booking.isConfirmed)
                FilledButton.icon(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Cancel Booking'),
                        content: const Text(
                          'Are you sure you want to cancel this booking?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('No'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Yes, Cancel'),
                          ),
                        ],
                      ),
                    );

                    if (confirmed == true) {
                      await ref
                          .read(bookingProvider.notifier)
                          .cancelBooking(booking.id, null);
                      if (context.mounted) {
                        context.pop();
                      }
                    }
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text('Cancel Booking'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
            ],
          ),
          );
        },
        orElse: () => const Center(child: CircularProgressIndicator()),
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
            width: 100,
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

  IconData _getStatusIcon(BookingStatus status) {
    return switch (status) {
      BookingStatus.pending => Icons.pending,
      BookingStatus.confirmed => Icons.check_circle,
      BookingStatus.cancelled => Icons.cancel,
      BookingStatus.completed => Icons.done_all,
      BookingStatus.noShow => Icons.person_off,
    };
  }

  Color _getStatusColor(BookingStatus status) {
    return switch (status) {
      BookingStatus.pending => Colors.orange,
      BookingStatus.confirmed => Colors.green,
      BookingStatus.cancelled => Colors.red,
      BookingStatus.completed => Colors.blue,
      BookingStatus.noShow => Colors.grey,
    };
  }
}

