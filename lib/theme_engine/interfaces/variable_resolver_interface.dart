import '../models/theme_variables.dart';

/// Interface for resolving variable references within a theme.
abstract class IVariableResolver {
  /// Resolves a single variable reference by [name].
  ///
  /// Throws [VariableResolutionException] if the variable cannot be resolved.
  dynamic resolve(String name);

  /// Resolves all variables in the given [variables] collection.
  /// Returns a map of resolved values.
  Map<String, dynamic> resolveAll(ThemeVariables variables);

  /// Returns `true` if [value] contains a variable reference pattern.
  bool hasVariableReference(dynamic value);

  /// Extracts variable names referenced in [value].
  List<String> extractReferences(dynamic value);
}
