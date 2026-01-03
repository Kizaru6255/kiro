/// Biometric authentication button.
library;

import 'package:flutter/material.dart';

/// Button for biometric authentication (fingerprint/face ID).
class BiometricButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final IconData icon;

  const BiometricButton({
    super.key,
    this.onPressed,
    IconData? icon,
  }) : icon = icon ?? Icons.fingerprint;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      iconSize: 32,
      tooltip: 'Use biometric authentication',
    );
  }
}

