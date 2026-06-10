// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'radius_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RadiusSetImpl _$$RadiusSetImplFromJson(Map<String, dynamic> json) =>
    _$RadiusSetImpl(
      none: json['none'] as String? ?? '0',
      sm: json['sm'] as String? ?? '4.0',
      md: json['md'] as String? ?? '8.0',
      lg: json['lg'] as String? ?? '12.0',
      xl: json['xl'] as String? ?? '16.0',
      full: json['full'] as String? ?? '9999',
      custom: (json['custom'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$RadiusSetImplToJson(_$RadiusSetImpl instance) =>
    <String, dynamic>{
      'none': instance.none,
      'sm': instance.sm,
      'md': instance.md,
      'lg': instance.lg,
      'xl': instance.xl,
      'full': instance.full,
      'custom': instance.custom,
    };
