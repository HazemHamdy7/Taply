import '../models/theme_assets.dart';
import '../utils/json_utils.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';

class AssetsParser extends InternalParser<ThemeAssets> {
  static const _knownFields = {
    'fontFamily', 'fontAsset', 'backgroundImage', 'imageAssets', 'assetMap',
  };

  @override
  String get key => 'assets';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<ThemeAssets> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('assets');
    final data = json['assets'] as Map<String, dynamic>?;

    if (data == null) {
      return ParseResult(
        value: const ThemeAssets(),
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
      final imageAssets = (data['imageAssets'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [];

      final rawAssetMap = data['assetMap'];
      final assetMap = <String, String>{};
      if (rawAssetMap is Map) {
        for (final entry in rawAssetMap.entries) {
          assetMap[entry.key.toString()] = entry.value.toString();
        }
      }

      final assets = ThemeAssets(
        fontFamily: JsonUtils.optionalString(data, 'fontFamily'),
        fontAsset: JsonUtils.optionalString(data, 'fontAsset'),
        backgroundImage: JsonUtils.optionalString(data, 'backgroundImage'),
        imageAssets: imageAssets,
        assetMap: assetMap,
      );

      return ParseResult(
        value: assets,
        success: true,
        diagnostics: ctx.diagnostics,
        unknownFields: ctx.unknownFields,
      );
    } catch (e) {
      if (ctx.isLenient) {
        ctx.addError('Failed to parse assets: $e');
        return ParseResult(
          value: const ThemeAssets(),
          success: false,
          diagnostics: ctx.diagnostics,
        );
      }
      rethrow;
    }
  }
}
