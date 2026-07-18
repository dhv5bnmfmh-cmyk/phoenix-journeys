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
          bottomNavigationBar: _CompactBottomNavigation(state: state),
        );
      },
    );
  }
}

class _CompactBottomNavigation extends StatelessWidget {
  const _CompactBottomNavigation({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        border: Border(
          top: BorderSide(
            color: PhoenixTheme.gold.withValues(alpha: .24),
          ),
        ),
        boxShadow: const [
          BoxShadow(
            blurRadius: 12,
            offset: Offset(0, -3),
            color: Color(0x12000000),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 50,
          child: Row(
            children: [
              _CompactNavItem(
                icon: Icons.public_rounded,
                label: state.displayText('探索'),
                selected: state.selectedTab == 0,
                onTap: () => state.setTab(0),
              ),
              _CompactNavItem(
                icon: Icons.auto_stories_rounded,
                label: state.displayText('护照'),
                selected: state.selectedTab == 1,
                onTap: () => state.setTab(1),
              ),
              _CompactNavItem(
                icon: Icons.person_outline_rounded,
                label: state.displayText('我的'),
                selected: state.selectedTab == 2,
                onTap: () => state.setTab(2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompactNavItem extends StatelessWidget {
  const _CompactNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = selected ? PhoenixTheme.red : Colors.black54;

    return Expanded(
      child: Semantics(
        button: true,
        selected: selected,
        label: label,
        child: InkWell(
          onTap: onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 160),
                width: 30,
                height: 24,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? PhoenixTheme.red.withValues(alpha: .09)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Icon(icon, size: 19, color: color),
              ),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 9.5,
                  height: 1.05,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
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
