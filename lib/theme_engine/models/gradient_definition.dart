import 'package:freezed_annotation/freezed_annotation.dart';

part 'gradient_definition.freezed.dart';
part 'gradient_definition.g.dart';

@freezed
class GradientDefinition with _$GradientDefinition {
  const factory GradientDefinition({
    @Default('linear') String kind,
    @Default([]) List<String> colors,
    @Default(0) double angle,
    List<double>? stops,
    @Default(0) double focalX,
    @Default(0) double focalY,
    @Default(1.0) double radius,
  }) = _GradientDefinition;

  factory GradientDefinition.fromJson(Map<String, dynamic> json) =>
      _$GradientDefinitionFromJson(json);

}