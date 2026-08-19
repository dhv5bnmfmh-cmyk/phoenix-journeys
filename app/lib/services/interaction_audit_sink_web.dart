// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:convert';
import 'dart:html' as html;

bool get phoenixInteractionAuditEnabled =>
    Uri.base.queryParameters['interaction_audit'] == '1';

void emitPhoenixInteractionAudit(
  String type, {
  Map<String, Object?> detail = const <String, Object?>{},
}) {
  if (!phoenixInteractionAuditEnabled) return;
  html.window.dispatchEvent(
    html.CustomEvent(
      'phoenix-interaction-audit',
      detail: jsonEncode(<String, Object?>{
        'type': type,
        ...detail,
      }),
    ),
  );
}
