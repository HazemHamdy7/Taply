// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_palette.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ColorSwatchImpl _$$ColorSwatchImplFromJson(Map<String, dynamic> json) =>
    _$ColorSwatchImpl(
      id: json['id'] as String,
      color: json['color'] as String,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$$ColorSwatchImplToJson(_$ColorSwatchImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'color': instance.color,
      'label': instance.label,
    };

_$ColorPaletteImpl _$$ColorPaletteImplFromJson(Map<String, dynamic> json) =>
    _$ColorPaletteImpl(
      swatches: (json['swatches'] as List<dynamic>?)
              ?.map((e) => ColorSwatch.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      blendMode: json['blendMode'] as String?,
    );

Map<String, dynamic> _$$ColorPaletteImplToJson(_$ColorPaletteImpl instance) =>
    <String, dynamic>{
      'swatches': instance.swatches,
      'blendMode': instance.blendMode,
    };
