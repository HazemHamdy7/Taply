import 'dart:convert';

import '../interfaces/theme_parser_interface.dart';
import '../models/theme_document.dart';
import 'parse_result.dart';
import 'parser_diagnostic.dart';
import 'parser_exception.dart';
import 'parser_options.dart';
import 'parser_registry.dart';
import 'json_path.dart';
import 'theme_parser_pipeline.dart';
import 'metadata_parser.dart';
import 'canvas_parser.dart';
import 'variables_parser.dart';
import 'assets_parser.dart';
import 'scene_parser.dart';
import 'component_parser.dart';
import 'animation_parser.dart';
import 'state_parser.dart';
import 'plugin_parser.dart';

class ThemeParser implements IThemeParser {
  final ParserRegistry registry;
  final ParserOptions options;
  late final ThemeParserPipeline _pipeline;

  ThemeParser({
    ParserRegistry? registry,
    ParserOptions? options,
  })  : registry = registry ?? _createDefaultRegistry(),
        options = options ?? const ParserOptions() {
    _pipeline = ThemeParserPipeline(registry: this.registry);
  }

  static ParserRegistry _createDefaultRegistry() {
    final registry = ParserRegistry();
    registry.registerAll([
      MetadataParser(),
      CanvasParser(),
      VariablesParser(),
      AssetsParser(),
      SceneParser(),
      ComponentParser(),
      AnimationParser(),
      StateParser(),
    ]);
    registry.discover();
    return registry;
  }

  @override
  ThemeDocument parse(Map<String, dynamic> json) {
    final result = parseWithResult(json);
    if (result.hasFatal || (!result.success && options.strictMode)) {
      final fatal = result.errors;
      if (fatal.isNotEmpty) {
        throw fatal.first;
      }
    }
    return result.requireValueOrThrow();
  }

  @override
  ThemeDocument parseString(String jsonString) {
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return parse(json);
    } on FormatException catch (e) {
      throw ParserFormatException('Invalid JSON format: $e');
    }
  }

  @override
  ParseResult<ThemeDocument> parseWithResult(Map<String, dynamic> json) {
    try {
      final result = _pipeline.runPipeline(json, options);
      return result;
    } on ParserException catch (e) {
      return ParseResult(
        value: null,
        success: false,
        diagnostics: [
          ParserDiagnostic(
            level: DiagnosticLevel.fatal,
            message: e.message,
            code: e.code ?? 'PARSE_ERROR',
            jsonPath: e.jsonPath ?? const JsonPath(),
          ),
        ],
      );
    } catch (e) {
      return ParseResult(
        value: null,
        success: false,
        diagnostics: [
          ParserDiagnostic(
            level: DiagnosticLevel.fatal,
            message: 'Unexpected error: $e',
            code: 'UNEXPECTED_ERROR',
            jsonPath: const JsonPath(),
          ),
        ],
      );
    }
  }

  @override
  List<String> validate(Map<String, dynamic> json) {
    final result = parseWithResult(json);
    if (result.success) return [];
    return result.errors.map((e) => e.toString()).toList();
  }

  void registerPlugin(PluginParser plugin) {
    registry.register(plugin);
  }

  void registerCustomNodeParser(CustomNodeParser parser) {
    registry.register(parser);
  }

  void registerMigrationHook(String key, MigrationHook hook) {
    registry.registerMigrationHook(key, hook);
  }

  Set<String> get registeredParserKeys => registry.registeredKeys;
}
