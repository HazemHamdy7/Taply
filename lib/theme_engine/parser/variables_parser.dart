import '../models/theme_variables.dart';
import '../models/color_palette.dart';
import '../models/typography_set.dart';
import '../models/spacing_set.dart';
import '../models/radius_set.dart';
import '../models/shadow_definition.dart';
import '../utils/json_utils.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';
import 'parser_exception.dart';

class VariablesParser extends InternalParser<ThemeVariables> {
  static const _knownFields = {
    'colors', 'typography', 'spacing', 'radius', 'opacity',
    'shadows', 'animations', 'custom',
  };

  @override
  String get key => 'variables';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<ThemeVariables> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('variables');
    final data = json['variables'] as Map<String, dynamic>?;

    if (data == null) {
      return ParseResult(
        value: const ThemeVariables(),
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
      final colors = data['colors'] is Map<String, dynamic>
          ? ColorPalette.fromJson(data['colors'] as Map<String, dynamic>)
          : const ColorPalette();

      final typography = data['typography'] is Map<String, dynamic>
          ? TypographySet.fromJson(data['typography'] as Map<String, dynamic>)
          : const TypographySet();

      final spacing = data['spacing'] is Map<String, dynamic>
          ? SpacingSet.fromJson(data['spacing'] as Map<String, dynamic>)
          : const SpacingSet();

      final radius = data['radius'] is Map<String, dynamic>
          ? RadiusSet.fromJson(data['radius'] as Map<String, dynamic>)
          : const RadiusSet();

      final shadows = (data['shadows'] as List<dynamic>?)
              ?.map((e) => e is Map<String, dynamic>
                  ? ShadowDefinition.fromJson(e)
                  : null)
              .whereType<ShadowDefinition>()
              .toList() ??
          [];

      final custom = <String, VariableDefinition>{};
      if (data['custom'] is Map<String, dynamic>) {
        final customMap = data['custom'] as Map<String, dynamic>;
        for (final entry in customMap.entries) {
          if (entry.value is Map<String, dynamic>) {
            custom[entry.key] = VariableDefinition.fromJson(
                entry.value as Map<String, dynamic>);
          } else {
            custom[entry.key] = VariableDefinition(
              name: entry.key,
              value: entry.value,
            );
          }
        }
      }

      final variables = ThemeVariables(
        colors: colors,
        typography: typography,
        spacing: spacing,
        radius: radius,
        opacity: JsonUtils.optionalDouble(data, 'opacity') ?? 1.0,
        shadows: shadows,
        custom: custom,
      );

      return ParseResult(
        value: variables,
        success: true,
        diagnostics: ctx.diagnostics,
        unknownFields: ctx.unknownFields,
      );
    } on ParserException {
      rethrow;
    } catch (e) {
      if (ctx.isLenient) {
        ctx.addError('Failed to parse variables: $e');
        return ParseResult(
          value: const ThemeVariables(),
          success: false,
          diagnostics: ctx.diagnostics,
        );
      }
      rethrow;
    }
  }
}
