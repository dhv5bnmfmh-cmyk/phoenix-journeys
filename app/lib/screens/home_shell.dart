import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/journey_background.dart';
import '../state/app_state.dart';
import '../services/interaction_audit_sink.dart';
import '../theme/phoenix_theme.dart';
import '../widgets/destination_background.dart';
import '../widgets/interaction_audit_probe.dart';
import '../widgets/journey_level_selector_button.dart';
import 'city_passport_screen.dart';
import 'explore_screen.dart';
import 'me_screen.dart';
import 'shadowing_training_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  Future<void> _showDiscovery(BuildContext context, AppState state) {
    return showModalBottomSheet<void>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: const Color(0xFFFFFBF3),
      builder: (sheetContext) => Padding(
        padding: const EdgeInsets.fromLTRB(18, 2, 18, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 18,
                  backgroundColor: Color(0xFF7B1E1E),
                  child: Icon(Icons.auto_awesome, color: Colors.white, size: 19),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    state.displayText('Discovery · 今日发现'),
                    style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w900,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              state.displayText(state.activeJourney.discoveryTeaser),
              style: const TextStyle(fontSize: 15, height: 1.35),
            ),
            const SizedBox(height: 10),
            Text(
              state.displayText('朗读后用探索者语言理解，再继续表达。'),
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _withInteractionBoundary({
    required BuildContext context,
    required AppState state,
    required Widget child,
  }) {
    if (!phoenixInteractionAuditEnabled) return child;
    return PhoenixHomeInteractionBoundary(
      selectedTab: state.selectedTab,
      onDiscoveryTap: () => _showDiscovery(context, state),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        final indexedPages = IndexedStack(
          index: state.selectedTab,
          children: const <Widget>[
            ExploreScreen(),
            CityPassportScreen(),
            ShadowingTrainingScreen(embedded: true),
            MeScreen(),
          ],
        );
        final pageType = switch (state.selectedTab) {
          1 => JourneyBackgroundPage.passport,
          3 => JourneyBackgroundPage.profile,
          _ => JourneyBackgroundPage.explore,
        };
        final baseContent = state.selectedTab == 0
            ? indexedPages
            : DestinationBackground(
                journeyId: state.activeJourneyId,
                pageType: pageType,
                child: indexedPages,
              );
        final content = Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(child: baseContent),
            const Positioned(
              top: 6,
              right: 8,
              child: JourneyLevelSelectorButton(compact: true),
            ),
          ],
        );

        if (isWide) {
          return _withInteractionBoundary(
            context: context,
            state: state,
            child: Scaffold(
              backgroundColor: Colors.transparent,
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
                      destinations: [
                        NavigationRailDestination(
                          icon: const Icon(Icons.public),
                          label: Text(state.displayText('探索')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.auto_stories),
                          label: Text(state.displayText('护照')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.mic_rounded),
                          label: Text(state.displayText('跟读训练')),
                        ),
                        NavigationRailDestination(
                          icon: const Icon(Icons.person_outline),
                          label: Text(state.displayText('我的')),
                        ),
                      ],
                    ),
                    const VerticalDivider(width: 1),
                    Expanded(
                      child: ColoredBox(
                        color: Colors.transparent,
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
            ),
          );
        }

        return _withInteractionBoundary(
          context: context,
          state: state,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: SafeArea(bottom: false, child: content),
            bottomNavigationBar: _CompactBottomNavigation(state: state),
          ),
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
          top: BorderSide(color: PhoenixTheme.gold.withValues(alpha: .24)),
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
                auditId: 'bottom-nav-explore',
                icon: Icons.public_rounded,
                label: state.displayText('探索'),
                selected: state.selectedTab == 0,
                onTap: () => state.setTab(0),
              ),
              _CompactNavItem(
                auditId: 'bottom-nav-passport',
                icon: Icons.auto_stories_rounded,
                label: state.displayText('护照'),
                selected: state.selectedTab == 1,
                onTap: () => state.setTab(1),
              ),
              _CompactNavItem(
                auditId: 'bottom-nav-shadowing',
                icon: Icons.mic_rounded,
                label: state.displayText('跟读训练'),
                selected: state.selectedTab == 2,
                onTap: () => state.setTab(2),
              ),
              _CompactNavItem(
                auditId: 'bottom-nav-me',
                icon: Icons.person_outline_rounded,
                label: state.displayText('我的'),
                selected: state.selectedTab == 3,
                onTap: () => state.setTab(3),
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
    required this.auditId,
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String auditId;
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
          key: ValueKey('interaction-audit-$auditId'),
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
