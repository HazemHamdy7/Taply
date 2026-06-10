import '../models/theme_document.dart';

/// Interface for theme validation.
abstract class IThemeValidator {
  /// Validates a [ThemeDocument] and returns a list of validation errors.
  /// An empty list means the theme is valid.
  List<String> validate(ThemeDocument theme);

  /// Validates the theme JSON structure without building a full model.
  List<String> validateJson(Map<String, dynamic> json);

  /// Validates a specific scene within a theme.
  List<String> validateScene(ThemeDocument theme, String sceneId);

  /// Validates variable definitions and their references.
  List<String> validateVariables(ThemeDocument theme);

  /// Validates asset references in a theme.
  List<String> validateAssets(ThemeDocument theme);

  /// Validates component usage against their schemas.
  List<String> validateComponents(ThemeDocument theme);
}
