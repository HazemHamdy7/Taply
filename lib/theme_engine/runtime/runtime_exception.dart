class RuntimeException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const RuntimeException(this.message, {this.code, this.stackTrace});

  @override
  String toString() => 'RuntimeException($code): $message';
}

class FieldNotFoundException extends RuntimeException {
  const FieldNotFoundException(String field)
      : super('Field not found: $field', code: 'FIELD_NOT_FOUND');
}

class ExpressionEvaluationException extends RuntimeException {
  const ExpressionEvaluationException(String expr, String reason)
      : super('Failed to evaluate expression "$expr": $reason',
            code: 'EXPRESSION_EVAL_ERROR');
}

class AvatarLoadException extends RuntimeException {
  const AvatarLoadException(String source, String reason)
      : super('Failed to load avatar from $source: $reason',
            code: 'AVATAR_LOAD_ERROR');
}

class QRGenerationException extends RuntimeException {
  const QRGenerationException(String reason)
      : super('QR generation failed: $reason', code: 'QR_GENERATION_ERROR');
}

class FormatException extends RuntimeException {
  const FormatException(String value, String format)
      : super('Cannot format "$value" as $format', code: 'FORMAT_ERROR');
}
