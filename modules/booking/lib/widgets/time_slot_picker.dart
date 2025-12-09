/// Time slot picker widget.
library;

import 'package:flutter/material.dart';

import '../models/time_slot.dart';

/// Widget for selecting time slots.
class TimeSlotPicker extends StatelessWidget {
  final List<TimeSlot> slots;
  final TimeSlot? selectedSlot;
  final ValueChanged<TimeSlot> onSlotSelected;

  const TimeSlotPicker({
    super.key,
    required this.slots,
    this.selectedSlot,
    required this.onSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: slots.map((slot) {
        final isSelected = selectedSlot?.startTime == slot.startTime;
        return ChoiceChip(
          label: Text(slot.formattedTimeRange),
          selected: isSelected,
          onSelected: (_) => onSlotSelected(slot),
        );
      }).toList(),
    );
  }
}

