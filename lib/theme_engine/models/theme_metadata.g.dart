// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_metadata.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeMetadataImpl _$$ThemeMetadataImplFromJson(Map<String, dynamic> json) =>
    _$ThemeMetadataImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      specVersion: json['specVersion'] as String? ?? '2.0.0',
      description: json['description'] as String?,
      author: json['author'] as String?,
      themeVersion: json['themeVersion'] as String?,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      colorScheme: json['colorScheme'] as String?,
    );

Map<String, dynamic> _$$ThemeMetadataImplToJson(_$ThemeMetadataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'specVersion': instance.specVersion,
      'description': instance.description,
      'author': instance.author,
      'themeVersion': instance.themeVersion,
      'tags': instance.tags,
      'colorScheme': instance.colorScheme,
    };
