import 'package:freezed_annotation/freezed_annotation.dart';
import 'theme_metadata.dart';
import 'theme_canvas.dart';
import 'theme_scene.dart';
import 'theme_variables.dart';
import 'theme_components.dart';
import 'theme_assets.dart';
import 'theme_animation.dart';
import 'theme_state.dart';

part 'theme_document.freezed.dart';
part 'theme_document.g.dart';

@freezed
class ThemeDocument with _$ThemeDocument {
  const factory ThemeDocument({
    required ThemeMetadata metadata,
    @Default(ThemeCanvas()) ThemeCanvas canvas,
    @Default(ThemeVariables()) ThemeVariables variables,
    @Default(ThemeAssets()) ThemeAssets assets,
    @Default(ThemeScene()) ThemeScene scene,
    @Default(ThemeComponents()) ThemeComponents components,
    @Default([]) List<ThemeAnimation> animations,
    @Default([]) List<ThemeState> states,
  }) = _ThemeDocument;

  factory ThemeDocument.fromJson(Map<String, dynamic> json) =>
      _$ThemeDocumentFromJson(json);
}
