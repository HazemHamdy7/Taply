import 'package:freezed_annotation/freezed_annotation.dart';
import 'scene_node.dart';

part 'theme_scene.freezed.dart';
part 'theme_scene.g.dart';

@freezed
class ThemeScene with _$ThemeScene {
  const factory ThemeScene({
    @Default('main') String id,
    String? label,
    @SceneNodeConverter() @Default([]) List<SceneNode> nodes,
  }) = _ThemeScene;

  factory ThemeScene.fromJson(Map<String, dynamic> json) =>
      _$ThemeSceneFromJson(json);
}
