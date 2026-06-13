import 'dart:ui' show
    Canvas, Paint, Color, Rect, Path,
    BlurStyle, MaskFilter, PaintingStyle, PictureRecorder;

import '../../../models/theme_canvas.dart';
import '../../../models/theme_document.dart';
import '../../../models/theme_metadata.dart';
import '../../../renderer/render_node.dart';
import '../../../renderer/render_tree.dart';
import '../../base_painter.dart';
import '../../paint_capabilities.dart';
import '../../paint_context.dart';
import '../../paint_result.dart';
import 'gradient_paint_metrics.dart';
import 'gradient_paint_options.dart';
import 'gradient_painter_diagnostics.dart';

class GradientPainter extends BasePainter {
  final GradientPaintMetrics _metrics = GradientPaintMetrics();
  final GradientPainterDiagnostics _diagnostics = GradientPainterDiagnostics();
  final Paint _fillPaint = Paint();
  final Paint _shadowPaint = Paint();
  final Paint _debugPaint = Paint();
  final Path _clipPath = Path();
  GradientPaintOptions? _lastOptions;

  GradientPaintMetrics get metrics => _metrics;
  GradientPainterDiagnostics get diagnostics => _diagnostics;

  @override
  String get type => 'gradient';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.advanced;

  @override
  bool canPaint(RenderPaintNode node) => node.type == 'gradient';

  @override
  void initialize() {
    _metrics.reset(); _diagnostics.reset();
  }

  @override
  void prepare(PaintContext context) {
    _lastOptions = GradientPaintOptions.fromNode(context.renderNode);
    _diagnostics.recordAllocation();
  }

  void cleanup() {
    _lastOptions = null; _clipPath.reset(); _diagnostics.reset();
  }

  @override
  PaintResult paint(PaintContext context) {
    final sw = Stopwatch()..start();
    final canvas = context.canvas;
    if (canvas == null) {
      _diagnostics.recordError('Canvas is null');
      return PaintResult.failure('Canvas is null');
    }
    final options = _lastOptions ?? GradientPaintOptions.fromNode(context.renderNode);

    if (!options.visible) {
      _metrics.recordGradient(0, options.style.gradientKind);
      _diagnostics.recordSkipped('Not visible');
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'gradient');
    }

    final rect = options.rect;

    canvas.save();
    _diagnostics.recordOperation('canvas.save');
    try {
      _applyTransform(canvas, options, rect);
      _applyClip(canvas, options, rect);
      _drawShadows(canvas, options, rect);
      _drawFill(canvas, options, rect);
      if (options.debugPaint) _drawDebug(canvas, options, rect);

      _metrics.recordGradient(rect.width * rect.height, options.style.gradientKind);
      sw.stop();
      _metrics.recordDuration(sw.elapsed);
      return PaintResult(
        success: true, duration: sw.elapsed,
        paintBounds: options.computePaintBounds(),
        elementType: 'gradient',
      );
    } catch (e) {
      sw.stop();
      _diagnostics.recordError('Paint error: $e');
      return PaintResult.failure('Paint error: $e', duration: sw.elapsed);
    } finally {
      canvas.restore();
      _diagnostics.recordOperation('canvas.restore');
    }
  }

  void _applyTransform(Canvas canvas, GradientPaintOptions options, Rect rect) {
    if (options.rotation == 0 && options.scaleX == 1 && options.scaleY == 1) return;
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    canvas.translate(cx, cy);
    if (options.rotation != 0) canvas.rotate(options.rotation);
    if (options.scaleX != 1 || options.scaleY != 1) canvas.scale(options.scaleX, options.scaleY);
    canvas.translate(-cx, -cy);
    _diagnostics.recordOperation('canvas.transform');
  }

  void _applyClip(Canvas canvas, GradientPaintOptions options, Rect rect) {
    if (!options.clipping) return;
    if (options.hasBorderRadius) {
      final rrect = options.toRRect();
      canvas.clipRRect(rrect);
      _diagnostics.recordOperation('canvas.clipRRect');
    } else {
      canvas.clipRect(rect);
      _diagnostics.recordOperation('canvas.clipRect');
    }
  }

  void _drawShadows(Canvas canvas, GradientPaintOptions options, Rect rect) {
    if (!options.style.hasShadows) return;
    final rrect = options.hasBorderRadius ? options.toRRect() : null;
    for (final shadow in options.style.shadows) {
      final alpha = (shadow.color.a * shadow.opacity).clamp(0.0, 1.0);
      _shadowPaint
        ..color = shadow.color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius)
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(shadow.offsetX, shadow.offsetY);
      if (rrect != null) {
        canvas.drawRRect(rrect, _shadowPaint);
      } else {
        canvas.drawRect(rect, _shadowPaint);
      }
      canvas.restore();
      _metrics.recordShadow();
      _diagnostics.recordOperation('canvas.drawShadow');
    }
  }

  void _drawFill(Canvas canvas, GradientPaintOptions options, Rect rect) {
    if (!options.style.hasGradient) return;
    final rrect = options.hasBorderRadius ? options.toRRect() : null;

    _fillPaint
      ..shader = options.style.gradient
      ..style = PaintingStyle.fill
      ..blendMode = options.style.blendMode;

    if (rrect != null) {
      canvas.drawRRect(rrect, _fillPaint);
      _diagnostics.recordOperation('canvas.drawRRect(fill)');
    } else {
      canvas.drawRect(rect, _fillPaint);
      _diagnostics.recordOperation('canvas.drawRect(fill)');
    }
  }

  void _drawDebug(Canvas canvas, GradientPaintOptions options, Rect rect) {
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
    _diagnostics.recordOperation('canvas.drawRect(debug)');
  }

  @override
  void dispose() {
    _lastOptions = null; _clipPath.reset();
    _metrics.reset(); _diagnostics.reset();
  }

  @override
  String toString() => 'GradientPainter(metrics: $_metrics)';
}

// ============================================================================
// Demo — 10 examples
// ============================================================================

String runGradientPainterDemo() {
  final buffer = StringBuffer();
  buffer.writeln('=== GradientPainter Demo ===');
  buffer.writeln('');

  final examples = <_DemoExample>[
    _DemoExample('Linear gradient', RenderPaintNode(
      id: 'ex1', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#FF0000', '#0000FF'],
        'angle': 45,
      },
    )),
    _DemoExample('Radial gradient', RenderPaintNode(
      id: 'ex2', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      properties: {
        'gradientKind': 'radial',
        'gradientColors': ['#00FF00', '#0000FF'],
      },
    )),
    _DemoExample('Sweep gradient', RenderPaintNode(
      id: 'ex3', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      properties: {
        'gradientKind': 'sweep',
        'gradientColors': ['#FF0000', '#FFFF00', '#00FF00', '#00FFFF', '#0000FF', '#FF00FF', '#FF0000'],
      },
    )),
    _DemoExample('Multi-color stop gradient', RenderPaintNode(
      id: 'ex4', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#FF0000', '#FFFF00', '#00FF00'],
        'gradientStops': [0.0, 0.5, 1.0],
        'angle': 0,
      },
    )),
    _DemoExample('Rounded gradient', RenderPaintNode(
      id: 'ex5', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#FF6F00', '#FFB74D'],
        'borderRadius': 20,
      },
    )),
    _DemoExample('Rotated gradient', RenderPaintNode(
      id: 'ex6', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      rotation: 0.3,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#EF5350', '#42A5F5'],
        'angle': 90,
      },
    )),
    _DemoExample('Scaled gradient', RenderPaintNode(
      id: 'ex7', type: 'gradient',
      x: 50, y: 50, width: 150, height: 100,
      scaleX: 1.5, scaleY: 1.5,
      properties: {
        'gradientKind': 'radial',
        'gradientColors': ['#26A69A', '#00695C'],
      },
    )),
    _DemoExample('Shadow gradient', RenderPaintNode(
      id: 'ex8', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#8D6E63', '#D7CCC8'],
        'angle': 135,
        'shadows': [
          {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
        ],
      },
    )),
    _DemoExample('Clipped gradient', RenderPaintNode(
      id: 'ex9', type: 'gradient',
      x: 50, y: 50, width: 200, height: 150,
      properties: {
        'gradientKind': 'sweep',
        'gradientColors': ['#FF7043', '#FFEB3B', '#4CAF50'],
        'clipping': true,
        'borderRadius': 30,
      },
    )),
    _DemoExample('Mixed gradient', RenderPaintNode(
      id: 'ex10', type: 'gradient',
      x: 50, y: 50, width: 220, height: 160,
      rotation: 0.1, opacity: 0.85,
      properties: {
        'gradientKind': 'linear',
        'gradientColors': ['#7E57C2', '#B39DDB', '#4A148C'],
        'gradientStops': [0.0, 0.5, 1.0],
        'angle': -45,
        'borderRadius': 16,
        'blendMode': 'srcOver',
        'shadows': [
          {'color': '#000000', 'offsetX': 3, 'offsetY': 3, 'blurRadius': 6, 'opacity': 0.3},
        ],
      },
    )),
  ];

  for (var i = 0; i < examples.length; i++) {
    final ex = examples[i];
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = GradientPainter();
    final context = PaintContext(
      canvas: canvas,
      document: ThemeDocument(
        metadata: ThemeMetadata(id: 'demo', name: 'GradientPainter Demo'),
      ),
      renderTree: RenderTree(
        canvasWidth: 300, canvasHeight: 250,
        viewportWidth: 300, viewportHeight: 250,
        layoutMode: LayoutMode.centered,
        scaleFactor: 1.0,
        root: RenderGroup(id: 'root', children: [ex.node]),
      ),
      renderNode: ex.node,
      viewportWidth: 300, viewportHeight: 250,
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
