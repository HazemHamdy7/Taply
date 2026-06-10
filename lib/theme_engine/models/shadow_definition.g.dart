// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shadow_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShadowDefinitionImpl _$$ShadowDefinitionImplFromJson(
        Map<String, dynamic> json) =>
    _$ShadowDefinitionImpl(
      color: json['color'] as String? ?? '#000000',
      offsetX: (json['offsetX'] as num?)?.toDouble() ?? 0,
      offsetY: (json['offsetY'] as num?)?.toDouble() ?? 0,
      blurRadius: (json['blurRadius'] as num?)?.toDouble() ?? 4.0,
      spreadRadius: (json['spreadRadius'] as num?)?.toDouble() ?? 1.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 0.3,
    );

Map<String, dynamic> _$$ShadowDefinitionImplToJson(
        _$ShadowDefinitionImpl instance) =>
    <String, dynamic>{
      'color': instance.color,
      'offsetX': instance.offsetX,
      'offsetY': instance.offsetY,
      'blurRadius': instance.blurRadius,
      'spreadRadius': instance.spreadRadius,
      'opacity': instance.opacity,
    };
