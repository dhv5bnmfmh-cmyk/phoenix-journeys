import 'package:flutter/material.dart';

import '../services/interaction_audit_sink.dart';
import '../services/phoenix_level_controller.dart';

final NavigatorObserver phoenixInteractionAuditNavigatorObserver =
    _PhoenixInteractionAuditNavigatorObserver();

class _PhoenixInteractionAuditNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    emitPhoenixInteractionAudit(
      'route-push',
      detail: <String, Object?>{
        'routeType': route.runtimeType.toString(),
        'routeName': route.settings.name,
      },
    );
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    emitPhoenixInteractionAudit(
      'route-pop',
      detail: <String, Object?>{
        'routeType': route.runtimeType.toString(),
        'routeName': route.settings.name,
      },
    );
  }
}

class PhoenixHomeInteractionBoundary extends StatefulWidget {
  const PhoenixHomeInteractionBoundary({
    super.key,
    required this.selectedTab,
    required this.onDiscoveryTap,
    required this.child,
  });

  final int selectedTab;
  final VoidCallback onDiscoveryTap;
  final Widget child;

  @override
  State<PhoenixHomeInteractionBoundary> createState() =>
      _PhoenixHomeInteractionBoundaryState();
}

class _PhoenixHomeInteractionBoundaryState
    extends State<PhoenixHomeInteractionBoundary> {
  final PhoenixLevelController _levelController = PhoenixLevelController.instance;
  Rect? _discoveryRect;
  Offset? _pointerDownPosition;
  bool _pointerDownOnDiscovery = false;
  bool _scanScheduled = false;
  late int _lastSelectedTab;

  @override
  void initState() {
    super.initState();
    _lastSelectedTab = widget.selectedTab;
    _levelController.addListener(_handleLevelChanged);
  }

  @override
  void didUpdateWidget(covariant PhoenixHomeInteractionBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedTab != _lastSelectedTab) {
      _lastSelectedTab = widget.selectedTab;
      emitPhoenixInteractionAudit(
        'home-tab-state',
        detail: <String, Object?>{'selectedTab': widget.selectedTab},
      );
    }
  }

  @override
  void dispose() {
    _levelController.removeListener(_handleLevelChanged);
    super.dispose();
  }

  void _handleLevelChanged() {
    emitPhoenixInteractionAudit(
      'level-state',
      detail: <String, Object?>{'level': _levelController.level},
    );
    _scheduleTargetScan();
  }

  Rect? _rectForElement(Element element) {
    final renderObject = element.findRenderObject();
    if (renderObject is! RenderBox || !renderObject.hasSize) return null;
    final origin = renderObject.localToGlobal(Offset.zero);
    return origin & renderObject.size;
  }

  bool _subtreeHasStartJourneyLabel(Element root) {
    var found = false;
    void visit(Element element) {
      if (found) return;
      final widget = element.widget;
      if (widget is Text) {
        final text = widget.data ?? '';
        if (text.contains('Journey') || text.startsWith('再次探索')) {
          found = true;
          return;
        }
      }
      element.visitChildElements(visit);
    }

    root.visitChildElements(visit);
    return found;
  }

  void _publishRect(String id, Rect rect) {
    emitPhoenixInteractionAudit(
      'target-rect',
      detail: <String, Object?>{
        'id': id,
        'x': rect.left,
        'y': rect.top,
        'width': rect.width,
        'height': rect.height,
      },
    );
  }

  void _scheduleTargetScan() {
    if (_scanScheduled || !mounted) return;
    _scanScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scanScheduled = false;
      if (!mounted) return;
      _scanTargets();
    });
  }

  void _scanTargets() {
    Rect? discovery;
    final targets = <String, Rect>{};

    void visit(Element element) {
      final widget = element.widget;
      final key = widget.key;
      if (key is ValueKey<String>) {
        final id = switch (key.value) {
          'choose-city-journey' => 'city-selector',
          'phoenix-level-plus' => 'level-plus',
          'phoenix-level-minus' => 'level-minus',
          'interaction-audit-bottom-nav-explore' => 'bottom-nav-explore',
          'interaction-audit-bottom-nav-passport' => 'bottom-nav-passport',
          _ => null,
        };
        if (id != null) {
          final rect = _rectForElement(element);
          if (rect != null && !rect.isEmpty) targets[id] = rect;
        }
      }

      if (widget is FilledButton && _subtreeHasStartJourneyLabel(element)) {
        final rect = _rectForElement(element);
        if (rect != null && !rect.isEmpty) targets['start-journey'] = rect;
      }

      if (widget is Text) {
        final text = widget.data ?? '';
        if (text.startsWith('Discovery ·')) {
          final rect = _rectForElement(element);
          if (rect != null && !rect.isEmpty) {
            discovery = rect.inflate(6);
            targets['discovery'] = discovery!;
          }
        }
      }

      element.visitChildElements(visit);
    }

    context.visitChildElements(visit);
    _discoveryRect = widget.selectedTab == 0 ? discovery : null;

    if (!phoenixInteractionAuditEnabled) return;
    for (final entry in targets.entries) {
      _publishRect(entry.key, entry.value);
    }
    emitPhoenixInteractionAudit(
      'targets-ready',
      detail: <String, Object?>{
        'selectedTab': widget.selectedTab,
        'ids': targets.keys.join(','),
      },
    );
  }

  void _onPointerDown(PointerDownEvent event) {
    _pointerDownPosition = event.position;
    _pointerDownOnDiscovery =
        widget.selectedTab == 0 &&
        (_discoveryRect?.contains(event.position) ?? false);
    emitPhoenixInteractionAudit(
      'flutter-pointer-down',
      detail: <String, Object?>{
        'x': event.position.dx,
        'y': event.position.dy,
        'kind': event.kind.name,
      },
    );
  }

  void _onPointerUp(PointerUpEvent event) {
    emitPhoenixInteractionAudit(
      'flutter-pointer-up',
      detail: <String, Object?>{
        'x': event.position.dx,
        'y': event.position.dy,
        'kind': event.kind.name,
      },
    );

    final down = _pointerDownPosition;
    final shouldOpenDiscovery =
        _pointerDownOnDiscovery &&
        down != null &&
        (event.position - down).distance <= 12 &&
        (_discoveryRect?.contains(event.position) ?? false);
    _pointerDownPosition = null;
    _pointerDownOnDiscovery = false;

    if (shouldOpenDiscovery) {
      emitPhoenixInteractionAudit('discovery-callback');
      widget.onDiscoveryTap();
    }
  }

  @override
  Widget build(BuildContext context) {
    _scheduleTargetScan();
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: widget.child,
    );
  }
}
