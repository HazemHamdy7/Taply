import 'dart:math' show cos, sin;
import 'dart:ui' show Offset, Rect, RRect, Radius;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseDouble;
import 'gradient_paint_style.dart' show GradientPaintStyle;

class GradientPaintOptions {
  final Rect rect;
  final double borderRadiusTL;
  final double borderRadiusTR;
  final double borderRadiusBR;
  final double borderRadiusBL;
  final double opacity;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final bool visible;
  final bool clipping;
  final bool debugPaint;
  final Rect? hitTestBounds;
  final GradientPaintStyle style;

  const GradientPaintOptions({
    required this.rect,
    this.borderRadiusTL = 0,
    this.borderRadiusTR = 0,
    this.borderRadiusBR = 0,
    this.borderRadiusBL = 0,
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
        if (x < minX) minX = x;
        if (y < minY) minY = y;
        if (x > maxX) maxX = x;
        if (y > maxY) maxY = y;
      }
      r = Rect.fromLTRB(minX, minY, maxX, maxY);
    }
    return r;
  }

  factory GradientPaintOptions.fromNode(RenderPaintNode node) {
    final style = GradientPaintStyle.fromNode(node);
    final r = Rect.fromLTWH(node.x, node.y, node.width, node.height);

    final br = parseDouble(node.properties['borderRadius']);
    final brTL = parseDouble(node.properties['borderRadiusTL']) ?? br ?? 0;
    final brTR = parseDouble(node.properties['borderRadiusTR']) ?? br ?? 0;
    final brBR = parseDouble(node.properties['borderRadiusBR']) ?? br ?? 0;
    final brBL = parseDouble(node.properties['borderRadiusBL']) ?? br ?? 0;

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

    return GradientPaintOptions(
      rect: r,
      borderRadiusTL: brTL, borderRadiusTR: brTR,
      borderRadiusBR: brBR, borderRadiusBL: brBL,
      opacity: node.opacity, rotation: node.rotation,
      scaleX: node.scaleX, scaleY: node.scaleY,
      visible: node.visible,
      clipping: (node.properties['clipping'] as bool?) ?? false,
      debugPaint: debugPaint,
      hitTestBounds: hitTestBounds,
      style: style,
    );
  }

  @override
  String toString() =>
      'GradientPaintOptions(rect: $rect, borderRadius: '
      '$borderRadiusTL,$borderRadiusTR,$borderRadiusBR,$borderRadiusBL, '
      'opacity: $opacity, rotation: $rotation, '
      'visible: $visible, clipping: $clipping)';
}
