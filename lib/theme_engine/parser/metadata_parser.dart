import '../models/theme_metadata.dart';
import '../utils/json_utils.dart';
import '../utils/semver_utils.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';
import 'parser_exception.dart';

class MetadataParser extends InternalParser<ThemeMetadata> {
  static const _knownFields = {
    'id', 'name', 'specVersion', 'description', 'author',
    'themeVersion', 'tags', 'colorScheme',
  };

  @override
  String get key => 'metadata';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<ThemeMetadata> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('metadata');

    try {
      if (json.isEmpty) {
        if (ctx.isStrict) {
          throw ParserMissingFieldException('metadata', jsonPath: ctx.jsonPath);
        }
        ctx.addWarning('Metadata section is empty');
        return ParseResult(
          value: ThemeMetadata(id: 'unknown', name: 'Untitled'),
          success: false,
          diagnostics: ctx.diagnostics,
        );
      }

      if (ctx.options.collectUnknownFields) {
        for (final key in json.keys) {
          if (!_knownFields.contains(key)) {
            ctx.addUnknownField(key);
          }
        }
      }

      final id = JsonUtils.optionalString(json, 'id') ?? 'unknown';
      final name = JsonUtils.optionalString(json, 'name') ?? 'Untitled';
      final specVersion =
          JsonUtils.optionalString(json, 'specVersion') ?? '2.0.0';

      final metadata = ThemeMetadata(
        id: id,
        name: name,
        specVersion: specVersion,
        description: JsonUtils.optionalString(json, 'description'),
        author: JsonUtils.optionalString(json, 'author'),
        themeVersion: JsonUtils.optionalString(json, 'themeVersion'),
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
        colorScheme: JsonUtils.optionalString(json, 'colorScheme'),
      );

      return ParseResult(
        value: metadata,
        success: true,
        diagnostics: ctx.diagnostics,
        unknownFields: ctx.unknownFields,
      );
    } on ParserException {
      rethrow;
    } catch (e) {
      if (ctx.isLenient) {
        ctx.addError('Failed to parse metadata: $e');
        return ParseResult(
          value: ThemeMetadata(id: 'unknown', name: 'Untitled'),
          success: false,
          diagnostics: ctx.diagnostics,
        );
      }
      rethrow;
    }
  }

  @override
  void migrate(Map<String, dynamic> json, String fromVersion, String toVersion) {
    if (SemverUtils.compare(fromVersion, '1.0.0') < 0 &&
        SemverUtils.compare(toVersion, '2.0.0') >= 0) {
      json.putIfAbsent('specVersion', () => '2.0.0');
    }
  }
}
