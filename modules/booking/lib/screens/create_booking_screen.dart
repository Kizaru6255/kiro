/// Create booking screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/time_slot.dart';
import '../providers/booking_provider.dart';
import '../providers/time_slot_provider.dart';
import '../widgets/time_slot_picker.dart';

/// Screen for creating a new booking.
class CreateBookingScreen extends ConsumerStatefulWidget {
  final String? serviceId;

  const CreateBookingScreen({
    super.key,
    this.serviceId,
  });

  @override
  ConsumerState<CreateBookingScreen> createState() =>
      _CreateBookingScreenState();
}

class _CreateBookingScreenState extends ConsumerState<CreateBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  TimeSlot? _selectedSlot;
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _handleCreateBooking() async {
    if (_selectedSlot == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a time slot')),
      );
      return;
    }

    await ref.read(bookingNotifierProvider.notifier).createBooking(
          serviceId: widget.serviceId ?? 'default',
          startTime: _selectedSlot!.startTime,
          endTime: _selectedSlot!.endTime,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        );

    final bookingsAsync = ref.read(bookingNotifierProvider);
    bookingsAsync.whenData((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking created successfully!')),
        );
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final slotsAsync = ref.watch(
      timeSlotsProvider({
        'serviceId': widget.serviceId ?? 'default',
        'date': _selectedDate,
      }),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Calendar
            Card(
              child: TableCalendar(
                firstDay: DateTime.now(),
                lastDay: DateTime.now().add(const Duration(days: 90)),
                focusedDay: _selectedDate,
                selectedDayPredicate: (day) => isSameDay(_selectedDate, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _selectedSlot = null;
                  });
                },
                calendarFormat: CalendarFormat.month,
                startingDayOfWeek: StartingDayOfWeek.monday,
                headerStyle: const HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Time Slots
            Text(
              'Available Time Slots',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            slotsAsync.when(
              data: (slots) {
                final availableSlots =
                    slots.where((s) => s.isAvailable).toList();
                if (availableSlots.isEmpty) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: Text(
                          'No available slots for this date',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  );
                }
                return TimeSlotPicker(
                  slots: availableSlots,
                  selectedSlot: _selectedSlot,
                  onSlotSelected: (slot) {
                    setState(() {
                      _selectedSlot = slot;
                    });
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Card(
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
            const SizedBox(height: 24),
            // Notes
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add any special requests...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            // Create Button
            FilledButton(
              onPressed: _selectedSlot == null ? null : _handleCreateBooking,
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Confirm Booking'),
            ),
          ],
        ),
      ),
    );
  }
}

