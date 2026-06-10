// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_canvas.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeCanvasImpl _$$ThemeCanvasImplFromJson(Map<String, dynamic> json) =>
    _$ThemeCanvasImpl(
      width: (json['width'] as num?)?.toDouble() ?? 1000,
      height: (json['height'] as num?)?.toDouble() ?? 600,
      cornerRadius: (json['cornerRadius'] as num?)?.toDouble() ?? 0,
      layoutMode:
          $enumDecodeNullable(_$LayoutModeEnumMap, json['layoutMode']) ??
              LayoutMode.centered,
    );

Map<String, dynamic> _$$ThemeCanvasImplToJson(_$ThemeCanvasImpl instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'cornerRadius': instance.cornerRadius,
      'layoutMode': _$LayoutModeEnumMap[instance.layoutMode]!,
    };

const _$LayoutModeEnumMap = {
  LayoutMode.centered: 'centered',
  LayoutMode.fill: 'fill',
  LayoutMode.stretch: 'stretch',
  LayoutMode.fit: 'fit',
  LayoutMode.fillAllEdges: 'fillAllEdges',
};
