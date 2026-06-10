import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_animation.freezed.dart';
part 'theme_animation.g.dart';

@JsonEnum()
enum AnimationType {
  @JsonValue('tween')
  tween,
  @JsonValue('spring')
  spring,
  @JsonValue('keyframe')
  keyframe,
  @JsonValue('sequence')
  sequence,
  @JsonValue('parallel')
  parallel,
  @JsonValue('loop')
  loop,
}

@freezed
class ThemeAnimation with _$ThemeAnimation {
  const factory ThemeAnimation({
    required String id,
    required AnimationType type,
    @Default(300) int durationMs,
    int? delayMs,
    double? from,
    double? to,
    @Default('easeInOut') String easing,
    @Default(1) int repeatCount,
    bool? autoReverse,
  }) = _ThemeAnimation;

  factory ThemeAnimation.fromJson(Map<String, dynamic> json) =>
      _$ThemeAnimationFromJson(json);

}