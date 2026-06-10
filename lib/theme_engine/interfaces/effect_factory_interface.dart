/// Interface for an effect factory.
abstract class IEffectFactory {
  /// The effect type identifier.
  String get type;

  /// Applies the effect to the given [properties] and returns
  /// modified properties.
  Map<String, dynamic> apply(Map<String, dynamic> properties);

  /// Returns `true` if this factory can handle the given [type].
  bool supports(String type);
}
