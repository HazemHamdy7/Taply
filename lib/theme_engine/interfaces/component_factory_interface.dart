/// Interface for a component factory that instantiates reusable components.
abstract class IComponentFactory {
  /// The component type identifier.
  String get type;

  /// Instantiates a component with the given [properties].
  /// Returns a map of scene layers that constitute the component.
  List<Map<String, dynamic>> instantiate(Map<String, dynamic> properties);

  /// Returns `true` if this factory can handle the given [type].
  bool supports(String type);
}
