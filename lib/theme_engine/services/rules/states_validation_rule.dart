// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';
import 'walk_nodes.dart';

class StatesValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.states;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final stateIds = <String>{};

    for (final state in context.document.states) {
      if (state.id.isEmpty) {
        issues.add(ValidationIssue(
          code: 'STATE_001',
          severity: ValidationSeverity.error,
          message: 'State id must not be empty',
          jsonPath: r'$.states',
          field: 'id',
        ));
      } else if (stateIds.contains(state.id)) {
        issues.add(ValidationIssue(
          code: 'STATE_002',
          severity: ValidationSeverity.error,
          message: 'Duplicate state id: "${state.id}"',
          jsonPath: r'$.states',
          field: 'id',
          actual: state.id,
        ));
      } else {
        stateIds.add(state.id);
      }

      final nodeIds = <String>{};
      final id = state.id;
      walkSceneNodes(
        state.nodes,
        r'$.' + 'states.' + id + '.nodes',
        (node, path) {
          if (node.id.isEmpty) {
            issues.add(ValidationIssue(
              code: 'STATE_003',
              severity: ValidationSeverity.error,
              message: 'State node id must not be empty',
              jsonPath: path,
              field: 'id',
            ));
          } else if (nodeIds.contains(node.id)) {
            issues.add(ValidationIssue(
              code: 'STATE_004',
              severity: ValidationSeverity.error,
              message: 'Duplicate state node id: "${node.id}"',
              jsonPath: '$path.id',
              field: 'id',
              actual: node.id,
            ));
          } else {
            nodeIds.add(node.id);
          }
        },
      );
    }

    return issues;
  }
}
