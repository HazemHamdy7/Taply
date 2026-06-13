import 'dart:ui' show Color, Shadow, Gradient, Offset, Rect, BlendMode, TileMode, PaintingStyle, Paint;
import 'package:flutter/painting.dart' show
    TextStyle, FontWeight, FontStyle, TextAlign, TextDirection, TextOverflow;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseColor, parseBlendMode, parseDouble;

class TextPaintStyle {
  final String text;
  final String? fontFamily;
  final FontWeight fontWeight;
  final FontStyle fontStyle;
  final double fontSize;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? lineHeight;
  final TextAlign textAlign;
  final TextDirection textDirection;
  final int? maxLines;
  final String? ellipsis;
  final bool softWrap;
  final TextOverflow overflow;
  final Color? color;
  final Gradient? gradient;
  final List<Shadow> shadows;
  final Color? strokeColor;
  final double strokeWidth;
  final BlendMode blendMode;
  final bool antiAlias;
  final List<double>? gradientStops;
  final String gradientKind;
  final TileMode tileMode;

  const TextPaintStyle({
    this.text = '',
    this.fontFamily,
    this.fontWeight = FontWeight.normal,
    this.fontStyle = FontStyle.normal,
    this.fontSize = 14.0,
    this.letterSpacing,
    this.wordSpacing,
    this.lineHeight,
    this.textAlign = TextAlign.start,
    this.textDirection = TextDirection.ltr,
    this.maxLines,
    this.ellipsis,
    this.softWrap = true,
    this.overflow = TextOverflow.clip,
    this.color,
    this.gradient,
    this.shadows = const [],
    this.strokeColor,
    this.strokeWidth = 0,
    this.blendMode = BlendMode.srcOver,
    this.antiAlias = true,
    this.gradientStops,
    this.gradientKind = 'linear',
    this.tileMode = TileMode.clamp,
  });

  bool get hasGradient => gradient != null;
  bool get hasShadows => shadows.isNotEmpty;
  bool get hasStroke => strokeColor != null && strokeWidth > 0;

  static Gradient? _buildGradient(
    String kind,
    List<Color> colors,
    List<double>? stops,
    TileMode tileMode,
    Rect bounds,
  ) {
    if (colors.isEmpty) return null;
    switch (kind) {
      case 'radial':
        return Gradient.radial(bounds.center, bounds.shortestSide / 2, colors, stops, tileMode);
      case 'sweep':
        return Gradient.sweep(bounds.center, colors, stops, tileMode);
      default:
        return Gradient.linear(bounds.topLeft, bounds.bottomRight, colors, stops, tileMode);
    }
  }

  factory TextPaintStyle.fromNode(RenderPaintNode node) {
    final text = node.properties['text'] as String? ?? '';
    final fontFamily = node.properties['fontFamily'] as String?;

    final fontWeightStr = node.properties['fontWeight'] as String?;
    final fontWeight = _parseFontWeight(fontWeightStr);

    final fontStyleStr = node.properties['fontStyle'] as String?;
    final fontStyle = fontStyleStr == 'italic' ? FontStyle.italic : FontStyle.normal;

    final fontSize = parseDouble(node.properties['fontSize']) ?? 14.0;
    final letterSpacing = parseDouble(node.properties['letterSpacing']);
    final wordSpacing = parseDouble(node.properties['wordSpacing']);
    final lineHeight = parseDouble(node.properties['lineHeight']);

    final textAlignStr = node.properties['textAlign'] as String?;
    final textAlign = _parseTextAlign(textAlignStr);

    final textDirectionStr = node.properties['textDirection'] as String?;
    final textDirection = _parseTextDirection(textDirectionStr);

    final maxLines = (node.properties['maxLines'] as num?)?.toInt();
    final ellipsis = node.properties['ellipsis'] as String?;
    final softWrap = (node.properties['softWrap'] as bool?) ?? true;

    final overflowStr = node.properties['overflow'] as String?;
    final overflow = _parseOverflow(overflowStr);

    final color = parseColor(node.properties['color'] as String?);

    final rawColors = node.properties['gradientColors'] as List<dynamic>?;
    final gColors = rawColors?.map((c) => parseColor(c as String?)).whereType<Color>().toList() ?? [];

    final rawStops = node.properties['gradientStops'] as List<dynamic>?;
    final stops = rawStops?.map((s) => (s as num).toDouble()).toList();

    final gKind = node.properties['gradientKind'] as String? ?? 'linear';
    final tMode = node.properties['tileMode'] as String?;
    final tileMode = tMode == 'repeated' ? TileMode.repeated :
                     tMode == 'mirrored' ? TileMode.mirror : TileMode.clamp;

    final gBounds = Rect.fromLTWH(node.x, node.y, node.width, node.height);
    final gradient = gColors.isNotEmpty
        ? _buildGradient(gKind, gColors, stops, tileMode, gBounds)
        : null;

    final rawShadows = node.properties['textShadows'] as List<dynamic>?;
    final shadows = <Shadow>[];
    if (rawShadows != null) {
      for (final s in rawShadows) {
        if (s is Map<String, dynamic>) {
          shadows.add(Shadow(
            color: parseColor(s['color'] as String?) ?? const Color(0x33000000),
            offset: Offset(
              parseDouble(s['offsetX']) ?? 0,
              parseDouble(s['offsetY']) ?? 4,
            ),
            blurRadius: parseDouble(s['blurRadius']) ?? 4,
          ));
        }
      }
    }

    final strokeColor = parseColor(node.properties['strokeColor'] as String?);
    final strokeWidth = parseDouble(node.properties['strokeWidth']) ?? 0;

    return TextPaintStyle(
      text: text,
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      lineHeight: lineHeight,
      textAlign: textAlign,
      textDirection: textDirection,
      maxLines: maxLines,
      ellipsis: ellipsis,
      softWrap: softWrap,
      overflow: overflow,
      color: color,
      gradient: gradient,
      shadows: shadows,
      strokeColor: strokeColor,
      strokeWidth: strokeWidth,
      blendMode: parseBlendMode(node.properties['blendMode'] as String?),
      antiAlias: (node.properties['antiAlias'] as bool?) ?? true,
      gradientStops: stops,
      gradientKind: gKind,
      tileMode: tileMode,
    );
  }

  TextStyle buildTextStyle() {
    Paint? foreground;
    if (hasGradient && gradient != null) {
      foreground = Paint()
        ..shader = gradient
        ..style = PaintingStyle.fill
        ..isAntiAlias = antiAlias;
    }
    if (color != null) {
      if (foreground != null) {
        return TextStyle(
          color: color,
          fontFamily: fontFamily,
          fontWeight: fontWeight,
          fontStyle: fontStyle,
          fontSize: fontSize,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          height: lineHeight,
          shadows: shadows.isNotEmpty ? shadows : null,
          foreground: foreground,
        );
      }
      return TextStyle(
        color: color,
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: lineHeight,
        shadows: shadows.isNotEmpty ? shadows : null,
      );
    }
    if (foreground != null) {
      return TextStyle(
        fontFamily: fontFamily,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: lineHeight,
        shadows: shadows.isNotEmpty ? shadows : null,
        foreground: foreground,
      );
    }
    return TextStyle(
      color: const Color(0xFF000000),
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: lineHeight,
      shadows: shadows.isNotEmpty ? shadows : null,
    );
  }

  TextStyle buildStrokeTextStyle() {
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..color = strokeColor ?? const Color(0xFF000000)
      ..isAntiAlias = antiAlias;
    return TextStyle(
      fontFamily: fontFamily,
      fontWeight: fontWeight,
      fontStyle: fontStyle,
      fontSize: fontSize,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: lineHeight,
      foreground: strokePaint,
    );
  }

  static FontWeight _parseFontWeight(String? s) {
    if (s == null) return FontWeight.normal;
    switch (s) {
      case 'w100': case '100': return FontWeight.w100;
      case 'w200': case '200': return FontWeight.w200;
      case 'w300': case '300': return FontWeight.w300;
      case 'w400': case '400': case 'normal': return FontWeight.normal;
      case 'w500': case '500': return FontWeight.w500;
      case 'w600': case '600': return FontWeight.w600;
      case 'w700': case '700': case 'bold': return FontWeight.bold;
      case 'w800': case '800': return FontWeight.w800;
      case 'w900': case '900': return FontWeight.w900;
      default: return FontWeight.normal;
    }
  }

  static TextAlign _parseTextAlign(String? s) {
    switch (s) {
      case 'left': return TextAlign.left;
      case 'right': return TextAlign.right;
      case 'center': return TextAlign.center;
      case 'justify': return TextAlign.justify;
      case 'start': return TextAlign.start;
      case 'end': return TextAlign.end;
      default: return TextAlign.start;
    }
  }

  static TextDirection _parseTextDirection(String? s) {
    switch (s) {
      case 'rtl': return TextDirection.rtl;
      default: return TextDirection.ltr;
    }
  }

  static TextOverflow _parseOverflow(String? s) {
    switch (s) {
      case 'ellipsis': return TextOverflow.ellipsis;
      case 'fade': return TextOverflow.fade;
      case 'visible': return TextOverflow.visible;
      default: return TextOverflow.clip;
    }
  }

  @override
  bool operator ==(Object other) =>
      other is TextPaintStyle &&
      text == other.text &&
      fontFamily == other.fontFamily &&
      fontWeight == other.fontWeight &&
      fontStyle == other.fontStyle &&
      fontSize == other.fontSize &&
      textAlign == other.textAlign &&
      textDirection == other.textDirection;

  @override
  int get hashCode => Object.hash(text, fontFamily, fontWeight, fontStyle, fontSize, textAlign, textDirection);

  @override
  String toString() =>
      'TextPaintStyle(text: "$text", font: $fontFamily, size: $fontSize, '
      'align: $textAlign, dir: $textDirection)';
}

