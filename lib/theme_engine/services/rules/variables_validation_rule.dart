// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';

class VariablesValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.variables;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final variables = context.document.variables;

    if (variables.colors.swatches.isEmpty) {
      issues.add(ValidationIssue(
        code: 'VAR_001',
        severity: ValidationSeverity.info,
        message: 'No color swatches defined',
        jsonPath: r'$.variables.colors.swatches',
      ));
    }
    for (final swatch in variables.colors.swatches) {
      if (swatch.id.isEmpty) {
        issues.add(ValidationIssue(
          code: 'VAR_002',
          severity: ValidationSeverity.error,
          message: 'Color swatch id must not be empty',
          jsonPath: r'$.variables.colors.swatches',
          field: 'id',
        ));
      }
      if (swatch.color.isEmpty) {
        issues.add(ValidationIssue(
          code: 'VAR_003',
          severity: ValidationSeverity.error,
          message: 'Color swatch value must not be empty',
          jsonPath: r'$.variables.colors.swatches',
          field: 'color',
        ));
      }
    }

    _validateNumericMap(
      {'xs': variables.spacing.xs, 'sm': variables.spacing.sm, 'md': variables.spacing.md, 'lg': variables.spacing.lg, 'xl': variables.spacing.xl},
      'spacing',
      'VAR_004',
      issues,
    );
    _validateNumericMap(
      {'none': variables.radius.none, 'sm': variables.radius.sm, 'md': variables.radius.md, 'lg': variables.radius.lg, 'xl': variables.radius.xl, 'full': variables.radius.full},
      'radius',
      'VAR_005',
      issues,
    );

    for (final entry in variables.spacing.custom.entries) {
      if (double.tryParse(entry.value) == null) {
        final k = entry.key;
        issues.add(ValidationIssue(
          code: 'VAR_006',
          severity: ValidationSeverity.warning,
          message: 'Custom spacing "$k" is not a valid number',
          jsonPath: r'$.' + 'variables.spacing.custom.' + k,
          field: k,
          expected: 'valid number string',
          actual: entry.value,
        ));
      }
    }
    for (final entry in variables.radius.custom.entries) {
      if (double.tryParse(entry.value) == null) {
        final k = entry.key;
        issues.add(ValidationIssue(
          code: 'VAR_007',
          severity: ValidationSeverity.warning,
          message: 'Custom radius "$k" is not a valid number',
          jsonPath: r'$.' + 'variables.radius.custom.' + k,
          field: entry.key,
          expected: 'valid number string',
          actual: entry.value,
        ));
      }
    }

    if (variables.opacity < 0 || variables.opacity > 1) {
      issues.add(ValidationIssue(
        code: 'VAR_008',
        severity: ValidationSeverity.warning,
        message: 'Opacity should be between 0 and 1',
        jsonPath: r'$.variables.opacity',
        field: 'opacity',
        expected: '0.0 to 1.0',
        actual: variables.opacity.toString(),
      ));
    }

    return issues;
  }

  void _validateNumericMap(
    Map<String, String> fields,
    String category,
    String code,
    List<ValidationIssue> issues,
  ) {
    for (final entry in fields.entries) {
      if (double.tryParse(entry.value) == null) {
        final k = entry.key;
        final c = category;
        issues.add(ValidationIssue(
          code: code,
          severity: ValidationSeverity.error,
          message: c + ' "' + k + '" is not a valid number',
          jsonPath: r'$.' + 'variables.' + c + '.' + k,
          field: k,
          expected: 'valid number string',
          actual: entry.value,
        ));
      }
    }
  }
}
