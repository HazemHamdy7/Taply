import 'dart:typed_data';
import 'dart:ui' as ui;

import '../runtime_cache.dart';
import '../runtime_exception.dart';

class QRRuntime {
  final RuntimeCache? cache;

  QRRuntime({this.cache});

  Future<ui.Image> generateQRImage(
    String data, {
    double size = 200,
    ui.Color foreground = const ui.Color(0xFF000000),
    ui.Color background = const ui.Color(0xFFFFFFFF),
    bool useCache = true,
  }) async {
    final cacheKey = 'qr_${data.hashCode}_${size}_${foreground.value}_${background.value}';

    if (useCache && cache != null) {
      final cached = cache!.getImage(cacheKey);
      if (cached != null) return cached;
    }

    final image = await _renderQR(data, size, foreground, background);

    if (useCache && cache != null) {
      cache!.cacheImage(cacheKey, image);
    }

    return image;
  }

  Future<Uint8List> generateQrPngBytes(
    String data, {
    double size = 200,
    ui.Color foreground = const ui.Color(0xFF000000),
    ui.Color background = const ui.Color(0xFFFFFFFF),
  }) async {
    final image = await generateQRImage(
      data,
      size: size,
      foreground: foreground,
      background: background,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) {
      throw const QRGenerationException('Failed to encode QR as PNG');
    }
    return byteData.buffer.asUint8List();
  }

  Future<ui.Image> _renderQR(
    String data,
    double size,
    ui.Color foreground,
    ui.Color background,
  ) async {
    final sizeInt = size.toInt();
    final qrCode = _generateQRCode(data);
    final pixelSize = qrCode.length;
    final cellSize = sizeInt / pixelSize;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final bgPaint = ui.Paint()..color = background;
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, sizeInt.toDouble(), sizeInt.toDouble()),
      bgPaint,
    );

    final fgPaint = ui.Paint()..color = foreground;
    for (var y = 0; y < pixelSize; y++) {
      for (var x = 0; x < pixelSize; x++) {
        if (qrCode[y][x] == 1) {
          canvas.drawRect(
            ui.Rect.fromLTWH(
              x * cellSize,
              y * cellSize,
              cellSize,
              cellSize,
            ),
            fgPaint,
          );
        }
      }
    }

    final picture = recorder.endRecording();
    return picture.toImage(sizeInt, sizeInt);
  }

  List<List<int>> _generateQRCode(String data) {
    final length = data.length;
    final version = _selectVersion(length);
    final size = version * 4 + 17;
    final code = List.generate(size, (_) => List.filled(size, 0));

    _addFinderPatterns(code, size);
    _addTimingPatterns(code, size);
    _addData(code, data, size);

    return code;
  }

  int _selectVersion(int dataLength) {
    if (dataLength <= 10) return 1;
    if (dataLength <= 20) return 2;
    if (dataLength <= 40) return 3;
    if (dataLength <= 80) return 4;
    if (dataLength <= 160) return 5;
    if (dataLength <= 320) return 6;
    if (dataLength <= 640) return 7;
    return 8;
  }

  void _addFinderPatterns(List<List<int>> code, int size) {
    for (final (cx, cy) in [(0, 0), (size - 7, 0), (0, size - 7)]) {
      for (var y = 0; y < 7; y++) {
        for (var x = 0; x < 7; x++) {
          if (cy + y < size && cx + x < size) {
            if (y == 0 || y == 6 || x == 0 || x == 6) {
              code[cy + y][cx + x] = 1;
            } else if ((y >= 2 && y <= 4) && (x >= 2 && x <= 4)) {
              code[cy + y][cx + x] = 1;
            }
          }
        }
      }
    }
  }

  void _addTimingPatterns(List<List<int>> code, int size) {
    for (var i = 8; i < size - 8; i++) {
      code[6][i] = i.isEven ? 1 : 0;
      code[i][6] = i.isEven ? 1 : 0;
    }
  }

  void _addData(List<List<int>> code, String data, int size) {
    final bytes = data.codeUnits;
    var bitIndex = 0;
    var x = size - 1;
    var y = size - 1;
    var goingUp = true;

    while (x > 0) {
      if (x == 6) x--;
      for (var i = 0; i < 2; i++) {
        final cx = x - i;
        if (cx >= 0) {
          if (_isDataArea(cx, y, size)) {
            final byteIndex = bitIndex ~/ 8;
            final bitPos = 7 - (bitIndex % 8);
            if (byteIndex < bytes.length) {
              code[y][cx] = ((bytes[byteIndex] >> bitPos) & 1);
            } else {
              code[y][cx] = 0;
            }
            bitIndex++;
          }
        }
      }
      if (goingUp) {
        y--;
        if (y < 0) {
          goingUp = false;
          x -= 2;
          y = 0;
        }
      } else {
        y++;
        if (y >= size) {
          goingUp = true;
          x -= 2;
          y = size - 1;
        }
      }
    }
  }

  bool _isDataArea(int x, int y, int size) {
    if (x < 9 && y < 9) return false;
    if (x >= size - 8 && y < 9) return false;
    if (x < 9 && y >= size - 8) return false;
    if (x == 6 || y == 6) return false;
    return true;
  }
}
