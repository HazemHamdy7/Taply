import 'dart:ui' show
    Canvas, Paint, Color, Offset, BlurStyle, MaskFilter,
    PaintingStyle, PictureRecorder;

import '../../../models/shadow_definition.dart';
import '../../../models/theme_canvas.dart';
import '../../../models/theme_document.dart';
import '../../../models/theme_metadata.dart';
import '../../../renderer/render_node.dart';
import '../../../renderer/render_tree.dart';
import '../../base_painter.dart';
import '../../paint_capabilities.dart';
import '../../paint_context.dart';
import '../../paint_result.dart';
import 'circle_paint_metrics.dart';
import 'circle_paint_options.dart';
import 'circle_painter_diagnostics.dart';

class CirclePainter extends BasePainter {
  final CirclePaintMetrics _metrics = CirclePaintMetrics();
  final CirclePainterDiagnostics _diagnostics = CirclePainterDiagnostics();
  final Paint _fillPaint = Paint();
  final Paint _strokePaint = Paint();
  final Paint _shadowPaint = Paint();
  final Paint _debugPaint = Paint();
  CirclePaintOptions? _lastOptions;

  CirclePaintMetrics get metrics => _metrics;
  CirclePainterDiagnostics get diagnostics => _diagnostics;

  @override
  String get type => 'circle';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.advanced;

  @override
  bool canPaint(RenderPaintNode node) => node.type == 'circle';

  @override
  void initialize() { _metrics.reset(); _diagnostics.reset(); }

  @override
  void prepare(PaintContext context) {
    _lastOptions = CirclePaintOptions.fromNode(context.renderNode);
    _diagnostics.recordAllocation();
  }

  @override
  PaintResult paint(PaintContext context) {
    final sw = Stopwatch()..start();
    final canvas = context.canvas;
    if (canvas == null) {
      _diagnostics.recordError('Canvas is null');
      return PaintResult.failure('Canvas is null');
    }
    final options = _lastOptions ?? CirclePaintOptions.fromNode(context.renderNode);

    if (!options.visible) {
      _diagnostics.recordSkipped('Not visible');
      _metrics.recordCircle(0);
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'circle');
    }

    canvas.save();
    _diagnostics.recordOperation('canvas.save');
    try {
      _applyTransform(canvas, options);
      _drawShadows(canvas, options);
      _drawFill(canvas, options);
      _drawStroke(canvas, options);
      if (options.debugPaint) _drawDebug(canvas, options);

      _metrics.recordCircle(options.radius * options.radius * 3.14159);
      sw.stop();
      _metrics.recordDuration(sw.elapsed);
      return PaintResult(
        success: true, duration: sw.elapsed,
        paintBounds: options.computePaintBounds(),
        elementType: 'circle',
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

  void _applyTransform(Canvas canvas, CirclePaintOptions o) {
    if (o.rotation == 0 && o.scaleX == 1 && o.scaleY == 1) return;
    canvas.translate(o.cx, o.cy);
    if (o.rotation != 0) canvas.rotate(o.rotation);
    if (o.scaleX != 1 || o.scaleY != 1) canvas.scale(o.scaleX, o.scaleY);
    canvas.translate(-o.cx, -o.cy);
    _diagnostics.recordOperation('canvas.transform');
  }

  void _drawShadows(Canvas canvas, CirclePaintOptions o) {
    if (!o.style.hasShadows) return;
    for (final shadow in o.style.shadows) {
      final alpha = (shadow.color.a * shadow.opacity).clamp(0.0, 1.0);
      _shadowPaint
        ..color = shadow.color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius)
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(shadow.offsetX, shadow.offsetY);
      canvas.drawCircle(Offset(o.cx, o.cy), o.radius, _shadowPaint);
      canvas.restore();
      _metrics.recordShadow();
      _diagnostics.recordOperation('canvas.drawCircle(shadow)');
    }
  }

  void _drawFill(Canvas canvas, CirclePaintOptions o) {
    if (!o.style.hasFill) return;
    final alpha = (o.style.fillColor!.a * o.opacity).clamp(0.0, 1.0);
    _fillPaint
      ..color = o.style.fillColor!.withValues(alpha: alpha)
      ..style = PaintingStyle.fill
      ..blendMode = o.style.blendMode;
    canvas.drawCircle(Offset(o.cx, o.cy), o.radius, _fillPaint);
    _diagnostics.recordOperation('canvas.drawCircle(fill)');
  }

  void _drawStroke(Canvas canvas, CirclePaintOptions o) {
    if (!o.style.hasStroke) return;
    final alpha = (o.style.strokeColor!.a * o.opacity).clamp(0.0, 1.0);
    _strokePaint
      ..color = o.style.strokeColor!.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = o.style.strokeWidth
      ..blendMode = o.style.blendMode;
    canvas.drawCircle(Offset(o.cx, o.cy), o.radius, _strokePaint);
    _metrics.recordStroke();
    _diagnostics.recordOperation('canvas.drawCircle(stroke)');
  }

  void _drawDebug(Canvas canvas, CirclePaintOptions o) {
    _debugPaint
      ..color = const Color(0x44FF0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawCircle(Offset(o.cx, o.cy), o.radius, _debugPaint);
    final bounds = o.computePaintBounds();
    _debugPaint.color = const Color(0x440000FF);
    canvas.drawRect(bounds, _debugPaint);
    if (o.hitTestBounds != null) {
      _debugPaint.color = const Color(0x4400FF00);
      canvas.drawRect(o.hitTestBounds!, _debugPaint);
    }
    _diagnostics.recordOperation('canvas.drawCircle(debug)');
  }

  void cleanup() { _lastOptions = null; _diagnostics.reset(); }

  @override
  void dispose() {
    _lastOptions = null; _metrics.reset(); _diagnostics.reset();
  }

  @override
  String toString() => 'CirclePainter(metrics: $_metrics)';
}

// ============================================================================
// Demo — 10 examples
// ============================================================================

String runCirclePainterDemo() {
  final buffer = StringBuffer();
  buffer.writeln('=== CirclePainter Demo ===');
  buffer.writeln('');

  final examples = <_DemoExample>[
    _DemoExample('Simple circle', RenderPaintNode(
      id: 'ex1', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#FF0000',
    )),
    _DemoExample('Stroked circle', RenderPaintNode(
      id: 'ex2', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#FF0000', strokeWidth: 5, strokeColor: '#0000FF',
    )),
    _DemoExample('Transparent circle', RenderPaintNode(
      id: 'ex3', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#FF0000', opacity: 0.5,
    )),
    _DemoExample('Rotated circle', RenderPaintNode(
      id: 'ex4', type: 'circle',
      x: 50, y: 50, width: 100, height: 100,
      color: '#FF0000', rotation: 0.3,
    )),
    _DemoExample('Scaled circle', RenderPaintNode(
      id: 'ex5', type: 'circle',
      x: 50, y: 50, width: 50, height: 50,
      color: '#00FF00', scaleX: 2.0, scaleY: 1.5,
    )),
    _DemoExample('Shadow circle', RenderPaintNode(
      id: 'ex6', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#0000FF',
      shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8, opacity: 0.4)],
    )),
    _DemoExample('Explicit cx/cy/radius', RenderPaintNode(
      id: 'ex7', type: 'circle',
      x: 0, y: 0, width: 200, height: 200,
      color: '#FF8800',
      properties: {'cx': 100, 'cy': 100, 'radius': 60},
    )),
    _DemoExample('Multiple shadows', RenderPaintNode(
      id: 'ex8', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#8800FF',
      properties: {
        'shadows': [
          {'color': '#000000', 'offsetX': 2, 'offsetY': 2, 'blurRadius': 4, 'opacity': 0.3},
          {'color': '#000000', 'offsetX': 6, 'offsetY': 6, 'blurRadius': 12, 'opacity': 0.2},
        ],
      },
    )),
    _DemoExample('Debug paint circle', RenderPaintNode(
      id: 'ex9', type: 'circle',
      x: 0, y: 0, width: 100, height: 100,
      color: '#FF0000',
      properties: {'debugPaint': true},
    )),
    _DemoExample('Mixed example', RenderPaintNode(
      id: 'ex10', type: 'circle',
      x: 50, y: 50, width: 120, height: 120,
      color: '#FF6600',
      strokeWidth: 3.0,
      strokeColor: '#993300',
      rotation: 0.15,
      opacity: 0.85,
      shadows: [const ShadowDefinition(color: '#000000', offsetX: 3, offsetY: 3, blurRadius: 6, opacity: 0.3)],
      properties: {
        'debugPaint': false,
        'blendMode': 'srcOver',
      },
    )),
  ];

  for (var i = 0; i < examples.length; i++) {
    final ex = examples[i];
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final painter = CirclePainter();

    final context = PaintContext(
      canvas: canvas,
      document: ThemeDocument(
        metadata: ThemeMetadata(id: 'demo', name: 'CirclePainter Demo'),
      ),
      renderTree: RenderTree(
        canvasWidth: 300, canvasHeight: 250,
        viewportWidth: 300, viewportHeight: 250,
        layoutMode: LayoutMode.centered,
        scaleFactor: 1.0,
        root: RenderGroup(id: 'root', children: [ex.node]),
      ),
      renderNode: ex.node,
      viewportWidth: 300,
      viewportHeight: 250,
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
