import '../models/validation_category.dart';
import '../models/validation_issue.dart';
import 'validation_context.dart';

/// Base class for all validation rules.
///
/// Each rule validates a single aspect of a [ThemeDocument] and returns a
/// list of [ValidationIssue]s (empty when no issues are found).
abstract class ValidationRule {
  ValidationCategory get category;

  List<ValidationIssue> validate(ValidationContext context);
}
