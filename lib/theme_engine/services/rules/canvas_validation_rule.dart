import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';

class CanvasValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.canvas;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final canvas = context.document.canvas;

    if (canvas.width <= 0) {
      issues.add(ValidationIssue(
        code: 'CANVAS_001',
        severity: ValidationSeverity.error,
        message: 'Canvas width must be greater than 0',
        jsonPath: r'$.canvas.width',
        field: 'width',
        expected: '> 0',
        actual: canvas.width.toString(),
      ));
    }
    if (canvas.height <= 0) {
      issues.add(ValidationIssue(
        code: 'CANVAS_002',
        severity: ValidationSeverity.error,
        message: 'Canvas height must be greater than 0',
        jsonPath: r'$.canvas.height',
        field: 'height',
        expected: '> 0',
        actual: canvas.height.toString(),
      ));
    }
    if (canvas.cornerRadius < 0) {
      issues.add(ValidationIssue(
        code: 'CANVAS_003',
        severity: ValidationSeverity.error,
        message: 'Canvas cornerRadius must not be negative',
        jsonPath: r'$.canvas.cornerRadius',
        field: 'cornerRadius',
        expected: '>= 0',
        actual: canvas.cornerRadius.toString(),
      ));
    }

    return issues;
  }
}
