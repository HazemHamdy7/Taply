import 'registry_base.dart';
import '../interfaces/component_factory_interface.dart';

/// Registry for component types.
///
/// Component factories are registered by type key and instantiate
/// reusable component schemas at parse time.
class ComponentRegistry extends RegistryBase<IComponentFactory> {
  /// Provides access to the singleton instance.
  static final ComponentRegistry instance = ComponentRegistry._();

  ComponentRegistry._();
}
