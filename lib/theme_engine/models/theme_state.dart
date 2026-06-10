import 'package:freezed_annotation/freezed_annotation.dart';
import 'scene_node.dart';

part 'theme_state.freezed.dart';
part 'theme_state.g.dart';

@freezed
class ThemeState with _$ThemeState {
  const factory ThemeState({
    required String id,
    String? label,
    @SceneNodeConverter() @Default([]) List<SceneNode> nodes,
  }) = _ThemeState;

  factory ThemeState.fromJson(Map<String, dynamic> json) =>
      _$ThemeStateFromJson(json);
}
