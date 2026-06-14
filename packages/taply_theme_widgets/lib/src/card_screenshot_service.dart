import 'dart:typed_data';
import 'dart:ui' show PictureRecorder, Canvas, ImageByteFormat;
import 'package:taply_theme_engine/taply_theme_engine.dart';

/// Service for capturing rendered theme output as PNG images.
class CardScreenshotService {
  final ThemeEngine engine;

  const CardScreenshotService({required this.engine});

  /// Render a theme to an image and return raw pixel data.
  ///
  /// The returned bytes are in a raw RGBA format.
  Future<Uint8List> renderToImage(
    ThemeDocument document, {
    double width = 600,
    double height = 400,
    double pixelRatio = 2.0,
  }) async {
    final metrics = engine.createMetrics();
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    engine.render(document, metrics, canvas,
        viewportWidth: width, viewportHeight: height);

    final picture = recorder.endRecording();

    final image = await picture.toImage(
      (width * pixelRatio).round(),
      (height * pixelRatio).round(),
    );

    final byteData = await image.toByteData(
      format: ImageByteFormat.rawRgba,
    );

    picture.dispose();

    return byteData!.buffer.asUint8List();
  }
}
