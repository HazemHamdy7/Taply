import '../models/theme_state.dart';
import '../models/scene_node.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';
import 'parser_exception.dart';

class StateParser extends InternalParser<List<ThemeState>> {
  static const _knownFields = {
    'id', 'label', 'nodes',
  };

  @override
  String get key => 'states';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<List<ThemeState>> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('states');
    final list = json['states'] as List<dynamic>?;

    if (list == null || list.isEmpty) {
      return const ParseResult(value: [], success: true);
    }

    final states = <ThemeState>[];
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      final itemCtx = ctx.pushIndex(i);

      if (item is! Map<String, dynamic>) {
        if (ctx.isStrict) {
          throw ParserTypeMismatchException(
            field: 'states[$i]',
            expectedType: 'Map<String, dynamic>',
            actualType: item.runtimeType.toString(),
            jsonPath: itemCtx.jsonPath,
          );
        }
        itemCtx.addWarning('State at index $i is not a valid object');
        continue;
      }

      try {
        if (ctx.options.collectUnknownFields) {
          for (final key in item.keys) {
            if (!_knownFields.contains(key)) {
              itemCtx.addUnknownField(key);
            }
          }
        }

        final converter = const SceneNodeConverter();
        final nodes = (item['nodes'] as List<dynamic>?)
                ?.map((n) => n is Map<String, dynamic>
                    ? converter.fromJson(n)
                    : null)
                .whereType<SceneNode>()
                .toList() ??
            [];

        states.add(ThemeState(
          id: item['id'] as String? ?? 'state_$i',
          label: item['label'] as String?,
          nodes: nodes,
        ));
      } catch (e) {
        if (ctx.isLenient) {
          itemCtx.addError('Failed to parse state at index $i: $e');
        } else {
          rethrow;
        }
      }
    }

    return ParseResult(
      value: states,
      success: true,
      diagnostics: ctx.diagnostics,
      unknownFields: ctx.unknownFields,
    );
  }
}
