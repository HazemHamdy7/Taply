import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_palette.freezed.dart';
part 'color_palette.g.dart';

@freezed
class ColorSwatch with _$ColorSwatch {
  const factory ColorSwatch({
    required String id,
    required String color,
    String? label,
  }) = _ColorSwatch;

  factory ColorSwatch.fromJson(Map<String, dynamic> json) =>
      _$ColorSwatchFromJson(json);

}

@freezed
class ColorPalette with _$ColorPalette {
  const factory ColorPalette({
    @Default([]) List<ColorSwatch> swatches,
    String? blendMode,
  }) = _ColorPalette;

  factory ColorPalette.fromJson(Map<String, dynamic> json) =>
      _$ColorPaletteFromJson(json);

}