import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/home_shell.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

class StartupGate extends StatelessWidget {
  const StartupGate({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return switch (state.loadStatus) {
      AppLoadStatus.loading => _StartupLoading(state: state),
      AppLoadStatus.error => _StartupError(
          state: state,
          message: state.displayText(
            state.loadErrorMessage ?? '暂时无法打开 Phoenix Journeys。',
          ),
          onRetry: state.load,
        ),
      AppLoadStatus.ready => const HomeShell(),
    };
  }
}

class _StartupLoading extends StatelessWidget {
  const _StartupLoading({required this.state});

  final AppState state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      body: SafeArea(
        child: Center(
          child: Semantics(
            label: state.displayText('Phoenix Journeys 正在载入'),
            liveRegion: true,
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PhoenixMark(),
                  const SizedBox(height: 24),
                  const CircularProgressIndicator(),
                  const SizedBox(height: 18),
                  Text(
                    state.displayText('正在准备你的旅程…'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.displayText('读取语言设置与学习记录'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StartupError extends StatelessWidget {
  const _StartupError({
    required this.state,
    required this.message,
    required this.onRetry,
  });

  final AppState state;
  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PhoenixTheme.paper,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(28),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const _PhoenixMark(),
                  const SizedBox(height: 24),
                  Text(
                    state.displayText('旅程暂时停在登机口'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(height: 1.5, color: Colors.black54),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh),
                    label: Text(state.displayText('重新尝试')),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PhoenixMark extends StatelessWidget {
  const _PhoenixMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: PhoenixTheme.red,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            blurRadius: 24,
            offset: Offset(0, 12),
            color: Color(0x26000000),
          ),
        ],
      ),
      child: const Icon(
        Icons.local_fire_department,
        size: 40,
        color: Colors.white,
      ),
    );
  }
}
