/// Central constants for the Taply Theme Engine V2.
class ThemeConstants {
  ThemeConstants._();

  /// Current theme specification version.
  static const String specVersion = '2.0.0';

  /// Default design canvas width in logical pixels.
  static const double defaultCanvasWidth = 1000;

  /// Default design canvas height in logical pixels.
  static const double defaultCanvasHeight = 600;

  /// Default corner radius when none is specified.
  static const double defaultCornerRadius = 0;

  /// Minimum supported theme file version.
  static const String minSupportedVersion = '2.0.0';

  /// Registry type constants.
  static const String registryTypePaint = 'paint';
  static const String registryTypeWidget = 'widget';
  static const String registryTypeComponent = 'component';
  static const String registryTypeEffect = 'effect';

  /// Maximum variable nesting depth during resolution.
  static const int maxVariableNestingDepth = 10;

  /// Default cache TTL in seconds.
  static const int defaultCacheTtlSeconds = 300;

  /// Maximum number of cached themes.
  static const int maxCachedThemes = 20;

  /// Maximum asset size in bytes (10 MB).
  static const int maxAssetSizeBytes = 10 * 1024 * 1024;

  /// Supported asset file extensions.
  static const List<String> supportedImageExtensions = [
    '.png',
    '.jpg',
    '.jpeg',
    '.webp',
    '.svg',
  ];

  static const List<String> supportedFontExtensions = [
    '.ttf',
    '.otf',
    '.woff',
    '.woff2',
  ];
}
