import 'package:freezed_annotation/freezed_annotation.dart';
import 'color_palette.dart';
import 'typography_set.dart';
import 'spacing_set.dart';
import 'radius_set.dart';
import 'shadow_definition.dart';
import 'theme_animation.dart';

part 'theme_variables.freezed.dart';
part 'theme_variables.g.dart';

@freezed
class VariableDefinition with _$VariableDefinition {
  const factory VariableDefinition({
    required String name,
    dynamic value,
    String? type,
    String? description,
  }) = _VariableDefinition;

  factory VariableDefinition.fromJson(Map<String, dynamic> json) =>
      _$VariableDefinitionFromJson(json);
}

@freezed
class ThemeVariables with _$ThemeVariables {
  const factory ThemeVariables({
    @Default(ColorPalette()) ColorPalette colors,
    @Default(TypographySet()) TypographySet typography,
    @Default(SpacingSet()) SpacingSet spacing,
    @Default(RadiusSet()) RadiusSet radius,
    @Default(1.0) double opacity,
    @Default([]) List<ShadowDefinition> shadows,
    @Default([]) List<ThemeAnimation> animations,
    @Default({}) Map<String, VariableDefinition> custom,
  }) = _ThemeVariables;

  factory ThemeVariables.fromJson(Map<String, dynamic> json) =>
      _$ThemeVariablesFromJson(json);
}
