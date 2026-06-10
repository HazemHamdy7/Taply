// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spacing_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SpacingSetImpl _$$SpacingSetImplFromJson(Map<String, dynamic> json) =>
    _$SpacingSetImpl(
      xs: json['xs'] as String? ?? '8.0',
      sm: json['sm'] as String? ?? '12.0',
      md: json['md'] as String? ?? '16.0',
      lg: json['lg'] as String? ?? '24.0',
      xl: json['xl'] as String? ?? '32.0',
      custom: (json['custom'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$SpacingSetImplToJson(_$SpacingSetImpl instance) =>
    <String, dynamic>{
      'xs': instance.xs,
      'sm': instance.sm,
      'md': instance.md,
      'lg': instance.lg,
      'xl': instance.xl,
      'custom': instance.custom,
    };
