import 'package:flutter/material.dart';

import '../theme/phoenix_theme.dart';

class DiscoveryAuthorityLine extends StatelessWidget {
  const DiscoveryAuthorityLine({
    required this.authorityLabels,
    super.key,
  });

  final List<String> authorityLabels;

  @override
  Widget build(BuildContext context) {
    final labels = authorityLabels
        .map((label) => label.trim())
        .where((label) => label.isNotEmpty)
        .toSet()
        .toList(growable: false);
    if (labels.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(3, 1, 3, 0),
      child: Text(
        '知识依据 · ${labels.join(' · ')}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: PhoenixTheme.journeyMetaStyle.copyWith(
          color: Colors.white70,
          fontSize: 9.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
