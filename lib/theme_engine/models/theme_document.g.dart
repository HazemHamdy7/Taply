// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_document.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeDocumentImpl _$$ThemeDocumentImplFromJson(Map<String, dynamic> json) =>
    _$ThemeDocumentImpl(
      metadata:
          ThemeMetadata.fromJson(json['metadata'] as Map<String, dynamic>),
      canvas: json['canvas'] == null
          ? const ThemeCanvas()
          : ThemeCanvas.fromJson(json['canvas'] as Map<String, dynamic>),
      variables: json['variables'] == null
          ? const ThemeVariables()
          : ThemeVariables.fromJson(json['variables'] as Map<String, dynamic>),
      assets: json['assets'] == null
          ? const ThemeAssets()
          : ThemeAssets.fromJson(json['assets'] as Map<String, dynamic>),
      scene: json['scene'] == null
          ? const ThemeScene()
          : ThemeScene.fromJson(json['scene'] as Map<String, dynamic>),
      components: json['components'] == null
          ? const ThemeComponents()
          : ThemeComponents.fromJson(
              json['components'] as Map<String, dynamic>),
      animations: (json['animations'] as List<dynamic>?)
              ?.map((e) => ThemeAnimation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      states: (json['states'] as List<dynamic>?)
              ?.map((e) => ThemeState.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ThemeDocumentImplToJson(_$ThemeDocumentImpl instance) =>
    <String, dynamic>{
      'metadata': instance.metadata,
      'canvas': instance.canvas,
      'variables': instance.variables,
      'assets': instance.assets,
      'scene': instance.scene,
      'components': instance.components,
      'animations': instance.animations,
      'states': instance.states,
    };
