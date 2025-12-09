/// Amount input field widget.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Custom input field for amount entry.
class AmountInputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final String? currency;
  final ValueChanged<String>? onChanged;

  const AmountInputField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.currency,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
      ],
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint ?? 'Enter amount',
        prefixText: currency != null ? '$currency ' : null,
        prefixIcon: const Icon(Icons.currency_rupee),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Amount is required';
        }
        final amount = double.tryParse(value);
        if (amount == null || amount <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }
}

