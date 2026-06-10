// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_variables.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$VariableDefinitionImpl _$$VariableDefinitionImplFromJson(
        Map<String, dynamic> json) =>
    _$VariableDefinitionImpl(
      name: json['name'] as String,
      value: json['value'],
      type: json['type'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$VariableDefinitionImplToJson(
        _$VariableDefinitionImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'value': instance.value,
      'type': instance.type,
      'description': instance.description,
    };

_$ThemeVariablesImpl _$$ThemeVariablesImplFromJson(Map<String, dynamic> json) =>
    _$ThemeVariablesImpl(
      colors: json['colors'] == null
          ? const ColorPalette()
          : ColorPalette.fromJson(json['colors'] as Map<String, dynamic>),
      typography: json['typography'] == null
          ? const TypographySet()
          : TypographySet.fromJson(json['typography'] as Map<String, dynamic>),
      spacing: json['spacing'] == null
          ? const SpacingSet()
          : SpacingSet.fromJson(json['spacing'] as Map<String, dynamic>),
      radius: json['radius'] == null
          ? const RadiusSet()
          : RadiusSet.fromJson(json['radius'] as Map<String, dynamic>),
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      shadows: (json['shadows'] as List<dynamic>?)
              ?.map((e) => ShadowDefinition.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      animations: (json['animations'] as List<dynamic>?)
              ?.map((e) => ThemeAnimation.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      custom: (json['custom'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(
                k, VariableDefinition.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ThemeVariablesImplToJson(
        _$ThemeVariablesImpl instance) =>
    <String, dynamic>{
      'colors': instance.colors,
      'typography': instance.typography,
      'spacing': instance.spacing,
      'radius': instance.radius,
      'opacity': instance.opacity,
      'shadows': instance.shadows,
      'animations': instance.animations,
      'custom': instance.custom,
    };
