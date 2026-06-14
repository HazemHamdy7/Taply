import 'dart:ui' show
    Canvas, Paint, Color, Offset, Path, BlurStyle, MaskFilter,
    PaintingStyle, StrokeCap, StrokeJoin;

import '../../../renderer/render_node.dart';
import '../../base_painter.dart';
import '../../paint_capabilities.dart';
import '../../paint_context.dart';
import '../../paint_result.dart';
import '../paint_shadow.dart';
import 'path_paint_metrics.dart';
import 'path_paint_options.dart';
import 'path_paint_style.dart';
import 'path_painter_diagnostics.dart';

class PathPainter extends BasePainter {
  final PathPaintMetrics _metrics = PathPaintMetrics();
  final PathPainterDiagnostics _diagnostics = PathPainterDiagnostics();
  final Paint _fillPaint = Paint();
  final Paint _strokePaint = Paint();
  final Paint _shadowPaint = Paint();
  final Paint _debugPaint = Paint();
  final Path _path = Path();
  final Path _shadowPath = Path();
  PathPaintOptions? _lastOptions;

  PathPaintMetrics get metrics => _metrics;
  PathPainterDiagnostics get diagnostics => _diagnostics;

  @override
  String get type => 'path';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.advanced;

  @override
  bool canPaint(RenderPaintNode node) => node.type == 'path';

  @override
  void initialize() { _metrics.reset(); _diagnostics.reset(); }

  @override
  void prepare(PaintContext context) {
    _lastOptions = PathPaintOptions.fromNode(context.renderNode);
    _diagnostics.recordAllocation();
  }

  void cleanup() { _lastOptions = null; _path.reset(); _shadowPath.reset(); _diagnostics.reset(); }

  @override
  PaintResult paint(PaintContext context) {
    final sw = Stopwatch()..start();
    final canvas = context.canvas;
    if (canvas == null) {
      _diagnostics.recordError('Canvas is null');
      return PaintResult.failure('Canvas is null');
    }
    final options = _lastOptions ?? PathPaintOptions.fromNode(context.renderNode);

    if (!options.visible) {
      _diagnostics.recordSkipped('Not visible');
      _metrics.recordPath();
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'path');
    }

    _path.reset();
    if (options.commands.isEmpty) {
      _diagnostics.recordSkipped('Empty commands');
      _metrics.recordPath();
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'path',
        warnings: ['Empty path commands']);
    }
    _buildPath(options.commands);

    canvas.save();
    _diagnostics.recordOperation('canvas.save');
    try {
      _applyTransform(canvas, options);
      _drawShadows(canvas, options);
      _drawFill(canvas, options);
      _drawStroke(canvas, options);
      if (options.debugPaint) _drawDebug(canvas, options);

      _metrics.recordPath();
      sw.stop();
      _metrics.recordDuration(sw.elapsed);
      return PaintResult(
        success: true, duration: sw.elapsed,
        paintBounds: options.computePaintBounds(),
        elementType: 'path',
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

  double _sanitize(double v) => v.isNaN || v.isInfinite ? 0.0 : v;

  void _buildPath(List<PathCommand> commands) {
    for (final cmd in commands) {
      switch (cmd) {
        case PathMoveTo(:final x, :final y):
          _path.moveTo(_sanitize(x), _sanitize(y));
          _metrics.recordSegment();
        case PathLineTo(:final x, :final y):
          _path.lineTo(_sanitize(x), _sanitize(y));
          _metrics.recordSegment();
        case PathCubicTo(:final controlX1, :final controlY1, :final controlX2, :final controlY2, :final x, :final y):
          _path.cubicTo(_sanitize(controlX1), _sanitize(controlY1), _sanitize(controlX2), _sanitize(controlY2), _sanitize(x), _sanitize(y));
          _metrics.recordSegment();
        case PathQuadraticTo(:final controlX, :final controlY, :final x, :final y):
          _path.quadraticBezierTo(_sanitize(controlX), _sanitize(controlY), _sanitize(x), _sanitize(y));
          _metrics.recordSegment();
        case PathClose():
          _path.close();
          _metrics.recordSegment();
      }
    }
    _diagnostics.recordOperation('path.build');
  }

  void _applyTransform(Canvas canvas, PathPaintOptions o) {
    final r = o.rotation;
    final sx = o.scaleX;
    final sy = o.scaleY;
    if ((r == 0 || r.isNaN || r.isInfinite) &&
        (sx == 1 || sx.isNaN || sx.isInfinite) &&
        (sy == 1 || sy.isNaN || sy.isInfinite)) return;
    final bounds = o.computePaintBounds();
    final cx = bounds.center.dx;
    final cy = bounds.center.dy;
    canvas.translate(cx, cy);
    if (r != 0 && !r.isNaN && !r.isInfinite) canvas.rotate(r);
    if ((sx != 1 || sy != 1) && !sx.isNaN && !sx.isInfinite && !sy.isNaN && !sy.isInfinite) canvas.scale(sx, sy);
    canvas.translate(-cx, -cy);
    _diagnostics.recordOperation('canvas.transform');
  }

  void _drawShadows(Canvas canvas, PathPaintOptions o) {
    if (!o.style.hasShadows) return;
    for (final shadow in o.style.shadows) {
      final alpha = (shadow.color.a * shadow.opacity).clamp(0.0, 1.0);
      _shadowPaint
        ..color = shadow.color.withValues(alpha: alpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, shadow.blurRadius)
        ..style = PaintingStyle.fill;
      _shadowPath.reset();
      _shadowPath.addPath(_path, Offset(shadow.offsetX, shadow.offsetY));
      canvas.drawPath(_shadowPath, _shadowPaint);
      _metrics.recordShadow();
      _diagnostics.recordOperation('canvas.drawPath(shadow)');
    }
  }

  void _drawFill(Canvas canvas, PathPaintOptions o) {
    if (!o.style.hasFill) return;
    final alpha = (o.style.fillColor!.a * o.opacity).clamp(0.0, 1.0);
    _fillPaint
      ..color = o.style.fillColor!.withValues(alpha: alpha)
      ..style = PaintingStyle.fill
      ..blendMode = o.style.blendMode;
    canvas.drawPath(_path, _fillPaint);
    _metrics.recordFill();
    _diagnostics.recordOperation('canvas.drawPath(fill)');
  }

  void _drawStroke(Canvas canvas, PathPaintOptions o) {
    if (!o.style.hasStroke) return;
    final alpha = (o.style.strokeColor!.a * o.opacity).clamp(0.0, 1.0);
    _strokePaint
      ..color = o.style.strokeColor!.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = o.style.strokeWidth
      ..strokeCap = o.style.strokeCap
      ..strokeJoin = o.style.strokeJoin
      ..blendMode = o.style.blendMode;
    canvas.drawPath(_path, _strokePaint);
    _metrics.recordStroke();
    _diagnostics.recordOperation('canvas.drawPath(stroke)');
  }

  void _drawDebug(Canvas canvas, PathPaintOptions o) {
    _debugPaint
      ..color = const Color(0x44FF0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawPath(_path, _debugPaint);
    final bounds = o.computePaintBounds();
    _debugPaint.color = const Color(0x440000FF);
    canvas.drawRect(bounds, _debugPaint);
    if (o.hitTestBounds != null) {
      _debugPaint.color = const Color(0x4400FF00);
      canvas.drawRect(o.hitTestBounds!, _debugPaint);
    }
    _diagnostics.recordOperation('canvas.drawPath(debug)');
  }

  @override
  void dispose() {
    _lastOptions = null; _path.reset(); _shadowPath.reset();
    _metrics.reset(); _diagnostics.reset();
  }

  @override
  String toString() => 'PathPainter(metrics: $_metrics)';
}

/// Runs a demo of all PathPainter capabilities, printing results to console.
///
/// Creates and describes 10 example paths covering fill, stroke, curves,
/// transparency, rotation, shadows, and mixed command types.
void runPathPainterDemo() {
  // ignore: avoid_print
  print('═══ PathPainter Demo ═══');

  void demo(String name, PathPaintOptions opts) {
    // ignore: avoid_print
    print('\n── $name ──');
    // ignore: avoid_print
    print('  Commands: ${opts.commands.length}');
    // ignore: avoid_print
    print('  Style: ${opts.style}');
    // ignore: avoid_print
    print('  Bounds: ${opts.computePaintBounds()}');
    // ignore: avoid_print
    print('  HasFill: ${opts.style.hasFill}, HasStroke: ${opts.style.hasStroke}');
    if (opts.debugPaint) {
      // ignore: avoid_print
      print('  Debug paint: ON');
    }
    if (opts.rotation != 0) {
      // ignore: avoid_print
      print('  Rotation: ${opts.rotation} rad');
    }
    if (opts.scaleX != 1 || opts.scaleY != 1) {
      // ignore: avoid_print
      print('  Scale: ${opts.scaleX}x${opts.scaleY}');
    }
    if (opts.style.hasShadows) {
      // ignore: avoid_print
      print('  Shadows: ${opts.style.shadows.length}');
    }
  }

  // 1. Simple triangle
  demo('Simple Triangle', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 100, y: 10),
      PathLineTo(x: 180, y: 180),
      PathLineTo(x: 20, y: 180),
      PathClose(),
    ],
    style: PathPaintStyle(fillColor: Color(0xFFFF0000)),
  ));

  // 2. Rectangle path
  demo('Rectangle Path', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 50, y: 50),
      PathLineTo(x: 150, y: 50),
      PathLineTo(x: 150, y: 150),
      PathLineTo(x: 50, y: 150),
      PathClose(),
    ],
    style: PathPaintStyle(fillColor: Color(0xFF00AA00)),
  ));

  // 3. Cubic bezier curve
  demo('Cubic Bezier Curve', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 20, y: 100),
      PathCubicTo(
        controlX1: 60, controlY1: 20,
        controlX2: 140, controlY2: 180,
        x: 180, y: 100,
      ),
    ],
    style: PathPaintStyle(
      fillColor: Color(0xFFFF0000),
      strokeWidth: 3,
      strokeColor: Color(0xFF0000FF),
    ),
  ));

  // 4. Quadratic bezier curve
  demo('Quadratic Bezier Curve', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 20, y: 100),
      PathQuadraticTo(controlX: 100, controlY: 10, x: 180, y: 100),
    ],
    style: PathPaintStyle(
      fillColor: Color(0xFFFF0000),
      strokeWidth: 2,
      strokeColor: Color(0xFF000000),
    ),
  ));

  // 5. Stroked path
  demo('Stroked Path', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 20, y: 50),
      PathLineTo(x: 180, y: 50),
      PathLineTo(x: 180, y: 150),
    ],
    style: PathPaintStyle(
      strokeWidth: 6,
      strokeColor: Color(0xFF0000FF),
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    ),
  ));

  // 6. Filled + stroked path
  demo('Filled + Stroked Path', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 100, y: 20),
      PathLineTo(x: 180, y: 170),
      PathLineTo(x: 20, y: 170),
      PathClose(),
    ],
    style: PathPaintStyle(
      fillColor: Color(0x44FF0000),
      strokeWidth: 4,
      strokeColor: Color(0xFFFF0000),
    ),
  ));

  // 7. Transparent path
  demo('Transparent Path', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 100, y: 10),
      PathLineTo(x: 180, y: 180),
      PathLineTo(x: 20, y: 180),
      PathClose(),
    ],
    style: PathPaintStyle(fillColor: Color(0xFFFF0000)),
    opacity: 0.3,
  ));

  // 8. Rotated path
  demo('Rotated Path', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 50, y: 50),
      PathLineTo(x: 150, y: 50),
      PathLineTo(x: 100, y: 150),
      PathClose(),
    ],
    style: PathPaintStyle(fillColor: Color(0xFF0000FF)),
    rotation: 0.5,
  ));

  // 9. Shadow path
  demo('Shadow Path', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 100, y: 20),
      PathLineTo(x: 180, y: 170),
      PathLineTo(x: 20, y: 170),
      PathClose(),
    ],
    style: PathPaintStyle(
      fillColor: Color(0xFFFF8800),
      shadows: [
        PaintShadow(
          color: Color(0x33000000),
          offsetX: 4, offsetY: 4,
          blurRadius: 8, opacity: 0.4,
        ),
      ],
    ),
  ));

  // 10. Mixed example (complex path with all command types)
  demo('Mixed Complex Path', PathPaintOptions(
    commands: const [
      PathMoveTo(x: 50, y: 100),
      PathLineTo(x: 80, y: 40),
      PathCubicTo(
        controlX1: 100, controlY1: 10,
        controlX2: 120, controlY2: 10,
        x: 140, y: 40,
      ),
      PathLineTo(x: 170, y: 100),
      PathQuadraticTo(controlX: 150, controlY: 150, x: 120, y: 130),
      PathLineTo(x: 100, y: 160),
      PathLineTo(x: 80, y: 130),
      PathQuadraticTo(controlX: 50, controlY: 150, x: 50, y: 100),
      PathClose(),
    ],
    style: PathPaintStyle(
      fillColor: Color(0x44AA44FF),
      strokeWidth: 3,
      strokeColor: Color(0xFFAA44FF),
      strokeCap: StrokeCap.round,
      strokeJoin: StrokeJoin.round,
    ),
    debugPaint: true,
  ));

  // ignore: avoid_print
  print('\n═══ Demo Complete ═══');
}
