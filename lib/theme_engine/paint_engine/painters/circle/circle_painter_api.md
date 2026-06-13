# CirclePainter API Documentation

## UML Class Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                    BasePainter (abstract)                    │
│  ┌──────────────────────────────────────────────────────┐   │
│  │  + type: String                                      │   │
│  │  + capabilities: PaintCapabilities                   │   │
│  │  + canPaint(node): bool                              │   │
│  │  + initialize(): void                                │   │
│  │  + prepare(context): void                            │   │
│  │  + paint(context): PaintResult                       │   │
│  │  + dispose(): void                                   │   │
│  └──────────────────────────┬───────────────────────────┘   │
│                             │                                 │
│  ┌──────────────────────────▼───────────────────────────┐   │
│  │                    CirclePainter                      │   │
│  │  ┌─────────────────────────────────────────────────┐ │   │
│  │  │ - _metrics: CirclePaintMetrics                   │ │   │
│  │  │ - _diagnostics: CirclePainterDiagnostics         │ │   │
│  │  │ - _fillPaint: Paint                              │ │   │
│  │  │ - _strokePaint: Paint                            │ │   │
│  │  │ - _shadowPaint: Paint                            │ │   │
│  │  │ - _debugPaint: Paint                             │ │   │
│  │  │ - _lastOptions: CirclePaintOptions?              │ │   │
│  │  ├──────────────────────────────────────────────────┤ │   │
│  │  │ + metrics: CirclePaintMetrics                    │ │   │
│  │  │ + diagnostics: CirclePainterDiagnostics          │ │   │
│  │  │ + type: 'circle'                                 │ │   │
│  │  │ + capabilities: PaintCapabilities.advanced       │ │   │
│  │  │ + canPaint(node): bool                           │ │   │
│  │  │ + initialize(): void                             │ │   │
│  │  │ + prepare(context): void                         │ │   │
│  │  │ + paint(context): PaintResult                    │ │   │
│  │  │ + dispose(): void                                │ │   │
│  │  │ + cleanup(): void                                │ │   │
│  │  │ + toString(): String                             │ │   │
│  │  └──────────────────────────────────────────────────┘ │   │
│  └─────────────────────────────────────────────────────────┘   │
│                                                                  │
│  ┌──────────────────────────┐   ┌────────────────────────────┐  │
│  │    CirclePaintStyle      │   │    CirclePaintOptions      │  │
│  │  ┌────────────────────┐  │   │  ┌──────────────────────┐ │  │
│  │  │ + fillColor: Color?│  │   │  │ + cx: double          │ │  │
│  │  │ + strokeColor:     │  │   │  │ + cy: double          │ │  │
│  │  │   Color?           │  │   │  │ + radius: double      │ │  │
│  │  │ + strokeWidth:     │  │   │  │ + opacity: double     │ │  │
│  │  │   double           │  │   │  │ + rotation: double    │ │  │
│  │  │ + shadows:         │  │   │  │ + scaleX: double      │ │  │
│  │  │   List<PaintShadow>│  │   │  │ + scaleY: double      │ │  │
│  │  │ + blendMode:       │  │   │  │ + visible: bool       │ │  │
│  │  │   BlendMode        │  │   │  │ + debugPaint: bool    │ │  │
│  │  │ + antiAlias: bool  │  │   │  │ + hitTestBounds: Rect?│ │  │
│  │  ├────────────────────┤  │   │  │ + style:              │ │  │
│  │  │ + hasFill: bool    │  │   │  │   CirclePaintStyle    │ │  │
│  │  │ + hasStroke: bool  │  │   │  ├──────────────────────┤ │  │
│  │  │ + hasShadows: bool │  │   │  │ + computePaintBounds  │ │  │
│  │  │ + fromNode(node)   │  │   │  │   (): Rect            │ │  │
│  │  └────────────────────┘  │   │  │ + fromNode(node)      │ │  │
│  └──────────────────────────┘   │  └──────────────────────┘ │  │
│                                  └────────────────────────────┘  │
│                                                                  │
│  ┌──────────────────────────┐   ┌────────────────────────────┐  │
│  │  CirclePaintMetrics      │   │ CirclePainterDiagnostics   │  │
│  │  ┌────────────────────┐  │   │  ┌──────────────────────┐ │  │
│  │  │ + circlesPainted   │  │   │  │ + operations:        │ │  │
│  │  │ + strokedCircles   │  │   │  │   List<CanvasOp>     │ │  │
│  │  │ + shadowCount      │  │   │  │ + warnings:List<String>│ │
│  │  │ + cacheHits/Misses │  │   │  │ + skipped:List<String>│ │  │
│  │  │ + paintDuration    │  │   │  │ + errors:List<String> │ │  │
│  │  │ + totalArea        │  │   │  │ + memoryAllocations   │ │  │
│  │  ├────────────────────┤  │   │  ├──────────────────────┤ │  │
│  │  │ + averagePaintTimeMs│  │   │  │ + totalOperations   │ │  │
│  │  │ + copy()           │  │   │  │ + totalDuration      │ │  │
│  │  │ + reset()          │  │   │  │ + hasWarnings        │ │  │
│  │  │ + operator+()      │  │   │  │ + hasErrors          │ │  │
│  │  └────────────────────┘  │   │  │ + merge(other)       │ │  │
│  └──────────────────────────┘   │  │ + reset()            │ │  │
│                                  │  └──────────────────────┘ │  │
│                                  └────────────────────────────┘  │
└──────────────────────────────────────────────────────────────────┘
```

## Lifecycle Diagram

```
                    ┌──────────────┐
                    │ uninitialized │
                    └──────┬───────┘
                           │ initialize()
                    ┌──────▼───────┐
                    │  initialized │
                    └──────┬───────┘
                           │ prepare(context)
                    ┌──────▼───────┐
                    │   prepared   │
                    └──────┬───────┘
                           │ paint(context)
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ painting │ │ painted  │ │  error   │
        └──────────┘ └────┬─────┘ └──────────┘
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
        ┌──────────┐ ┌──────────┐ ┌──────────┐
        │ prepare  │ │ cleanup │ │ dispose  │
        │ (recycle)│ │         │ │          │
        └──────────┘ └────┬─────┘ └────┬─────┘
                           │            │
                           ▼            ▼
                    ┌──────────┐  ┌──────────┐
                    │initialized│  │ disposed │
                    └──────────┘  └──────────┘
```

States:
- **uninitialized**: Fresh instance, no state allocated.
- **initialized**: `initialize()` called. Metrics and diagnostics reset.
- **prepared**: `prepare(context)` called. Options parsed from render node.
- **painting**: Currently executing `paint()`. Canvas operations in flight.
- **painted**: Successfully painted. Results in metrics/diagnostics.
- **disposed**: `dispose()` called. Resources freed.

## Sequence Diagram — Paint Process

```
  Client          CirclePainter        CirclePaintOptions      Canvas
    │                    │                      │                │
    │   prepare(ctx)     │                      │                │
    │──────────────────► │                      │                │
    │                    │ fromNode(node)        │                │
    │                    │─────────────────────►│                │
    │                    │◄─────────────────────│                │
    │                    │ recordAllocation()                     │
    │                    │                      │                │
    │    paint(ctx)      │                      │                │
    │──────────────────► │                      │                │
    │                    │ canvas.save()                          │
    │                    │──────────────────────────────────────►│
    │                    │ _applyTransform()                      │
    │                    │   ├─ translate(cx, cy)                │
    │                    │   ├─ rotate(rotation)  (if !=0)       │
    │                    │   ├─ scale(sx, sy)     (if !=1)       │
    │                    │   └─ translate(-cx,-cy)               │
    │                    │──────────────────────────────────────►│
    │                    │ _drawShadows()                         │
    │                    │   for each shadow:                     │
    │                    │   ├─ translate(ox, oy)                │
    │                    │   ├─ drawCircle(shadow)               │
    │                    │   └─ restore()                        │
    │                    │──────────────────────────────────────►│
    │                    │ _drawFill()                            │
    │                    │   └─ drawCircle(fill)                 │
    │                    │──────────────────────────────────────►│
    │                    │ _drawStroke()                          │
    │                    │   └─ drawCircle(stroke) (if hasStroke)│
    │                    │──────────────────────────────────────►│
    │                    │ _drawDebug()  (if debugPaint)         │
    │                    │   ├─ drawCircle(debug)                │
    │                    │   ├─ drawRect(bounds)                 │
    │                    │   └─ drawRect(hitTest)  (if present)  │
    │                    │──────────────────────────────────────►│
    │                    │ canvas.restore()                      │
    │                    │──────────────────────────────────────►│
    │                    │ recordCircle/duration                  │
    │◄───────────────────│                      │                │
    │   PaintResult      │                      │                │
```

## Public API

### `CirclePainter`

| Member | Type | Description |
|--------|------|-------------|
| `metrics` | `CirclePaintMetrics` | Runtime statistics |
| `diagnostics` | `CirclePainterDiagnostics` | Operation tracing |
| `type` | `String` | Returns `'circle'` |
| `capabilities` | `PaintCapabilities` | Returns `PaintCapabilities.advanced` |
| `canPaint(node)` | `bool` | True when `node.type == 'circle'` |
| `initialize()` | `void` | Resets metrics/diagnostics |
| `prepare(context)` | `void` | Parses node into `CirclePaintOptions` |
| `paint(context)` | `PaintResult` | Paints circle; fills, strokes, shadows, debug |
| `cleanup()` | `void` | Clears last options, resets diagnostics |
| `dispose()` | `void` | Full cleanup of metrics and diagnostics |

### `CirclePaintStyle`

| Member | Type | Description |
|--------|------|-------------|
| `fillColor` | `Color?` | Fill color |
| `strokeColor` | `Color?` | Stroke color |
| `strokeWidth` | `double` | Stroke width in pixels |
| `shadows` | `List<PaintShadow>` | Shadow definitions |
| `blendMode` | `BlendMode` | Blend mode (default `srcOver`) |
| `antiAlias` | `bool` | Anti-aliasing flag |
| `hasFill` | `bool` | True when `fillColor` is not null |
| `hasStroke` | `bool` | True when `strokeWidth > 0` and `strokeColor` not null |
| `hasShadows` | `bool` | True when shadows list is not empty |
| `CirclePaintStyle.fromNode(node)` | factory | Parses from `RenderPaintNode` |

### `CirclePaintOptions`

| Member | Type | Description |
|--------|------|-------------|
| `cx` | `double` | Center X coordinate |
| `cy` | `double` | Center Y coordinate |
| `radius` | `double` | Circle radius |
| `opacity` | `double` | Global opacity (0.0–1.0) |
| `rotation` | `double` | Rotation in radians |
| `scaleX` | `double` | Horizontal scale factor |
| `scaleY` | `double` | Vertical scale factor |
| `visible` | `bool` | Visibility flag |
| `debugPaint` | `bool` | Draw debug overlays |
| `hitTestBounds` | `Rect?` | Custom hit test rectangle |
| `style` | `CirclePaintStyle` | Paint style |
| `computePaintBounds()` | `Rect` | Bounding box including stroke/shadows/transform |
| `CirclePaintOptions.fromNode(node)` | factory | Parses from `RenderPaintNode` |

### `CirclePaintMetrics`

| Member | Type | Description |
|--------|------|-------------|
| `circlesPainted` | `int` | Number of circles painted |
| `strokedCircles` | `int` | Number of stroked circles |
| `shadowCount` | `int` | Total shadows rendered |
| `cacheHits` | `int` | Cache hit count |
| `cacheMisses` | `int` | Cache miss count |
| `paintDuration` | `Duration` | Accumulated paint time |
| `totalArea` | `double` | Sum of circle areas (πr²) |
| `recordCircle(area)` | `void` | Increment circle counter, add area |
| `recordStroke()` | `void` | Increment stroke counter |
| `recordShadow()` | `void` | Increment shadow counter |
| `recordCacheHit/Miss()` | `void` | Update cache counters |
| `recordDuration(d)` | `void` | Add to paint duration |
| `reset()` | `void` | Zero all counters |
| `copy()` | `CirclePaintMetrics` | Independent clone |
| `operator+(other)` | `CirclePaintMetrics` | Merge metrics |
| `averagePaintTimeMs` | `double` | Average paint time in ms |

### `CirclePainterDiagnostics`

| Member | Type | Description |
|--------|------|-------------|
| `operations` | `List<CanvasOperation>` | Recorded canvas operations |
| `warnings` | `List<String>` | Warning messages |
| `skipped` | `List<String>` | Skipped paint reasons |
| `errors` | `List<String>` | Error messages |
| `memoryAllocations` | `int` | Allocation counter |
| `recordOperation(name)` | `void` | Log a canvas operation |
| `recordWarning(msg)` | `void` | Log a warning |
| `recordSkipped(reason)` | `void` | Log a skip |
| `recordError(msg)` | `void` | Log an error |
| `recordAllocation()` | `void` | Increment allocation counter |
| `reset()` | `void` | Clear all state |
| `merge(other)` | `void` | Merge another diagnostics instance |
| `totalOperations` | `int` | Number of operations |
| `totalDuration` | `Duration` | Sum of operation durations |
| `hasWarnings` | `bool` | True when warnings exist |
| `hasErrors` | `bool` | True when errors exist |

## Usage Guide

### Basic fill circle

```dart
final painter = CirclePainter();
painter.prepare(context);
final result = painter.paint(context);
if (result.success) {
  print('Circle painted in ${result.duration.inMicroseconds}us');
}
```

### Circle with stroke and shadow

```dart
final node = RenderPaintNode(
  id: 'my-circle', type: 'circle',
  x: 0, y: 0, width: 100, height: 100,
  color: '#FF0000',
  strokeWidth: 4, strokeColor: '#0000FF',
  shadows: [ShadowDefinition(color: '#000', offsetX: 4, offsetY: 4, blurRadius: 8)],
);
```

### Reading metrics after painting

```dart
print('Circles painted: ${painter.metrics.circlesPainted}');
print('Avg paint time: ${painter.metrics.averagePaintTimeMs}ms');
```

### Diagnostics for debugging

```dart
print('Operations: ${painter.diagnostics.operations.length}');
print('Errors: ${painter.diagnostics.errors}');
```

### Running the demo

```dart
final output = runCirclePainterDemo();
print(output);
```

## Supported Features

| Feature | Supported | Notes |
|---------|-----------|-------|
| Fill | ✅ | Solid color fill |
| Stroke | ✅ | Width + color via `CirclePaintStyle` |
| Opacity | ✅ | Per-element global alpha |
| Rotation | ✅ | Radians, transforms around center |
| Scale X/Y | ✅ | Independent horizontal/vertical scale |
| Shadows | ✅ | Multiple shadows, blur, offset, opacity |
| Debug Paint | ✅ | Renders bounds & hit-test overlays |
| Hit Test Bounds | ✅ | Custom rect for hit testing |
| Visible toggle | ✅ | Skips paint when `visible = false` |
| Blend Modes | ✅ | All `BlendMode` values supported |
| Anti-aliasing | ✅ | Enabled by default |
| Cache tracking | ✅ | Cache hit/miss counters in metrics |
| Diagnostics | ✅ | Full operation log with durations |

## Performance Notes

- **Paint object reuse**: `CirclePainter` maintains 4 `Paint` instances across frames to avoid allocation in the hot path.
- **Metrics overhead**: Recording metrics adds ~0.1–0.5µs per paint call.
- **Transform early-out**: When rotation=0 and scale=1 (identity transform), the transform block is skipped entirely.
- **Shadow cost**: Each shadow requires a `save()`/`restore()` pair and a `MaskFilter.blur()` allocation — shadows are the most expensive feature.
- **Memory**: The painter holds no heap allocations beyond the 4 Paint objects and the last parsed options. All temporary state is stack-local within `paint()`.
- **Thread safety**: Not thread-safe. Paint calls must be serialized on the Flutter UI thread.
- **Suggested optimizations for hot paths**:
  - Pre-compute `CirclePaintOptions` and cache them when the node tree is stable.
  - Batch multiple circles into a single `Canvas` save/restore scope.
  - Use `PictureRecorder` to cache frequently painted circles as display lists.
