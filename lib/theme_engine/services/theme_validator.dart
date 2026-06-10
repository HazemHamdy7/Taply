// ignore_for_file: prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings

import '../interfaces/theme_validator_interface.dart';
import '../models/theme_document.dart';
import '../models/validation_report.dart';
import '../models/validation_severity.dart';
import 'validation_context.dart';
import 'validation_registry.dart';
import 'rules/metadata_validation_rule.dart';
import 'rules/canvas_validation_rule.dart';
import 'rules/variables_validation_rule.dart';
import 'rules/assets_validation_rule.dart';
import 'rules/scene_validation_rule.dart';
import 'rules/paint_validation_rule.dart';
import 'rules/widget_validation_rule.dart';
import 'rules/components_validation_rule.dart';
import 'rules/animations_validation_rule.dart';
import 'rules/states_validation_rule.dart';

/// Default implementation of [IThemeValidator].
///
/// Orchestrates validation by delegating to a [ValidationRegistry] of
/// [ValidationRule]s. No validation logic lives directly in this class.
class ThemeValidator implements IThemeValidator {
  final ValidationRegistry registry;

  ThemeValidator({ValidationRegistry? registry})
      : registry = registry ?? _createDefaultRegistry();

  static ValidationRegistry _createDefaultRegistry() {
    final registry = ValidationRegistry();
    registry.registerAll([
      MetadataValidationRule(),
      CanvasValidationRule(),
      VariablesValidationRule(),
      AssetsValidationRule(),
      SceneValidationRule(),
      PaintValidationRule(),
      WidgetValidationRule(),
      ComponentsValidationRule(),
      AnimationsValidationRule(),
      StatesValidationRule(),
    ]);
    return registry;
  }

  @override
  ValidationReport validate(ThemeDocument document) {
    final stopwatch = Stopwatch()..start();
    final context = ValidationContext(document: document);
    final issues = registry.validateAll(context);

    stopwatch.stop();

    final errors = issues
        .where((i) =>
            i.severity == ValidationSeverity.error ||
            i.severity == ValidationSeverity.fatal)
        .toList();
    final warnings =
        issues.where((i) => i.severity == ValidationSeverity.warning).toList();
    final suggestions =
        issues.where((i) => i.severity == ValidationSeverity.info).toList();

    return ValidationReport(
      isValid: errors.isEmpty,
      errors: errors,
      warnings: warnings,
      suggestions: suggestions,
      errorCount: errors.length,
      warningCount: warnings.length,
      suggestionCount: suggestions.length,
      executionTime: stopwatch.elapsed,
    );
  }
}
