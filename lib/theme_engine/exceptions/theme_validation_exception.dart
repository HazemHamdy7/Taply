/// Exception thrown when a theme fails structural or semantic validation.
class ThemeValidationException implements Exception {
  /// Creates a [ThemeValidationException] with an optional [message]
  /// and a list of [errors].
  const ThemeValidationException([
    this.message,
    this.errors = const [],
  ]);

  /// A summary of the validation failure.
  final String? message;

  /// Detailed validation error descriptions.
  final List<String> errors;

  @override
  String toString() {
    if (errors.isEmpty) {
      return 'ThemeValidationException${message != null ? ': $message' : ''}';
    }
    return 'ThemeValidationException${message != null ? ': $message' : ''}\n'
        '  ${errors.join('\n  ')}';
  }
}
