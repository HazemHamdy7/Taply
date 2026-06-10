import 'package:meta/meta.dart';

/// A component schema describing a reusable component that can be
/// instantiated multiple times within a theme.
@immutable
class ComponentSchema {
  /// The unique identifier for this component.
  final String id;

  /// Properties exposed by this component for customization.
  final Map<String, ComponentProperty> properties;

  /// Creates a [ComponentSchema].
  const ComponentSchema({
    required this.id,
    this.properties = const {},
  });

  /// Creates a [ComponentSchema] from a JSON map.
  factory ComponentSchema.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ComponentSchema.fromJson');
  }

  /// Converts this schema to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ComponentSchema.toJson');
  }
}

/// A property exposed by a component schema.
@immutable
class ComponentProperty {
  /// The data type of this property (e.g., `"string"`, `"color"`, `"number"`).
  final String type;

  /// The default value for this property.
  final dynamic defaultValue;

  /// An optional description of this property.
  final String? description;

  /// Creates a [ComponentProperty].
  const ComponentProperty({
    required this.type,
    this.defaultValue,
    this.description,
  });

  /// Creates a [ComponentProperty] from a JSON map.
  factory ComponentProperty.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ComponentProperty.fromJson');
  }

  /// Converts this property to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ComponentProperty.toJson');
  }
}

/// Reusable component definitions within a theme.
@immutable
class ThemeComponents {
  /// Component schemas keyed by identifier.
  final Map<String, ComponentSchema> schemas;

  /// Creates [ThemeComponents].
  const ThemeComponents({
    this.schemas = const {},
  });

  /// Creates [ThemeComponents] from a JSON map.
  factory ThemeComponents.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeComponents.fromJson');
  }

  /// Converts to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ThemeComponents.toJson');
  }
}
