import 'package:meta/meta.dart';
import 'theme_metadata.dart';
import 'theme_scene.dart';
import 'theme_variables.dart';
import 'theme_components.dart';
import 'color_palette.dart';
import 'typography_set.dart';
import 'breakpoint_set.dart';
import 'animation_definition.dart';
import 'theme_states.dart';

/// The root model for a complete Taply Theme document.
///
/// A [ThemeDocument] aggregates all aspects of a theme: metadata, scenes,
/// variables, components, palette, typography, breakpoints, animations,
/// and states.
@immutable
class ThemeDocument {
  /// The theme metadata.
  final ThemeMetadata metadata;

  /// The scenes composing this theme.
  final List<ThemeScene> scenes;

  /// The variable definitions.
  final ThemeVariables variables;

  /// The component schemas.
  final ThemeComponents components;

  /// The color palette.
  final ColorPalette palette;

  /// The typography settings.
  final TypographySet typography;

  /// The responsive breakpoints.
  final BreakpointSet breakpoints;

  /// The animation definitions.
  final List<AnimationDefinition> animations;

  /// The state definitions.
  final List<ThemeState> states;

  /// Creates a [ThemeDocument].
  const ThemeDocument({
    required this.metadata,
    this.scenes = const [],
    this.variables = const ThemeVariables(),
    this.components = const ThemeComponents(),
    this.palette = const ColorPalette(),
    this.typography = const TypographySet(),
    this.breakpoints = const BreakpointSet(),
    this.animations = const [],
    this.states = const [],
  });

  /// Creates a [ThemeDocument] from a JSON map.
  factory ThemeDocument.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeDocument.fromJson');
  }

  /// Converts this document to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ThemeDocument.toJson');
  }
}
