import 'package:meta/meta.dart';

/// A variable definition within a theme.
@immutable
class VariableDefinition {
  /// The variable name without the `$` prefix.
  final String name;

  /// The variable value, which may reference other variables.
  final dynamic value;

  /// An optional type hint (e.g., `"color"`, `"dimension"`, `"string"`).
  final String? type;

  /// An optional description of this variable.
  final String? description;

  /// Creates a [VariableDefinition].
  const VariableDefinition({
    required this.name,
    this.value,
    this.type,
    this.description,
  });

  /// Creates a [VariableDefinition] from a JSON map.
  factory VariableDefinition.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('VariableDefinition.fromJson');
  }

  /// Converts this definition to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('VariableDefinition.toJson');
  }
}

/// A collection of variable definitions for a theme.
@immutable
class ThemeVariables {
  /// Variables keyed by name (without the `$` prefix).
  final Map<String, VariableDefinition> variables;

  /// Creates [ThemeVariables].
  const ThemeVariables({
    this.variables = const {},
  });

  /// Creates [ThemeVariables] from a JSON map.
  factory ThemeVariables.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeVariables.fromJson');
  }

  /// Converts to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ThemeVariables.toJson');
  }
}
