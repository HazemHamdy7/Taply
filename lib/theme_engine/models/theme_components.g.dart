// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_components.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ComponentPropertyImpl _$$ComponentPropertyImplFromJson(
        Map<String, dynamic> json) =>
    _$ComponentPropertyImpl(
      type: json['type'] as String,
      defaultValue: json['defaultValue'],
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ComponentPropertyImplToJson(
        _$ComponentPropertyImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'defaultValue': instance.defaultValue,
      'description': instance.description,
    };

_$ComponentSchemaImpl _$$ComponentSchemaImplFromJson(
        Map<String, dynamic> json) =>
    _$ComponentSchemaImpl(
      id: json['id'] as String,
      properties: (json['properties'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ComponentProperty.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ComponentSchemaImplToJson(
        _$ComponentSchemaImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'properties': instance.properties,
    };

_$ThemeComponentsImpl _$$ThemeComponentsImplFromJson(
        Map<String, dynamic> json) =>
    _$ThemeComponentsImpl(
      schemas: (json['schemas'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, ComponentSchema.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ThemeComponentsImplToJson(
        _$ThemeComponentsImpl instance) =>
    <String, dynamic>{
      'schemas': instance.schemas,
    };
