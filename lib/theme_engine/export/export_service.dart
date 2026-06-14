import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import '../models/theme_document.dart';
import '../paint_engine/paint_engine.dart';
import '../renderer/render_pipeline.dart';

class ExportService {
  final RenderPipeline pipeline;
  final PaintEngine paintEngine;

  ExportService({
    RenderPipeline? pipeline,
    PaintEngine? paintEngine,
  })  : pipeline = pipeline ?? RenderPipeline(),
        paintEngine = paintEngine ?? PaintEngine();

  ui.Picture renderToPicture(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    final renderTree = pipeline.prepare(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    paintEngine.render(
      renderTree,
      document,
      canvas: canvas,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    return recorder.endRecording();
  }

  Future<ui.Image> renderToImage(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
    double pixelRatio = 3.0,
  }) async {
    final picture = renderToPicture(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    final image = await picture.toImage(
      (viewportWidth * pixelRatio).toInt(),
      (viewportHeight * pixelRatio).toInt(),
    );
    return image;
  }

  Future<Uint8List> renderToPngBytes(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
    double pixelRatio = 3.0,
  }) async {
    final image = await renderToImage(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
      pixelRatio: pixelRatio,
    );
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }

  PaintMetrics renderWithMetrics(
    ThemeDocument document, {
    ui.Canvas? canvas,
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    final renderTree = pipeline.prepare(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    return paintEngine.render(
      renderTree,
      document,
      canvas: canvas,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
  }

  Map<String, dynamic> exportToJson(ThemeDocument theme) {
    return theme.toJson();
  }

  String exportToJsonString(ThemeDocument theme) {
    return const JsonEncoder.withIndent('  ').convert(theme.toJson());
  }

  Map<String, dynamic> exportForApi(ThemeDocument theme) {
    return {
      'id': theme.metadata.id,
      'name': theme.metadata.name,
      'specVersion': theme.metadata.specVersion,
      'canvas': {
        'width': theme.canvas.width,
        'height': theme.canvas.height,
      },
      'scene': theme.scene.toJson(),
    };
  }
}
