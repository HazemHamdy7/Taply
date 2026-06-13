import 'dart:math' show cos, sin;
import 'dart:ui' show Offset, Rect, RRect, Radius, Size;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseDouble;
import 'image_paint_style.dart' show ImagePaintStyle;

enum ImageBoxFit { fill, contain, cover, fitWidth, fitHeight, none, scaleDown }

enum ImageAlignment { center, topLeft, topCenter, topRight, centerLeft, centerRight, bottomLeft, bottomCenter, bottomRight }

class ImagePaintOptions {
  final Rect rect;
  final ImageBoxFit fit;
  final ImageAlignment alignment;
  final double borderRadiusTL;
  final double borderRadiusTR;
  final double borderRadiusBR;
  final double borderRadiusBL;
  final bool circular;
  final double opacity;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final bool visible;
  final bool clipping;
  final bool debugPaint;
  final Rect? hitTestBounds;
  final ImagePaintStyle style;

  const ImagePaintOptions({
    required this.rect,
    this.fit = ImageBoxFit.contain,
    this.alignment = ImageAlignment.center,
    this.borderRadiusTL = 0,
    this.borderRadiusTR = 0,
    this.borderRadiusBR = 0,
    this.borderRadiusBL = 0,
    this.circular = false,
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
    borderRadiusBR > 0 || borderRadiusBL > 0 || circular;

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
    if (style.hasBorder) {
      r = r.inflate(style.borderWidth / 2);
    }
    if (style.hasShadows) {
      for (final s in style.shadows) {
        final shadowRect = r.shift(Offset(s.offsetX, s.offsetY)).inflate(s.blurRadius);
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

  static ImageBoxFit _parseFit(String? fit) {
    switch (fit) {
      case 'fill':      return ImageBoxFit.fill;
      case 'cover':     return ImageBoxFit.cover;
      case 'fitWidth':  return ImageBoxFit.fitWidth;
      case 'fitHeight': return ImageBoxFit.fitHeight;
      case 'none':      return ImageBoxFit.none;
      case 'scaleDown': return ImageBoxFit.scaleDown;
      default:          return ImageBoxFit.contain;
    }
  }

  static ImageAlignment _parseAlignment(String? align) {
    switch (align) {
      case 'topLeft':      return ImageAlignment.topLeft;
      case 'topCenter':    return ImageAlignment.topCenter;
      case 'topRight':     return ImageAlignment.topRight;
      case 'centerLeft':   return ImageAlignment.centerLeft;
      case 'centerRight':  return ImageAlignment.centerRight;
      case 'bottomLeft':   return ImageAlignment.bottomLeft;
      case 'bottomCenter': return ImageAlignment.bottomCenter;
      case 'bottomRight':  return ImageAlignment.bottomRight;
      default:             return ImageAlignment.center;
    }
  }

  static Offset _alignmentOffset(ImageAlignment align, Rect rect, Size imageSize) {
    final dx = rect.width - imageSize.width;
    final dy = rect.height - imageSize.height;
    switch (align) {
      case ImageAlignment.topLeft:      return Offset(0, 0);
      case ImageAlignment.topCenter:    return Offset(dx / 2, 0);
      case ImageAlignment.topRight:     return Offset(dx, 0);
      case ImageAlignment.centerLeft:   return Offset(0, dy / 2);
      case ImageAlignment.centerRight:  return Offset(dx, dy / 2);
      case ImageAlignment.bottomLeft:   return Offset(0, dy);
      case ImageAlignment.bottomCenter: return Offset(dx / 2, dy);
      case ImageAlignment.bottomRight:  return Offset(dx, dy);
      default:                          return Offset(dx / 2, dy / 2);
    }
  }

  Rect computeImageRect(Size imageSize) {
    final double srcW = imageSize.width;
    final double srcH = imageSize.height;
    if (srcW <= 0 || srcH <= 0) return rect;
    final double dstW = rect.width;
    final double dstH = rect.height;

    switch (fit) {
      case ImageBoxFit.fill:
        return rect;
      case ImageBoxFit.contain: {
        final scale = (dstW / srcW) < (dstH / srcH) ? dstW / srcW : dstH / srcH;
        final sw = srcW * scale;
        final sh = srcH * scale;
        final offset = _alignmentOffset(alignment, rect, Size(sw, sh));
        return Rect.fromLTWH(rect.left + offset.dx, rect.top + offset.dy, sw, sh);
      }
      case ImageBoxFit.cover: {
        final scale = (dstW / srcW) > (dstH / srcH) ? dstW / srcW : dstH / srcH;
        final sw = srcW * scale;
        final sh = srcH * scale;
        final offset = _alignmentOffset(alignment, rect, Size(sw, sh));
        return Rect.fromLTWH(rect.left + offset.dx, rect.top + offset.dy, sw, sh);
      }
      case ImageBoxFit.fitWidth: {
        final scale = dstW / srcW;
        final sh = srcH * scale;
        return Rect.fromLTWH(rect.left, rect.top + (dstH - sh) / 2, dstW, sh);
      }
      case ImageBoxFit.fitHeight: {
        final scale = dstH / srcH;
        final sw = srcW * scale;
        return Rect.fromLTWH(rect.left + (dstW - sw) / 2, rect.top, sw, dstH);
      }
      case ImageBoxFit.none:
        return Rect.fromLTWH(rect.left, rect.top, srcW, srcH);
      case ImageBoxFit.scaleDown: {
        final scale = (dstW / srcW) < (dstH / srcH) ? dstW / srcW : dstH / srcH;
        if (scale >= 1) return rect;
        final sw = srcW * scale;
        final sh = srcH * scale;
        final offset = _alignmentOffset(alignment, rect, Size(sw, sh));
        return Rect.fromLTWH(rect.left + offset.dx, rect.top + offset.dy, sw, sh);
      }
    }
  }

  factory ImagePaintOptions.fromNode(RenderPaintNode node) {
    final style = ImagePaintStyle.fromNode(node);
    final r = Rect.fromLTWH(node.x, node.y, node.width, node.height);

    final br = parseDouble(node.properties['borderRadius']);
    final brTL = parseDouble(node.properties['borderRadiusTL']) ?? br ?? 0;
    final brTR = parseDouble(node.properties['borderRadiusTR']) ?? br ?? 0;
    final brBR = parseDouble(node.properties['borderRadiusBR']) ?? br ?? 0;
    final brBL = parseDouble(node.properties['borderRadiusBL']) ?? br ?? 0;

    final circular = node.properties['circular'] as bool? ?? false;
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

    return ImagePaintOptions(
      rect: r,
      fit: _parseFit(node.properties['fit'] as String?),
      alignment: _parseAlignment(node.properties['alignment'] as String?),
      borderRadiusTL: brTL, borderRadiusTR: brTR,
      borderRadiusBR: brBR, borderRadiusBL: brBL,
      circular: circular,
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
      'ImagePaintOptions(rect: $rect, fit: $fit, circular: $circular, '
      'opacity: $opacity, rotation: $rotation)';
}


