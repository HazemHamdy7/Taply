import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_assets.freezed.dart';
part 'theme_assets.g.dart';

@freezed
class ThemeAssets with _$ThemeAssets {
  const factory ThemeAssets({
    String? fontFamily,
    String? fontAsset,
    String? backgroundImage,
    @Default([]) List<String> imageAssets,
    @Default({}) Map<String, String> assetMap,
  }) = _ThemeAssets;

  factory ThemeAssets.fromJson(Map<String, dynamic> json) =>
      _$ThemeAssetsFromJson(json);

}