import 'dart:ui' show Color, BlendMode, StrokeCap;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseColor, parseBlendMode, parseDouble;
import '../paint_shadow.dart' show PaintShadow;

class LinePaintStyle {
  final Color? lineColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final List<PaintShadow> shadows;
  final BlendMode blendMode;
  final bool antiAlias;

  const LinePaintStyle({
    this.lineColor,
    this.strokeWidth = 1.0,
    this.strokeCap = StrokeCap.butt,
    this.shadows = const [],
    this.blendMode = BlendMode.srcOver,
    this.antiAlias = true,
  });

  bool get hasLine => lineColor != null && strokeWidth > 0;
  bool get hasShadows => shadows.isNotEmpty;

  factory LinePaintStyle.fromNode(RenderPaintNode node) {
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
    final capRaw = node.properties['strokeCap'] as String?;
    final strokeCap = switch (capRaw) {
      'round' => StrokeCap.round,
      'square' => StrokeCap.square,
      _ => StrokeCap.butt,
    };
    return LinePaintStyle(
      lineColor: parseColor(node.color),
      strokeWidth: node.strokeWidth ?? 1.0,
      strokeCap: strokeCap,
      shadows: shadows,
      blendMode: parseBlendMode(node.properties['blendMode'] as String?),
      antiAlias: (node.properties['antiAlias'] as bool?) ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is LinePaintStyle &&
      lineColor == other.lineColor &&
      strokeWidth == other.strokeWidth &&
      strokeCap == other.strokeCap &&
      blendMode == other.blendMode;

  @override
  int get hashCode => Object.hash(lineColor, strokeWidth, strokeCap, blendMode);

  @override
  String toString() =>
      'LinePaintStyle(color: $lineColor, width: ${strokeWidth}px, '
      'cap: $strokeCap, shadows: ${shadows.length})';
}
