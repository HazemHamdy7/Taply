import 'package:freezed_annotation/freezed_annotation.dart';

part 'transform.freezed.dart';
part 'transform.g.dart';

@freezed
class Transform with _$Transform {
  const factory Transform({
    @Default(0) double x,
    @Default(0) double y,
    @Default(0) double rotation,
    @Default(1.0) double scaleX,
    @Default(1.0) double scaleY,
    @Default(0) double skewX,
    @Default(0) double skewY,
  }) = _Transform;

  factory Transform.fromJson(Map<String, dynamic> json) =>
      _$TransformFromJson(json);

}