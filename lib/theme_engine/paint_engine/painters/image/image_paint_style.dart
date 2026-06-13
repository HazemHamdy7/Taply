import 'dart:ui' show Color, BlendMode;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseColor, parseBlendMode, parseDouble;
import '../paint_shadow.dart' show PaintShadow;

class ImagePaintStyle {
  final String imageSource;
  final String? imagePath;
  final List<int>? imageBytes;
  final String? imageKey;
  final Color? placeholderColor;
  final Color? borderColor;
  final double borderWidth;
  final Color? colorFilterColor;
  final BlendMode colorFilterBlendMode;
  final List<PaintShadow> shadows;
  final BlendMode blendMode;
  final bool antiAlias;

  const ImagePaintStyle({
    this.imageSource = 'placeholder',
    this.imagePath,
    this.imageBytes,
    this.imageKey,
    this.placeholderColor,
    this.borderColor,
    this.borderWidth = 0,
    this.colorFilterColor,
    this.colorFilterBlendMode = BlendMode.srcIn,
    this.shadows = const [],
    this.blendMode = BlendMode.srcOver,
    this.antiAlias = true,
  });

  bool get hasBorder => borderWidth > 0 && borderColor != null;
  bool get hasShadows => shadows.isNotEmpty;
  bool get hasColorFilter => colorFilterColor != null;

  factory ImagePaintStyle.fromNode(RenderPaintNode node) {
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

    final cfColor = parseColor(node.properties['colorFilterColor'] as String?);
    final cfBlendStr = node.properties['colorFilterBlendMode'] as String?;
    final cfBlend = cfBlendStr != null ? parseBlendMode(cfBlendStr) : BlendMode.srcIn;

    return ImagePaintStyle(
      imageSource: node.properties['imageSource'] as String? ?? 'placeholder',
      imagePath: node.properties['imagePath'] as String?,
      imageBytes: (node.properties['imageBytes'] as List<dynamic>?)
          ?.map((e) => e as int).toList(),
      imageKey: node.properties['imageKey'] as String?,
      placeholderColor: parseColor(node.color) ?? parseColor(node.properties['placeholderColor'] as String?),
      borderColor: parseColor(node.properties['borderColor'] as String?),
      borderWidth: parseDouble(node.properties['borderWidth']) ?? 0,
      colorFilterColor: cfColor,
      colorFilterBlendMode: cfBlend,
      shadows: shadows,
      blendMode: parseBlendMode(node.properties['blendMode'] as String?),
      antiAlias: (node.properties['antiAlias'] as bool?) ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ImagePaintStyle &&
      imageSource == other.imageSource &&
      imagePath == other.imagePath &&
      borderWidth == other.borderWidth &&
      borderColor == other.borderColor &&
      blendMode == other.blendMode;

  @override
  int get hashCode => Object.hash(imageSource, imagePath, borderWidth, borderColor, blendMode);

  @override
  String toString() =>
      'ImagePaintStyle(source: $imageSource, path: $imagePath, '
      'border: $borderWidth, shadows: ${shadows.length})';
}
