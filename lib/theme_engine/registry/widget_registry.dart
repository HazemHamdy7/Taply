import 'registry_base.dart';
import '../interfaces/widget_factory_interface.dart';

/// Registry for widget layer types.
///
/// Widget factories are registered by type key (e.g., `"text"`, `"image"`)
/// and are looked up at widget build time.
class WidgetRegistry extends RegistryBase<IWidgetFactory> {
  /// Provides access to the singleton instance.
  static final WidgetRegistry instance = WidgetRegistry._();

  WidgetRegistry._();
}
