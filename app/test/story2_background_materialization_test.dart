import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

const _names = <String>[
  '01-palace-axis-soft-morning',
  '02-roofline-haze',
  '03-red-wall-eaves',
  '04-doorway-observer',
  '05-golden-courtyard',
  '06-courtyard-profile',
  '07-old-paper-shadow',
  '08-old-paper-light',
  '09-palace-wall-sunset',
  '10-quiet-palace-edge',
];

void main() {
  test('materializes the ten reviewed Story 2 runtime backgrounds', () {
    final directory = Directory(
      'assets/images/backgrounds/generated/beijing/forbidden-city/'
      'wuying-hall-light-limit',
    );
    final source = File('${directory.path}/contact.webp.b64');
    expect(source.existsSync(), isTrue);

    final contact = img.decodeImage(base64Decode(source.readAsStringSync()));
    expect(contact, isNotNull);
    expect(contact!.width, 450);
    expect(contact.height, 320);

    for (var index = 0; index < _names.length; index += 1) {
      final tile = img.copyCrop(
        contact,
        x: (index % 5) * 90,
        y: (index ~/ 5) * 160,
        width: 90,
        height: 160,
      );
      final runtimeImage = img.copyResize(
        tile,
        width: 360,
        height: 640,
        interpolation: img.Interpolation.linear,
      );
      final target = File('${directory.path}/${_names[index]}.png');
      target.writeAsBytesSync(img.encodePng(runtimeImage), flush: true);
      expect(target.existsSync(), isTrue);
      expect(target.lengthSync(), greaterThan(1000));
    }
  });
}
