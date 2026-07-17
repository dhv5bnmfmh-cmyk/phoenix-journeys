import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';
import 'explore_screen.dart';
import 'me_screen.dart';
import 'passport_screen.dart';

class HomeShell extends StatelessWidget {
  const HomeShell({super.key});

  static const _pages = [
    ExploreScreen(),
    PassportScreen(),
    MeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        final content = IndexedStack(
          index: state.selectedTab,
          children: _pages,
        );

        if (isWide) {
          return Scaffold(
            backgroundColor: PhoenixTheme.paper,
            body: SafeArea(
              child: Row(
                children: [
                  NavigationRail(
                    selectedIndex: state.selectedTab,
                    onDestinationSelected: state.setTab,
                    labelType: NavigationRailLabelType.all,
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 12, bottom: 20),
                      child: _PhoenixRailMark(),
                    ),
                    destinations: const [
                      NavigationRailDestination(
                        icon: Icon(Icons.public),
                        label: Text('探索'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.auto_stories),
                        label: Text('护照'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.person_outline),
                        label: Text('我的'),
                      ),
                    ],
                  ),
                  const VerticalDivider(width: 1),
                  Expanded(
                    child: ColoredBox(
                      color: PhoenixTheme.paper,
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 760),
                          child: content,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Scaffold(
          body: SafeArea(bottom: false, child: content),
          bottomNavigationBar: SafeArea(
            top: false,
            child: NavigationBar(
              selectedIndex: state.selectedTab,
              onDestinationSelected: state.setTab,
              destinations: const [
                NavigationDestination(icon: Icon(Icons.public), label: '探索'),
                NavigationDestination(
                  icon: Icon(Icons.auto_stories),
                  label: '护照',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  label: '我的',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PhoenixRailMark extends StatelessWidget {
  const _PhoenixRailMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: PhoenixTheme.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Icon(Icons.local_fire_department, color: Colors.white),
    );
  }
}
