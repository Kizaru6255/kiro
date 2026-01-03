/// Main shell template with bottom navigation.
library;

/// Generate main shell with bottom navigation.
String generateMainShell({
  required String appName,
  required List<String> modules,
  required List<String> bottomNavTabs,
  required bool hasNotifications,
}) {
  final tabs = StringBuffer();
  final imports = StringBuffer();
  
  // Generate imports
  imports.writeln("import '../../config/router.dart';");
  imports.writeln("import '../home/home_screen.dart';");
  for (final tab in bottomNavTabs) {
    if (tab == 'home') continue;
    if (tab == 'chat') {
      imports.writeln("import '../../modules/chat/presentation/screens/chat_list_screen.dart';");
    } else if (tab == 'profile') {
      imports.writeln("import '../../modules/profile/presentation/screens/profile_screen.dart';");
    } else if (tab == 'wallet') {
      imports.writeln("import '../../modules/wallet/presentation/screens/wallet_screen.dart';");
    } else if (tab == 'booking') {
      imports.writeln("import '../../modules/booking/presentation/screens/bookings_screen.dart';");
    }
  }
  
  // Generate tab configurations
  for (var i = 0; i < bottomNavTabs.length; i++) {
    final tab = bottomNavTabs[i];
    final tabName = tab == 'home' ? 'Home' : _capitalize(tab);
    final tabRoute = _getTabRoute(tab);
    final tabIcon = _getTabIcon(tab);
    final tabLabel = tabName;
    final screenWidget = _getScreenWidget(tab);
    
    tabs.writeln('    _TabConfig(');
    tabs.writeln('      route: $tabRoute,');
    tabs.writeln('      icon: $tabIcon,');
    tabs.writeln('      label: \'$tabLabel\',');
    tabs.writeln('      screen: $screenWidget,');
    tabs.writeln('    ),');
  }
  
  final tabsContent = tabs.toString();
  final importsContent = imports.toString();
  
  return '''/// Main app shell with bottom navigation.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

$importsContent
/// Main shell with bottom navigation bar.
class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _currentIndex = 0;

  final List<_TabConfig> _tabs = [
$tabsContent
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
''';
}

String _getScreenWidget(String tab) {
  switch (tab) {
    case 'home':
      return 'const HomeScreen()';
    case 'chat':
      return 'const ChatListScreen()';
    case 'profile':
      return 'const ProfileScreen()';
    case 'wallet':
      return 'const WalletScreen()';
    case 'booking':
      return 'const BookingsScreen()';
    default:
      return 'const SizedBox()';
  }
}

String _getTabRoute(String tab) {
  switch (tab) {
    case 'home':
      return 'AppRoutes.home';
    case 'chat':
      return 'AppRoutes.chat_list';
    case 'profile':
      return 'AppRoutes.profile';
    case 'wallet':
      return 'AppRoutes.wallet';
    case 'booking':
      return 'AppRoutes.bookings';
    default:
      return 'AppRoutes.home';
  }
}

String _getTabIcon(String tab) {
  switch (tab) {
    case 'home':
      return 'Icons.home';
    case 'chat':
      return 'Icons.chat';
    case 'profile':
      return 'Icons.person';
    case 'wallet':
      return 'Icons.account_balance_wallet';
    case 'booking':
      return 'Icons.calendar_today';
    default:
      return 'Icons.circle';
  }
}

String _capitalize(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}
