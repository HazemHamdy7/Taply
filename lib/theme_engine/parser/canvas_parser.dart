import '../models/theme_canvas.dart';
import '../utils/json_utils.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';

class CanvasParser extends InternalParser<ThemeCanvas> {
  static const _knownFields = {
    'width', 'height', 'cornerRadius', 'layoutMode',
  };

  @override
  String get key => 'canvas';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<ThemeCanvas> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('canvas');
    final data = json['canvas'] as Map<String, dynamic>?;

    if (data == null) {
      if (ctx.isStrict) {
        ctx.addWarning('Canvas section missing, using defaults');
      }
      return ParseResult(
        value: const ThemeCanvas(),
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
      final modeStr = JsonUtils.optionalString(data, 'layoutMode') ?? 'centered';
      final layoutMode = LayoutMode.values.firstWhere(
        (m) => m.name == modeStr,
        orElse: () => LayoutMode.centered,
      );

      final canvas = ThemeCanvas(
        width: JsonUtils.optionalDouble(data, 'width') ?? 1000,
        height: JsonUtils.optionalDouble(data, 'height') ?? 600,
        cornerRadius: JsonUtils.optionalDouble(data, 'cornerRadius') ?? 0,
        layoutMode: layoutMode,
      );

      return ParseResult(
        value: canvas,
        success: true,
        diagnostics: ctx.diagnostics,
        unknownFields: ctx.unknownFields,
      );
    } catch (e) {
      if (ctx.isLenient) {
        ctx.addError('Failed to parse canvas: $e');
        return ParseResult(
          value: const ThemeCanvas(),
          success: false,
          diagnostics: ctx.diagnostics,
        );
      }
      rethrow;
    }
  }
}
