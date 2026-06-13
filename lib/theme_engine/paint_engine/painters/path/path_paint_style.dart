import 'dart:ui' show Color, BlendMode, StrokeCap, StrokeJoin;

import '../../../renderer/render_node.dart';
import '../paint_helpers.dart' show parseColor, parseBlendMode, parseStrokeCap, parseStrokeJoin, parseDouble;
import '../paint_shadow.dart' show PaintShadow;

sealed class PathCommand {
  const PathCommand();
  factory PathCommand.fromMap(Map<String, dynamic> map) {
    final type = map['type'] as String?;
    switch (type) {
      case 'moveTo':
        return PathMoveTo(
          x: (map['x'] as num?)?.toDouble() ?? 0,
          y: (map['y'] as num?)?.toDouble() ?? 0,
        );
      case 'lineTo':
        return PathLineTo(
          x: (map['x'] as num?)?.toDouble() ?? 0,
          y: (map['y'] as num?)?.toDouble() ?? 0,
        );
      case 'cubicTo':
        return PathCubicTo(
          controlX1: (map['controlX1'] as num?)?.toDouble() ?? 0,
          controlY1: (map['controlY1'] as num?)?.toDouble() ?? 0,
          controlX2: (map['controlX2'] as num?)?.toDouble() ?? 0,
          controlY2: (map['controlY2'] as num?)?.toDouble() ?? 0,
          x: (map['x'] as num?)?.toDouble() ?? 0,
          y: (map['y'] as num?)?.toDouble() ?? 0,
        );
      case 'quadraticTo':
        return PathQuadraticTo(
          controlX: (map['controlX'] as num?)?.toDouble() ?? 0,
          controlY: (map['controlY'] as num?)?.toDouble() ?? 0,
          x: (map['x'] as num?)?.toDouble() ?? 0,
          y: (map['y'] as num?)?.toDouble() ?? 0,
        );
      case 'closePath':
        return const PathClose();
      default:
        throw ArgumentError('Unknown path command type: $type');
    }
  }
}

class PathMoveTo extends PathCommand {
  final double x;
  final double y;
  const PathMoveTo({required this.x, required this.y});
  @override
  String toString() => 'PathMoveTo($x, $y)';
}

class PathLineTo extends PathCommand {
  final double x;
  final double y;
  const PathLineTo({required this.x, required this.y});
  @override
  String toString() => 'PathLineTo($x, $y)';
}

class PathCubicTo extends PathCommand {
  final double controlX1;
  final double controlY1;
  final double controlX2;
  final double controlY2;
  final double x;
  final double y;
  const PathCubicTo({
    required this.controlX1, required this.controlY1,
    required this.controlX2, required this.controlY2,
    required this.x, required this.y,
  });
  @override
  String toString() => 'PathCubicTo($controlX1,$controlY1 $controlX2,$controlY2 $x,$y)';
}

class PathQuadraticTo extends PathCommand {
  final double controlX;
  final double controlY;
  final double x;
  final double y;
  const PathQuadraticTo({
    required this.controlX, required this.controlY,
    required this.x, required this.y,
  });
  @override
  String toString() => 'PathQuadraticTo($controlX,$controlY $x,$y)';
}

class PathClose extends PathCommand {
  const PathClose();
  @override
  String toString() => 'PathClose';
}

class PathPaintStyle {
  final Color? fillColor;
  final Color? strokeColor;
  final double strokeWidth;
  final StrokeCap strokeCap;
  final StrokeJoin strokeJoin;
  final List<PaintShadow> shadows;
  final BlendMode blendMode;
  final bool antiAlias;

  const PathPaintStyle({
    this.fillColor,
    this.strokeColor,
    this.strokeWidth = 0.0,
    this.strokeCap = StrokeCap.butt,
    this.strokeJoin = StrokeJoin.miter,
    this.shadows = const [],
    this.blendMode = BlendMode.srcOver,
    this.antiAlias = true,
  });

  bool get hasFill => fillColor != null;
  bool get hasStroke => strokeWidth > 0 && strokeColor != null;
  bool get hasShadows => shadows.isNotEmpty;

  factory PathPaintStyle.fromNode(RenderPaintNode node) {
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
    return PathPaintStyle(
      fillColor: parseColor(node.color),
      strokeColor: parseColor(node.strokeColor),
      strokeWidth: node.strokeWidth ?? 0.0,
      strokeCap: parseStrokeCap(node.properties['strokeCap'] as String?),
      strokeJoin: parseStrokeJoin(node.properties['strokeJoin'] as String?),
      shadows: shadows,
      blendMode: parseBlendMode(node.properties['blendMode'] as String?),
      antiAlias: (node.properties['antiAlias'] as bool?) ?? true,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PathPaintStyle &&
      fillColor == other.fillColor &&
      strokeColor == other.strokeColor &&
      strokeWidth == other.strokeWidth &&
      strokeCap == other.strokeCap &&
      strokeJoin == other.strokeJoin &&
      blendMode == other.blendMode;

  @override
  int get hashCode => Object.hash(fillColor, strokeColor, strokeWidth, strokeCap, strokeJoin, blendMode);

  @override
  String toString() =>
      'PathPaintStyle(fill: $fillColor, stroke: $strokeColor/${strokeWidth}px, '
      'cap: $strokeCap, join: $strokeJoin, shadows: ${shadows.length})';
}
