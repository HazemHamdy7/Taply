# Migration Guide

## Upgrading to Taply Theme SDK v1.0

### Overview

The Taply Theme SDK v1.0 replaces direct usage of the internal theme engine with a stable public API surface across three packages:

- `taply_theme_engine` — public facade over the hardened rendering engine
- `taply_theme_runtime` — data binding and card runtime
- `taply_theme_widgets` — Flutter UI widgets

### Breaking Changes

#### Package Structure

| Before | After |
|--------|-------|
| Direct `theme_engine` imports | `package:taply_theme_engine/taply_theme_engine.dart` |
| Direct `paint_engine` imports | `package:taply_theme_engine/taply_theme_engine.dart` |
| Runtime code in app | `package:taply_theme_runtime/taply_theme_runtime.dart` |
| Widget code in app | `package:taply_theme_widgets/taply_theme_widgets.dart` |

#### Deprecated Classes

| Old (Internal) | New (Public) |
|----------------|--------------|
| `PaintEngine` (internal) | `ThemeEngine` (public) |
| Direct `Canvas` painting | `CardEngineWidget` wrapper |
| Manual metrics tracking | `PaintMetrics` accumulator via `engine.createMetrics()` |

### Migration Steps

#### Step 1: Update pubspec.yaml

Remove any direct theme engine source imports. Add the new packages:

```yaml
dependencies:
  taply_theme_engine: ^1.0.0
  taply_theme_runtime: ^1.0.0
  taply_theme_widgets: ^1.0.0
```

#### Step 2: Replace engine instantiation

**Before:**
```dart
import 'theme_engine/paint_engine/engine.dart';
final engine = PaintEngine();
```

**After:**
```dart
import 'package:taply_theme_engine/taply_theme_engine.dart';
final engine = ThemeEngine();
```

#### Step 3: Replace render calls

**Before:**
```dart
final metrics = PaintMetrics();
engine.renderTree(renderTree, canvas, metrics);
```

**After:**
```dart
final metrics = engine.createMetrics();
final report = engine.render(theme, metrics, canvas,
    viewportWidth: 600, viewportHeight: 400);
```

#### Step 4: Update widget usage

**Before:**
```dart
CustomPaint(
  painter: MyDirectPainter(engine, renderTree),
)
```

**After:**
```dart
CardEngineWidget(
  engine: engine,
  document: theme,
  metrics: metrics,
)
```

### Compatibility Notes

- The underlying rendering engine remains unchanged (v1.0, frozen).
- All existing themes and templates continue to work.
- The SDK provides a 100% compatibility scoring layer via `RenderReport.compatibilityScore`.
- Custom painters need only extend `BasePainter` (instead of implementing an internal interface).

### Rollback

The existing `lib/theme_engine/` internal code is preserved. To roll back:

1. Remove the three `taply_theme_*` package dependencies
2. Revert to direct `theme_engine` imports
3. Use the previous `PaintEngine` API

### Questions

Refer to the [Quick Start Guide](quick_start_guide.md) or [Public API Reference](api_reference.md) for detailed documentation.
