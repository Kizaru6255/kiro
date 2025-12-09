/// Social login button widget.
library;

import 'package:flutter/material.dart';

/// Social login types.
enum SocialLoginType {
  google,
  apple,
  facebook,
}

/// Button for social login.
class SocialLoginButton extends StatelessWidget {
  final SocialLoginType type;
  final VoidCallback? onPressed;

  const SocialLoginButton({
    super.key,
    required this.type,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final (icon, text) = switch (type) {
      SocialLoginType.google => (
          Icons.g_mobiledata,
          'Continue with Google',
        ),
      SocialLoginType.apple => (
          Icons.apple,
          'Continue with Apple',
        ),
      SocialLoginType.facebook => (
          Icons.facebook,
          'Continue with Facebook',
        ),
    };

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(text),
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }
}

