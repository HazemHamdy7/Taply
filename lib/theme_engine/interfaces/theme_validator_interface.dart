import '../models/theme_document.dart';
import '../models/validation_report.dart';

/// Interface for theme validation.
abstract class IThemeValidator {
  /// Validates a [ThemeDocument] and returns a [ValidationReport].
  ///
  /// Validation is always synchronous and always completes, returning a
  /// detailed report of errors, warnings, and suggestions.
  ValidationReport validate(ThemeDocument document);
}
