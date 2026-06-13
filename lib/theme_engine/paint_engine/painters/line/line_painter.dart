import 'dart:math' show sqrt;
import 'dart:ui' show
    Canvas, Paint, Color, Offset, BlurStyle, MaskFilter,
    PaintingStyle, PictureRecorder, Rect;

import '../../../models/theme_canvas.dart';
import '../../../models/theme_document.dart';
import '../../../models/theme_metadata.dart';
import '../../../renderer/render_tree.dart';
import '../../../renderer/render_node.dart';
import '../../base_painter.dart';
import '../../paint_capabilities.dart';
import '../../paint_context.dart';
import '../../paint_result.dart';
import 'line_paint_metrics.dart';
import 'line_paint_options.dart';
import 'line_painter_diagnostics.dart';

class LinePainter extends BasePainter {
  final LinePaintMetrics _metrics = LinePaintMetrics();
  final LinePainterDiagnostics _diagnostics = LinePainterDiagnostics();
  final Paint _linePaint = Paint();
  final Paint _shadowPaint = Paint();
  final Paint _debugPaint = Paint();
  LinePaintOptions? _lastOptions;

  LinePaintMetrics get metrics => _metrics;
  LinePainterDiagnostics get diagnostics => _diagnostics;

  @override
  String get type => 'line';

  @override
  PaintCapabilities get capabilities => PaintCapabilities(
    supportsStroke: true, supportsShadow: true,
    supportsBlendMode: true,
  );

  @override
  bool canPaint(RenderPaintNode node) => node.type == 'line';

  @override
  void initialize() { _metrics.reset(); _diagnostics.reset(); }

  @override
  void prepare(PaintContext context) {
    _lastOptions = LinePaintOptions.fromNode(context.renderNode);
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
    final options = _lastOptions ?? LinePaintOptions.fromNode(context.renderNode);

    if (!options.visible) {
      _diagnostics.recordSkipped('Not visible');
      _metrics.recordLine(0);
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'line');
    }

    canvas.save();
    _diagnostics.recordOperation('canvas.save');
    try {
      _applyTransform(canvas, options);
      _drawShadows(canvas, options);
      _drawLine(canvas, options);
      if (options.debugPaint) _drawDebug(canvas, options);

      final dx = options.endX - options.startX;
      final dy = options.endY - options.startY;
      final length = sqrt(dx * dx + dy * dy);
      _metrics.recordLine(length);
      sw.stop();
      _metrics.recordDuration(sw.elapsed);
      return PaintResult(
        success: true, duration: sw.elapsed,
        paintBounds: options.computePaintBounds(),
        elementType: 'line',
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

  void _applyTransform(Canvas canvas, LinePaintOptions o) {
    if (o.rotation == 0 && o.scaleX == 1 && o.scaleY == 1) return;
    final ctrX = o.cx;
    final ctrY = o.cy;
    canvas.translate(ctrX, ctrY);
    if (o.rotation != 0) canvas.rotate(o.rotation);
    if (o.scaleX != 1 || o.scaleY != 1) canvas.scale(o.scaleX, o.scaleY);
    canvas.translate(-ctrX, -ctrY);
    _diagnostics.recordOperation('canvas.transform');
  }

  void _drawShadows(Canvas canvas, LinePaintOptions o) {
    if (!o.style.hasShadows) return;
    for (final shadow in o.style.shadows) {
      final alpha = (shadow.color.a * shadow.opacity).clamp(0.0, 1.0);
      _shadowPaint
        ..color = shadow.color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius)
        ..style = PaintingStyle.stroke
        ..strokeWidth = o.style.strokeWidth
        ..strokeCap = o.style.strokeCap;
      canvas.save();
      canvas.translate(shadow.offsetX, shadow.offsetY);
      canvas.drawLine(
        Offset(o.startX, o.startY), Offset(o.endX, o.endY), _shadowPaint);
      canvas.restore();
      _metrics.recordShadow();
      _diagnostics.recordOperation('canvas.drawLine(shadow)');
    }
  }

  void _drawLine(Canvas canvas, LinePaintOptions o) {
    if (!o.style.hasLine) return;
    final alpha = (o.style.lineColor!.a * o.opacity).clamp(0.0, 1.0);
    _linePaint
      ..color = o.style.lineColor!.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = o.style.strokeWidth
      ..strokeCap = o.style.strokeCap
      ..blendMode = o.style.blendMode;
    canvas.drawLine(
      Offset(o.startX, o.startY), Offset(o.endX, o.endY), _linePaint);
    _diagnostics.recordOperation('canvas.drawLine');
  }

  void _drawDebug(Canvas canvas, LinePaintOptions o) {
    _debugPaint
      ..color = const Color(0x44FF0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(o.startX, o.startY), Offset(o.endX, o.endY), _debugPaint);
    final bounds = o.computePaintBounds();
    _debugPaint.color = const Color(0x440000FF);
    canvas.drawRect(bounds, _debugPaint);
    if (o.hitTestBounds != null) {
      _debugPaint.color = const Color(0x4400FF00);
      canvas.drawRect(o.hitTestBounds!, _debugPaint);
    }
    _diagnostics.recordOperation('canvas.drawLine(debug)');
  }

  void cleanup() { _lastOptions = null; _diagnostics.reset(); }

  @override
  void dispose() {
    _lastOptions = null; _metrics.reset(); _diagnostics.reset();
  }

  @override
  String toString() => 'LinePainter(metrics: $_metrics)';
}

void runLinePainterDemo() {
  print('═══ LinePainter Demo ═══\n');

  final examples = <String, RenderPaintNode>{
    '1. Simple horizontal line': RenderPaintNode(
      id: 'demo1', type: 'line',
      x: 30, y: 100, width: 200, height: 0,
      color: '#E53935',
    ),
    '2. Vertical line': RenderPaintNode(
      id: 'demo2', type: 'line',
      x: 100, y: 20, width: 0, height: 160,
      color: '#1E88E5',
    ),
    '3. Diagonal line': RenderPaintNode(
      id: 'demo3', type: 'line',
      x: 20, y: 20, width: 200, height: 160,
      color: '#43A047',
    ),
    '4. Thick line': RenderPaintNode(
      id: 'demo4', type: 'line',
      x: 30, y: 100, width: 200, height: 0,
      color: '#8E24AA', strokeWidth: 8,
    ),
    '5. Transparent line': RenderPaintNode(
      id: 'demo5', type: 'line',
      x: 30, y: 100, width: 200, height: 0,
      color: '#E53935', opacity: 0.3,
    ),
    '6. Rotated line': RenderPaintNode(
      id: 'demo6', type: 'line',
      x: 30, y: 100, width: 200, height: 0,
      color: '#FB8C00', rotation: 0.5,
    ),
    '7. Scaled line': RenderPaintNode(
      id: 'demo7', type: 'line',
      x: 30, y: 100, width: 100, height: 0,
      color: '#00ACC1', scaleX: 2.0,
    ),
    '8. Shadow line': RenderPaintNode(
      id: 'demo8', type: 'line',
      x: 30, y: 100, width: 200, height: 0,
      color: '#E53935',
      properties: {
        'shadows': [
          {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.3},
        ],
      },
    ),
    '9. Line with round cap': RenderPaintNode(
      id: 'demo9', type: 'line',
      x: 30, y: 100, width: 200, height: 0,
      color: '#6D4C41', strokeWidth: 6,
      properties: {'strokeCap': 'round'},
    ),
    '10. Mixed (shadow + rotation + opacity)': RenderPaintNode(
      id: 'demo10', type: 'line',
      x: 30, y: 100, width: 200, height: 0,
      color: '#D81B60', strokeWidth: 4,
      opacity: 0.8, rotation: 0.2,
      properties: {
        'shadows': [
          {'color': '#000000', 'offsetX': 3, 'offsetY': 3, 'blurRadius': 6, 'opacity': 0.4},
        ],
      },
    ),
  };

  for (final entry in examples.entries) {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, 300, 200));
    final node = entry.value;
    final ctx = PaintContext(
      canvas: canvas,
      document: ThemeDocument(
        metadata: ThemeMetadata(id: 'demo', name: 'Demo'),
      ),
      renderTree: RenderTree(
        canvasWidth: 300, canvasHeight: 200,
        viewportWidth: 300, viewportHeight: 200,
        layoutMode: LayoutMode.centered,
        scaleFactor: 1.0,
        root: RenderGroup(id: 'root', children: [node]),
      ),
      renderNode: node,
      viewportWidth: 300, viewportHeight: 200,
      scaleFactor: 1.0,
    );
    final painter = LinePainter();
    painter.prepare(ctx);
    final result = painter.paint(ctx);
    recorder.endRecording();
    print('  ${entry.key}');
    print('    success: ${result.success}');
    print('    duration: ${result.duration.inMicroseconds} us');
    print('    metrics: ${painter.metrics}');
    print('');
  }

  print('═══ Demo complete ═══');
}
