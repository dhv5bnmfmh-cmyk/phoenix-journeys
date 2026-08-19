// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:html' as html;

void notifyPhoenixStartupSettled({required bool ready}) {
  html.window.dispatchEvent(
    html.CustomEvent(
      'phoenix-startup-settled',
      detail: ready ? 'ready' : 'error',
    ),
  );
}
