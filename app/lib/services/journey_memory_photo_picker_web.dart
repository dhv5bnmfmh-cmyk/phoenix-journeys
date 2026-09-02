import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

Future<List<Uint8List>> pickPhotos() async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = 'image/*'
    ..multiple = true;
  input.click();
  final changed = Completer<void>();
  input.onchange = ((web.Event _) => changed.complete()).toJS;
  await changed.future;
  final output = <Uint8List>[];
  final files = input.files;
  if (files == null) return output;
  for (var index = 0; index < files.length; index++) {
    final reader = web.FileReader();
    final loaded = Completer<void>();
    reader.onload = ((web.ProgressEvent _) => loaded.complete()).toJS;
    reader.readAsArrayBuffer(files.item(index)!);
    await loaded.future;
    output.add((reader.result as JSArrayBuffer).toDart.asUint8List());
  }
  return output;
}
