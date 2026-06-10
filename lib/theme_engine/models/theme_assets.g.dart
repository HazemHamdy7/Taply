// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_assets.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeAssetsImpl _$$ThemeAssetsImplFromJson(Map<String, dynamic> json) =>
    _$ThemeAssetsImpl(
      fontFamily: json['fontFamily'] as String?,
      fontAsset: json['fontAsset'] as String?,
      backgroundImage: json['backgroundImage'] as String?,
      imageAssets: (json['imageAssets'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      assetMap: (json['assetMap'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as String),
          ) ??
          const {},
    );

Map<String, dynamic> _$$ThemeAssetsImplToJson(_$ThemeAssetsImpl instance) =>
    <String, dynamic>{
      'fontFamily': instance.fontFamily,
      'fontAsset': instance.fontAsset,
      'backgroundImage': instance.backgroundImage,
      'imageAssets': instance.imageAssets,
      'assetMap': instance.assetMap,
    };
