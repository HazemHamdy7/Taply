import '../../models/validation_category.dart';
import '../../models/validation_issue.dart';
import '../../models/validation_severity.dart';
import '../validation_context.dart';
import '../validation_rule.dart';
import 'walk_nodes.dart';

class SceneValidationRule extends ValidationRule {
  @override
  ValidationCategory get category => ValidationCategory.scene;

  @override
  List<ValidationIssue> validate(ValidationContext context) {
    final issues = <ValidationIssue>[];
    final scene = context.document.scene;

    if (scene.id.isEmpty) {
      issues.add(ValidationIssue(
        code: 'SCENE_001',
        severity: ValidationSeverity.error,
        message: 'Scene id must not be empty',
        jsonPath: r'$.scene.id',
        field: 'id',
      ));
    }

    walkSceneNodes(scene.nodes, r'$.scene.nodes', (node, path) {
      if (node.id.isEmpty) {
        issues.add(ValidationIssue(
          code: 'SCENE_002',
          severity: ValidationSeverity.error,
          message: 'Scene node id must not be empty',
          jsonPath: path,
          field: 'id',
        ));
      } else if (context.hasNodeId(node.id)) {
        issues.add(ValidationIssue(
          code: 'SCENE_003',
          severity: ValidationSeverity.error,
          message: 'Duplicate scene node id: "${node.id}"',
          jsonPath: '$path.id',
          field: 'id',
          actual: node.id,
        ));
      } else {
        context.registerNodeId(node.id);
      }
    });

    return issues;
  }
}
