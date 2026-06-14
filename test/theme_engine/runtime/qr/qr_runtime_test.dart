import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:business_card/theme_engine/runtime/qr/qr_runtime.dart';

void main() {
  group('QRRuntime', () {
    test('generateQRImage returns an image', () async {
      final qr = QRRuntime();
      final image = await qr.generateQRImage('https://example.com', size: 100);
      expect(image, isA<ui.Image>());
      expect(image.width, 100);
      expect(image.height, 100);
    });

    test('generateQrPngBytes returns non-empty bytes', () async {
      final qr = QRRuntime();
      final bytes = await qr.generateQrPngBytes('Hello QR', size: 100);
      expect(bytes, isA<Uint8List>());
      expect(bytes.length, greaterThan(0));
    });

    test('generateQRImage works with empty string', () async {
      final qr = QRRuntime();
      final image = await qr.generateQRImage('', size: 100);
      expect(image, isA<ui.Image>());
    });

    test('generateQRImage works with long data', () async {
      final qr = QRRuntime();
      final image = await qr.generateQRImage('A' * 100, size: 200);
      expect(image.width, 200);
    });
  });
}
