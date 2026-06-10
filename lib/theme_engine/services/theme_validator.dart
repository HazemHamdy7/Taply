import '../interfaces/theme_validator_interface.dart';
import '../models/theme_document.dart';

/// Default implementation of [IThemeValidator].
///
/// Validates theme structure, variable consistency, asset references,
/// and component usage.
class ThemeValidator implements IThemeValidator {
  @override
  List<String> validate(ThemeDocument theme) {
    throw UnimplementedError('ThemeValidator.validate');
  }

  @override
  List<String> validateJson(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeValidator.validateJson');
  }

  @override
  List<String> validateScene(ThemeDocument theme, String sceneId) {
    throw UnimplementedError('ThemeValidator.validateScene');
  }

  @override
  List<String> validateVariables(ThemeDocument theme) {
    throw UnimplementedError('ThemeValidator.validateVariables');
  }

  @override
  List<String> validateAssets(ThemeDocument theme) {
    throw UnimplementedError('ThemeValidator.validateAssets');
  }

  @override
  List<String> validateComponents(ThemeDocument theme) {
    throw UnimplementedError('ThemeValidator.validateComponents');
  }
}
