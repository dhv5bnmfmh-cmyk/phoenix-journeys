import 'dart:async';
import 'dart:js_interop';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:image/image.dart' as image_lib;
import 'package:web/web.dart' as web;

const int _maxPhotoLongEdge = 1600;
const int _jpegQuality = 82;

Future<Uint8List?> pickPhoto() async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = 'image/*'
    ..multiple = false;
  final settled = Completer<void>();

  void finish() {
    if (!settled.isCompleted) settled.complete();
  }

  input.onchange = ((web.Event _) => finish()).toJS;
  input.oncancel = ((web.Event _) => finish()).toJS;
  input.click();

  try {
    await settled.future.timeout(const Duration(minutes: 2));
  } on TimeoutException {
    return null;
  }

  final files = input.files;
  if (files == null || files.length == 0) return null;
  final file = files.item(0);
  if (file == null) return null;

  final reader = web.FileReader();
  final loaded = Completer<void>();
  reader.onload = ((web.ProgressEvent _) {
    if (!loaded.isCompleted) loaded.complete();
  }).toJS;
  reader.onerror = ((web.ProgressEvent _) {
    if (!loaded.isCompleted) {
      loaded.completeError(StateError('Photo read failed'));
    }
  }).toJS;
  reader.readAsArrayBuffer(file);
  await loaded.future;

  final raw = reader.result;
  if (raw is! JSArrayBuffer) throw StateError('Unsupported photo bytes');
  return _compressPhoto(raw.toDart.asUint8List());
}

Uint8List _compressPhoto(Uint8List bytes) {
  final decoded = image_lib.decodeImage(bytes);
  if (decoded == null || decoded.width <= 0 || decoded.height <= 0) {
    return bytes;
  }

  final longest = math.max(decoded.width, decoded.height);
  final resized = longest <= _maxPhotoLongEdge
      ? decoded
      : decoded.width >= decoded.height
          ? image_lib.copyResize(
              decoded,
              width: _maxPhotoLongEdge,
              interpolation: image_lib.Interpolation.average,
            )
          : image_lib.copyResize(
              decoded,
              height: _maxPhotoLongEdge,
              interpolation: image_lib.Interpolation.average,
            );
  return Uint8List.fromList(
    image_lib.encodeJpg(resized, quality: _jpegQuality),
  );
}
