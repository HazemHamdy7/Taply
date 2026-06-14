import '../taply_theme_runtime.dart';

/// Resolves field names to values from a [BusinessCardData] instance.
class FieldResolver {
  final Map<String, FieldBinding> _bindings;

  FieldResolver({Map<String, FieldBinding>? bindings})
      : _bindings = Map.from(bindings ?? {});

  void registerBinding(FieldBinding binding) {
    _bindings[binding.fieldName] = binding;
  }

  void registerBindings(Iterable<FieldBinding> bindings) {
    for (final b in bindings) {
      _bindings[b.fieldName] = b;
    }
  }

  /// Resolve a field value. Returns null if the field is unknown.
  String? resolve(String field, BusinessCardData data, CardRuntime runtime) {
    final binding = _bindings[field];
    if (binding != null) return binding.resolve(data);
    return data[field];
  }

  List<String> get registeredFields => _bindings.keys.toList();
}
