import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';

class AnimationsValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.animations;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final animationIds = <String>{};

    for (final animation in context.document.animations) {
      if (animation.id.isEmpty) {
        issues.add(ValidationIssue(
          code: 'ANIM_001',
          severity: ValidationSeverity.error,
          message: 'Animation id must not be empty',
          jsonPath: r'$.animations',
          field: 'id',
        ));
      } else if (animationIds.contains(animation.id)) {
        issues.add(ValidationIssue(
          code: 'ANIM_002',
          severity: ValidationSeverity.error,
          message: 'Duplicate animation id: "${animation.id}"',
          jsonPath: r'$.animations',
          field: 'id',
          actual: animation.id,
        ));
      } else {
        animationIds.add(animation.id);
      }

      if (animation.durationMs < 0) {
        issues.add(ValidationIssue(
          code: 'ANIM_003',
          severity: ValidationSeverity.error,
          message: 'Animation duration must not be negative',
          jsonPath: r'$.animations',
          field: 'durationMs',
          expected: '>= 0',
          actual: animation.durationMs.toString(),
        ));
      }
    }

    return issues;
  }
}
