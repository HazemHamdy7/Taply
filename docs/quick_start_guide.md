# Taply Theme Engine SDK — Quick Start Guide

## Installation

Add the following to your `pubspec.yaml`:

```yaml
dependencies:
  taply_theme_engine: ^1.0.0
  taply_theme_runtime: ^1.0.0
  taply_theme_widgets: ^1.0.0
```

For monorepo development, use path dependencies:

```yaml
dependencies:
  taply_theme_engine:
    path: packages/taply_theme_engine
  taply_theme_runtime:
    path: packages/taply_theme_runtime
  taply_theme_widgets:
    path: packages/taply_theme_widgets
```

Then run:

```bash
flutter pub get
```

## Basic Usage

### 1. Create the engine

```dart
import 'package:taply_theme_engine/taply_theme_engine.dart';
import 'package:taply_theme_widgets/taply_theme_widgets.dart';

final engine = ThemeEngine();
final metrics = engine.createMetrics();
```

### 2. Load a theme

```dart
final json = '''
{
  "id": "modern_theme",
  "name": "Modern Theme",
  "width": 600,
  "height": 400
}
''';

final theme = await engine.loadTheme(json);
```

### 3. Render with a widget

```dart
CardEngineWidget(
  engine: engine,
  document: theme,
  metrics: metrics,
  width: 600,
  height: 400,
)
```

### 4. Use with runtime data binding

```dart
import 'package:taply_theme_runtime/taply_theme_runtime.dart';

final runtime = CardRuntime(
  data: BusinessCardData(
    name: 'Jane Doe',
    title: 'Software Engineer',
    company: 'Taply',
    email: 'jane@example.com',
  ),
);

BusinessCardWidget(
  engine: engine,
  document: theme,
  runtime: runtime,
)
```

## Registering Custom Painters

```dart
class MyCustomPainter extends BasePainter {
  @override
  String get type => 'my_custom_type';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.basic;

  @override
  bool canPaint(RenderPaintNode node) => node.type == type;

  @override
  void initialize() {}

  @override
  void prepare(PaintContext context) {}

  @override
  PaintResult paint(PaintContext context) {
    // Your paint logic here
    return PaintResult(
      success: true,
      duration: Duration.zero,
    );
  }

  @override
  void dispose() {}
}

// Register with the engine
engine.registerPainter(MyCustomPainter());
```

## Capturing Screenshots

```dart
final screenshotService = CardScreenshotService(engine: engine);
final bytes = await screenshotService.renderToImage(
  theme,
  width: 600,
  height: 400,
  pixelRatio: 2.0,
);
```

## Package Overview

| Package | Purpose |
|---------|---------|
| `taply_theme_engine` | Core rendering engine, painters, theme loading |
| `taply_theme_runtime` | Data binding, field resolution, expression evaluation |
| `taply_theme_widgets` | Flutter widgets for rendering and screenshot capture |

## Next Steps

- Read the [Migration Guide](migration_guide.md) if upgrading from an earlier version
- See the [Public API Reference](api_reference.md) for detailed documentation
- Check the [examples](../examples/) directory for complete sample applications
