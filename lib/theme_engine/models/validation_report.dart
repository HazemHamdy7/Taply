import 'package:freezed_annotation/freezed_annotation.dart';
import 'validation_issue.dart';

part 'validation_report.freezed.dart';
part 'validation_report.g.dart';

@freezed
class ValidationReport with _$ValidationReport {
  const factory ValidationReport({
    @Default(true) bool isValid,
    @Default([]) List<ValidationIssue> errors,
    @Default([]) List<ValidationIssue> warnings,
    @Default([]) List<ValidationIssue> suggestions,
    @Default(0) int errorCount,
    @Default(0) int warningCount,
    @Default(0) int suggestionCount,
    Duration? executionTime,
  }) = _ValidationReport;

  const ValidationReport._();

  factory ValidationReport.fromJson(Map<String, dynamic> json) =>
      _$ValidationReportFromJson(json);

  bool get hasErrors => errors.isNotEmpty;
  bool get hasWarnings => warnings.isNotEmpty;
}
