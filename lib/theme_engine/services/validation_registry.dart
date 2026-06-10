import '../models/validation_issue.dart';
import 'validation_context.dart';
import 'validation_rule.dart';

/// Registry that holds and executes all registered [ValidationRule]s.
class ValidationRegistry {
  final List<ValidationRule> _rules = [];

  void register(ValidationRule rule) => _rules.add(rule);

  void registerAll(Iterable<ValidationRule> rules) => _rules.addAll(rules);

  List<ValidationRule> get rules => List.unmodifiable(_rules);

  List<ValidationIssue> validateAll(ValidationContext context) {
    final issues = <ValidationIssue>[];
    for (final rule in _rules) {
      issues.addAll(rule.validate(context));
    }
    return issues;
  }
}
