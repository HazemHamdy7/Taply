// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'typography_set.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TextStyleDefImpl _$$TextStyleDefImplFromJson(Map<String, dynamic> json) =>
    _$TextStyleDefImpl(
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      fontWeight: json['fontWeight'] as String?,
      lineHeight: (json['lineHeight'] as num?)?.toDouble(),
      letterSpacing: (json['letterSpacing'] as num?)?.toDouble(),
      color: json['color'] as String?,
    );

Map<String, dynamic> _$$TextStyleDefImplToJson(_$TextStyleDefImpl instance) =>
    <String, dynamic>{
      'fontSize': instance.fontSize,
      'fontWeight': instance.fontWeight,
      'lineHeight': instance.lineHeight,
      'letterSpacing': instance.letterSpacing,
      'color': instance.color,
    };

_$TypographySetImpl _$$TypographySetImplFromJson(Map<String, dynamic> json) =>
    _$TypographySetImpl(
      primaryFontFamily: json['primaryFontFamily'] as String?,
      secondaryFontFamily: json['secondaryFontFamily'] as String?,
      styles: (json['styles'] as Map<String, dynamic>?)?.map(
            (k, e) =>
                MapEntry(k, TextStyleDef.fromJson(e as Map<String, dynamic>)),
          ) ??
          const {},
    );

Map<String, dynamic> _$$TypographySetImplToJson(_$TypographySetImpl instance) =>
    <String, dynamic>{
      'primaryFontFamily': instance.primaryFontFamily,
      'secondaryFontFamily': instance.secondaryFontFamily,
      'styles': instance.styles,
    };
