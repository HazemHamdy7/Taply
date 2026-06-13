import 'dart:math' show cos, sin;
import 'dart:ui' show Offset, Rect;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseDouble;
import 'circle_paint_style.dart' show CirclePaintStyle;

class CirclePaintOptions {
  final double cx;
  final double cy;
  final double radius;
  final double opacity;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final bool visible;
  final bool debugPaint;
  final Rect? hitTestBounds;
  final CirclePaintStyle style;

  const CirclePaintOptions({
    required this.cx,
    required this.cy,
    required this.radius,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.visible = true,
    this.debugPaint = false,
    this.hitTestBounds,
    required this.style,
  });

  Rect computePaintBounds() {
    double r = radius;
    if (style.strokeWidth > 0 && style.strokeColor != null) {
      r += style.strokeWidth / 2;
    }
    var bounds = Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2);
    if (style.hasShadows) {
      for (final s in style.shadows) {
        final sr = bounds.shift(Offset(s.offsetX, s.offsetY)).inflate(s.blurRadius);
        bounds = bounds.expandToInclude(sr);
      }
    }
    if (rotation != 0 || scaleX != 1 || scaleY != 1) {
      final corners = [
        Offset(bounds.left - cx, bounds.top - cy),
        Offset(bounds.right - cx, bounds.top - cy),
        Offset(bounds.right - cx, bounds.bottom - cy),
        Offset(bounds.left - cx, bounds.bottom - cy),
      ];
      final c = cos(rotation);
      final s = sin(rotation);
      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
      for (final corner in corners) {
        final rx = corner.dx * c - corner.dy * s;
        final ry = corner.dx * s + corner.dy * c;
        final x = rx * scaleX + cx;
        final y = ry * scaleY + cy;
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
      bounds = Rect.fromLTRB(minX, minY, maxX, maxY);
    }
    return bounds;
  }

  factory CirclePaintOptions.fromNode(RenderPaintNode node) {
    final style = CirclePaintStyle.fromNode(node);
    final pcx = parseDouble(node.properties['cx']);
    final pcy = parseDouble(node.properties['cy']);
    final pr = parseDouble(node.properties['radius']);
    final cx = pcx ?? node.x + node.width / 2;
    final cy = pcy ?? node.y + node.height / 2;
    final radius = pr ?? (node.width < node.height ? node.width / 2 : node.height / 2);
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
    return CirclePaintOptions(
      cx: cx, cy: cy, radius: radius,
      opacity: node.opacity, rotation: node.rotation,
      scaleX: node.scaleX, scaleY: node.scaleY,
      visible: node.visible, debugPaint: debugPaint,
      hitTestBounds: hitTestBounds, style: style,
    );
  }

  @override
  String toString() =>
      'CirclePaintOptions(center: $cx,$cy radius: $radius '
      'opacity: $opacity rotation: $rotation '
      'scale: ${scaleX}x$scaleY visible: $visible)';
}
