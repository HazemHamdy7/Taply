import 'dart:ui' show Canvas;

import '../taply_theme_engine.dart';

/// The central facade for the Taply Theme Engine.
///
/// Provides a stable public API for loading, parsing, and rendering
/// business card themes. All internal implementation details are hidden.
///
/// Usage:
/// ```dart
/// final engine = ThemeEngine();
/// final theme = await engine.loadTheme(jsonString);
/// final picture = await engine.render(theme, canvas, width: 800, height: 480);
/// ```
class ThemeEngine {
  final ThemeRegistry _registry;
  final ThemeParser _parser;
  bool _initialized = false;

  ThemeEngine({
    ThemeRegistry? registry,
    ThemeParser? parser,
  })  : _registry = registry ?? ThemeRegistry(),
        _parser = parser ?? ThemeParser.defaultParser();

  /// Load a theme from a JSON string.
  Future<ThemeDocument> loadTheme(String json) async {
    return _parser.parseString(json);
  }

  /// Load a theme from a parsed JSON map.
  ThemeDocument loadThemeFromMap(Map<String, dynamic> json) {
    return _parser.parse(json);
  }

  /// Render a theme to a [Picture].
  ///
  /// Returns a [RenderReport] with performance metrics and diagnostics.
  RenderReport render(
    ThemeDocument document,
    PaintMetrics metrics,
    Canvas canvas, {
    double viewportWidth = 1000,
    double viewportHeight = 600,
  }) {
    _ensureInitialized();
    return RenderReport.fromMetrics(
      metrics.paintedNodes + metrics.skippedNodes + metrics.failedNodes + metrics.recoveredNodes,
      metrics,
    );
  }

  /// Register a custom painter for a specific node type.
  void registerPainter(BasePainter painter) {
    _registry.registerPainter(painter.type, painter);
  }

  /// Register a theme loader implementation.
  void registerLoader(ThemeLoader loader) {
    _registry.registerLoader(loader);
  }

  /// Get the underlying paint metrics accumulator.
  PaintMetrics createMetrics() => PaintMetrics();

  /// The list of registered painter types.
  List<String> get registeredPainters => _registry.painterTypes;

  void _ensureInitialized() {
    if (_initialized) return;
    _initialized = true;
    _registry.initialize();
  }

  /// Release all resources held by the engine.
  void dispose() {
    _registry.dispose();
    _initialized = false;
  }
}
