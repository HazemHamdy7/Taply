import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_canvas.freezed.dart';
part 'theme_canvas.g.dart';

@JsonEnum()
enum LayoutMode {
  @JsonValue('centered')
  centered,
  @JsonValue('fill')
  fill,
  @JsonValue('stretch')
  stretch,
  @JsonValue('fit')
  fit,
  @JsonValue('fillAllEdges')
  fillAllEdges,
}

@freezed
class ThemeCanvas with _$ThemeCanvas {
  const factory ThemeCanvas({
    @Default(1000) double width,
    @Default(600) double height,
    @Default(0) double cornerRadius,
    @Default(LayoutMode.centered) LayoutMode layoutMode,
  }) = _ThemeCanvas;

  factory ThemeCanvas.fromJson(Map<String, dynamic> json) =>
      _$ThemeCanvasFromJson(json);

}