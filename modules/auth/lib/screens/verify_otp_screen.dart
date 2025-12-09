/// OTP verification screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/auth_state.dart';
import '../providers/auth_provider.dart';

/// OTP verification screen for phone authentication.
class VerifyOtpScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const VerifyOtpScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authStateProvider.notifier).verifyOtp(
          phoneNumber: widget.phoneNumber,
          otp: _otpController.text.trim(),
        );

    final authState = ref.read(authStateProvider);
    if (authState.isAuthenticated) {
      if (mounted) {
        context.go('/');
      }
    } else if (authState.errorMessage != null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authState.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Icon(
                  Icons.sms_outlined,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: 24),
                Text(
                  'Enter OTP',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'We\'ve sent a verification code to\n${widget.phoneNumber}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                  maxLength: 6,
                  decoration: const InputDecoration(
                    hintText: '000000',
                    counterText: '',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'OTP is required';
                    }
                    if (value.length != 6) {
                      return 'OTP must be 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: authState.isLoading ? null : _handleVerify,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: authState.isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Verify'),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Resend OTP
                  },
                  child: const Text('Resend OTP'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

