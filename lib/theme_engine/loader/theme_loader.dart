import 'dart:io' show File;

import '../interfaces/theme_loader_interface.dart';
import '../models/theme_document.dart';
import '../parser/theme_parser.dart';

class ThemeLoader implements IThemeLoader {
  final ThemeParser parser;

  ThemeLoader({ThemeParser? parser}) : parser = parser ?? ThemeParser();

  @override
  Future<ThemeDocument> load(String themeId) async {
    throw UnimplementedError(
      'ThemeLoader.load not implemented. Use loadFromString or loadFromFile instead.',
    );
  }

  @override
  Future<ThemeDocument> loadFromString(String jsonString) async {
    return parser.parseString(jsonString);
  }

  @override
  Future<ThemeDocument> loadFromFile(String filePath) async {
    final file = File(filePath);
    final content = await file.readAsString();
    return parser.parseString(content);
  }

  @override
  Future<ThemeDocument> loadFromUrl(String url) async {
    throw UnimplementedError('ThemeLoader.loadFromUrl not implemented.');
  }

  @override
  Future<ThemeDocument> loadFromBundle(String assetPath) async {
    throw UnimplementedError(
      'ThemeLoader.loadFromBundle not implemented in non-Flutter context.',
    );
  }

  @override
  Future<List<String>> listAvailable() async {
    return [];
  }
}
