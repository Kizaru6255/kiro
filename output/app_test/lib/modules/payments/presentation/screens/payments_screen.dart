/// Payments history screen.
library;

import 'package:flutter/material.dart';

/// Screen displaying payment history.
class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
      ),
      body: const Center(
        child: Text('Payment history will be displayed here'),
      ),
    );
  }
}

