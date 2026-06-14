/// Metadata associated with a theme document.
class ThemeMetadata {
  final String id;
  final String name;
  final String? description;
  final String? version;
  final String? author;

  const ThemeMetadata({
    required this.id,
    required this.name,
    this.description,
    this.version,
    this.author,
  });
}
