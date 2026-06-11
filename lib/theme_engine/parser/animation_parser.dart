import '../models/theme_animation.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';
import 'parser_exception.dart';

class AnimationParser extends InternalParser<List<ThemeAnimation>> {
  static const _knownFields = {
    'id', 'type', 'durationMs', 'delayMs', 'from', 'to',
    'easing', 'repeatCount', 'autoReverse',
  };

  @override
  String get key => 'animations';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<List<ThemeAnimation>> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('animations');
    final list = json['animations'] as List<dynamic>?;

    if (list == null || list.isEmpty) {
      return const ParseResult(value: [], success: true);
    }

    final animations = <ThemeAnimation>[];
    for (var i = 0; i < list.length; i++) {
      final item = list[i];
      final itemCtx = ctx.pushIndex(i);

      if (item is! Map<String, dynamic>) {
        if (ctx.isStrict) {
          throw ParserTypeMismatchException(
            field: 'animations[$i]',
            expectedType: 'Map<String, dynamic>',
            actualType: item.runtimeType.toString(),
            jsonPath: itemCtx.jsonPath,
          );
        }
        itemCtx.addWarning('Animation at index $i is not a valid object');
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
        animations.add(ThemeAnimation.fromJson(item));
      } catch (e) {
        if (ctx.isLenient) {
          itemCtx.addError('Failed to parse animation at index $i: $e');
        } else {
          rethrow;
        }
      }
    }

    return ParseResult(
      value: animations,
      success: true,
      diagnostics: ctx.diagnostics,
      unknownFields: ctx.unknownFields,
    );
  }
}
