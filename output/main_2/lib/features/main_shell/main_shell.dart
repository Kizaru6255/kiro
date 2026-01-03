/// Main app shell with bottom navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../config/router.dart';
import '../home/home_screen.dart';
import '../../modules/chat/presentation/screens/chat_list_screen.dart';
import '../../modules/wallet/presentation/screens/wallet_screen.dart';
import '../../modules/profile/presentation/screens/profile_screen.dart';

/// Main shell with bottom navigation bar.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final List<_TabConfig> _tabs = [
    _TabConfig(
      route: AppRoutes.home,
      icon: Icons.home,
      label: 'Home',
      screen: const HomeScreen(),
    ),
    _TabConfig(
      route: AppRoutes.chat_list,
      icon: Icons.chat,
      label: 'Chat',
      screen: const ChatListScreen(),
    ),
    _TabConfig(
      route: AppRoutes.wallet,
      icon: Icons.account_balance_wallet,
      label: 'Wallet',
      screen: const WalletScreen(),
    ),
    _TabConfig(
      route: AppRoutes.profile,
      icon: Icons.person,
      label: 'Profile',
      screen: const ProfileScreen(),
    ),

  ];

  void _onTabTapped(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _currentIndex = index;
    });
    // Navigate to the route for the selected tab
    final tab = _tabs[index];
    context.go(tab.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs.map((tab) => tab.screen).toList(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        items: _tabs.map((tab) => BottomNavigationBarItem(
          icon: Icon(tab.icon),
          label: tab.label,
        )).toList(),
      ),
    );
  }
}

class _TabConfig {
  final String route;
  final IconData icon;
  final String label;
  final Widget screen;

  const _TabConfig({
    required this.route,
    required this.icon,
    required this.label,
    required this.screen,
  });
}
