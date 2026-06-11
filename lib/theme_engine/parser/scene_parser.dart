import '../models/theme_scene.dart';
import '../models/scene_node.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';

class SceneParser extends InternalParser<ThemeScene> {
  static const _knownFields = {
    'id', 'label', 'nodes',
  };

  @override
  String get key => 'scene';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<ThemeScene> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('scene');
    final data = json['scene'] as Map<String, dynamic>?;

    if (data == null) {
      if (ctx.isStrict) {
        ctx.addWarning('Scene section missing, using defaults');
      }
      return ParseResult(
        value: const ThemeScene(),
        success: true,
        diagnostics: ctx.diagnostics,
      );
    }

    if (ctx.options.collectUnknownFields) {
      for (final key in data.keys) {
        if (!_knownFields.contains(key)) {
          ctx.addUnknownField(key);
        }
      }
    }

    try {
      final converter = const SceneNodeConverter();

      final rawNodes = data['nodes'] as List<dynamic>? ?? [];
      final nodes = <SceneNode>[];
      for (var i = 0; i < rawNodes.length; i++) {
        final nodeCtx = ctx.push('nodes').pushIndex(i);
        final item = rawNodes[i];
        if (item is Map<String, dynamic>) {
          try {
            nodes.add(converter.fromJson(item));
          } catch (e) {
            if (ctx.isLenient) {
              nodeCtx.addError('Failed to parse scene node at index $i: $e');
            } else {
              rethrow;
            }
          }
        } else {
          nodeCtx.addWarning('Scene node at index $i is not a valid object');
        }
      }

      final scene = ThemeScene(
        id: data['id'] as String? ?? 'main',
        label: data['label'] as String?,
        nodes: nodes,
      );

      return ParseResult(
        value: scene,
        success: true,
        diagnostics: ctx.diagnostics,
        unknownFields: ctx.unknownFields,
      );
    } catch (e) {
      if (ctx.isLenient) {
        ctx.addError('Failed to parse scene: $e');
        return ParseResult(
          value: const ThemeScene(),
          success: false,
          diagnostics: ctx.diagnostics,
        );
      }
      rethrow;
    }
  }
}
