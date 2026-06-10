// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';
import 'walk_nodes.dart';

class WidgetValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.widget;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];

    walkSceneNodes(
      context.document.scene.nodes,
      r'$.scene.nodes',
      (node, path) {
        node.maybeWhen(
          widget: (id, type, name, visible, opacity, zIndex, transform,
              constraints, field, fontSize, color, fontWeight, maxLines, size,
              shape, shadows, properties) {
            if (type.isEmpty) {
              issues.add(ValidationIssue(
                code: 'WIDGET_001',
                severity: ValidationSeverity.error,
                message: 'Widget node type must not be empty',
                jsonPath: '$path.type',
                field: 'type',
              ));
            }
          },
          orElse: () {},
        );
      },
    );

    for (final state in context.document.states) {
      final id = state.id;
      walkSceneNodes(
        state.nodes,
        r'$.' + 'states.' + id + '.nodes',
        (node, path) {
          node.maybeWhen(
            widget: (id, type, name, visible, opacity, zIndex, transform,
                constraints, field, fontSize, color, fontWeight, maxLines,
                size, shape, shadows, properties) {
              if (type.isEmpty) {
                issues.add(ValidationIssue(
                  code: 'WIDGET_001',
                  severity: ValidationSeverity.error,
                  message: 'Widget node type must not be empty',
                  jsonPath: '$path.type',
                  field: 'type',
                ));
              }
            },
            orElse: () {},
          );
        },
      );
    }

    return issues;
  }
}
