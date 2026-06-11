import '../exceptions/registry_exception.dart';

/// Abstract base class for all registries.
abstract class RegistryBase<T> {
  final Map<String, T> _items = {};

  /// Registers an [item] under its [type] key.
  ///
  /// Throws [RegistryException] if the type is already registered.
  void register(String type, T item) {
    if (_items.containsKey(type)) {
      throw RegistryException('Type "$type" is already registered', type);
    }
    _items[type] = item;
  }

  /// Registers an [item] under its [type] key, replacing any existing entry.
  void registerOrReplace(String type, T item) {
    _items[type] = item;
  }

  /// Unregisters an item by [type] key.
  void unregister(String type) {
    _items.remove(type);
  }

  /// Retrieves a registered item by [type] key.
  /// Returns `null` if not found.
  T? get(String type) => _items[type];

  /// Returns `true` if the given [type] is registered.
  bool has(String type) => _items.containsKey(type);

  /// Returns all registered type keys.
  List<String> get registeredTypes => _items.keys.toList();

  /// Returns all registered items.
  List<T> get all => _items.values.toList();

  /// Returns the number of registered items.
  int get count => _items.length;

  /// Removes all registrations.
  void clear() => _items.clear();
}
