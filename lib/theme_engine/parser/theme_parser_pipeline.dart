import '../models/theme_document.dart';
import '../models/theme_metadata.dart';
import '../models/theme_canvas.dart';
import '../models/theme_variables.dart';
import '../models/theme_assets.dart';
import '../models/theme_scene.dart';
import '../models/theme_components.dart';
import '../models/theme_animation.dart';
import '../models/theme_state.dart';
import '../constants/theme_constants.dart';
import 'parse_result.dart';
import 'parser_context.dart';
import 'parser_options.dart';
import 'parser_registry.dart';
import 'parser_exception.dart';
import 'internal_parser.dart';

class ThemeParserPipeline {
  final ParserRegistry registry;

  ThemeParserPipeline({required this.registry});

  ParseResult<ThemeDocument> runPipeline(
      Map<String, dynamic> json, ParserOptions options) {
    final specVersion = _resolveSpecVersion(json, options);
    final context = ParserContext(
      options: options,
      specVersion: specVersion,
    );

    _validateRootStructure(json, context);

    final metadataResult = _parseStage<ThemeMetadata>(
      json, context, 'metadata', _parseMetadata);

    final canvasResult = _parseStage<ThemeCanvas>(
      json, context, 'canvas', _parseCanvas);

    final variablesResult = _parseStage<ThemeVariables>(
      json, context, 'variables', _parseVariables);

    final assetsResult = _parseStage<ThemeAssets>(
      json, context, 'assets', _parseAssets);

    final sceneResult = _parseStage<ThemeScene>(
      json, context, 'scene', _parseScene);

    final componentsResult = _parseStage<ThemeComponents>(
      json, context, 'components', _parseComponents);

    final animationsResult = _parseStage<List<ThemeAnimation>>(
      json, context, 'animations', _parseAnimations);

    final statesResult = _parseStage<List<ThemeState>>(
      json, context, 'states', _parseStates);

    context.diagnostics.addAll(metadataResult.diagnostics);
    context.diagnostics.addAll(canvasResult.diagnostics);
    context.diagnostics.addAll(variablesResult.diagnostics);
    context.diagnostics.addAll(assetsResult.diagnostics);
    context.diagnostics.addAll(sceneResult.diagnostics);
    context.diagnostics.addAll(componentsResult.diagnostics);
    context.diagnostics.addAll(animationsResult.diagnostics);
    context.diagnostics.addAll(statesResult.diagnostics);

    for (final entry in metadataResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }
    for (final entry in canvasResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }
    for (final entry in variablesResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }
    for (final entry in assetsResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }
    for (final entry in sceneResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }
    for (final entry in componentsResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }
    for (final entry in animationsResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }
    for (final entry in statesResult.unknownFields.entries) {
      context.unknownFields.putIfAbsent(entry.key, () => <String>{});
      context.unknownFields[entry.key]!.addAll(entry.value);
    }

    final hasFatal = context.diagnostics.any((d) => d.isFatal);
    if (hasFatal) {
      return ParseResult(
        value: null,
        success: false,
        diagnostics: context.diagnostics,
        unknownFields: context.unknownFields,
      );
    }

    try {
      final document = _buildDocument(
        metadata: metadataResult.value!,
        canvas: canvasResult.value!,
        variables: variablesResult.value!,
        assets: assetsResult.value!,
        scene: sceneResult.value!,
        components: componentsResult.value!,
        animations: animationsResult.value!,
        states: statesResult.value!,
      );

      return ParseResult(
        value: document,
        success: true,
        diagnostics: context.diagnostics,
        unknownFields: context.unknownFields,
      );
    } catch (e) {
      context.addFatal('Failed to build ThemeDocument: $e');
      return ParseResult(
        value: null,
        success: false,
        diagnostics: context.diagnostics,
        unknownFields: context.unknownFields,
      );
    }
  }

  String _resolveSpecVersion(Map<String, dynamic> json, ParserOptions options) {
    if (options.specVersionOverride != null) {
      return options.specVersionOverride!;
    }
    final metadata = json['metadata'] as Map<String, dynamic>?;
    return metadata?['specVersion'] as String? ?? ThemeConstants.specVersion;
  }

  void _validateRootStructure(Map<String, dynamic> json, ParserContext context) {
    if (!context.options.lenientMode && json.isEmpty) {
      throw ParserFormatException('JSON root is empty');
    }
  }

  ParseResult<T> _parseStage<T>(
    Map<String, dynamic> json,
    ParserContext context,
    String key,
    ParseResult<T> Function(Map<String, dynamic>, ParserContext) parseFn,
  ) {
    try {
      final parser = registry.get(key, version: context.specVersion);
      if (parser != null && parser.canParse(context.specVersion)) {
        return parser.parse(json, context) as ParseResult<T>;
      }
      return parseFn(json, context);
    } catch (e) {
      if (context.isLenient) {
        context.addError('Stage "$key" failed: $e');
        return ParseResult(value: null, success: false, diagnostics: context.diagnostics);
      }
      rethrow;
    }
  }

  ParseResult<ThemeMetadata> _parseMetadata(
      Map<String, dynamic> json, ParserContext context) {
    final data = json['metadata'] as Map<String, dynamic>?;
    if (data == null) {
      if (context.isStrict) {
        throw ParserMissingFieldException('metadata', jsonPath: context.jsonPath);
      }
      return ParseResult(
        value: ThemeMetadata(id: 'unknown', name: 'Untitled'),
        success: false,
        diagnostics: context.diagnostics,
      );
    }
    final parser = _findParser<ThemeMetadata>('metadata');
    return parser.parse(data, context);
  }

  ParseResult<ThemeCanvas> _parseCanvas(
      Map<String, dynamic> json, ParserContext context) {
    final parser = _findParser<ThemeCanvas>('canvas');
    return parser.parse(json, context);
  }

  ParseResult<ThemeVariables> _parseVariables(
      Map<String, dynamic> json, ParserContext context) {
    final parser = _findParser<ThemeVariables>('variables');
    return parser.parse(json, context);
  }

  ParseResult<ThemeAssets> _parseAssets(
      Map<String, dynamic> json, ParserContext context) {
    final parser = _findParser<ThemeAssets>('assets');
    return parser.parse(json, context);
  }

  ParseResult<ThemeScene> _parseScene(
      Map<String, dynamic> json, ParserContext context) {
    final parser = _findParser<ThemeScene>('scene');
    return parser.parse(json, context);
  }

  ParseResult<ThemeComponents> _parseComponents(
      Map<String, dynamic> json, ParserContext context) {
    final parser = _findParser<ThemeComponents>('components');
    return parser.parse(json, context);
  }

  ParseResult<List<ThemeAnimation>> _parseAnimations(
      Map<String, dynamic> json, ParserContext context) {
    final parser = _findParser<List<ThemeAnimation>>('animations');
    return parser.parse(json, context);
  }

  ParseResult<List<ThemeState>> _parseStates(
      Map<String, dynamic> json, ParserContext context) {
    final parser = _findParser<List<ThemeState>>('states');
    return parser.parse(json, context);
  }

  InternalParser<T> _findParser<T>(String key) {
    final parser = registry.get(key);
    if (parser == null) {
      throw ParserInternalException('No parser registered for "$key"',
          code: 'PARSER_NOT_FOUND');
    }
    return parser as InternalParser<T>;
  }

  ThemeDocument _buildDocument({
    required ThemeMetadata metadata,
    required ThemeCanvas canvas,
    required ThemeVariables variables,
    required ThemeAssets assets,
    required ThemeScene scene,
    required ThemeComponents components,
    required List<ThemeAnimation> animations,
    required List<ThemeState> states,
  }) {
    return ThemeDocument(
      metadata: metadata,
      canvas: canvas,
      variables: variables,
      assets: assets,
      scene: scene,
      components: components,
      animations: animations,
      states: states,
    );
  }
}
