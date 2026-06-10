import 'package:freezed_annotation/freezed_annotation.dart';

part 'shadow_definition.freezed.dart';
part 'shadow_definition.g.dart';

@freezed
class ShadowDefinition with _$ShadowDefinition {
  const factory ShadowDefinition({
    @Default('#000000') String color,
    @Default(0) double offsetX,
    @Default(0) double offsetY,
    @Default(4.0) double blurRadius,
    @Default(1.0) double spreadRadius,
    @Default(0.3) double opacity,
  }) = _ShadowDefinition;

  factory ShadowDefinition.fromJson(Map<String, dynamic> json) =>
      _$ShadowDefinitionFromJson(json);

}