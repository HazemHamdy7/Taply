import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_components.freezed.dart';
part 'theme_components.g.dart';

@freezed
class ComponentProperty with _$ComponentProperty {
  const factory ComponentProperty({
    required String type,
    dynamic defaultValue,
    String? description,
  }) = _ComponentProperty;

  factory ComponentProperty.fromJson(Map<String, dynamic> json) =>
      _$ComponentPropertyFromJson(json);

}

@freezed
class ComponentSchema with _$ComponentSchema {
  const factory ComponentSchema({
    required String id,
    @Default({}) Map<String, ComponentProperty> properties,
  }) = _ComponentSchema;

  factory ComponentSchema.fromJson(Map<String, dynamic> json) =>
      _$ComponentSchemaFromJson(json);

}

@freezed
class ThemeComponents with _$ThemeComponents {
  const factory ThemeComponents({
    @Default({}) Map<String, ComponentSchema> schemas,
  }) = _ThemeComponents;

  factory ThemeComponents.fromJson(Map<String, dynamic> json) =>
      _$ThemeComponentsFromJson(json);

}