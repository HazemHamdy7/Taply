## Goal
- Implement production-ready immutable domain models for the Taply Theme Engine V2 using freezed + json_serializable, then perform an architecture refactor based on review feedback.

## Constraints & Preferences
- No rendering, painting, widgets, layout, effects, parser, loader, registry, or service logic — foundation only.
- All public classes, interfaces, abstract classes, services, registries, and exceptions must exist with Dart documentation and Clean Architecture structure.
- Follow SOLID, immutable design, barrel exports, dependency direction rules.
- No placeholder implementations — methods throw UnimplementedError().
- ThemeParser is the ONLY public parser; SceneParser, VariableParser, ComponentParser are internal.
- LayoutEngine moves from renderer/ to layout/ as an independent module.
- AssetManager moves to core/; FontProvider and ImageProvider stay in assets/.
- AnalyticsService removed; ExportService moves to export/.
- engine.dart public API exposes only 17 types (ThemeEngine, EngineConfig, AssetManager, ThemeLoader, ThemeParser, ThemeValidator, ThemeCache, VariableResolver, PaintRegistry, WidgetRegistry, ComponentRegistry, EffectRegistry, ThemeDocument, ThemeScene, SceneLayer, ThemeVariables, ThemeComponents, plus all exceptions and ExportService).
- No feature may depend on renderer; renderer depends on models; layout depends on models; variables depend on models; assets depend on core.
- Models use freezed, json_serializable, equatable; every model supports copyWith, ==, hashCode, toJson, fromJson, deep equality, validation, factory constructors, defaults, documentation.
- Every model exposes validate() returning ValidationResult (no exceptions for validation failures).
- ValidationResult is a single freezed class with isValid/errors/warnings (not a sealed union).
- Use freezed ^2.5.2 and json_serializable ^6.7.1 due to analyzer version constraints.
- Do NOT continue to parser implementation — stop after models are complete.
- validate() methods are implemented as PUBLIC extension methods on model types (not instance methods on the freezed class itself), because freezed 2.x generates `abstract class _X implements X` which forces any instance method to become abstract and need implementation in the generated subclass.

## Progress
### Done
- Architecture refactor: restricted parser exports to ThemeParser only; moved LayoutEngine to layout/; moved AssetManager to core/; deleted AnalyticsService; moved ExportService to export/; engine.dart exports only 17 public types; ThemeEngine no longer imports concrete SceneGraph/LayoutEngine (constructor injection instead); fixed all import paths.
- flutter analyze: 0 issues.
- Added freezed_annotation, json_annotation as dependencies; freezed, json_serializable as dev_dependencies (versions compatible with analyzer 6.4.1).
- Created 21 model files with freezed:
  - validation_result.dart (single class with isValid, errors, warnings)
  - layout_constraint.dart
  - transform.dart
  - shadow_definition.dart
  - gradient_definition.dart
  - breakpoint_set.dart
  - color_palette.dart (ColorSwatch + ColorPalette)
  - typography_set.dart (TextStyleDef + TypographySet)
  - theme_metadata.dart
  - theme_canvas.dart (includes LayoutMode enum with @JsonEnum)
  - theme_animation.dart (includes AnimationType enum with @JsonEnum)
  - paint_layer.dart
  - widget_layer.dart
  - scene_layer.dart
  - scene_group.dart
  - theme_scene.dart
  - theme_variables.dart (VariableDefinition + ThemeVariables)
  - theme_components.dart (ComponentProperty + ComponentSchema + ThemeComponents)
  - theme_assets.dart
  - theme_state.dart
  - theme_document.dart (root model, validates all children)
- Every model has validate() method as a public extension method returning ValidationResult with recursive child validation.
- Ran build_runner — all .freezed.dart and .g.dart generated successfully.
- Updated models.dart barrel, engine.dart exports, and fixed import paths.
- flutter analyze: 0 issues.

### In Progress
- (none)

### Blocked
- (none)

## Key Decisions
- Use a single freezed class for ValidationResult (isValid/errors/warnings fields) instead of a sealed union, because freezed unions don't share getters across union cases.
- validate() methods are PUBLIC extension methods (not instance methods) because freezed 2.x generates `abstract class _X implements X`. Instance methods on the freezed class become abstract and cannot be implemented by the generated subclass. Extension methods avoid this limitation completely.
- LayoutMode and AnimationType enums use @JsonEnum with explicit @JsonValue strings for stable serialization.
- ThemeEngine now requires sceneGraph and layoutEngine as constructor injection parameters (no concrete defaults) to keep core module free of renderer/layout dependencies.
- analyzer version 6.4.1 constrains freezed to ^2.5.2 (not latest 3.x) and json_serializable to ^6.7.1.
- SceneLayer contains optional PaintLayer and WidgetLayer (composition) rather than using freezed sealed union, allowing a layer to have both or neither.

## Next Steps
- Implement ThemeParser (parse JSON into the model tree).
- Loader implementations (bundle, file, network).
- VariableResolver resolution logic.
- PaintRegistry, WidgetRegistry, ComponentRegistry, EffectRegistry concrete registrations.
- ThemeValidator full validation logic.
- LayoutEngine computeLayout implementation.
- SceneGraph build/traverse/flatten logic.
- RenderPipeline paint dispatch.

## Critical Context
- ThemeDocument.validate() calls validate() on all 11 child models recursively, aggregating errors into a single ValidationResult.
- All models are in lib/theme_engine/models/ with freezed-generated part files in the same directory.
- The existing V1 template engine at lib/shared/template_engine/ is untouched; V2 models are separate and V1→V2 migration is a future task.
- engine.dart barrel exports only to individual model/parser/loader/registry files (not barrel files) to control what is public API.
- validate() uses public extensions (`extension XxxValidation on Xxx`) defined in the same file as each model, so the import of the model file automatically brings the validation method into scope.

## Relevant Files
- `lib/theme_engine/models/`: 21 model files + generated part files (.freezed.dart, .g.dart)
- `lib/theme_engine/engine.dart`: public API barrel (17 typed exports + exceptions + ExportService)
- `lib/theme_engine/layout/layout_engine.dart`: moved from renderer/
- `lib/theme_engine/core/asset_manager.dart`: moved from assets/
- `lib/theme_engine/export/export_service.dart`: moved from services/
- `lib/theme_engine/renderer/layout_engine.dart`: deleted (moved to layout/)
- `lib/theme_engine/services/analytics_service.dart`: deleted
- `lib/theme_engine/services/export_service.dart`: deleted (moved to export/)
- `pubspec.yaml`: freezed_annotation ^2.4.4, json_annotation ^4.9.0, freezed ^2.5.2, json_serializable ^6.7.1