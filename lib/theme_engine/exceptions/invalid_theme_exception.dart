/// Exception thrown when a theme document has invalid structure or data.
class InvalidThemeException implements Exception {
  /// Creates an [InvalidThemeException] with an optional [message]
  /// and a list of [reasons] for the invalidity.
  const InvalidThemeException([
    this.message,
    this.reasons = const [],
  ]);

  /// A summary of the invalidity.
  final String? message;

  /// Specific reasons the theme is considered invalid.
  final List<String> reasons;

  @override
  String toString() {
    if (reasons.isEmpty) {
      return 'InvalidThemeException${message != null ? ': $message' : ''}';
    }
    return 'InvalidThemeException${message != null ? ': $message' : ''}\n'
        '  ${reasons.join('\n  ')}';
  }
}
