import 'package:meta/meta.dart';

/// Configuration for the Taply Theme Engine.
@immutable
class EngineConfig {
  /// Whether to enable caching of parsed themes.
  final bool enableCache;

  /// Whether to enable variable resolution.
  final bool enableVariables;

  /// Whether to enable asset validation on load.
  final bool enableAssetValidation;

  /// The maximum number of themes to cache.
  final int maxCachedThemes;

  /// The cache TTL in seconds.
  final int cacheTtlSeconds;

  /// Whether to enable verbose logging.
  final bool verboseLogging;

  /// Creates an [EngineConfig] with sensible defaults.
  const EngineConfig({
    this.enableCache = true,
    this.enableVariables = true,
    this.enableAssetValidation = true,
    this.maxCachedThemes = 20,
    this.cacheTtlSeconds = 300,
    this.verboseLogging = false,
  });
}
