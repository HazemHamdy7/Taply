import 'dart:math' show cos, sin;
import 'dart:ui' show Offset, Rect;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseDouble;
import 'path_paint_style.dart';

class PathPaintOptions {
  final List<PathCommand> commands;
  final double opacity;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final bool visible;
  final bool debugPaint;
  final Rect? hitTestBounds;
  final PathPaintStyle style;

  const PathPaintOptions({
    required this.commands,
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
    double minX = double.infinity, minY = double.infinity;
    double maxX = double.negativeInfinity, maxY = double.negativeInfinity;
    for (final cmd in commands) {
      switch (cmd) {
        case PathMoveTo(:final x, :final y):
          if (x < minX) minX = x; if (y < minY) minY = y;
          if (x > maxX) maxX = x; if (y > maxY) maxY = y;
        case PathLineTo(:final x, :final y):
          if (x < minX) minX = x; if (y < minY) minY = y;
          if (x > maxX) maxX = x; if (y > maxY) maxY = y;
        case PathCubicTo(:final controlX1, :final controlY1, :final controlX2, :final controlY2, :final x, :final y):
          for (final pt in [controlX1, controlX2, x]) { if (pt < minX) minX = pt; if (pt > maxX) maxX = pt; }
          for (final pt in [controlY1, controlY2, y]) { if (pt < minY) minY = pt; if (pt > maxY) maxY = pt; }
        case PathQuadraticTo(:final controlX, :final controlY, :final x, :final y):
          for (final pt in [controlX, x]) { if (pt < minX) minX = pt; if (pt > maxX) maxX = pt; }
          for (final pt in [controlY, y]) { if (pt < minY) minY = pt; if (pt > maxY) maxY = pt; }
        case PathClose():
          break;
      }
    }
    if (minX == double.infinity) minX = 0;
    if (minY == double.infinity) minY = 0;
    if (maxX == double.negativeInfinity) maxX = 0;
    if (maxY == double.negativeInfinity) maxY = 0;

    double halfW = style.strokeWidth / 2;
    var bounds = Rect.fromLTRB(minX - halfW, minY - halfW, maxX + halfW, maxY + halfW);
    final cx = (minX + maxX) / 2;
    final cy = (minY + maxY) / 2;

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
      minX = double.infinity; minY = double.infinity;
      maxX = double.negativeInfinity; maxY = double.negativeInfinity;
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

  factory PathPaintOptions.fromNode(RenderPaintNode node) {
    final style = PathPaintStyle.fromNode(node);
    final rawCommands = node.properties['commands'] as List<dynamic>?;
    final commands = <PathCommand>[];
    if (rawCommands != null) {
      for (final cmd in rawCommands) {
        if (cmd is Map<String, dynamic>) {
          commands.add(PathCommand.fromMap(cmd));
        }
      }
    }
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
    return PathPaintOptions(
      commands: commands, opacity: node.opacity,
      rotation: node.rotation, scaleX: node.scaleX, scaleY: node.scaleY,
      visible: node.visible, debugPaint: debugPaint,
      hitTestBounds: hitTestBounds, style: style,
    );
  }

  @override
  String toString() =>
      'PathPaintOptions(commands: ${commands.length}, '
      'opacity: $opacity rotation: $rotation '
      'scale: ${scaleX}x$scaleY visible: $visible)';
}
