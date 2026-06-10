import 'registry_base.dart';
import '../interfaces/effect_factory_interface.dart';

/// Registry for effect types.
///
/// Effect factories modify layer properties before painting or layout.
class EffectRegistry extends RegistryBase<IEffectFactory> {
  /// Provides access to the singleton instance.
  static final EffectRegistry instance = EffectRegistry._();

  EffectRegistry._();
}
