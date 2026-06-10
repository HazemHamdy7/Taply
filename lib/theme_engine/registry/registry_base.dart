import '../exceptions/registry_exception.dart';

/// Abstract base class for all registries.
abstract class RegistryBase<T> {
  /// Registers an item under its type key.
  ///
  /// Throws [RegistryException] if the type is already registered.
  void register(String type, T item) {
    throw UnimplementedError('RegistryBase.register');
  }

  /// Unregisters an item by type key.
  void unregister(String type) {
    throw UnimplementedError('RegistryBase.unregister');
  }

  /// Retrieves a registered item by type key.
  /// Returns `null` if not found.
  T? get(String type) {
    throw UnimplementedError('RegistryBase.get');
  }

  /// Returns `true` if the given [type] is registered.
  bool has(String type) {
    throw UnimplementedError('RegistryBase.has');
  }

  /// Returns all registered type keys.
  List<String> get registeredTypes {
    throw UnimplementedError('RegistryBase.registeredTypes');
  }

  /// Returns all registered items.
  List<T> get all {
    throw UnimplementedError('RegistryBase.all');
  }

  /// Removes all registrations.
  void clear() {
    throw UnimplementedError('RegistryBase.clear');
  }
}
