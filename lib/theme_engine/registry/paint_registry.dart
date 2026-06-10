import 'registry_base.dart';
import '../interfaces/painter_interface.dart';

/// Registry for paint layer types.
///
/// Painters are registered by type key (e.g., `"rect"`, `"circle"`)
/// and are looked up at render time.
class PaintRegistry extends RegistryBase<IPainter> {
  /// Provides access to the singleton instance.
  static final PaintRegistry instance = PaintRegistry._();

  PaintRegistry._();
}
