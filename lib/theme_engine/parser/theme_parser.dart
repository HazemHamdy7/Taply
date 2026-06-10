import '../interfaces/theme_parser_interface.dart';
import '../models/theme_document.dart';

/// Default implementation of [IThemeParser].
///
/// Parses theme JSON into a [ThemeDocument] model tree.
class ThemeParser implements IThemeParser {
  @override
  ThemeDocument parse(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeParser.parse');
  }

  @override
  ThemeDocument parseString(String jsonString) {
    throw UnimplementedError('ThemeParser.parseString');
  }

  @override
  List<String> validate(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeParser.validate');
  }
}
