/// Booking calendar widget.
library;

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../models/booking.dart';

/// Calendar widget showing bookings.
class BookingCalendar extends StatelessWidget {
  final List<Booking> bookings;
  final DateTime focusedDay;
  final DateTime? selectedDay;
  final OnDaySelected? onDaySelected;

  const BookingCalendar({
    super.key,
    required this.bookings,
    required this.focusedDay,
    this.selectedDay,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      firstDay: DateTime.now(),
      lastDay: DateTime.now().add(const Duration(days: 365)),
      focusedDay: focusedDay,
      selectedDayPredicate: (day) =>
          selectedDay != null && isSameDay(selectedDay, day),
      onDaySelected: onDaySelected,
      eventLoader: (day) {
        return bookings
            .where((booking) => isSameDay(booking.startTime, day))
            .toList();
      },
      calendarFormat: CalendarFormat.month,
      startingDayOfWeek: StartingDayOfWeek.monday,
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
      ),
      calendarStyle: CalendarStyle(
        markerDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

