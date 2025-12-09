/// Edit profile screen.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/profile_provider.dart';

/// Screen for editing user profile.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(profileNotifierProvider.notifier).updateProfile(
          displayName: _displayNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          bio: _bioController.text.trim().isEmpty
              ? null
              : _bioController.text.trim(),
        );

    final profileAsync = ref.read(profileNotifierProvider);
    profileAsync.whenData((_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully!')),
        );
        context.pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: profileAsync.when(
        data: (profile) {
          _displayNameController.text = profile.displayName ?? '';
          _phoneController.text = profile.phoneNumber ?? '';
          _bioController.text = profile.bio ?? '';

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _displayNameController,
                    decoration: const InputDecoration(
                      labelText: 'Display Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Display name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    decoration: const InputDecoration(
                      labelText: 'Bio (Optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  FilledButton(
                    onPressed: _handleSave,
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: ${error.toString()}'),
        ),
      ),
    );
  }
}

