import 'dart:math' show pi, cos, sin, max;
import 'dart:typed_data' show Float64List;
import 'dart:ui' show
    Canvas,
    Paint,
    Color,
    Rect,
    RRect,
    Radius,
    Path,
    Offset,
    Gradient,
    PaintingStyle,
    BlendMode,
    BlurStyle,
    MaskFilter,
    StrokeCap,
    StrokeJoin,
    PictureRecorder,
    TileMode;

import '../../models/gradient_definition.dart';
import '../../models/shadow_definition.dart';
import '../../models/theme_canvas.dart';
import '../../models/theme_document.dart';
import '../../models/theme_metadata.dart';
import '../../renderer/render_node.dart';
import '../../renderer/render_tree.dart';
import '../base_painter.dart';
import '../paint_capabilities.dart';
import '../paint_context.dart';
import '../paint_result.dart';

// ============================================================================
// Helpers
// ============================================================================

Color? _parseColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var h = hex;
  if (h.startsWith('#')) h = h.substring(1);
  if (h.length == 6) {
    return Color(int.parse('FF$h', radix: 16));
  }
  return Color(int.parse(h, radix: 16));
}

BlendMode _parseBlendMode(String? mode) {
  if (mode == null) return BlendMode.srcOver;
  switch (mode) {
    case 'srcOver':    return BlendMode.srcOver;
    case 'srcIn':      return BlendMode.srcIn;
    case 'srcOut':     return BlendMode.srcOut;
    case 'srcATop':    return BlendMode.srcATop;
    case 'dstOver':    return BlendMode.dstOver;
    case 'dstIn':      return BlendMode.dstIn;
    case 'dstOut':     return BlendMode.dstOut;
    case 'dstATop':    return BlendMode.dstATop;
    case 'multiply':   return BlendMode.multiply;
    case 'screen':     return BlendMode.screen;
    case 'overlay':    return BlendMode.overlay;
    case 'darken':     return BlendMode.darken;
    case 'lighten':    return BlendMode.lighten;
    case 'colorDodge': return BlendMode.colorDodge;
    case 'colorBurn':  return BlendMode.colorBurn;
    case 'hardLight':  return BlendMode.hardLight;
    case 'softLight':  return BlendMode.softLight;
    case 'difference': return BlendMode.difference;
    case 'exclusion':  return BlendMode.exclusion;
    case 'hue':        return BlendMode.hue;
    case 'saturation': return BlendMode.saturation;
    case 'color':      return BlendMode.color;
    case 'luminosity': return BlendMode.luminosity;
    default:           return BlendMode.srcOver;
  }
}

StrokeCap _parseStrokeCap(String? cap) {
  switch (cap) {
    case 'round': return StrokeCap.round;
    case 'square': return StrokeCap.square;
    default: return StrokeCap.butt;
  }
}

StrokeJoin _parseStrokeJoin(String? join) {
  switch (join) {
    case 'round': return StrokeJoin.round;
    case 'bevel': return StrokeJoin.bevel;
    default: return StrokeJoin.miter;
  }
}

// ============================================================================
// PaintStyleType
// ============================================================================

enum PaintStyleType { fill, stroke, fillAndStroke }

// ============================================================================
// StrokeAlignment
// ============================================================================

enum StrokeAlignment { center, inside, outside }

// ============================================================================
// RectanglePaintStyle
// ============================================================================

class RectanglePaintStyle {
  final PaintStyleType styleType;

  // Fill
  final Color? fillColor;
  final Gradient? fillGradient;

  // Stroke
  final Color? strokeColor;
  final Gradient? strokeGradient;
  final double strokeWidth;
  final StrokeAlignment strokeAlignment;
  final List<double>? dashPattern;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;

  // Gradient
  final GradientDefinition? gradientDef;

  // Shadows
  final List<PaintShadow> shadows;

  // General
  final BlendMode blendMode;
  final bool antiAlias;

  const RectanglePaintStyle({
    this.styleType = PaintStyleType.fill,
    this.fillColor,
    this.fillGradient,
    this.strokeColor,
    this.strokeGradient,
    this.strokeWidth = 0.0,
    this.strokeAlignment = StrokeAlignment.center,
    this.dashPattern,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.gradientDef,
    this.shadows = const [],
    this.blendMode = BlendMode.srcOver,
    this.antiAlias = true,
  });

  bool get hasFill => styleType != PaintStyleType.stroke && (fillColor != null || fillGradient != null);
  bool get hasStroke =>
      styleType != PaintStyleType.fill && strokeWidth > 0 && strokeColor != null;
  bool get hasGradient => fillGradient != null || strokeGradient != null;
  bool get hasDash => dashPattern != null && dashPattern!.isNotEmpty;
  bool get hasShadows => shadows.isNotEmpty;

  static Gradient? _buildGradient(
    GradientDefinition? def,
    Rect bounds,
  ) {
    if (def == null) return null;
    final colors = def.colors
        .map((c) => _parseColor(c))
        .whereType<Color>()
        .toList();
    if (colors.isEmpty) return null;

    final stops = def.stops?.map((s) => s.toDouble()).toList();

    switch (def.kind) {
      case 'linear':
        final angle = def.angle * pi / 180.0;
        final c = cos(angle).abs();
        final s = sin(angle).abs();
        final cx = bounds.center.dx;
        final cy = bounds.center.dy;
        final dx = (bounds.width / 2 * c + bounds.height / 2 * s);
        final dy = (bounds.width / 2 * s + bounds.height / 2 * c);
        return Gradient.linear(
          Offset(cx - dx, cy - dy),
          Offset(cx + dx, cy + dy),
          colors,
          stops,
          TileMode.clamp,
        );
      case 'radial':
        return Gradient.radial(
          Offset(def.focalX * bounds.width, def.focalY * bounds.height),
          def.radius * max(bounds.width, bounds.height) / 2,
          colors,
          stops,
          TileMode.clamp,
        );
      case 'sweep':
        return Gradient.sweep(
          Offset(bounds.center.dx, bounds.center.dy),
          colors, stops, TileMode.clamp, 0, 2 * pi,
        );
      default:
        return null;
    }
  }

  factory RectanglePaintStyle.fromNode(RenderPaintNode node) {
    final gradientDef = node.gradient;
    final bounds = Rect.fromLTWH(node.x, node.y, node.width, node.height);
    final fillGradient = _buildGradient(gradientDef, bounds);

    final rawShadows = node.properties['shadows'] as List<dynamic>?;
    final shadows = <PaintShadow>[];
    if (rawShadows != null) {
      for (final s in rawShadows) {
        if (s is Map<String, dynamic>) {
          shadows.add(PaintShadow(
            color: _parseColor(s['color'] as String?) ?? const Color(0x33000000),
            offsetX: (s['offsetX'] as num?)?.toDouble() ?? 0,
            offsetY: (s['offsetY'] as num?)?.toDouble() ?? 0,
            blurRadius: (s['blurRadius'] as num?)?.toDouble() ?? 4,
            opacity: (s['opacity'] as num?)?.toDouble() ?? 0.3,
          ));
        }
      }
    }
    for (final s in node.shadows) {
      shadows.add(PaintShadow(
        color: _parseColor(s.color) ?? const Color(0x33000000),
        offsetX: s.offsetX,
        offsetY: s.offsetY,
        blurRadius: s.blurRadius,
        opacity: s.opacity,
      ));
    }

    final dashRaw = node.properties['dashPattern'] as List<dynamic>?;
    final dashPattern = dashRaw?.map((d) => (d as num).toDouble()).toList();

    final styleRaw = node.properties['styleType'] as String?;
    final styleType = switch (styleRaw) {
      'stroke' => PaintStyleType.stroke,
      'fillAndStroke' => PaintStyleType.fillAndStroke,
      _ => PaintStyleType.fill,
    };

    final alignRaw = node.properties['strokeAlignment'] as String?;
    final strokeAlignment = switch (alignRaw) {
      'inside' => StrokeAlignment.inside,
      'outside' => StrokeAlignment.outside,
      _ => StrokeAlignment.center,
    };

    return RectanglePaintStyle(
      styleType: styleType,
      fillColor: _parseColor(node.color),
      fillGradient: fillGradient,
      strokeColor: _parseColor(node.strokeColor),
      strokeGradient: null,
      strokeWidth: node.strokeWidth ?? 0.0,
      strokeAlignment: strokeAlignment,
      dashPattern: dashPattern,
      strokeCap: _parseStrokeCap(node.properties['strokeCap'] as String?),
      strokeJoin: _parseStrokeJoin(node.properties['strokeJoin'] as String?),
      gradientDef: gradientDef,
      shadows: shadows,
      blendMode: _parseBlendMode(node.properties['blendMode'] as String?),
      antiAlias: (node.properties['antiAlias'] as bool?) ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is RectanglePaintStyle &&
      styleType == other.styleType &&
      fillColor == other.fillColor &&
      strokeColor == other.strokeColor &&
      strokeWidth == other.strokeWidth &&
      strokeAlignment == other.strokeAlignment &&
      blendMode == other.blendMode;

  @override
  int get hashCode => Object.hash(
    styleType, fillColor, strokeColor, strokeWidth, strokeAlignment, blendMode,
  );

  @override
  String toString() =>
    'RectanglePaintStyle(type: $styleType, fill: $fillColor, '
    'stroke: $strokeColor/${strokeWidth}px, '
    'shadows: ${shadows.length}, dash: ${dashPattern?.length ?? 0})';
}

// ============================================================================
// PaintShadow
// ============================================================================

class PaintShadow {
  final Color color;
  final double offsetX;
  final double offsetY;
  final double blurRadius;
  final double opacity;

  const PaintShadow({
    required this.color,
    this.offsetX = 0,
    this.offsetY = 4,
    this.blurRadius = 4.0,
    this.opacity = 0.3,
  });

  PaintShadow scale(double factor) {
    return PaintShadow(
      color: color,
      offsetX: offsetX * factor,
      offsetY: offsetY * factor,
      blurRadius: blurRadius * factor,
      opacity: opacity,
    );
  }

  @override
  String toString() =>
    'PaintShadow(offset: $offsetX,$offsetY, blur: $blurRadius, opacity: $opacity)';
}

// ============================================================================
// RectanglePaintOptions
// ============================================================================

class RectanglePaintOptions {
  final Rect rect;
  final double borderRadiusTL;
  final double borderRadiusTR;
  final double borderRadiusBR;
  final double borderRadiusBL;
  final double opacity;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final double translateX;
  final double translateY;
  final Float64List? transformMatrix;
  final bool visible;
  final bool clipping;
  final int zIndex;
  final int paintOrder;
  final bool debugPaint;
  final Rect? hitTestBounds;
  final RectanglePaintStyle style;

  const RectanglePaintOptions({
    required this.rect,
    this.borderRadiusTL = 0,
    this.borderRadiusTR = 0,
    this.borderRadiusBR = 0,
    this.borderRadiusBL = 0,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.translateX = 0.0,
    this.translateY = 0.0,
    this.transformMatrix,
    this.visible = true,
    this.clipping = false,
    this.zIndex = 0,
    this.paintOrder = 0,
    this.debugPaint = false,
    this.hitTestBounds,
    required this.style,
  });

  double get borderRadius => borderRadiusTL;

  bool get hasBorderRadius =>
    borderRadiusTL > 0 || borderRadiusTR > 0 ||
    borderRadiusBR > 0 || borderRadiusBL > 0;

  RRect toRRect() {
    return RRect.fromRectAndCorners(
      rect,
      topLeft: Radius.circular(borderRadiusTL),
      topRight: Radius.circular(borderRadiusTR),
      bottomRight: Radius.circular(borderRadiusBR),
      bottomLeft: Radius.circular(borderRadiusBL),
    );
  }

  Rect computePaintBounds() {
    Rect r = rect;
    if (style.strokeWidth > 0 && style.strokeColor != null) {
      final half = style.strokeWidth / 2;
      r = r.inflate(half);
    }
    if (style.hasShadows) {
      for (final s in style.shadows) {
        final shadowOffset = Offset(s.offsetX, s.offsetY);
        final shadowRect = r.shift(shadowOffset).inflate(s.blurRadius);
        r = r.expandToInclude(shadowRect);
      }
    }
    if (rotation != 0 || scaleX != 1 || scaleY != 1) {
      final cx = r.center.dx;
      final cy = r.center.dy;
      final c = cos(rotation);
      final s = sin(rotation);
      final corners = [
        Offset(r.left - cx, r.top - cy),
        Offset(r.right - cx, r.top - cy),
        Offset(r.right - cx, r.bottom - cy),
        Offset(r.left - cx, r.bottom - cy),
      ];
      double minX = double.infinity;
      double minY = double.infinity;
      double maxX = double.negativeInfinity;
      double maxY = double.negativeInfinity;
      for (final corner in corners) {
        final rx = corner.dx * c - corner.dy * s;
        final ry = corner.dx * s + corner.dy * c;
        final sx = rx * scaleX;
        final sy = ry * scaleY;
        final x = sx + cx;
        final y = sy + cy;
        minX = minX < x ? minX : x;
        minY = minY < y ? minY : y;
        maxX = maxX > x ? maxX : x;
        maxY = maxY > y ? maxY : y;
      }
      r = Rect.fromLTRB(minX, minY, maxX, maxY);
    }
    return r;
  }

  factory RectanglePaintOptions.fromNode(RenderPaintNode node) {
    final style = RectanglePaintStyle.fromNode(node);
    final r = Rect.fromLTWH(node.x, node.y, node.width, node.height);

    final br = (node.properties['borderRadius'] as num?)?.toDouble();
    final brTL = (node.properties['borderRadiusTL'] as num?)?.toDouble() ?? br ?? 0;
    final brTR = (node.properties['borderRadiusTR'] as num?)?.toDouble() ?? br ?? 0;
    final brBR = (node.properties['borderRadiusBR'] as num?)?.toDouble() ?? br ?? 0;
    final brBL = (node.properties['borderRadiusBL'] as num?)?.toDouble() ?? br ?? 0;

    final matrixRaw = node.properties['transformMatrix'] as List<dynamic>?;
    Float64List? matrix;
    if (matrixRaw != null && matrixRaw.length == 16) {
      matrix = Float64List(16);
      for (var i = 0; i < 16; i++) {
        matrix[i] = (matrixRaw[i] as num).toDouble();
      }
    }

    final tx = (node.properties['translateX'] as num?)?.toDouble() ?? 0;
    final ty = (node.properties['translateY'] as num?)?.toDouble() ?? 0;
    final zIndex = (node.properties['zIndex'] as num?)?.toInt() ?? node.zIndex;
    final paintOrder = (node.properties['paintOrder'] as num?)?.toInt() ?? 0;
    final debugPaint = (node.properties['debugPaint'] as bool?) ?? false;

    final htRaw = node.properties['hitTestBounds'] as Map<String, dynamic>?;
    Rect? hitTestBounds;
    if (htRaw != null) {
      final hx = (htRaw['x'] as num?)?.toDouble();
      final hy = (htRaw['y'] as num?)?.toDouble();
      final hw = (htRaw['width'] as num?)?.toDouble();
      final hh = (htRaw['height'] as num?)?.toDouble();
      if (hx != null && hy != null && hw != null && hh != null) {
        hitTestBounds = Rect.fromLTWH(hx, hy, hw, hh);
      }
    }

    return RectanglePaintOptions(
      rect: r,
      borderRadiusTL: brTL,
      borderRadiusTR: brTR,
      borderRadiusBR: brBR,
      borderRadiusBL: brBL,
      opacity: node.opacity,
      rotation: node.rotation,
      scaleX: node.scaleX,
      scaleY: node.scaleY,
      translateX: tx,
      translateY: ty,
      transformMatrix: matrix,
      visible: node.visible,
      clipping: (node.properties['clipping'] as bool?) ?? false,
      zIndex: zIndex,
      paintOrder: paintOrder,
      debugPaint: debugPaint,
      hitTestBounds: hitTestBounds,
      style: style,
    );
  }

  @override
  String toString() =>
    'RectanglePaintOptions(rect: $rect, borderRadius: '
    '$borderRadiusTL,$borderRadiusTR,$borderRadiusBR,$borderRadiusBL, '
    'opacity: $opacity, rotation: $rotation, scale: ${scaleX}x$scaleY, '
    'visible: $visible, clipping: $clipping, style: $style)';
}

// ============================================================================
// RectanglePaintMetrics
// ============================================================================

class RectanglePaintMetrics {
  int rectanglesPainted = 0;
  int gradientPainted = 0;
  int strokedRectangles = 0;
  int shadowCount = 0;
  int clippedCount = 0;
  int cacheHits = 0;
  int cacheMisses = 0;
  Duration paintDuration = Duration.zero;
  double totalArea = 0.0;

  void recordRect(double area) {
    rectanglesPainted++;
    totalArea += area;
  }

  void recordGradient() {
    gradientPainted++;
  }

  void recordStroke() {
    strokedRectangles++;
  }

  void recordShadow() {
    shadowCount++;
  }

  void recordClip() {
    clippedCount++;
  }

  void recordCacheHit() {
    cacheHits++;
  }

  void recordCacheMiss() {
    cacheMisses++;
  }

  void recordDuration(Duration d) {
    paintDuration += d;
  }

  void reset() {
    rectanglesPainted = 0;
    gradientPainted = 0;
    strokedRectangles = 0;
    shadowCount = 0;
    clippedCount = 0;
    cacheHits = 0;
    cacheMisses = 0;
    paintDuration = Duration.zero;
    totalArea = 0.0;
  }

  RectanglePaintMetrics copy() {
    final m = RectanglePaintMetrics();
    m.rectanglesPainted = rectanglesPainted;
    m.gradientPainted = gradientPainted;
    m.strokedRectangles = strokedRectangles;
    m.shadowCount = shadowCount;
    m.clippedCount = clippedCount;
    m.cacheHits = cacheHits;
    m.cacheMisses = cacheMisses;
    m.paintDuration = paintDuration;
    m.totalArea = totalArea;
    return m;
  }

  RectanglePaintMetrics operator +(RectanglePaintMetrics other) {
    final m = copy();
    m.rectanglesPainted += other.rectanglesPainted;
    m.gradientPainted += other.gradientPainted;
    m.strokedRectangles += other.strokedRectangles;
    m.shadowCount += other.shadowCount;
    m.clippedCount += other.clippedCount;
    m.cacheHits += other.cacheHits;
    m.cacheMisses += other.cacheMisses;
    m.paintDuration += other.paintDuration;
    m.totalArea += other.totalArea;
    return m;
  }

  double get averagePaintTimeMs {
    if (rectanglesPainted == 0) return 0;
    return paintDuration.inMicroseconds / rectanglesPainted / 1000.0;
  }

  @override
  String toString() =>
    'RectanglePaintMetrics(rects: $rectanglesPainted, '
    'gradients: $gradientPainted, strokes: $strokedRectangles, '
    'shadows: $shadowCount, clips: $clippedCount, '
    'cache: ${cacheHits}h/${cacheMisses}m, '
    'time: ${paintDuration.inMilliseconds}ms, '
    'avg: ${averagePaintTimeMs.toStringAsFixed(2)}ms, '
    'area: ${totalArea.toStringAsFixed(1)})';
}

// ============================================================================
// CanvasOperation
// ============================================================================

class CanvasOperation {
  final String name;
  final Duration duration;
  final Map<String, dynamic> details;

  const CanvasOperation({
    required this.name,
    this.duration = Duration.zero,
    this.details = const {},
  });

  @override
  String toString() => '$name(${duration.inMicroseconds}us)';
}

// ============================================================================
// RectanglePainterDiagnostics
// ============================================================================

class RectanglePainterDiagnostics {
  final List<CanvasOperation> operations = [];
  final List<String> warnings = [];
  final List<String> skipped = [];
  final List<String> errors = [];
  int memoryAllocations = 0;

  void recordOperation(String name, {Duration? duration, Map<String, dynamic>? details}) {
    operations.add(CanvasOperation(
      name: name,
      duration: duration ?? Duration.zero,
      details: details ?? const {},
    ));
  }

  void recordWarning(String message) {
    warnings.add(message);
  }

  void recordSkipped(String reason) {
    skipped.add(reason);
  }

  void recordError(String message) {
    errors.add(message);
  }

  void recordAllocation() {
    memoryAllocations++;
  }

  void reset() {
    operations.clear();
    warnings.clear();
    skipped.clear();
    errors.clear();
    memoryAllocations = 0;
  }

  void merge(RectanglePainterDiagnostics other) {
    operations.addAll(other.operations);
    warnings.addAll(other.warnings);
    skipped.addAll(other.skipped);
    errors.addAll(other.errors);
    memoryAllocations += other.memoryAllocations;
  }

  int get totalOperations => operations.length;
  Duration get totalDuration {
    Duration d = Duration.zero;
    for (final op in operations) {
      d += op.duration;
    }
    return d;
  }

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() =>
    'RectanglePainterDiagnostics(ops: $totalOperations, '
    'warnings: ${warnings.length}, errors: ${errors.length}, '
    'skipped: ${skipped.length}, allocs: $memoryAllocations)';
}

// ============================================================================
// RectanglePainter
// ============================================================================

class RectanglePainter extends BasePainter {
  final RectanglePaintMetrics _metrics = RectanglePaintMetrics();
  final RectanglePainterDiagnostics _diagnostics = RectanglePainterDiagnostics();

  // Reusable Paint objects — avoid allocations in paint()
  final Paint _fillPaint = Paint();
  final Paint _strokePaint = Paint();
  final Paint _shadowPaint = Paint();
  final Paint _debugPaint = Paint();

  // Reusable Path
  final Path _path = Path();

  // Last prepared options
  RectanglePaintOptions? _lastOptions;

  RectanglePaintMetrics get metrics => _metrics;
  RectanglePainterDiagnostics get diagnostics => _diagnostics;

  @override
  String get type => 'rect';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.advanced;

  @override
  bool canPaint(RenderPaintNode node) => node.type == 'rect';

  @override
  void initialize() {
    _metrics.reset();
    _diagnostics.reset();
  }

  @override
  void prepare(PaintContext context) {
    _lastOptions = RectanglePaintOptions.fromNode(context.renderNode);
    _diagnostics.recordAllocation();
  }

  void cleanup() {
    _lastOptions = null;
    _path.reset();
    _diagnostics.reset();
  }

  @override
  PaintResult paint(PaintContext context) {
    final sw = Stopwatch()..start();
    final node = context.renderNode;
    final canvas = context.canvas;

    if (canvas == null) {
      _diagnostics.recordError('Canvas is null');
      return PaintResult.failure('Canvas is null');
    }

    final options = _lastOptions ?? RectanglePaintOptions.fromNode(node);

    if (!options.visible) {
      _metrics.recordRect(0);
      _diagnostics.recordSkipped('Not visible');
      return PaintResult(success: true, duration: sw.elapsed, elementType: 'rect');
    }

    final rect = options.rect;

    canvas.save();
    _diagnostics.recordOperation('canvas.save');

    try {
      _applyTransform(canvas, options, rect);
      _applyClip(canvas, options, rect);
      _drawShadows(canvas, options, rect);
      _drawFill(canvas, options, rect);
      _drawStroke(canvas, options, rect);
      _drawDebugPaint(canvas, options, rect);

      _metrics.recordRect(rect.width * rect.height);
      sw.stop();
      _metrics.recordDuration(sw.elapsed);

      return PaintResult(
        success: true,
        duration: sw.elapsed,
        paintBounds: options.computePaintBounds(),
        elementType: 'rect',
        diagnostics: _diagnostics.hasErrors
            ? List<String>.from(_diagnostics.errors)
            : const [],
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

  void _applyTransform(Canvas canvas, RectanglePaintOptions options, Rect rect) {
    final hasMatrix = options.transformMatrix != null;
    final hasRotation = options.rotation != 0.0;
    final hasScale = options.scaleX != 1.0 || options.scaleY != 1.0;
    final hasTranslate = options.translateX != 0.0 || options.translateY != 0.0;

    if (hasMatrix) {
      canvas.transform(options.transformMatrix!);
      _diagnostics.recordOperation('canvas.transform(matrix)');
      return;
    }

    final cx = rect.center.dx;
    final cy = rect.center.dy;
    var transformed = false;

    if (hasTranslate) {
      canvas.translate(options.translateX, options.translateY);
      transformed = true;
    }
    if (hasRotation || hasScale) {
      canvas.translate(cx, cy);
      if (hasRotation) canvas.rotate(options.rotation);
      if (hasScale) canvas.scale(options.scaleX, options.scaleY);
      canvas.translate(-cx, -cy);
      transformed = true;
    }

    if (transformed) {
      _diagnostics.recordOperation('canvas.transform');
    }
  }

  void _applyClip(Canvas canvas, RectanglePaintOptions options, Rect rect) {
    if (!options.clipping) return;

    if (options.hasBorderRadius) {
      final rrect = options.toRRect();
      canvas.clipRRect(rrect);
      _diagnostics.recordOperation('canvas.clipRRect');
    } else {
      canvas.clipRect(rect);
      _diagnostics.recordOperation('canvas.clipRect');
    }
    _metrics.recordClip();
  }

  void _drawShadows(Canvas canvas, RectanglePaintOptions options, Rect rect) {
    final shadows = options.style.shadows;
    if (shadows.isEmpty) return;

    final rrect = options.hasBorderRadius ? options.toRRect() : null;

    for (final shadow in shadows) {
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

  void _drawFill(Canvas canvas, RectanglePaintOptions options, Rect rect) {
    if (!options.style.hasFill) return;

    final rrect = options.hasBorderRadius ? options.toRRect() : null;
    final effectiveAlpha = (options.style.fillColor?.a ?? 1.0) * options.opacity;

    if (options.style.fillGradient != null) {
      _fillPaint
        ..shader = options.style.fillGradient
        ..style = PaintingStyle.fill
        ..blendMode = options.style.blendMode;
      _metrics.recordGradient();
      _diagnostics.recordAllocation();
    } else if (options.style.fillColor != null) {
      _fillPaint
        ..color = options.style.fillColor!.withValues(alpha: effectiveAlpha)
        ..shader = null
        ..style = PaintingStyle.fill
        ..blendMode = options.style.blendMode;
    } else {
      return;
    }

    if (rrect != null) {
      canvas.drawRRect(rrect, _fillPaint);
      _diagnostics.recordOperation('canvas.drawRRect(fill)');
    } else {
      canvas.drawRect(rect, _fillPaint);
      _diagnostics.recordOperation('canvas.drawRect(fill)');
    }
  }

  void _drawStroke(Canvas canvas, RectanglePaintOptions options, Rect rect) {
    if (!options.style.hasStroke) return;

    final effectiveAlpha = (options.style.strokeColor?.a ?? 1.0) * options.opacity;

    _strokePaint
      ..color = options.style.strokeColor!.withValues(alpha: effectiveAlpha)
      ..style = PaintingStyle.stroke
      ..strokeWidth = options.style.strokeWidth
      ..strokeCap = options.style.strokeCap
      ..strokeJoin = options.style.strokeJoin
      ..blendMode = options.style.blendMode
      ..shader = null;

    final width = options.style.strokeWidth;
    final alignment = options.style.strokeAlignment;
    Rect strokeRect = rect;

    if (alignment == StrokeAlignment.inside) {
      strokeRect = rect.deflate(width / 2);
    } else if (alignment == StrokeAlignment.outside) {
      strokeRect = rect.inflate(width / 2);
    }

    if (options.style.hasDash) {
      _drawDashedStroke(canvas, strokeRect, options);
    } else if (options.hasBorderRadius) {
      final rrect = RRect.fromRectAndCorners(
        strokeRect,
        topLeft: Radius.circular(options.borderRadiusTL),
        topRight: Radius.circular(options.borderRadiusTR),
        bottomRight: Radius.circular(options.borderRadiusBR),
        bottomLeft: Radius.circular(options.borderRadiusBL),
      );
      canvas.drawRRect(rrect, _strokePaint);
      _diagnostics.recordOperation('canvas.drawRRect(stroke)');
    } else {
      canvas.drawRect(strokeRect, _strokePaint);
      _diagnostics.recordOperation('canvas.drawRect(stroke)');
    }

    _metrics.recordStroke();
  }

  void _drawDashedStroke(Canvas canvas, Rect rect, RectanglePaintOptions options) {
    final dash = options.style.dashPattern!;
    if (dash.isEmpty) return;

    _path.reset();
    if (options.hasBorderRadius) {
      _path.addRRect(RRect.fromRectAndCorners(
        rect,
        topLeft: Radius.circular(options.borderRadiusTL),
        topRight: Radius.circular(options.borderRadiusTR),
        bottomRight: Radius.circular(options.borderRadiusBR),
        bottomLeft: Radius.circular(options.borderRadiusBL),
      ));
    } else {
      _path.addRect(rect);
    }

    final metrics = _path.computeMetrics();
    for (final metric in metrics) {
      var distance = 0.0;
      var dashIndex = 0;
      var draw = true;

      while (distance < metric.length) {
        final segmentLength = dash[dashIndex % dash.length];
        final end = distance + segmentLength;

        if (end > metric.length) {
          if (draw) {
            final sub = metric.extractPath(distance, metric.length);
            canvas.drawPath(sub, _strokePaint);
          }
          break;
        }

        if (draw) {
          final sub = metric.extractPath(distance, end);
          canvas.drawPath(sub, _strokePaint);
        }

        distance = end;
        dashIndex++;
        draw = !draw;
      }
    }

    _diagnostics.recordOperation('canvas.drawPath(dash)');
  }

  void _drawDebugPaint(Canvas canvas, RectanglePaintOptions options, Rect rect) {
    if (!options.debugPaint) return;

    _debugPaint
      ..color = const Color(0x44FF0000)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(rect, _debugPaint);

    final bounds = options.computePaintBounds();
    _debugPaint
      ..color = const Color(0x440000FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRect(bounds, _debugPaint);

    if (options.hitTestBounds != null) {
      _debugPaint
        ..color = const Color(0x4400FF00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;

      canvas.drawRect(options.hitTestBounds!, _debugPaint);
    }

    _diagnostics.recordOperation('canvas.drawRect(debug)');
  }

  @override
  void dispose() {
    _lastOptions = null;
    _path.reset();
    _metrics.reset();
    _diagnostics.reset();
  }

  @override
  String toString() => 'RectanglePainter(metrics: $_metrics, diag: $_diagnostics)';
}

// ============================================================================
// Demo — 10 examples
// ============================================================================

String runRectanglePainterDemo() {
  final buffer = StringBuffer();
  buffer.writeln('=== RectanglePainter Demo ===');
  buffer.writeln('');

  final examples = <_DemoExample>[
    _DemoExample('Simple rectangle', RenderPaintNode(
      id: 'ex1', type: 'rect',
      x: 50, y: 50, width: 200, height: 150,
      color: '#42A5F5',
    )),
    _DemoExample('Rounded rectangle', RenderPaintNode(
      id: 'ex2', type: 'rect',
      x: 50, y: 50, width: 200, height: 150,
      color: '#66BB6A',
      properties: {'borderRadius': 20.0},
    )),
    _DemoExample('Gradient rectangle', RenderPaintNode(
      id: 'ex3', type: 'rect',
      x: 50, y: 50, width: 200, height: 150,
      gradient: GradientDefinition(
        kind: 'linear', colors: ['#FF6F00', '#FFB74D'], angle: 45,
      ),
    )),
    _DemoExample('Transparent rectangle', RenderPaintNode(
      id: 'ex4', type: 'rect',
      x: 50, y: 50, width: 200, height: 150,
      color: '#AB47BC',
      opacity: 0.5,
    )),
    _DemoExample('Rotated rectangle', RenderPaintNode(
      id: 'ex5', type: 'rect',
      x: 100, y: 80, width: 180, height: 120,
      color: '#EF5350',
      rotation: 0.3,
    )),
    _DemoExample('Scaled rectangle', RenderPaintNode(
      id: 'ex6', type: 'rect',
      x: 80, y: 60, width: 150, height: 100,
      color: '#26A69A',
      scaleX: 1.5, scaleY: 1.5,
    )),
    _DemoExample('Shadow rectangle', RenderPaintNode(
      id: 'ex7', type: 'rect',
      x: 50, y: 50, width: 200, height: 150,
      color: '#8D6E63',
      shadows: [const ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8, opacity: 0.4)],
    )),
    _DemoExample('Clipped rectangle', RenderPaintNode(
      id: 'ex8', type: 'rect',
      x: 50, y: 50, width: 200, height: 150,
      color: '#FF7043',
      properties: {'clipping': true, 'borderRadius': 30.0},
    )),
    _DemoExample('Dashed border rectangle', RenderPaintNode(
      id: 'ex9', type: 'rect',
      x: 50, y: 50, width: 200, height: 150,
      color: '#FFFFFF',
      strokeWidth: 3.0,
      strokeColor: '#1565C0',
      properties: {
        'dashPattern': [10, 5],
        'borderRadius': 12.0,
        'styleType': 'fillAndStroke',
      },
    )),
    _DemoExample('Mixed example', RenderPaintNode(
      id: 'ex10', type: 'rect',
      x: 50, y: 50, width: 220, height: 160,
      color: '#7E57C2',
      strokeWidth: 2.0,
      strokeColor: '#4A148C',
      rotation: 0.1,
      opacity: 0.85,
      shadows: [const ShadowDefinition(color: '#000000', offsetX: 3, offsetY: 3, blurRadius: 6, opacity: 0.3)],
      properties: {
        'borderRadius': 16.0,
        'clipping': false,
        'blendMode': 'srcOver',
        'dashPattern': [8, 4],
        'styleType': 'fillAndStroke',
      },
    )),
  ];

  for (var i = 0; i < examples.length; i++) {
    final ex = examples[i];
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);

    final painter = RectanglePainter();

    final context = PaintContext(
      canvas: canvas,
      document: ThemeDocument(
        metadata: ThemeMetadata(id: 'demo', name: 'RectanglePainter Demo'),
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
