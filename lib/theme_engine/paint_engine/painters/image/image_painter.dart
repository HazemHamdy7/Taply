import 'dart:ui' show
    Canvas, Paint, Color, Rect, RRect, Offset, Image,
    BlurStyle, MaskFilter, PaintingStyle, ColorFilter, PictureRecorder, Size;

import '../../../models/theme_canvas.dart';
import '../../../models/theme_document.dart';
import '../../../models/theme_metadata.dart';
import '../../../renderer/render_node.dart';
import '../../../renderer/render_tree.dart';
import '../../base_painter.dart';
import '../../paint_capabilities.dart';
import '../../paint_context.dart';
import '../../paint_result.dart';
import 'image_paint_metrics.dart';
import 'image_paint_options.dart';
import 'image_painter_diagnostics.dart';

class ImagePainter extends BasePainter {
  final ImagePaintMetrics _metrics = ImagePaintMetrics();
  final ImagePainterDiagnostics _diagnostics = ImagePainterDiagnostics();
  final Paint _imagePaint = Paint();
  final Paint _borderPaint = Paint();
  final Paint _shadowPaint = Paint();
  final Paint _placeholderPaint = Paint();
  final Paint _debugPaint = Paint();
  ImagePaintOptions? _lastOptions;
  Image? _image;

  ImagePaintMetrics get metrics => _metrics;
  ImagePainterDiagnostics get diagnostics => _diagnostics;

  @override
  String get type => 'image';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.advanced;

  @override
  bool canPaint(RenderPaintNode node) => node.type == 'image';

  void setImage(Image? image) { _image = image; }

  @override
  void initialize() {
    _metrics.reset(); _diagnostics.reset(); _image = null;
  }

  @override
  void prepare(PaintContext context) {
    _lastOptions = ImagePaintOptions.fromNode(context.renderNode);
    _diagnostics.recordAllocation();
  }

  void cleanup() { _lastOptions = null; _diagnostics.reset(); }

  @override
  PaintResult paint(PaintContext context) {
    final sw = Stopwatch()..start();
    final canvas = context.canvas;
    if (canvas == null) {
      _diagnostics.recordError('Canvas is null');
      return PaintResult.failure('Canvas is null');
    }
    final options = _lastOptions ?? ImagePaintOptions.fromNode(context.renderNode);

    if (!options.visible) {
      _metrics.recordImage(0);
      _diagnostics.recordSkipped('Not visible');
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'image');
    }

    final rect = options.rect;

    canvas.save();
    _diagnostics.recordOperation('canvas.save');
    try {
      _applyTransform(canvas, options, rect);
      _applyClip(canvas, options, rect);
      _drawShadows(canvas, options, rect);
      _drawPlaceholderOrImage(canvas, options, rect);
      _drawBorder(canvas, options, rect);
      if (options.debugPaint) _drawDebug(canvas, options, rect);

      _metrics.recordImage(rect.width * rect.height);
      sw.stop();
      _metrics.recordDuration(sw.elapsed);
      return PaintResult(
        success: true, duration: sw.elapsed,
        paintBounds: options.computePaintBounds(),
        elementType: 'image',
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

  void _applyTransform(Canvas canvas, ImagePaintOptions options, Rect rect) {
    if (options.rotation == 0 && options.scaleX == 1 && options.scaleY == 1) return;
    final cx = rect.center.dx;
    final cy = rect.center.dy;
    canvas.translate(cx, cy);
    if (options.rotation != 0) canvas.rotate(options.rotation);
    if (options.scaleX != 1 || options.scaleY != 1) canvas.scale(options.scaleX, options.scaleY);
    canvas.translate(-cx, -cy);
    _diagnostics.recordOperation('canvas.transform');
  }

  void _applyClip(Canvas canvas, ImagePaintOptions options, Rect rect) {
    if (options.circular) {
      canvas.clipRRect(RRect.fromRectXY(rect, rect.width / 2, rect.height / 2));
      _diagnostics.recordOperation('canvas.clipRRect(oval)');
    } else if (options.hasBorderRadius) {
      canvas.clipRRect(options.toRRect());
      _diagnostics.recordOperation('canvas.clipRRect');
    } else if (options.clipping) {
      canvas.clipRect(rect);
      _diagnostics.recordOperation('canvas.clipRect');
    }
  }

  void _drawShadows(Canvas canvas, ImagePaintOptions options, Rect rect) {
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
      if (options.circular) {
        canvas.drawOval(rect, _shadowPaint);
      } else if (rrect != null) {
        canvas.drawRRect(rrect, _shadowPaint);
      } else {
        canvas.drawRect(rect, _shadowPaint);
      }
      canvas.restore();
      _metrics.recordShadow();
      _diagnostics.recordOperation('canvas.drawShadow');
    }
  }

  void _drawPlaceholderOrImage(Canvas canvas, ImagePaintOptions options, Rect rect) {
    if (_image != null) {
      _drawImage(canvas, options, rect);
    } else {
      _drawPlaceholder(canvas, options, rect);
    }
  }

  void _drawImage(Canvas canvas, ImagePaintOptions options, Rect rect) {
    final image = _image!;
    final imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final imageRect = options.computeImageRect(imageSize);

    _imagePaint
      ..style = PaintingStyle.fill
      ..blendMode = options.style.blendMode;

    if (options.style.hasColorFilter) {
      _imagePaint.colorFilter = ColorFilter.mode(
        options.style.colorFilterColor!, options.style.colorFilterBlendMode,
      );
    } else {
      _imagePaint.colorFilter = null;
    }

    canvas.drawImageRect(image, Offset.zero & imageSize, imageRect, _imagePaint);
    _diagnostics.recordOperation('canvas.drawImageRect');
  }

  void _drawPlaceholder(Canvas canvas, ImagePaintOptions options, Rect rect) {
    final color = options.style.placeholderColor ?? const Color(0xFFE0E0E0);
    _placeholderPaint
      ..color = color.withValues(alpha: color.a * options.opacity)
      ..style = PaintingStyle.fill
      ..blendMode = options.style.blendMode;

    if (options.hasBorderRadius) {
      canvas.drawRRect(options.toRRect(), _placeholderPaint);
    } else {
      canvas.drawRect(rect, _placeholderPaint);
    }

    _metrics.recordPlaceholder();
    _diagnostics.recordOperation('canvas.drawPlaceholder');
  }

  void _drawBorder(Canvas canvas, ImagePaintOptions options, Rect rect) {
    if (!options.style.hasBorder) return;
    final alpha = (options.style.borderColor!.a * options.opacity).clamp(0.0, 1.0);
    _borderPaint
      ..color = options.style.borderColor!.withValues(alpha: alpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = options.style.borderWidth
      ..blendMode = options.style.blendMode;

    if (options.circular) {
      canvas.drawOval(rect, _borderPaint);
    } else if (options.hasBorderRadius) {
      canvas.drawRRect(options.toRRect(), _borderPaint);
    } else {
      canvas.drawRect(rect, _borderPaint);
    }
    _metrics.recordBorder();
    _diagnostics.recordOperation('canvas.drawBorder');
  }

  void _drawDebug(Canvas canvas, ImagePaintOptions options, Rect rect) {
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
    _lastOptions = null; _image = null;
    _metrics.reset(); _diagnostics.reset();
  }

  @override
  String toString() => 'ImagePainter(metrics: $_metrics)';
}

// ============================================================================
// Demo — 10 examples
// ============================================================================

String runImagePainterDemo() {
  final buffer = StringBuffer();
  buffer.writeln('=== ImagePainter Demo ===');
  buffer.writeln('');

  final examples = <_DemoExample>[
    _DemoExample('Placeholder image (no source)', RenderPaintNode(
      id: 'ex1', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#E0E0E0',
    )),
    _DemoExample('Placeholder with color', RenderPaintNode(
      id: 'ex2', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#BBDEFB',
    )),
    _DemoExample('Rounded image', RenderPaintNode(
      id: 'ex3', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#C8E6C9',
      properties: {'borderRadius': 20},
    )),
    _DemoExample('Circular image', RenderPaintNode(
      id: 'ex4', type: 'image',
      x: 50, y: 50, width: 150, height: 150,
      color: '#FFE0B2',
      properties: {'circular': true},
    )),
    _DemoExample('Image with border', RenderPaintNode(
      id: 'ex5', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#F8BBD0',
      properties: {
        'borderWidth': 4,
        'borderColor': '#E91E63',
      },
    )),
    _DemoExample('Image with shadow', RenderPaintNode(
      id: 'ex6', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#B3E5FC',
      properties: {
        'shadows': [
          {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
        ],
      },
    )),
    _DemoExample('Rotated image', RenderPaintNode(
      id: 'ex7', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#D1C4E9',
      rotation: 0.3,
    )),
    _DemoExample('Transparent image', RenderPaintNode(
      id: 'ex8', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#FFCDD2',
      opacity: 0.5,
    )),
    _DemoExample('Color filter placeholder', RenderPaintNode(
      id: 'ex9', type: 'image',
      x: 50, y: 50, width: 200, height: 150,
      color: '#FFF9C4',
      properties: {
        'colorFilterColor': '#FF0000',
        'colorFilterBlendMode': 'srcOver',
      },
    )),
    _DemoExample('Mixed example', RenderPaintNode(
      id: 'ex10', type: 'image',
      x: 50, y: 50, width: 220, height: 160,
      color: '#DCEDC8',
      rotation: 0.1, opacity: 0.85,
      properties: {
        'borderRadius': 12,
        'circular': false,
        'borderWidth': 3,
        'borderColor': '#33691E',
        'clipping': true,
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
    final painter = ImagePainter();
    final context = PaintContext(
      canvas: canvas,
      document: ThemeDocument(
        metadata: ThemeMetadata(id: 'demo', name: 'ImagePainter Demo'),
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
