/// Represents a scope level for variable resolution.
///
/// Variables can be defined at theme level, scene level, or layer level.
class VariableScope {
  /// The scope name (e.g., `"theme"`, `"scene"`, `"layer"`).
  final String name;

  /// The variables defined at this scope.
  final Map<String, dynamic> variables;

  /// Creates a [VariableScope].
  const VariableScope({
    required this.name,
    this.variables = const {},
  });
}
