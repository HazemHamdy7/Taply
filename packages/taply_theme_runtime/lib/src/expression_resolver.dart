import '../taply_theme_runtime.dart';

/// Evaluates expression strings against the current runtime state.
///
/// Supports simple expansions like `{{fieldName}}`.
class ExpressionResolver {
  final RegExp _expressionPattern;

  ExpressionResolver({
    RegExp? expressionPattern,
  }) : _expressionPattern = expressionPattern ?? RegExp(r'\{\{(.+?)\}\}');

  /// Evaluate an expression string.
  ///
  /// Replaces `{{fieldName}}` placeholders with resolved field values.
  String evaluate(String expression, CardRuntime runtime) {
    return expression.replaceAllMapped(
      _expressionPattern,
      (match) {
        final field = match.group(1)?.trim() ?? '';
        final value = runtime.resolveField(field);
        return value ?? '{{$field}}';
      },
    );
  }

  /// Check if an expression contains any placeholders.
  bool hasPlaceholders(String expression) {
    return _expressionPattern.hasMatch(expression);
  }
}
