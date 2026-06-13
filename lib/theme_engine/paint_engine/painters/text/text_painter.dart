import 'dart:ui' show
    Canvas, Paint, Color, Rect, PictureRecorder, PaintingStyle;
import 'package:flutter/painting.dart' show
    TextPainter, TextSpan, TextStyle, LineMetrics;

import '../../../models/theme_canvas.dart';
import '../../../models/theme_document.dart';
import '../../../models/theme_metadata.dart';
import '../../../renderer/render_node.dart';
import '../../../renderer/render_tree.dart';
import '../../base_painter.dart';
import '../../paint_capabilities.dart';
import '../../paint_context.dart';
import '../../paint_result.dart';
import 'text_paint_metrics.dart';
import 'text_paint_options.dart';
import 'text_painter_diagnostics.dart';

class TextPainterElement extends BasePainter {
  final TextPaintMetrics _metrics = TextPaintMetrics();
  final TextPainterDiagnostics _diagnostics = TextPainterDiagnostics();
  final Paint _debugPaint = Paint();
  TextPaintOptions? _lastOptions;
  TextPainter? _fillPainter;
  TextPainter? _strokePainter;
  TextStyle? _cachedFillStyle;
  TextStyle? _cachedStrokeStyle;

  TextPaintMetrics get metrics => _metrics;
  TextPainterDiagnostics get diagnostics => _diagnostics;

  @override
  String get type => 'text';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.advanced;

  @override
  bool canPaint(RenderPaintNode node) => node.type == 'text';

  @override
  void initialize() {
    _metrics.reset();
    _diagnostics.reset();
    _fillPainter?.dispose();
    _fillPainter = null;
    _strokePainter?.dispose();
    _strokePainter = null;
  }

  @override
  void prepare(PaintContext context) {
    _lastOptions = TextPaintOptions.fromNode(context.renderNode);
    _diagnostics.recordAllocation();
  }

  void cleanup() {
    _lastOptions = null;
    _diagnostics.reset();
  }

  @override
  PaintResult paint(PaintContext context) {
    final sw = Stopwatch()..start();
    final canvas = context.canvas;
    if (canvas == null) {
      _diagnostics.recordError('Canvas is null');
      return PaintResult.failure('Canvas is null');
    }
    final options = _lastOptions ?? TextPaintOptions.fromNode(context.renderNode);

    if (!options.visible || options.text.isEmpty) {
      _metrics.recordCacheMiss();
      _diagnostics.recordSkipped(options.text.isEmpty ? 'Empty text' : 'Not visible');
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'text');
    }

    final rect = options.rect;
    final text = options.text;

    canvas.save();
    _diagnostics.recordLayoutOp('canvas.save');
    try {
      _applyTransform(canvas, options, rect);
      _applyClip(canvas, options, rect);

      _cachedFillStyle = options.style.buildTextStyle();
      _fillPainter ??= TextPainter();
      _fillPainter!
        ..text = TextSpan(text: text, style: _cachedFillStyle)
        ..textAlign = options.style.textAlign
        ..textDirection = options.style.textDirection
        ..maxLines = options.style.maxLines
        ..ellipsis = options.style.ellipsis
        ..locale = null;

      final layoutSw = Stopwatch()..start();
      _fillPainter!.layout(maxWidth: rect.width);
      layoutSw.stop();
      _metrics.recordLayoutTime(layoutSw.elapsed);
      _diagnostics.recordLayoutOp('layout(${text.length} chars)');

      final lines = _fillPainter!.computeLineMetrics();
      _metrics.recordCharacter(text.length);
      _metrics.recordLine(lines.length);
      _diagnostics.recordLayoutOp('lines: ${lines.length}');

      if (options.style.hasStroke) {
        _cachedStrokeStyle = options.style.buildStrokeTextStyle();
        _strokePainter ??= TextPainter();
        _strokePainter!
          ..text = TextSpan(text: text, style: _cachedStrokeStyle)
          ..textAlign = options.style.textAlign
          ..textDirection = options.style.textDirection
          ..maxLines = options.style.maxLines
          ..ellipsis = options.style.ellipsis
          ..locale = null;

        final strokeSw = Stopwatch()..start();
        _strokePainter!.layout(maxWidth: rect.width);
        strokeSw.stop();
        _metrics.recordLayoutTime(strokeSw.elapsed);
        _diagnostics.recordLayoutOp('stroke layout');

        _strokePainter!.paint(canvas, rect.topLeft);
        _diagnostics.recordPaintOp('canvas.drawText(stroke)');
      }

      if (options.style.hasGradient) {
        _fillPainter!.text = TextSpan(
          text: text,
          style: _cachedFillStyle?.copyWith(
            foreground: Paint()
              ..shader = options.style.gradient
              ..style = PaintingStyle.fill
              ..isAntiAlias = options.style.antiAlias,
          ),
        );
        _fillPainter!.layout(maxWidth: rect.width);
      }

      _fillPainter!.paint(canvas, rect.topLeft);
      _diagnostics.recordPaintOp('canvas.drawText');

      _metrics.recordParagraph();

      if (options.debugPaint) _drawDebug(canvas, options, rect);

      sw.stop();
      _metrics.recordPaintTime(sw.elapsed);

      _checkOverflow(lines, rect);

      return PaintResult(
        success: true,
        duration: sw.elapsed,
        paintBounds: options.computePaintBounds(),
        elementType: 'text',
      );
    } catch (e) {
      sw.stop();
      _diagnostics.recordError('Paint error: $e');
      return PaintResult.failure('Paint error: $e', duration: sw.elapsed);
    } finally {
      canvas.restore();
      _diagnostics.recordPaintOp('canvas.restore');
    }
  }

  void _checkOverflow(List<LineMetrics> lines, Rect rect) {
    if (lines.isEmpty) return;
    for (final line in lines) {
      final lineBottom = line.baseline + line.descent;
      if (lineBottom > rect.height) {
        _diagnostics.recordOverflow(
          'Text exceeds bounds: ${lineBottom.toStringAsFixed(1)} > ${rect.height.toStringAsFixed(1)}',
        );
        return;
      }
    }
  }

  void _applyTransform(Canvas canvas, TextPaintOptions options, Rect rect) {
    if (options.rotation == 0 && options.scaleX == 1 && options.scaleY == 1) return;
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    canvas.translate(cx, cy);
    if (options.rotation != 0) canvas.rotate(options.rotation);
    if (options.scaleX != 1 || options.scaleY != 1) canvas.scale(options.scaleX, options.scaleY);
    canvas.translate(-cx, -cy);
    _diagnostics.recordPaintOp('canvas.transform');
  }

  void _applyClip(Canvas canvas, TextPaintOptions options, Rect rect) {
    if (!options.clipping) return;
    canvas.clipRect(rect);
    _diagnostics.recordPaintOp('canvas.clipRect');
  }

  void _drawDebug(Canvas canvas, TextPaintOptions options, Rect rect) {
    _debugPaint
      ..color = const Color(0x44FF0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(rect, _debugPaint);
    final bounds = options.computePaintBounds();
    _debugPaint.color = const Color(0x440000FF);
    canvas.drawRect(bounds, _debugPaint);
    if (options.hitTestBounds != null) {
      _debugPaint.color = const Color(0x4400FF00);
      canvas.drawRect(options.hitTestBounds!, _debugPaint);
    }
    _diagnostics.recordPaintOp('canvas.drawRect(debug)');
  }

  @override
  void dispose() {
    _lastOptions = null;
    _fillPainter?.dispose();
    _fillPainter = null;
    _strokePainter?.dispose();
    _strokePainter = null;
    _cachedFillStyle = null;
    _cachedStrokeStyle = null;
    _metrics.reset();
    _diagnostics.reset();
  }

  @override
  String toString() => 'TextPainterElement(metrics: $_metrics)';
}

// ============================================================================
// Demo — 10 examples
// ============================================================================

String runTextPainterDemo() {
  final buffer = StringBuffer();
  buffer.writeln('=== TextPainter Demo ===');
  buffer.writeln('');

  final examples = <_DemoExample>[
    _DemoExample('English text', RenderPaintNode(
      id: 'ex1', type: 'text',
      x: 20, y: 20, width: 260, height: 40,
      properties: {
        'text': 'Hello, World!',
        'fontSize': 18,
        'color': '#000000',
      },
    )),
    _DemoExample('Arabic text (RTL)', RenderPaintNode(
      id: 'ex2', type: 'text',
      x: 20, y: 80, width: 260, height: 40,
      properties: {
        'text': 'مرحباً بالعالم',
        'fontSize': 18,
        'color': '#1565C0',
        'textDirection': 'rtl',
      },
    )),
    _DemoExample('Mixed Arabic/English', RenderPaintNode(
      id: 'ex3', type: 'text',
      x: 20, y: 140, width: 260, height: 60,
      properties: {
        'text': 'مرحباً Hello 2024',
        'fontSize': 20,
        'color': '#2E7D32',
        'textDirection': 'rtl',
        'fontWeight': 'bold',
      },
    )),
    _DemoExample('Gradient text', RenderPaintNode(
      id: 'ex4', type: 'text',
      x: 20, y: 220, width: 260, height: 50,
      properties: {
        'text': 'Gradient Text',
        'fontSize': 24,
        'fontWeight': 'bold',
        'gradientKind': 'linear',
        'gradientColors': ['#FF0000', '#0000FF'],
      },
    )),
    _DemoExample('Shadow text', RenderPaintNode(
      id: 'ex5', type: 'text',
      x: 20, y: 290, width: 260, height: 50,
      properties: {
        'text': 'Shadow Text',
        'fontSize': 22,
        'color': '#000000',
        'fontWeight': 'bold',
        'textShadows': [
          {'color': '#FF0000', 'offsetX': 3, 'offsetY': 3, 'blurRadius': 4},
        ],
      },
    )),
    _DemoExample('Stroke text', RenderPaintNode(
      id: 'ex6', type: 'text',
      x: 20, y: 360, width: 260, height: 50,
      properties: {
        'text': 'Stroke Text',
        'fontSize': 24,
        'color': '#FFFFFF',
        'strokeColor': '#000000',
        'strokeWidth': 2,
        'fontWeight': 'bold',
      },
    )),
    _DemoExample('Multiline text', RenderPaintNode(
      id: 'ex7', type: 'text',
      x: 20, y: 430, width: 260, height: 100,
      properties: {
        'text': 'This is a multiline text block that should wrap properly.',
        'fontSize': 14,
        'color': '#424242',
        'lineHeight': 1.5,
        'maxLines': 5,
      },
    )),
    _DemoExample('Ellipsis overflow', RenderPaintNode(
      id: 'ex8', type: 'text',
      x: 20, y: 550, width: 260, height: 40,
      properties: {
        'text': 'This is a very long text that should be truncated with ellipsis at the end',
        'fontSize': 16,
        'color': '#C62828',
        'maxLines': 1,
        'overflow': 'ellipsis',
      },
    )),
    _DemoExample('Center aligned', RenderPaintNode(
      id: 'ex9', type: 'text',
      x: 300, y: 20, width: 260, height: 40,
      properties: {
        'text': 'Center Aligned',
        'fontSize': 18,
        'color': '#6A1B9A',
        'textAlign': 'center',
        'fontWeight': 'bold',
      },
    )),
    _DemoExample('Multi-style text', RenderPaintNode(
      id: 'ex10', type: 'text',
      x: 300, y: 80, width: 260, height: 80,
      properties: {
        'text': 'Rotated + Opacity',
        'fontSize': 22,
        'color': '#E65100',
        'fontWeight': 'bold',
        'rotation': 0.15,
        'opacity': 0.8,
      },
    )),
  ];

  for (var i = 0; i < examples.length; i++) {
    final ex = examples[i];
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = TextPainterElement();
    final context = PaintContext(
      canvas: canvas,
      document: ThemeDocument(
        metadata: ThemeMetadata(id: 'demo', name: 'TextPainter Demo'),
      ),
      renderTree: RenderTree(
        canvasWidth: 600, canvasHeight: 650,
        viewportWidth: 600, viewportHeight: 650,
        layoutMode: LayoutMode.centered,
        scaleFactor: 1.0,
        root: RenderGroup(id: 'root', children: [ex.node]),
      ),
      renderNode: ex.node,
      viewportWidth: 600, viewportHeight: 650,
      scaleFactor: 1.0,
    );
    painter.prepare(context);
    final result = painter.paint(context);
    recorder.endRecording();
    buffer.writeln('${i + 1}. ${ex.label}');
    buffer.writeln('   Result: ${result.success ? "OK" : "FAIL"}');
    buffer.writeln('   Bounds: ${result.paintBounds}');
    buffer.writeln('   Duration: ${result.duration.inMicroseconds}us');
    buffer.writeln('   Metrics: ${painter.metrics}');
    buffer.writeln('   Diag: ${painter.diagnostics}');
    buffer.writeln('');
  }

  buffer.writeln('=== Demo Complete (${examples.length} examples) ===');
  return buffer.toString();
}

class _DemoExample {
  final String label;
  final RenderPaintNode node;
  const _DemoExample(this.label, this.node);
}
