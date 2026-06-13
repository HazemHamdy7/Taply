import 'dart:math' show cos, sin;
import 'dart:ui' show Offset, Rect;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseDouble;
import 'line_paint_style.dart' show LinePaintStyle;

class LinePaintOptions {
  final double startX;
  final double startY;
  final double endX;
  final double endY;
  final double opacity;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final bool visible;
  final bool debugPaint;
  final Rect? hitTestBounds;
  final LinePaintStyle style;

  const LinePaintOptions({
    required this.startX,
    required this.startY,
    required this.endX,
    required this.endY,
    this.opacity = 1.0,
    this.rotation = 0.0,
    this.scaleX = 1.0,
    this.scaleY = 1.0,
    this.visible = true,
    this.debugPaint = false,
    this.hitTestBounds,
    required this.style,
  });

  double get cx => (startX + endX) / 2;
  double get cy => (startY + endY) / 2;

  Rect computePaintBounds() {
    double halfW = style.strokeWidth / 2;
    double l = startX < endX ? startX : endX;
    double t = startY < endY ? startY : endY;
    double r = startX > endX ? startX : endX;
    double b = startY > endY ? startY : endY;
    var bounds = Rect.fromLTRB(l - halfW, t - halfW, r + halfW, b + halfW);
    if (style.hasShadows) {
      for (final s in style.shadows) {
        final sr = bounds.shift(Offset(s.offsetX, s.offsetY)).inflate(s.blurRadius);
        bounds = bounds.expandToInclude(sr);
      }
    }
    if (rotation != 0 || scaleX != 1 || scaleY != 1) {
      final ctrX = cx;
      final ctrY = cy;
      final corners = [
        Offset(bounds.left - ctrX, bounds.top - ctrY),
        Offset(bounds.right - ctrX, bounds.top - ctrY),
        Offset(bounds.right - ctrX, bounds.bottom - ctrY),
        Offset(bounds.left - ctrX, bounds.bottom - ctrY),
      ];
      final c = cos(rotation);
      final s = sin(rotation);
      double minX = double.infinity, minY = double.infinity;
      double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
      for (final corner in corners) {
        final rx = corner.dx * c - corner.dy * s;
        final ry = corner.dx * s + corner.dy * c;
        final x = rx * scaleX + ctrX;
        final y = ry * scaleY + ctrY;
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
      bounds = Rect.fromLTRB(minX, minY, maxX, maxY);
    }
    return bounds;
  }

  factory LinePaintOptions.fromNode(RenderPaintNode node) {
    final style = LinePaintStyle.fromNode(node);
    final psx = parseDouble(node.properties['startX']);
    final psy = parseDouble(node.properties['startY']);
    final pex = parseDouble(node.properties['endX']);
    final pey = parseDouble(node.properties['endY']);
    final startX = psx ?? node.x;
    final startY = psy ?? node.y;
    final endX = pex ?? node.x + node.width;
    final endY = pey ?? node.y + node.height;
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
    return LinePaintOptions(
      startX: startX, startY: startY, endX: endX, endY: endY,
      opacity: node.opacity, rotation: node.rotation,
      scaleX: node.scaleX, scaleY: node.scaleY,
      visible: node.visible, debugPaint: debugPaint,
      hitTestBounds: hitTestBounds, style: style,
    );
  }

  @override
  String toString() =>
      'LinePaintOptions(start: $startX,$startY end: $endX,$endY '
      'opacity: $opacity rotation: $rotation '
      'scale: ${scaleX}x$scaleY visible: $visible)';
}
