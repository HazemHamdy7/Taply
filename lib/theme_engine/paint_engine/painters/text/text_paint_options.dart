import 'dart:math' show cos, sin;
import 'dart:ui' show Offset, Rect;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseDouble;
import 'text_paint_style.dart' show TextPaintStyle;

class TextPaintOptions {
  final Rect rect;
  final String text;
  final double opacity;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final bool visible;
  final bool clipping;
  final bool debugPaint;
  final Rect? hitTestBounds;
  final TextPaintStyle style;

  const TextPaintOptions({
    required this.rect,
    this.text = '',
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.visible = true,
    this.clipping = false,
    this.debugPaint = false,
    this.hitTestBounds,
    required this.style,
  });

  Rect computePaintBounds() {
    Rect r = rect;
    if (style.hasShadows) {
      for (final s in style.shadows) {
        final shadowRect = r.shift(s.offset).inflate(s.blurRadius);
        r = r.expandToInclude(shadowRect);
      }
    }
    if (style.hasStroke) {
      r = r.inflate(style.strokeWidth / 2);
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
      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
      for (final corner in corners) {
        final rx = corner.dx * c - corner.dy * s;
        final ry = corner.dx * s + corner.dy * c;
        final sx = rx * scaleX;
        final sy = ry * scaleY;
        if (sx + cx < minX) minX = sx + cx;
        if (sy + cy < minY) minY = sy + cy;
        if (sx + cx > maxX) maxX = sx + cx;
        if (sy + cy > maxY) maxY = sy + cy;
      }
      r = Rect.fromLTRB(minX, minY, maxX, maxY);
    }
    return r;
  }

  factory TextPaintOptions.fromNode(RenderPaintNode node) {
    final style = TextPaintStyle.fromNode(node);
    final r = Rect.fromLTWH(node.x, node.y, node.width, node.height);
    final debugPaint = node.properties['debugPaint'] as bool? ?? false;

    final htRaw = node.properties['hitTestBounds'] as Map<String, dynamic>?;
    Rect? hitTestBounds;
    if (htRaw != null) {
      final hx = parseDouble(htRaw['x']);
      final hy = parseDouble(htRaw['y']);
      final hw = parseDouble(htRaw['width']);
      final hh = parseDouble(htRaw['height']);
      if (hx != null && hy != null && hw != null && hh != null) {
        hitTestBounds = Rect.fromLTWH(hx, hy, hw, hh);
      }
    }

    return TextPaintOptions(
      rect: r,
      text: style.text,
      opacity: node.opacity,
      rotation: node.rotation,
      scaleX: node.scaleX,
      scaleY: node.scaleY,
      visible: node.visible,
      clipping: (node.properties['clipping'] as bool?) ?? false,
      debugPaint: debugPaint,
      hitTestBounds: hitTestBounds,
      style: style,
    );
  }

  @override
  String toString() =>
      'TextPaintOptions(rect: $rect, text: "${text.length > 20 ? text.substring(0, 20) : text}", '
      'opacity: $opacity, rotation: $rotation)';
}
