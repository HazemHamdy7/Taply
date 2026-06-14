# Taply Theme SDK Architecture

## Overview

The Taply Theme SDK provides a stable public API for the hardened theme engine, organized into three packages:

```
┌─────────────────────────────────────────────────────────┐
│                    Application Layer                      │
├─────────────────────────────────────────────────────────┤
│                   taply_theme_widgets                     │
│             CardEngineWidget, BusinessCardWidget          │
│             CardScreenshotService, WidgetRegistry         │
├─────────────────────────────────────────────────────────┤
│                   taply_theme_runtime                     │
│         CardRuntime, BusinessCardData, DataProvider       │
│         FieldResolver, ExpressionResolver                 │
├─────────────────────────────────────────────────────────┤
│                   taply_theme_engine                      │
│       ThemeEngine, BasePainter, PaintMetrics, RenderReport│
│       ThemeLoader, ThemeParser, PaintContext              │
│       Models: ThemeDocument, RenderNode, RenderGroup      │
├─────────────────────────────────────────────────────────┤
│              ┌───────────────────────┐                    │
│              │  Hardened Engine      │  (internal, frozen)│
│              │  lib/theme_engine/    │                    │
│              └───────────────────────┘                    │
└─────────────────────────────────────────────────────────┘
```

## Package Dependency Diagram

```
taply_theme_engine   (no internal dependencies)
       │
       ▼
taply_theme_runtime  (depends on taply_theme_engine)
       │
       ▼
taply_theme_widgets  (depends on taply_theme_engine, taply_theme_runtime)
```

## Package Details

### taply_theme_engine (v1.0.0)

- **Purpose**: Core rendering engine public API
- **Dependencies**: Flutter (via `flutter` SDK)
- **Entry point**: `lib/taply_theme_engine.dart`
- **Source files**: ~15 files under `lib/src/`

**Key exports:**
- `ThemeEngine` — central facade
- `BasePainter` — abstract painter interface
- `PaintMetrics` — performance metrics accumulator
- `RenderReport` — diagnostic report per render pass
- `PaintResult` — single paint operation result
- `ThemeDocument` / `ThemeMetadata` / `ThemeCanvas` — theme models
- `RenderPaintNode` / `RenderWidgetNode` / `RenderGroup` — render tree nodes
- `PaintContext` — context passed to painters
- `ThemeLoader` / `ThemeParser` — loading/parsing interfaces
- `ThemeRegistry` — plugin/painter/loader registry

### taply_theme_runtime (v1.0.0)

- **Purpose**: Runtime data binding and card lifecycle
- **Dependencies**: `taply_theme_engine`
- **Entry point**: `lib/taply_theme_runtime.dart`
- **Source files**: ~10 files under `lib/src/`

**Key exports:**
- `CardRuntime` — lifecycle manager for a business card
- `BusinessCardData` — structured card data model
- `DataProvider` — interface for data sources
- `FieldResolver` / `FieldBinding` — field resolution
- `ExpressionResolver` — `{{field}}` expression evaluation
- `FieldValidator` — field validation utilities
- `DataContext` — runtime data snapshot

### taply_theme_widgets (v1.0.0)

- **Purpose**: Flutter widgets for rendering
- **Dependencies**: `taply_theme_engine`, `taply_theme_runtime`, Flutter
- **Entry point**: `lib/taply_theme_widgets.dart`
- **Source files**: ~6 files under `lib/src/`

**Key exports:**
- `CardEngineWidget` — core rendering widget
- `BusinessCardWidget` — full card with runtime binding
- `CardScreenshotService` — PNG/image capture service
- `PaintPreviewWidget` — simple preview with metrics
- `WidgetRegistry` — custom widget builder registry

## Versioning Strategy

| Component | Version | Status |
|-----------|---------|--------|
| Hardened Engine (internal) | 1.0.0 | Frozen, no further modifications |
| taply_theme_engine | 1.0.0 | Stable, semantic versioning |
| taply_theme_runtime | 1.0.0 | Stable, semantic versioning |
| taply_theme_widgets | 1.0.0 | Stable, semantic versioning |

### Semantic Versioning Policy

- **MAJOR**: Breaking changes to public API (removing/changing exports, changing method signatures)
- **MINOR**: New public API additions (new classes, methods, parameters) without breaking changes
- **PATCH**: Bug fixes, internal improvements, documentation changes

### Dependency Versioning

- `taply_theme_runtime` depends on `taply_theme_engine` with `^1.0.0` constraint
- `taply_theme_widgets` depends on both with `^1.0.0` constraints
- All three packages version-locked at MAJOR.MINOR level

## Plugin System

Custom painters and widgets can be registered with the engine:

```dart
// Register a custom painter
engine.registerPainter(MyCustomPainter());

// Register via ThemeRegistry
final registry = ThemeRegistry();
registry.registerPlugin(() {
  // Initialize custom components
});
```

## Backward Compatibility

- The hardened engine (lib/theme_engine/) is frozen at v1.0
- All existing themes and templates continue to render identically
- The `RenderReport.compatibilityScore` provides a 0–100% compatibility metric
- Recovery mode catches and logs rendering errors without crashing

## Performance

- PaintMetrics tracks: painted/skipped/failed/recovered nodes, timing, cache stats
- RenderReport provides: node counts, warnings, compatibility score
- Average paint time per node available via `PaintMetrics.averagePaintTimeMs`
