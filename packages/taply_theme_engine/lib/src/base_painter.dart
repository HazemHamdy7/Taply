import '../taply_theme_engine.dart';

/// Abstract base class for all painters.
///
/// Implement this class to create custom painters for the theme engine.
/// Register custom painters with [ThemeEngine.registerPainter].
abstract class BasePainter {
  /// The unique type identifier for this painter (e.g. 'rect', 'circle').
  String get type;

  /// The capability level of this painter.
  PaintCapabilities get capabilities;

  /// Whether this painter can handle the given [node].
  bool canPaint(RenderPaintNode node);

  /// Initialize the painter. Called once before first use.
  void initialize();

  /// Prepare the painter for a specific [context].
  void prepare(PaintContext context);

  /// Execute the paint operation and return the result.
  PaintResult paint(PaintContext context);

  /// Dispose of resources held by this painter.
  void dispose();
}
