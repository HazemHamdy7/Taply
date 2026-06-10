import 'package:meta/meta.dart';

/// Metadata describing a theme's identity, version, and categorization.
@immutable
class ThemeMetadata {
  /// The unique identifier for this theme.
  final String id;

  /// The human-readable name of the theme.
  final String name;

  /// The theme specification version.
  final String specVersion;

  /// The description of the theme.
  final String? description;

  /// The author or creator of the theme.
  final String? author;

  /// The theme version string.
  final String? themeVersion;

  /// Category tags for the theme (e.g., `"luxury"`, `"modern"`).
  final List<String> tags;

  /// The color scheme identifier (e.g., `"light"`, `"dark"`).
  final String? colorScheme;

  /// Creates [ThemeMetadata].
  const ThemeMetadata({
    required this.id,
    required this.name,
    required this.specVersion,
    this.description,
    this.author,
    this.themeVersion,
    this.tags = const [],
    this.colorScheme,
  });

  /// Creates [ThemeMetadata] from a JSON map.
  factory ThemeMetadata.fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('ThemeMetadata.fromJson');
  }

  /// Converts to a JSON map.
  Map<String, dynamic> toJson() {
    throw UnimplementedError('ThemeMetadata.toJson');
  }
}
