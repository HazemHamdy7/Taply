import 'dart:ui' show Color, BlendMode;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseColor, parseBlendMode, parseDouble;
import '../paint_shadow.dart' show PaintShadow;

class CirclePaintStyle {
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final List<PaintShadow> shadows;
  final BlendMode blendMode;
  final bool antiAlias;

  const CirclePaintStyle({
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 0.0,
    this.shadows = const [],
    this.blendMode = BlendMode.srcOver,
    this.antiAlias = true,
  });

  bool get hasFill => fillColor != null;
  bool get hasStroke => strokeWidth > 0 && strokeColor != null;
  bool get hasShadows => shadows.isNotEmpty;

  factory CirclePaintStyle.fromNode(RenderPaintNode node) {
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
        offsetX: s.offsetX,
        offsetY: s.offsetY,
        blurRadius: s.blurRadius,
        opacity: s.opacity,
      ));
    }
    return CirclePaintStyle(
      fillColor: parseColor(node.color),
      strokeColor: parseColor(node.strokeColor),
      strokeWidth: node.strokeWidth ?? 0.0,
      shadows: shadows,
      blendMode: parseBlendMode(node.properties['blendMode'] as String?),
      antiAlias: (node.properties['antiAlias'] as bool?) ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is CirclePaintStyle &&
      fillColor == other.fillColor &&
      strokeColor == other.strokeColor &&
      strokeWidth == other.strokeWidth &&
      blendMode == other.blendMode;

  @override
  int get hashCode => Object.hash(fillColor, strokeColor, strokeWidth, blendMode);

  @override
  String toString() =>
      'CirclePaintStyle(fill: $fillColor, stroke: $strokeColor/${strokeWidth}px, '
      'shadows: ${shadows.length})';
}
