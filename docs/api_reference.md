# Taply Theme SDK — Public API Reference

## Package: `taply_theme_engine`

### ThemeEngine

The central facade for the theme engine.

```dart
class ThemeEngine
```

| Method | Description |
|--------|-------------|
| `loadTheme(String json)` | Load a theme from a JSON string |
| `loadThemeFromMap(Map<String, dynamic> json)` | Load a theme from a decoded map |
| `render(ThemeDocument, PaintMetrics, Canvas, {double viewportWidth, double viewportHeight})` | Render a theme and return a `RenderReport` |
| `registerPainter(BasePainter)` | Register a custom painter |
| `registerLoader(ThemeLoader)` | Register a theme loader |
| `createMetrics()` | Create a `PaintMetrics` accumulator |
| `dispose()` | Release resources |

### BasePainter

Abstract base class for custom painters.

```dart
abstract class BasePainter
```

| Property | Description |
|----------|-------------|
| `type` | Unique type identifier |
| `capabilities` | `PaintCapabilities` level |

| Method | Description |
|--------|-------------|
| `canPaint(RenderPaintNode)` | Whether the painter can handle the node |
| `initialize()` | Called once before first use |
| `prepare(PaintContext)` | Prepare for a specific context |
| `paint(PaintContext)` | Execute paint, returns `PaintResult` |
| `dispose()` | Release resources |

### PaintResult

```dart
class PaintResult
```

| Property | Description |
|----------|-------------|
| `success` | Whether the paint succeeded |
| `duration` | Paint duration |
| `warnings` | List of warning messages |
| `diagnostics` | List of diagnostic messages |
| `paintBounds` | Bounds of the painted area |

### PaintMetrics

```dart
class PaintMetrics
```

| Property | Description |
|----------|-------------|
| `paintedNodes` | Number of painted nodes |
| `skippedNodes` | Number of skipped nodes |
| `failedNodes` | Number of failed nodes |
| `recoveredNodes` | Number of recovered nodes |
| `paintTime` | Total paint duration |
| `warnings` | List of warnings |

| Method | Description |
|--------|-------------|
| `recordPaint(Duration, {String? elementType, Rect? bounds})` | Record a successful paint |
| `recordSkip()` | Record a skipped node |
| `recordFailure()` | Record a failed node |
| `recordRecovery()` | Record a recovered node |
| `addWarning(String)` | Add a warning |
| `reset()` | Reset all metrics |

### RenderReport

```dart
class RenderReport
```

| Property | Description |
|----------|-------------|
| `totalNodes` | Total nodes processed |
| `paintedNodes` | Nodes successfully painted |
| `recoveredNodes` | Nodes recovered from errors |
| `failedNodes` | Nodes that failed |
| `compatibilityScore` | Score percentage (0–100) |

### ThemeDocument

```dart
class ThemeDocument
```

| Property | Description |
|----------|-------------|
| `metadata` | `ThemeMetadata` |
| `canvas` | `ThemeCanvas` |

### PaintCapabilities

```dart
enum PaintCapabilities { basic, advanced, full }
```

### PaintException

```dart
class PaintException implements Exception
```

| Property | Description |
|----------|-------------|
| `message` | Error message |
| `type` | Optional error type |
| `nodeId` | Optional node identifier |

### ThemeLoader

```dart
abstract class ThemeLoader
```

| Method | Description |
|--------|-------------|
| `load(String themeId)` | Load theme JSON by ID |
| `listThemes()` | List available theme IDs |
| `supports(String themeId)` | Whether this loader handles the ID |

### ThemeParser

```dart
class ThemeParser
```

| Method | Description |
|--------|-------------|
| `parseString(String json)` | Parse a JSON string |
| `parse(Map<String, dynamic> json)` | Parse a decoded map |

### ThemeRegistry

```dart
class ThemeRegistry
```

| Method | Description |
|--------|-------------|
| `registerPainter(String, BasePainter)` | Register a painter |
| `registerLoader(ThemeLoader)` | Register a loader |
| `registerPlugin(void Function())` | Register a plugin initializer |

### RenderNode

```dart
class RenderNode
```

| Property | Description |
|----------|-------------|
| `id` | Unique node ID |
| `name` | Optional name |
| `visible` | Visibility flag |
| `opacity` | Opacity (0.0–1.0) |

### RenderPaintNode

```dart
class RenderPaintNode extends RenderNode
```

| Property | Description |
|----------|-------------|
| `type` | Painter type |
| `zIndex` | Z-order |
| `x`, `y`, `width`, `height` | Position and size |
| `rotation` | Rotation in degrees |
| `scaleX`, `scaleY` | Scale factors |
| `color` | Fill color |
| `gradient` | Gradient definition |
| `strokeWidth` | Stroke width |
| `strokeColor` | Stroke color |
| `shadows` | Shadow definitions |

### RenderWidgetNode

```dart
class RenderWidgetNode extends RenderNode
```

| Property | Description |
|----------|-------------|
| `type` | Widget type |
| `zIndex` | Z-order |
| `x`, `y`, `width`, `height` | Position and size |
| `field` | Data field key |
| `fontSize`, `color`, `fontWeight` | Text styling |

### RenderGroup

```dart
class RenderGroup extends RenderNode
```

| Property | Description |
|----------|-------------|
| `children` | Child `RenderNode` list |

### PaintContext

```dart
class PaintContext
```

| Property | Description |
|----------|-------------|
| `canvas` | The `Canvas` to paint on |
| `viewport` | Viewport rectangle |
| `opacity` | Current opacity |
| `themeData` | Theme data map |
| `bindings` | Runtime bindings |

---

## Package: `taply_theme_runtime`

### BusinessCardData

```dart
class BusinessCardData
```

| Property | Description |
|----------|-------------|
| `name`, `title`, `company`, `email`, `phone`, `website`, `address`, `avatarUrl` | Standard fields |
| `custom` | Custom field map |

### CardRuntime

```dart
class CardRuntime
```

| Method | Description |
|--------|-------------|
| `initialize()` | Load data and transition to ready state |
| `resolveField(String)` | Resolve a field value |
| `evaluateExpression(String)` | Evaluate an expression with `{{field}}` placeholders |
| `updateData(BusinessCardData)` | Update card data |
| `refresh()` | Reload from data provider |
| `dispose()` | Release resources |

### DataProvider

```dart
abstract class DataProvider
```

| Method | Description |
|--------|-------------|
| `load()` | Load `BusinessCardData` |
| `save(BusinessCardData)` | Persist card data |
| `addListener(Function)` | Subscribe to changes |
| `removeListener(Function)` | Unsubscribe from changes |

### FieldResolver

```dart
class FieldResolver
```

| Method | Description |
|--------|-------------|
| `registerBinding(FieldBinding)` | Register a field binding |
| `resolve(String, BusinessCardData, CardRuntime)` | Resolve a field value |

### ExpressionResolver

```dart
class ExpressionResolver
```

| Method | Description |
|--------|-------------|
| `evaluate(String, CardRuntime)` | Evaluate expressions |
| `hasPlaceholders(String)` | Check for placeholders |

### FieldValidator

```dart
class FieldValidator
```

| Factory | Description |
|---------|-------------|
| `email` | Validates email format |
| `phone` | Validates phone format |
| `url` | Validates URL format |
| `nonEmpty` | Validates non-empty |
| `minLength(int)` | Minimum length |
| `maxLength(int)` | Maximum length |
| `regex(String)` | Custom regex |

### CardState

```dart
enum CardState { idle, loading, ready, disposed }
```

---

## Package: `taply_theme_widgets`

### CardEngineWidget

```dart
class CardEngineWidget extends StatelessWidget
```

| Property | Description |
|----------|-------------|
| `engine` | `ThemeEngine` instance |
| `document` | `ThemeDocument` to render |
| `metrics` | `PaintMetrics` accumulator |
| `width`, `height` | Widget dimensions |

### BusinessCardWidget

```dart
class BusinessCardWidget extends StatefulWidget
```

| Property | Description |
|----------|-------------|
| `engine` | `ThemeEngine` instance |
| `document` | `ThemeDocument` to render |
| `runtime` | `CardRuntime` with data |
| `width`, `height` | Widget dimensions |

### CardScreenshotService

```dart
class CardScreenshotService
```

| Method | Description |
|--------|-------------|
| `renderToImage(ThemeDocument, {double width, double height, double pixelRatio})` | Render to raw RGBA bytes |

### WidgetRegistry

```dart
class WidgetRegistry
```

| Method | Description |
|--------|-------------|
| `registerWidgetBuilder(String, Function(RenderPaintNode, ThemeEngine))` | Register a custom widget builder |
| `buildWidget(RenderPaintNode, ThemeEngine)` | Build widget for a node |

### PaintPreviewWidget

```dart
class PaintPreviewWidget extends StatelessWidget
```

Shows a simple preview with paint metrics overlay.
