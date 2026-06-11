import '../models/theme_components.dart';
import '../utils/json_utils.dart';
import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';

class ComponentParser extends InternalParser<ThemeComponents> {
  static const _knownFields = {
    'schemas',
  };

  static const _schemaKnownFields = {
    'id', 'properties',
  };

  static const _propertyKnownFields = {
    'type', 'defaultValue', 'description',
  };

  @override
  String get key => 'components';

  @override
  String get supportedVersion => '2.0.0';

  @override
  bool canParse(String specVersion) => true;

  @override
  Set<String> knownFields() => _knownFields;

  @override
  ParseResult<ThemeComponents> parse(
      Map<String, dynamic> json, ParserContext context) {
    final ctx = context.push('components');
    final data = json['components'] as Map<String, dynamic>?;

    if (data == null) {
      return ParseResult(
        value: const ThemeComponents(),
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
      final schemas = <String, ComponentSchema>{};
      final rawSchemas = data['schemas'] as Map<String, dynamic>? ?? {};

      for (final entry in rawSchemas.entries) {
        final schemaCtx = ctx.push('schemas').push(entry.key);
        if (entry.value is! Map<String, dynamic>) {
          schemaCtx.addWarning('Component "${entry.key}" is not a valid map');
          continue;
        }
        final schemaMap = entry.value as Map<String, dynamic>;

        if (ctx.options.collectUnknownFields) {
          for (final key in schemaMap.keys) {
            if (!_schemaKnownFields.contains(key)) {
              schemaCtx.addUnknownField(key);
            }
          }
        }

        try {
          final properties = <String, ComponentProperty>{};
          final rawProps = schemaMap['properties'] as Map<String, dynamic>? ?? {};
          for (final propEntry in rawProps.entries) {
            final propCtx = schemaCtx.push('properties').push(propEntry.key);
            if (propEntry.value is! Map<String, dynamic>) {
              propCtx.addWarning(
                  'Property "${propEntry.key}" is not a valid map');
              continue;
            }
            final propMap = propEntry.value as Map<String, dynamic>;

            if (ctx.options.collectUnknownFields) {
              for (final key in propMap.keys) {
                if (!_propertyKnownFields.contains(key)) {
                  propCtx.addUnknownField(key);
                }
              }
            }

            properties[propEntry.key] = ComponentProperty(
              type: JsonUtils.requiredString(propMap, 'type'),
              defaultValue: propMap['defaultValue'],
              description: JsonUtils.optionalString(propMap, 'description'),
            );
          }

          schemas[entry.key] = ComponentSchema(
            id: JsonUtils.optionalString(schemaMap, 'id') ?? entry.key,
            properties: properties,
          );
        } catch (e) {
          if (ctx.isLenient) {
            schemaCtx.addError(
                'Failed to parse component "${entry.key}": $e');
          } else {
            rethrow;
          }
        }
      }

      return ParseResult(
        value: ThemeComponents(schemas: schemas),
        success: true,
        diagnostics: ctx.diagnostics,
        unknownFields: ctx.unknownFields,
      );
    } catch (e) {
      if (ctx.isLenient) {
        ctx.addError('Failed to parse components: $e');
        return ParseResult(
          value: const ThemeComponents(),
          success: false,
          diagnostics: ctx.diagnostics,
        );
      }
      rethrow;
    }
  }
}
