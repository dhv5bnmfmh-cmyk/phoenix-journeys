import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import 'explore_screen.dart';
import 'passport_screen.dart';
import 'me_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    const pages = [
      ExploreScreen(),
      PassportScreen(),
      MeScreen(),
    ];

    return Scaffold(
      body: SafeArea(child: pages[state.selectedTab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: state.selectedTab,
        onDestinationSelected: state.setTab,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.public), label: '探索'),
          NavigationDestination(icon: Icon(Icons.auto_stories), label: '护照'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: '我的'),
        ],
      ),
    );
  }
}
