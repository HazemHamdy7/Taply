import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum ValidationSeverity {
  @JsonValue('info')
  info,
  @JsonValue('warning')
  warning,
  @JsonValue('error')
  error,
  @JsonValue('fatal')
  fatal,
}
