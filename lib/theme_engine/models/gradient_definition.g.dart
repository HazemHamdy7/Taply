// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gradient_definition.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GradientDefinitionImpl _$$GradientDefinitionImplFromJson(
        Map<String, dynamic> json) =>
    _$GradientDefinitionImpl(
      kind: json['kind'] as String? ?? 'linear',
      colors: (json['colors'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      angle: (json['angle'] as num?)?.toDouble() ?? 0,
      stops: (json['stops'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList(),
      focalX: (json['focalX'] as num?)?.toDouble() ?? 0,
      focalY: (json['focalY'] as num?)?.toDouble() ?? 0,
      radius: (json['radius'] as num?)?.toDouble() ?? 1.0,
    );

Map<String, dynamic> _$$GradientDefinitionImplToJson(
        _$GradientDefinitionImpl instance) =>
    <String, dynamic>{
      'kind': instance.kind,
      'colors': instance.colors,
      'angle': instance.angle,
      'stops': instance.stops,
      'focalX': instance.focalX,
      'focalY': instance.focalY,
      'radius': instance.radius,
    };
