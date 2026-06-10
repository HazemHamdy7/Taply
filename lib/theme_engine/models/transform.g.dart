// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transform.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransformImpl _$$TransformImplFromJson(Map<String, dynamic> json) =>
    _$TransformImpl(
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0,
      scaleX: (json['scaleX'] as num?)?.toDouble() ?? 1.0,
      scaleY: (json['scaleY'] as num?)?.toDouble() ?? 1.0,
      skewX: (json['skewX'] as num?)?.toDouble() ?? 0,
      skewY: (json['skewY'] as num?)?.toDouble() ?? 0,
    );

Map<String, dynamic> _$$TransformImplToJson(_$TransformImpl instance) =>
    <String, dynamic>{
      'x': instance.x,
      'y': instance.y,
      'rotation': instance.rotation,
      'scaleX': instance.scaleX,
      'scaleY': instance.scaleY,
      'skewX': instance.skewX,
      'skewY': instance.skewY,
    };
