import 'dart:ui' show Canvas;

import '../models/theme_document.dart';
import '../renderer/render_node.dart';
import '../renderer/render_tree.dart';
import 'base_painter.dart';
import 'paint_cache.dart';
import 'paint_context.dart';
import 'paint_metrics.dart';
import 'paint_registry.dart';
import 'paint_request.dart';
import 'painter_factory.dart';
import 'painter_resolver.dart';
import 'painters/rectangle_painter.dart';
import 'painters/circle/circle_painter.dart';
import 'painters/line/line_painter.dart';
import 'painters/path/path_painter.dart';
import 'painters/gradient/gradient_painter.dart';
import 'painters/image/image_painter.dart';
import 'painters/text/text_painter.dart';

class PaintEngine {
  final PaintRegistry registry;
  final PainterResolver resolver;
  final PainterFactory factory;
  final PaintCache cache;
  final PaintMetrics metrics;

  bool _initialized = false;
  final Set<String> _initializedPainters = {};

  PaintEngine({
    PaintRegistry? registry,
    PainterResolver? resolver,
    PainterFactory? factory,
    PaintCache? cache,
    PaintMetrics? metrics,
  })  : registry = registry ?? PaintRegistry.instance,
        resolver = resolver ?? PainterResolver(),
        factory = factory ?? PainterFactory(),
        cache = cache ?? PaintCache(),
        metrics = metrics ?? PaintMetrics();

  void initialize() {
    if (_initialized) return;
    _initialized = true;
    _registerBuiltinPainters();
  }

  void _registerBuiltinPainters() {
    registry.registerOrReplace('rect', RectanglePainter());
    registry.registerOrReplace('circle', CirclePainter());
    registry.registerOrReplace('line', LinePainter());
    registry.registerOrReplace('path', PathPainter());
    registry.registerOrReplace('gradient', GradientPainter());
    registry.registerOrReplace('image', ImagePainter());
    registry.registerOrReplace('text', TextPainterElement());
  }

  PaintMetrics render(
    RenderTree renderTree,
    ThemeDocument document, {
    Canvas? canvas,
    double viewportWidth = 1000,
    double viewportHeight = 600,
    double devicePixelRatio = 1.0,
    bool isRtl = false,
    PaintThemeMode themeMode = PaintThemeMode.light,
    bool useCache = true,
  }) {
    if (!_initialized) initialize();
    metrics.reset();

    final baseContext = PaintContext(
      canvas: canvas,
      document: document,
      renderTree: renderTree,
      renderNode: _dummyNode(),
      viewportWidth: viewportWidth,
      viewportHeight: viewportHeight,
      scaleFactor: renderTree.scaleFactor,
      variables: _extractVariables(document),
      assets: _extractAssets(document),
      isRtl: isRtl,
      themeMode: themeMode,
      devicePixelRatio: devicePixelRatio,
    );

    final flattened = renderTree.flatten();

    for (final node in flattened) {
      if (node is! RenderPaintNode) continue;

      if (!node.visible) {
        metrics.recordSkip();
        continue;
      }

      final request = PaintRequest(
        node: node,
        context: baseContext.forNode(node),
        useCache: useCache,
      );

      _processNode(request);
    }

    return metrics.copy();
  }

  void _processNode(PaintRequest request) {
    final node = request.node;

    BasePainter? painter;
    try {
      painter = resolver.requireResolve(node);
    } catch (e) {
      metrics.recordFailure();
      metrics.addWarning('Failed to resolve painter for type "${node.type}": $e');
      return;
    }

    if (!painter.canPaint(node)) {
      metrics.recordSkip();
      return;
    }

    if (request.useCache && cache.contains(node.id)) {
      metrics.recordCacheHit();
      final bounds = cache.get(node.id);
      metrics.extendBounds(bounds);
      return;
    }
    metrics.recordCacheMiss();

    _ensurePainterInitialized(painter);

    final stopwatch = Stopwatch()..start();

    try {
      painter.prepare(request.context);
      final result = painter.paint(request.context);

      stopwatch.stop();
      metrics.recordPaint(
        stopwatch.elapsed,
        elementType: result.elementType ?? node.type,
        bounds: result.paintBounds,
      );

      if (result.success) {
        cache.set(node.id, result.paintBounds);
        metrics.extendBounds(result.paintBounds);
        if (result.hasWarnings || result.hasDiagnostics) {
          for (final w in result.warnings) {
            metrics.addWarning(w);
          }
        }
      } else {
        metrics.recordRecovery();
        metrics.addWarning('Recovered from ${node.type} node "${node.id}": ${result.diagnostics.isNotEmpty ? result.diagnostics.first : "unknown error"}');
      }
    } catch (e) {
      stopwatch.stop();
      metrics.recordPaint(
        stopwatch.elapsed,
        elementType: node.type,
      );
      metrics.recordRecovery();
      metrics.addWarning('Recovered from exception in ${node.type} node "${node.id}": $e');
    }
  }

  void _ensurePainterInitialized(BasePainter painter) {
    if (!_initializedPainters.contains(painter.type)) {
      painter.initialize();
      _initializedPainters.add(painter.type);
    }
  }

  Map<String, dynamic> _extractVariables(ThemeDocument document) {
    final vars = <String, dynamic>{};
    final variables = document.variables;
    vars['opacity'] = variables.opacity;
    return vars;
  }

  Map<String, dynamic> _extractAssets(ThemeDocument document) {
    final assets = document.assets;
    return {
      if (assets.fontFamily != null) 'fontFamily': assets.fontFamily,
      if (assets.backgroundImage != null)
        'backgroundImage': assets.backgroundImage,
      'imageAssets': assets.imageAssets,
    };
  }

  RenderPaintNode _dummyNode() {
    return const RenderPaintNode(id: '_dummy', type: '_dummy');
  }

  void dispose() {
    for (final type in registry.registeredTypes) {
      final painter = registry.get(type);
      painter?.dispose();
    }
    cache.invalidateAll();
    factory.disposeAll();
    _initializedPainters.clear();
    _initialized = false;
  }

  void registerPainter(BasePainter painter) {
    registry.register(painter.type, painter);
  }

  void registerPainterFromFactory(String type) {
    final painter = factory.getOrCreate(type);
    registry.register(type, painter);
  }
}
