/// Bookings list screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/booking_provider.dart';
import '../widgets/booking_item.dart';

/// Screen displaying all bookings.
class BookingsScreen extends ConsumerWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(bookingNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/bookings/create'),
          ),
        ],
      ),
      body: bookingsAsync.when(
        data: (bookings) {
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bookings yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Book your first appointment',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/bookings/create'),
                    icon: const Icon(Icons.add),
                    label: const Text('Book Now'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.read(bookingNotifierProvider.notifier).refresh();
            },
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return BookingItem(
                  booking: booking,
                  onTap: () => context.push('/bookings/${booking.id}'),
                );
              },
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
                'Error loading bookings',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () {
                  ref.read(bookingNotifierProvider.notifier).refresh();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

