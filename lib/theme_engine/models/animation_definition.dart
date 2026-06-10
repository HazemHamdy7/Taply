import 'package:meta/meta.dart';

/// Describes the animation type used for transitions or effects.
enum AnimationType {
  /// Linear interpolation between start and end values.
  tween,

  /// Spring-based physics animation.
  spring,

  /// Animation driven by keyframes.
  keyframe,

  /// A sequence of animations run in order.
  sequence,

  /// Multiple animations running simultaneously.
  parallel,

  /// A looping animation.
  loop,
}

/// Animation definition associated with a layer or state transition.
///
/// This class is intentionally unimplemented. Animation logic will be
/// added in a future sprint.
@immutable
class AnimationDefinition {
  /// The type of animation.
  final AnimationType type;

  /// Duration in milliseconds.
  final int durationMs;

  /// Optional delay before the animation starts, in milliseconds.
  final int? delayMs;

  /// Creates an [AnimationDefinition].
  const AnimationDefinition({
    required this.type,
    required this.durationMs,
    this.delayMs,
  });

  /// Creates an [AnimationDefinition] from a JSON map.
  factory AnimationDefinition.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('AnimationDefinition.fromJson');
  }

  /// Converts this definition to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('AnimationDefinition.toJson');
  }
}
