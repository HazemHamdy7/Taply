import 'engine_config.dart';
import 'asset_manager.dart';
import '../interfaces/theme_parser_interface.dart';
import '../interfaces/theme_loader_interface.dart';
import '../interfaces/cache_interface.dart';
import '../interfaces/variable_resolver_interface.dart';
import '../interfaces/scene_graph_interface.dart';
import '../interfaces/layout_engine_interface.dart';
import '../interfaces/theme_validator_interface.dart';
import '../services/theme_validator.dart';
import '../loader/theme_loader.dart';
import '../cache/theme_cache.dart';
import '../parser/theme_parser.dart';
import '../variables/variable_resolver.dart';

/// The main entry point for the Taply Theme Engine V2.
///
/// Orchestrates parsing, loading, caching, variable resolution, layout
/// computation, and rendering.
///
/// Inject all dependencies via the constructor. Scene graph and layout
/// engine must be provided externally to keep the core module free of
/// renderer/layout dependencies.
class ThemeEngine {
  /// The engine configuration.
  final EngineConfig config;

  /// The asset manager.
  final AssetManager assetManager;

  /// The theme parser.
  final IThemeParser parser;

  /// The theme loader.
  final IThemeLoader loader;

  /// The theme cache.
  final IThemeCache cache;

  /// The variable resolver.
  final IVariableResolver variableResolver;

  /// The theme validator.
  final IThemeValidator validator;

  /// The scene graph builder (injected externally).
  final ISceneGraph sceneGraph;

  /// The layout engine (injected externally).
  final ILayoutEngine layoutEngine;

  /// Creates a [ThemeEngine].
  ///
  /// Provide [sceneGraph] and [layoutEngine] for rendering support.
  ThemeEngine({
    EngineConfig? config,
    AssetManager? assetManager,
    IThemeParser? parser,
    IThemeLoader? loader,
    IThemeCache? cache,
    IVariableResolver? variableResolver,
    IThemeValidator? validator,
    required this.sceneGraph,
    required this.layoutEngine,
  })  : config = config ?? const EngineConfig(),
        assetManager = assetManager ?? AssetManager(),
        parser = parser ?? ThemeParser(),
        loader = loader ?? ThemeLoader(),
        cache = cache ?? ThemeCache(),
        variableResolver = variableResolver ?? VariableResolver(),
        validator = validator ?? ThemeValidator();

  bool _initialized = false;

  /// Initializes the engine. Must be called once before use.
  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
  }

  /// Returns whether the engine has been initialized.
  bool get isInitialized => _initialized;

  /// Disposes the engine and releases resources.
  Future<void> dispose() async {
    cache.clear();
    _initialized = false;
  }
}
