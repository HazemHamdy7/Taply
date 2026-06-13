import 'dart:ui' show
    PictureRecorder, Canvas, Color, StrokeCap, StrokeJoin, Rect;

import 'package:flutter_test/flutter_test.dart';

import 'package:business_card/theme_engine/models/shadow_definition.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/paint_engine/paint_context.dart';
import 'package:business_card/theme_engine/paint_engine/paint_result.dart';
import 'package:business_card/theme_engine/paint_engine/painters/paint_shadow.dart';
import 'package:business_card/theme_engine/paint_engine/painters/path/path_painter.dart';
import 'package:business_card/theme_engine/paint_engine/painters/path/path_paint_metrics.dart';
import 'package:business_card/theme_engine/paint_engine/painters/path/path_paint_options.dart';
import 'package:business_card/theme_engine/paint_engine/painters/path/path_paint_style.dart';
import 'package:business_card/theme_engine/paint_engine/painters/path/path_painter_diagnostics.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';

PaintContext _makeContext(RenderPaintNode node, {Canvas? canvas}) {
  return PaintContext(
    canvas: canvas,
    document: ThemeDocument(
      metadata: ThemeMetadata(id: 'test', name: 'Test'),
    ),
    renderTree: RenderTree(
      canvasWidth: 1000,
      canvasHeight: 600,
      viewportWidth: 1000,
      viewportHeight: 600,
      layoutMode: LayoutMode.centered,
      scaleFactor: 1.0,
      root: RenderGroup(id: 'root', children: [node]),
    ),
    renderNode: node,
    viewportWidth: 1000,
    viewportHeight: 600,
    scaleFactor: 1.0,
  );
}

PaintResult _paintNode(RenderPaintNode node) {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final ctx = _makeContext(node, canvas: canvas);
  final painter = PathPainter();
  painter.prepare(ctx);
  final result = painter.paint(ctx);
  recorder.endRecording();
  return result;
}

void main() {
  group('PathCommand', () {
    test('fromMap creates PathMoveTo correctly', () {
      final cmd = PathCommand.fromMap({'type': 'moveTo', 'x': 10, 'y': 20});
      expect(cmd, isA<PathMoveTo>());
      final move = cmd as PathMoveTo;
      expect(move.x, equals(10.0));
      expect(move.y, equals(20.0));
    });

    test('fromMap creates PathLineTo correctly', () {
      final cmd = PathCommand.fromMap({'type': 'lineTo', 'x': 30, 'y': 40});
      expect(cmd, isA<PathLineTo>());
      final line = cmd as PathLineTo;
      expect(line.x, equals(30.0));
      expect(line.y, equals(40.0));
    });

    test('fromMap creates PathCubicTo correctly', () {
      final cmd = PathCommand.fromMap({
        'type': 'cubicTo',
        'controlX1': 1, 'controlY1': 2,
        'controlX2': 3, 'controlY2': 4,
        'x': 5, 'y': 6,
      });
      expect(cmd, isA<PathCubicTo>());
      final cubic = cmd as PathCubicTo;
      expect(cubic.controlX1, equals(1.0));
      expect(cubic.controlY1, equals(2.0));
      expect(cubic.controlX2, equals(3.0));
      expect(cubic.controlY2, equals(4.0));
      expect(cubic.x, equals(5.0));
      expect(cubic.y, equals(6.0));
    });

    test('fromMap creates PathQuadraticTo correctly', () {
      final cmd = PathCommand.fromMap({
        'type': 'quadraticTo',
        'controlX': 1, 'controlY': 2,
        'x': 3, 'y': 4,
      });
      expect(cmd, isA<PathQuadraticTo>());
      final quad = cmd as PathQuadraticTo;
      expect(quad.controlX, equals(1.0));
      expect(quad.controlY, equals(2.0));
      expect(quad.x, equals(3.0));
      expect(quad.y, equals(4.0));
    });

    test('fromMap creates PathClose correctly', () {
      final cmd = PathCommand.fromMap({'type': 'closePath'});
      expect(cmd, isA<PathClose>());
    });

    test('fromMap throws ArgumentError for unknown type', () {
      expect(
        () => PathCommand.fromMap({'type': 'unknown'}),
        throwsArgumentError,
      );
    });

    test('PathMoveTo toString', () {
      expect(
        const PathMoveTo(x: 10.5, y: 20.5).toString(),
        equals('PathMoveTo(10.5, 20.5)'),
      );
    });

    test('PathLineTo toString', () {
      expect(
        const PathLineTo(x: 30.5, y: 40.5).toString(),
        equals('PathLineTo(30.5, 40.5)'),
      );
    });

    test('PathCubicTo toString', () {
      expect(
        const PathCubicTo(
          controlX1: 1.5, controlY1: 2.5,
          controlX2: 3.5, controlY2: 4.5,
          x: 5.5, y: 6.5,
        ).toString(),
        equals('PathCubicTo(1.5,2.5 3.5,4.5 5.5,6.5)'),
      );
    });

    test('PathQuadraticTo toString', () {
      expect(
        const PathQuadraticTo(
          controlX: 1.5, controlY: 2.5,
          x: 3.5, y: 4.5,
        ).toString(),
        equals('PathQuadraticTo(1.5,2.5 3.5,4.5)'),
      );
    });

    test('PathClose toString', () {
      expect(const PathClose().toString(), equals('PathClose'));
    });
  });

  group('PathPaintStyle', () {
    test('fromNode creates default fill style', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final style = PathPaintStyle.fromNode(node);
      expect(style.fillColor, equals(const Color(0xFFFF0000)));
      expect(style.hasFill, isTrue);
      expect(style.hasStroke, isFalse);
      expect(style.hasShadows, isFalse);
    });

    test('fromNode with null color returns null fillColor', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
      );
      final style = PathPaintStyle.fromNode(node);
      expect(style.fillColor, isNull);
      expect(style.hasFill, isFalse);
    });

    test('fromNode reads stroke properties (strokeWidth, strokeColor)', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
      );
      final style = PathPaintStyle.fromNode(node);
      expect(style.strokeWidth, equals(3.0));
      expect(style.strokeColor, equals(const Color(0xFF00FF00)));
      expect(style.hasStroke, isTrue);
    });

    test('fromNode reads strokeCap (butt, round, square)', () {
      final nodeButt = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        properties: {'strokeCap': 'butt'},
      );
      expect(PathPaintStyle.fromNode(nodeButt).strokeCap, equals(StrokeCap.butt));

      final nodeRound = RenderPaintNode(
        id: 'p2', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        properties: {'strokeCap': 'round'},
      );
      expect(PathPaintStyle.fromNode(nodeRound).strokeCap, equals(StrokeCap.round));

      final nodeSquare = RenderPaintNode(
        id: 'p3', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        properties: {'strokeCap': 'square'},
      );
      expect(PathPaintStyle.fromNode(nodeSquare).strokeCap, equals(StrokeCap.square));
    });

    test('fromNode reads strokeJoin (miter, round, bevel)', () {
      final nodeMiter = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        properties: {'strokeJoin': 'miter'},
      );
      expect(PathPaintStyle.fromNode(nodeMiter).strokeJoin, equals(StrokeJoin.miter));

      final nodeRound = RenderPaintNode(
        id: 'p2', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        properties: {'strokeJoin': 'round'},
      );
      expect(PathPaintStyle.fromNode(nodeRound).strokeJoin, equals(StrokeJoin.round));

      final nodeBevel = RenderPaintNode(
        id: 'p3', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        properties: {'strokeJoin': 'bevel'},
      );
      expect(PathPaintStyle.fromNode(nodeBevel).strokeJoin, equals(StrokeJoin.bevel));
    });

    test('fromNode reads shadows', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'shadows': [
            {'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4},
          ],
        },
      );
      final style = PathPaintStyle.fromNode(node);
      expect(style.hasShadows, isTrue);
      expect(style.shadows.length, equals(1));
    });

    test('hasFill, hasStroke getters', () {
      final noFill = PathPaintStyle();
      expect(noFill.hasFill, isFalse);

      final withFill = PathPaintStyle(fillColor: const Color(0xFFFF0000));
      expect(withFill.hasFill, isTrue);

      final noStroke = PathPaintStyle(fillColor: const Color(0xFFFF0000));
      expect(noStroke.hasStroke, isFalse);

      final withStroke = PathPaintStyle(
        fillColor: const Color(0xFFFF0000),
        strokeWidth: 2,
        strokeColor: const Color(0xFF000000),
      );
      expect(withStroke.hasStroke, isTrue);
    });

    test('equality operator', () {
      final a = PathPaintStyle(
        fillColor: const Color(0xFFFF0000),
        strokeWidth: 2,
        strokeColor: const Color(0xFF0000FF),
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      );
      final b = PathPaintStyle(
        fillColor: const Color(0xFFFF0000),
        strokeWidth: 2,
        strokeColor: const Color(0xFF0000FF),
        strokeCap: StrokeCap.round,
        strokeJoin: StrokeJoin.round,
      );
      expect(a, equals(b));

      final c = PathPaintStyle(
        fillColor: const Color(0xFF00FF00),
      );
      expect(a, isNot(equals(c)));
    });

    test('toString', () {
      final style = PathPaintStyle(
        fillColor: const Color(0xFFFF0000),
        strokeWidth: 3,
        strokeColor: const Color(0xFF00FF00),
      );
      final str = style.toString();
      expect(str, contains('PathPaintStyle'));
      expect(str, contains('fill'));
      expect(str, contains('stroke'));
    });
  });

  group('PathPaintOptions', () {
    test('fromNode parses commands list correctly', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 10},
            {'type': 'lineTo', 'x': 50, 'y': 90},
            {'type': 'closePath'},
          ],
        },
      );
      final opts = PathPaintOptions.fromNode(node);
      expect(opts.commands.length, equals(4));
      expect(opts.commands[0], isA<PathMoveTo>());
      expect(opts.commands[1], isA<PathLineTo>());
      expect(opts.commands[2], isA<PathLineTo>());
      expect(opts.commands[3], isA<PathClose>());
    });

    test('fromNode handles empty commands list', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'commands': <dynamic>[]},
      );
      final opts = PathPaintOptions.fromNode(node);
      expect(opts.commands, isEmpty);
    });

    test('fromNode with no commands property (null)', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
      );
      final opts = PathPaintOptions.fromNode(node);
      expect(opts.commands, isEmpty);
    });

    test('computePaintBounds from triangle path', () {
      final opts = PathPaintOptions(
        commands: const [
          PathMoveTo(x: 100, y: 10),
          PathLineTo(x: 180, y: 180),
          PathLineTo(x: 20, y: 180),
          PathClose(),
        ],
        style: const PathPaintStyle(fillColor: Color(0xFFFF0000)),
      );
      final bounds = opts.computePaintBounds();
      expect(bounds.left, equals(20.0));
      expect(bounds.top, equals(10.0));
      expect(bounds.right, equals(180.0));
      expect(bounds.bottom, equals(180.0));
    });

    test('computePaintBounds with stroke inflation', () {
      final opts = PathPaintOptions(
        commands: const [
          PathMoveTo(x: 100, y: 100),
          PathLineTo(x: 200, y: 100),
        ],
        style: const PathPaintStyle(
          fillColor: Color(0xFFFF0000),
          strokeWidth: 10,
        ),
      );
      final bounds = opts.computePaintBounds();
      expect(bounds.left, equals(95.0));
      expect(bounds.right, equals(205.0));
      expect(bounds.top, equals(95.0));
      expect(bounds.bottom, equals(105.0));
    });

    test('computePaintBounds with cubic path', () {
      final opts = PathPaintOptions(
        commands: const [
          PathMoveTo(x: 10, y: 50),
          PathCubicTo(
            controlX1: 30, controlY1: 0,
            controlX2: 70, controlY2: 100,
            x: 90, y: 50,
          ),
        ],
        style: const PathPaintStyle(fillColor: Color(0xFFFF0000)),
      );
      final bounds = opts.computePaintBounds();
      expect(bounds.left, lessThanOrEqualTo(10));
      expect(bounds.right, greaterThanOrEqualTo(90));
      expect(bounds.top, lessThanOrEqualTo(0));
      expect(bounds.bottom, greaterThanOrEqualTo(100));
    });

    test('computePaintBounds includes shadows', () {
      final opts = PathPaintOptions(
        commands: const [
          PathMoveTo(x: 100, y: 10),
          PathLineTo(x: 180, y: 180),
          PathLineTo(x: 20, y: 180),
          PathClose(),
        ],
        style: PathPaintStyle(
          fillColor: const Color(0xFFFF0000),
          shadows: [
            PaintShadow(
              color: Color(0x33000000),
              offsetX: 10,
              offsetY: 10,
              blurRadius: 20,
              opacity: 0.4,
            ),
          ],
        ),
      );
      final bounds = opts.computePaintBounds();
      // Base: (20,10)-(180,180). Shadow offset +10,+10 blur 20
      // => shifted (30,20)-(190,190), inflated by 20 => (10,0)-(210,210)
      expect(bounds.left, lessThanOrEqualTo(10));
      expect(bounds.top, lessThanOrEqualTo(0));
      expect(bounds.right, greaterThanOrEqualTo(210));
      expect(bounds.bottom, greaterThanOrEqualTo(210));
    });

    test('computePaintBounds includes rotation', () {
      final opts = PathPaintOptions(
        commands: const [
          PathMoveTo(x: 0, y: 0),
          PathLineTo(x: 100, y: 0),
          PathLineTo(x: 100, y: 100),
          PathClose(),
        ],
        style: const PathPaintStyle(fillColor: Color(0xFFFF0000)),
        rotation: 0.5,
      );
      final bounds = opts.computePaintBounds();
      expect(bounds, isA<Rect>());
      expect(bounds.width, greaterThan(0));
      expect(bounds.height, greaterThan(0));
    });

    test('debugPaint flag', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [{'type': 'moveTo', 'x': 10, 'y': 10}],
          'debugPaint': true,
        },
      );
      final opts = PathPaintOptions.fromNode(node);
      expect(opts.debugPaint, isTrue);
    });

    test('hitTestBounds', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
          ],
          'hitTestBounds': {'x': 0, 'y': 0, 'width': 200, 'height': 200},
        },
      );
      final opts = PathPaintOptions.fromNode(node);
      expect(opts.hitTestBounds, isNotNull);
      expect(opts.hitTestBounds!.left, equals(0));
      expect(opts.hitTestBounds!.top, equals(0));
      expect(opts.hitTestBounds!.width, equals(200));
      expect(opts.hitTestBounds!.height, equals(200));
    });
  });

  group('PathPaintMetrics', () {
    test('records all counters', () {
      final m = PathPaintMetrics();
      m.recordPath();
      m.recordFill();
      m.recordStroke();
      m.recordSegment();
      m.recordShadow();
      m.recordCacheHit();
      m.recordCacheMiss();
      m.recordDuration(const Duration(milliseconds: 5));
      expect(m.pathsPainted, equals(1));
      expect(m.filledPaths, equals(1));
      expect(m.strokedPaths, equals(1));
      expect(m.segmentsDrawn, equals(1));
      expect(m.shadowCount, equals(1));
      expect(m.cacheHits, equals(1));
      expect(m.cacheMisses, equals(1));
    });

    test('reset', () {
      final m = PathPaintMetrics();
      m.recordPath();
      m.recordFill();
      m.recordDuration(const Duration(milliseconds: 10));
      m.reset();
      expect(m.pathsPainted, equals(0));
      expect(m.filledPaths, equals(0));
      expect(m.paintDuration, equals(Duration.zero));
    });

    test('copy', () {
      final m = PathPaintMetrics();
      m.recordPath();
      m.recordFill();
      m.recordSegment();
      final c = m.copy();
      c.recordPath();
      expect(m.pathsPainted, equals(1));
      expect(c.pathsPainted, equals(2));
      expect(m.filledPaths, equals(1));
      expect(c.filledPaths, equals(1));
      expect(m.segmentsDrawn, equals(1));
      expect(c.segmentsDrawn, equals(1));
    });

    test('operator+', () {
      final a = PathPaintMetrics();
      a.recordPath();
      a.recordFill();
      final b = PathPaintMetrics();
      b.recordPath();
      b.recordStroke();
      final sum = a + b;
      expect(sum.pathsPainted, equals(2));
      expect(sum.filledPaths, equals(1));
      expect(sum.strokedPaths, equals(1));
    });

    test('averagePaintTimeMs', () {
      final m = PathPaintMetrics();
      expect(m.averagePaintTimeMs, equals(0));
      m.recordPath();
      m.recordDuration(const Duration(milliseconds: 10));
      expect(m.averagePaintTimeMs, equals(10.0));
    });

    test('segmentsDrawn accumulates', () {
      final m = PathPaintMetrics();
      m.recordSegment();
      m.recordSegment();
      m.recordSegment();
      expect(m.segmentsDrawn, equals(3));
    });
  });

  group('PathPainterDiagnostics', () {
    test('records operations', () {
      final d = PathPainterDiagnostics();
      d.recordOperation('drawPath');
      d.recordOperation('canvas.save');
      expect(d.totalOperations, equals(2));
    });

    test('warnings and errors', () {
      final d = PathPainterDiagnostics();
      expect(d.hasWarnings, isFalse);
      expect(d.hasErrors, isFalse);
      d.recordWarning('test warning');
      expect(d.hasWarnings, isTrue);
      d.recordError('test error');
      expect(d.hasErrors, isTrue);
      expect(d.warnings.length, equals(1));
      expect(d.errors.length, equals(1));
    });

    test('allocations', () {
      final d = PathPainterDiagnostics();
      expect(d.memoryAllocations, equals(0));
      d.recordAllocation();
      d.recordAllocation();
      expect(d.memoryAllocations, equals(2));
    });

    test('reset', () {
      final d = PathPainterDiagnostics();
      d.recordOperation('draw');
      d.recordError('err');
      d.recordAllocation();
      d.reset();
      expect(d.totalOperations, equals(0));
      expect(d.errors, isEmpty);
      expect(d.memoryAllocations, equals(0));
    });

    test('merge', () {
      final a = PathPainterDiagnostics();
      a.recordOperation('op1');
      a.recordError('err1');
      final b = PathPainterDiagnostics();
      b.recordOperation('op2');
      b.recordWarning('warn1');
      a.merge(b);
      expect(a.totalOperations, equals(2));
      expect(a.errors.length, equals(1));
      expect(a.warnings.length, equals(1));
    });

    test('totalDuration', () {
      final d = PathPainterDiagnostics();
      d.recordOperation('op1', duration: const Duration(milliseconds: 5));
      d.recordOperation('op2', duration: const Duration(milliseconds: 3));
      expect(d.totalDuration, equals(const Duration(milliseconds: 8)));
    });
  });

  group('PathPainter', () {
    test('canPaint returns true for path type', () {
      final painter = PathPainter();
      expect(
        painter.canPaint(const RenderPaintNode(id: 't', type: 'path')),
        isTrue,
      );
    });

    test('canPaint returns false for non-path types', () {
      final painter = PathPainter();
      expect(
        painter.canPaint(const RenderPaintNode(id: 't', type: 'circle')),
        isFalse,
      );
      expect(
        painter.canPaint(const RenderPaintNode(id: 't', type: 'rect')),
        isFalse,
      );
      expect(
        painter.canPaint(const RenderPaintNode(id: 't', type: 'ellipse')),
        isFalse,
      );
      expect(
        painter.canPaint(const RenderPaintNode(id: 't', type: 'text')),
        isFalse,
      );
    });

    test('type returns path', () {
      expect(PathPainter().type, equals('path'));
    });

    test('capabilities', () {
      final caps = PathPainter().capabilities;
      expect(caps.supportsOpacity, isTrue);
      expect(caps.supportsTransform, isTrue);
      expect(caps.supportsStroke, isTrue);
      expect(caps.supportsShadow, isTrue);
      expect(caps.supportsBlendMode, isTrue);
      expect(caps.supportsGradient, isTrue);
      expect(caps.supportsClipping, isTrue);
    });

    test('paint returns success for triangle path (fill)', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 10},
            {'type': 'lineTo', 'x': 50, 'y': 90},
            {'type': 'closePath'},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
      expect(result.elementType, equals('path'));
      expect(result.paintBounds, isNotNull);
    });

    test('paint returns success for stroked path', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', strokeWidth: 3, strokeColor: '#00FF00',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for cubic bezier path', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 50},
            {
              'type': 'cubicTo',
              'controlX1': 30, 'controlY1': 10,
              'controlX2': 70, 'controlY2': 90,
              'x': 90, 'y': 50,
            },
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for quadratic bezier path', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 50},
            {'type': 'quadraticTo', 'controlX': 50, 'controlY': 10, 'x': 90, 'y': 50},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for shadow path', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        shadows: const [
          ShadowDefinition(color: '#000000', offsetX: 4, offsetY: 4, blurRadius: 8),
        ],
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 10},
            {'type': 'lineTo', 'x': 50, 'y': 90},
            {'type': 'closePath'},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns success for invisible path (skipped)', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000', visible: false,
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint returns failure when canvas is null', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
          ],
        },
      );
      final ctx = _makeContext(node);
      final painter = PathPainter();
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      expect(result.success, isFalse);
    });

    test('paint with empty commands (no-op)', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {'commands': <dynamic>[]},
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with only moveTo commands', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'moveTo', 'x': 20, 'y': 20},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with only closePath', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [{'type': 'closePath'}],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with opacity=0', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        opacity: 0,
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
            {'type': 'closePath'},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with rotation', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        rotation: 0.5,
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
            {'type': 'closePath'},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with scale', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        scaleX: 1.5, scaleY: 0.5,
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
            {'type': 'closePath'},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('metrics accumulate', () {
      final painter = PathPainter();
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);

      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
          ],
        },
      );
      final ctx1 = _makeContext(node, canvas: canvas);
      painter.prepare(ctx1);
      painter.paint(ctx1);

      final ctx2 = _makeContext(node, canvas: canvas);
      painter.prepare(ctx2);
      painter.paint(ctx2);

      recorder.endRecording();
      expect(painter.metrics.pathsPainted, equals(2));
      expect(painter.metrics.segmentsDrawn, equals(4));
      expect(painter.metrics.paintDuration, greaterThan(Duration.zero));
    });

    test('dispose', () {
      final painter = PathPainter();
      painter.prepare(
        _makeContext(
          RenderPaintNode(id: 'p', type: 'path', x: 0, y: 0, width: 10, height: 10, color: '#000'),
        ),
      );
      painter.dispose();
      expect(painter.metrics.pathsPainted, equals(0));
    });

    test('lifecycle: initialize -> prepare -> paint -> cleanup', () {
      final painter = PathPainter();
      painter.initialize();
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
          ],
        },
      );
      final recorder = PictureRecorder();
      final canvas = Canvas(recorder);
      final ctx = _makeContext(node, canvas: canvas);
      painter.prepare(ctx);
      final result = painter.paint(ctx);
      painter.cleanup();
      expect(result.success, isTrue);
      recorder.endRecording();
    });

    test('debug paint', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 10},
            {'type': 'lineTo', 'x': 90, 'y': 90},
          ],
          'debugPaint': true,
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });

    test('paint with mixed command types', () {
      final node = RenderPaintNode(
        id: 'p1', type: 'path',
        x: 0, y: 0, width: 100, height: 100,
        color: '#FF0000',
        properties: {
          'commands': [
            {'type': 'moveTo', 'x': 10, 'y': 50},
            {'type': 'lineTo', 'x': 30, 'y': 10},
            {
              'type': 'cubicTo',
              'controlX1': 50, 'controlY1': 0,
              'controlX2': 70, 'controlY2': 100,
              'x': 90, 'y': 50,
            },
            {'type': 'quadraticTo', 'controlX': 50, 'controlY': 90, 'x': 10, 'y': 50},
            {'type': 'closePath'},
          ],
        },
      );
      final result = _paintNode(node);
      expect(result.success, isTrue);
    });
  });
}
