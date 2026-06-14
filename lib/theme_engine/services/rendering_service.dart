import 'dart:typed_data';
import 'dart:ui' as ui;

import '../export/export_service.dart';
import '../models/theme_document.dart';
import '../models/validation_report.dart';
import '../paint_engine/paint_engine.dart';
import '../parser/theme_parser.dart';
import '../renderer/render_pipeline.dart';
import '../renderer/render_tree.dart';
import '../services/theme_validator.dart';

class RenderingService {
  final ThemeParser parser;
  final ThemeValidator validator;
  final RenderPipeline pipeline;
  final PaintEngine paintEngine;
  final ExportService exportService;

  RenderingService({
    ThemeParser? parser,
    ThemeValidator? validator,
    RenderPipeline? pipeline,
    PaintEngine? paintEngine,
    ExportService? exportService,
  })  : parser = parser ?? ThemeParser(),
        validator = validator ?? ThemeValidator(),
        pipeline = pipeline ?? RenderPipeline(),
        paintEngine = paintEngine ?? PaintEngine(),
        exportService = exportService ?? ExportService();

  ThemeDocument parse(Map<String, dynamic> json) => parser.parse(json);

  ThemeDocument parseString(String jsonString) => parser.parseString(jsonString);

  ValidationReport validate(ThemeDocument document) =>
      validator.validate(document);

  RenderTree prepare(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    return pipeline.prepare(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
  }

  PaintMetrics render(
    ThemeDocument document, {
    ui.Canvas? canvas,
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    return exportService.renderWithMetrics(
      document,
      canvas: canvas,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
  }

  Future<ui.Image> renderToImage(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
    double pixelRatio = 3.0,
  }) async {
    return exportService.renderToImage(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
      pixelRatio: pixelRatio,
    );
  }

  Future<Uint8List> renderToPngBytes(
    ThemeDocument document, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
    double pixelRatio = 3.0,
  }) async {
    return exportService.renderToPngBytes(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
      pixelRatio: pixelRatio,
    );
  }

  RenderingResult renderFullPipeline(
    String jsonString, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    final sw = Stopwatch()..start();

    final parseSw = Stopwatch()..start();
    final document = parseString(jsonString);
    parseSw.stop();

    final validateSw = Stopwatch()..start();
    final report = validate(document);
    validateSw.stop();

    final prepareSw = Stopwatch()..start();
    final renderTree = prepare(
      document,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    prepareSw.stop();

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);

    final renderSw = Stopwatch()..start();
    final metrics = render(
      document,
      canvas: canvas,
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
    );
    renderSw.stop();

    final picture = recorder.endRecording();
    sw.stop();

    return RenderingResult(
      document: document,
      validationReport: report,
      renderTree: renderTree,
      picture: picture,
      metrics: metrics,
      parseTime: parseSw.elapsed,
      validateTime: validateSw.elapsed,
      prepareTime: prepareSw.elapsed,
      renderTime: renderSw.elapsed,
      totalTime: sw.elapsed,
    );
  }
}

class RenderingResult {
  final ThemeDocument document;
  final ValidationReport validationReport;
  final RenderTree renderTree;
  final ui.Picture picture;
  final PaintMetrics metrics;
  final Duration parseTime;
  final Duration validateTime;
  final Duration prepareTime;
  final Duration renderTime;
  final Duration totalTime;

  const RenderingResult({
    required this.document,
    required this.validationReport,
    required this.renderTree,
    required this.picture,
    required this.metrics,
    required this.parseTime,
    required this.validateTime,
    required this.prepareTime,
    required this.renderTime,
    required this.totalTime,
  });

  bool get isValid => validationReport.isValid;
  bool get renderSuccess => metrics.failedNodes == 0;
  int get totalNodes => metrics.totalProcessed;
  int get paintedNodes => metrics.paintedNodes;
}
