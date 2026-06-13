import 'dart:math' show pi, max, cos, sin;
import 'dart:ui' show Color, Gradient, Offset, Rect, BlendMode, TileMode;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseColor, parseBlendMode, parseDouble, parseTileMode;
import '../paint_shadow.dart' show PaintShadow;

class GradientPaintStyle {
  final Gradient? gradient;
  final String gradientKind;
  final List<Color> colors;
  final List<double>? stops;
  final TileMode tileMode;
  final List<PaintShadow> shadows;
  final BlendMode blendMode;
  final bool antiAlias;

  const GradientPaintStyle({
    this.gradient,
    this.gradientKind = 'linear',
    this.colors = const [],
    this.stops,
    this.tileMode = TileMode.clamp,
    this.shadows = const [],
    this.blendMode = BlendMode.srcOver,
    this.antiAlias = true,
  });

  bool get hasGradient => gradient != null;
  bool get hasShadows => shadows.isNotEmpty;

  static Gradient? _buildGradient(
    String kind, List<Color> colors, List<double>? stops,
    TileMode tileMode, Rect bounds, RenderPaintNode node,
  ) {
    if (colors.isEmpty) return null;
    switch (kind) {
      case 'radial': {
        final cx = parseDouble(node.properties['centerX']) ?? bounds.center.dx;
        final cy = parseDouble(node.properties['centerY']) ?? bounds.center.dy;
        final radius = parseDouble(node.properties['gradientRadius']) ??
            max(bounds.width, bounds.height) / 2;
        return Gradient.radial(
          Offset(cx, cy), radius, colors, stops, tileMode,
        );
      }
      case 'sweep': {
        final cx = parseDouble(node.properties['centerX']) ?? bounds.center.dx;
        final cy = parseDouble(node.properties['centerY']) ?? bounds.center.dy;
        final startAngle = (parseDouble(node.properties['startAngle']) ?? 0) * pi / 180;
        final endAngle = (parseDouble(node.properties['endAngle']) ?? 360) * pi / 180;
        final effectiveStops = stops ?? (colors.length == 2 ? null :
          List.generate(colors.length, (i) => i / (colors.length - 1)));
        return Gradient.sweep(Offset(cx, cy), colors, effectiveStops, tileMode, startAngle, endAngle);
      }
      default: {
        final angle = (parseDouble(node.properties['angle']) ?? 0) * pi / 180;
        final c = cos(angle).abs();
        final s = sin(angle).abs();
        final cx = bounds.center.dx;
        final cy = bounds.center.dy;
        final dx = bounds.width / 2 * c + bounds.height / 2 * s;
        final dy = bounds.width / 2 * s + bounds.height / 2 * c;
        final startX = parseDouble(node.properties['startX']) ?? (cx - dx);
        final startY = parseDouble(node.properties['startY']) ?? (cy - dy);
        final endX = parseDouble(node.properties['endX']) ?? (cx + dx);
        final endY = parseDouble(node.properties['endY']) ?? (cy + dy);
        return Gradient.linear(
          Offset(startX, startY), Offset(endX, endY),
          colors, stops, tileMode,
        );
      }
    }
  }

  factory GradientPaintStyle.fromNode(RenderPaintNode node) {
    final bounds = Rect.fromLTWH(node.x, node.y, node.width, node.height);

    final rawColors = node.properties['gradientColors'] as List<dynamic>?;
    final colors = rawColors
        ?.map((c) => parseColor(c as String?))
        .whereType<Color>()
        .toList() ?? [];

    final rawStops = node.properties['gradientStops'] as List<dynamic>?;
    final stops = rawStops?.map((s) => (s as num).toDouble()).toList();

    final kind = node.properties['gradientKind'] as String? ?? 'linear';
    final tileMode = parseTileMode(node.properties['tileMode'] as String?);

    final gradient = _buildGradient(kind, colors, stops, tileMode, bounds, node);

    final rawShadows = node.properties['shadows'] as List<dynamic>?;
    final shadows = <PaintShadow>[];
    if (rawShadows != null) {
      for (final s in rawShadows) {
        if (s is Map<String, dynamic>) {
          shadows.add(PaintShadow(
            color: parseColor(s['color'] as String?) ?? const Color(0x33000000),
            offsetX: parseDouble(s['offsetX']) ?? 0,
            offsetY: parseDouble(s['offsetY']) ?? 0,
            blurRadius: parseDouble(s['blurRadius']) ?? 4,
            opacity: parseDouble(s['opacity']) ?? 0.3,
          ));
        }
      }
    }
    for (final s in node.shadows) {
      shadows.add(PaintShadow(
        color: parseColor(s.color) ?? const Color(0x33000000),
        offsetX: s.offsetX, offsetY: s.offsetY,
        blurRadius: s.blurRadius, opacity: s.opacity,
      ));
    }

    return GradientPaintStyle(
      gradient: gradient,
      gradientKind: kind,
      colors: colors,
      stops: stops,
      tileMode: tileMode,
      shadows: shadows,
      blendMode: parseBlendMode(node.properties['blendMode'] as String?),
      antiAlias: (node.properties['antiAlias'] as bool?) ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is GradientPaintStyle &&
      gradientKind == other.gradientKind &&
      blendMode == other.blendMode &&
      tileMode == other.tileMode;

  @override
  int get hashCode => Object.hash(gradientKind, blendMode, tileMode);

  @override
  String toString() =>
      'GradientPaintStyle(kind: $gradientKind, colors: ${colors.length}, '
      'shadows: ${shadows.length})';
}
