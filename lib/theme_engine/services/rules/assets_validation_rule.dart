import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';

class AssetsValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.assets;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final assets = context.document.assets;

    if (assets.fontFamily != null && assets.fontFamily!.isEmpty) {
      issues.add(ValidationIssue(
        code: 'ASSET_001',
        severity: ValidationSeverity.warning,
        message: 'fontFamily is set but empty',
        jsonPath: r'$.assets.fontFamily',
        field: 'fontFamily',
      ));
    }
    if (assets.fontAsset != null && assets.fontAsset!.isEmpty) {
      issues.add(ValidationIssue(
        code: 'ASSET_002',
        severity: ValidationSeverity.warning,
        message: 'fontAsset is set but empty',
        jsonPath: r'$.assets.fontAsset',
        field: 'fontAsset',
      ));
    }

    return issues;
  }
}
