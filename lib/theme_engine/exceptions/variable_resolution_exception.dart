/// Exception thrown when a variable reference cannot be resolved.
class VariableResolutionException implements Exception {
  /// Creates a [VariableResolutionException] with an optional [message]
  /// and the [variableName] that could not be resolved.
  const VariableResolutionException([
    this.message,
    this.variableName,
  ]);

  /// A human-readable description of the resolution failure.
  final String? message;

  /// The name of the variable that could not be resolved.
  final String? variableName;

  @override
  String toString() {
    final buf = StringBuffer('VariableResolutionException');
    if (variableName != null) buf.write(' for "\$$variableName"');
    if (message != null) buf.write(': $message');
    return buf.toString();
  }
}
