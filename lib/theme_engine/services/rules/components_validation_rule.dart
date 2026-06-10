// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';

class ComponentsValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.components;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final components = context.document.components;

    for (final entry in components.schemas.entries) {
      if (entry.key.isEmpty) {
        issues.add(ValidationIssue(
          code: 'COMP_001',
          severity: ValidationSeverity.error,
          message: 'Component schema key must not be empty',
          jsonPath: r'$.components.schemas',
        ));
      }
      if (entry.value.id.isEmpty) {
        final k = entry.key;
        issues.add(ValidationIssue(
          code: 'COMP_002',
          severity: ValidationSeverity.error,
          message: 'Component schema id must not be empty',
          jsonPath: r'$.' + 'components.schemas.' + k + '.id',
          field: 'id',
        ));
      }
    }

    return issues;
  }
}
