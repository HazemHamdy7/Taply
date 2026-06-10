import 'package:freezed_annotation/freezed_annotation.dart';
import 'validation_severity.dart';

part 'validation_issue.freezed.dart';
part 'validation_issue.g.dart';

@freezed
class ValidationIssue with _$ValidationIssue {
  const factory ValidationIssue({
    required String code,
    required ValidationSeverity severity,
    required String message,
    required String jsonPath,
    String? field,
    String? expected,
    String? actual,
    String? documentationUrl,
    String? autoFixHint,
  }) = _ValidationIssue;

  factory ValidationIssue.fromJson(Map<String, dynamic> json) =>
      _$ValidationIssueFromJson(json);
}
