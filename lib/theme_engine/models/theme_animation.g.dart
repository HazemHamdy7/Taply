// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_animation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeAnimationImpl _$$ThemeAnimationImplFromJson(Map<String, dynamic> json) =>
    _$ThemeAnimationImpl(
      id: json['id'] as String,
      type: $enumDecode(_$AnimationTypeEnumMap, json['type']),
      durationMs: (json['durationMs'] as num?)?.toInt() ?? 300,
      delayMs: (json['delayMs'] as num?)?.toInt(),
      from: (json['from'] as num?)?.toDouble(),
      to: (json['to'] as num?)?.toDouble(),
      easing: json['easing'] as String? ?? 'easeInOut',
      repeatCount: (json['repeatCount'] as num?)?.toInt() ?? 1,
      autoReverse: json['autoReverse'] as bool?,
    );

Map<String, dynamic> _$$ThemeAnimationImplToJson(
        _$ThemeAnimationImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$AnimationTypeEnumMap[instance.type]!,
      'durationMs': instance.durationMs,
      'delayMs': instance.delayMs,
      'from': instance.from,
      'to': instance.to,
      'easing': instance.easing,
      'repeatCount': instance.repeatCount,
      'autoReverse': instance.autoReverse,
    };

const _$AnimationTypeEnumMap = {
  AnimationType.tween: 'tween',
  AnimationType.spring: 'spring',
  AnimationType.keyframe: 'keyframe',
  AnimationType.sequence: 'sequence',
  AnimationType.parallel: 'parallel',
  AnimationType.loop: 'loop',
};
