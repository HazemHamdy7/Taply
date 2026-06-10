import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';

class MetadataValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.metadata;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final metadata = context.document.metadata;

    if (metadata.id.isEmpty) {
      issues.add(ValidationIssue(
        code: 'META_001',
        severity: ValidationSeverity.error,
        message: 'Theme metadata id must not be empty',
        jsonPath: r'$.metadata.id',
        field: 'id',
      ));
    }
    if (metadata.name.isEmpty) {
      issues.add(ValidationIssue(
        code: 'META_002',
        severity: ValidationSeverity.error,
        message: 'Theme metadata name must not be empty',
        jsonPath: r'$.metadata.name',
        field: 'name',
      ));
    }
    final versionPattern = RegExp(r'^\d+\.\d+\.\d+$');
    if (!versionPattern.hasMatch(metadata.specVersion)) {
      issues.add(ValidationIssue(
        code: 'META_003',
        severity: ValidationSeverity.warning,
        message: 'specVersion should follow semver format (e.g., 2.0.0)',
        jsonPath: r'$.metadata.specVersion',
        field: 'specVersion',
        expected: 'major.minor.patch',
        actual: metadata.specVersion,
      ));
    }

    return issues;
  }
}
