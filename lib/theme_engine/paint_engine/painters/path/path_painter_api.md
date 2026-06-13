# PathPainter API Reference

## UML Class Diagram

```
┌──────────────────┐       ┌────────────────────┐
│   BasePainter    │       │    PathCommand     │ (sealed)
├──────────────────┤       ├────────────────────┤
│ +type            │       │ +fromMap()         │
│ +capabilities    │       └────────┬───────────┘
│ +canPaint()      │                │
│ +initialize()    │      ┌─────────┼──────────────┐
│ +prepare()       │      │         │              │
│ +paint()         │      │         │              │
│ +dispose()       │      │         │              │
└────────┬─────────┘      │         │              │
         │                │         │              │
         │ extends        │         │              │
         │                │         │              │
┌────────┴────────┐       │         │              │
│   PathPainter   │       │         │              │
├─────────────────┤       │         │              │
│ -_metrics       │       │         │              │
│ -_diagnostics   │       │         │              │
│ -_fillPaint     │       │         │              │
│ -_strokePaint   │       │         │              │
│ -_shadowPaint   │       │         │              │
│ -_path          │       │         │              │
├─────────────────┤       │         │              │
│ +metrics        │       │         │              │
│ +diagnostics    │       │         │              │
│ +initialize()   │       │         │              │
│ +prepare()      │       │         │              │
│ +paint()        │       │         │              │
│ +cleanup()      │       │         │              │
│ +dispose()      │       │         │              │
└─────────────────┘       │         │              │
                          │         │              │
┌─────────────────────────┴┐ ┌──────┴────────────┐
│       PathMoveTo         │ │    PathLineTo     │
├──────────────────────────┤ ├───────────────────┤
│ +x: double               │ │ +x: double        │
│ +y: double               │ │ +y: double        │
└──────────────────────────┘ └───────────────────┘

┌─────────────────────────────┐ ┌───────────────────────────┐
│        PathCubicTo          │ │     PathQuadraticTo       │
├─────────────────────────────┤ ├───────────────────────────┤
│ +controlX1: double          │ │ +controlX: double         │
│ +controlY1: double          │ │ +controlY: double         │
│ +controlX2: double          │ │ +x: double                │
│ +controlY2: double          │ │ +y: double                │
│ +x: double                  │ └───────────────────────────┘
│ +y: double                  │
└─────────────────────────────┘
        ┌────────────┐
        │ PathClose  │
        └────────────┘

┌─────────────────────┐  ┌──────────────────────────┐
│   PathPaintStyle    │  │    PathPaintOptions       │
├─────────────────────┤  ├──────────────────────────┤
│ +fillColor          │  │ +commands                 │
│ +strokeColor        │  │ +opacity                  │
│ +strokeWidth        │  │ +rotation                 │
│ +strokeCap          │  │ +scaleX / +scaleY         │
│ +strokeJoin         │  │ +visible                  │
│ +shadows            │  │ +debugPaint               │
│ +blendMode          │  │ +hitTestBounds            │
│ +antiAlias          │  │ +style                    │
├─────────────────────┤  ├──────────────────────────┤
│ +hasFill            │  │ +computePaintBounds()     │
│ +hasStroke          │  │ +fromNode()               │
│ +hasShadows         │  └──────────────────────────┘
│ +fromNode()         │
└─────────────────────┘

┌──────────────────────┐  ┌────────────────────────────┐
│  PathPaintMetrics    │  │  PathPainterDiagnostics     │
├──────────────────────┤  ├────────────────────────────┤
│ +pathsPainted        │  │ +operations                │
│ +filledPaths         │  │ +warnings                  │
│ +strokedPaths        │  │ +skipped                   │
│ +segmentsDrawn       │  │ +errors                    │
│ +shadowCount         │  │ +memoryAllocations         │
│ +cacheHits           │  ├────────────────────────────┤
│ +cacheMisses         │  │ +recordOperation()         │
│ +paintDuration       │  │ +recordWarning()           │
├──────────────────────┤  │ +recordSkipped()           │
│ +reset()             │  │ +recordError()             │
│ +copy()              │  │ +recordAllocation()        │
│ +operator+           │  │ +merge()                   │
│ +averagePaintTimeMs  │  │ +totalOperations           │
└──────────────────────┘  │ +totalDuration             │
                          │ +hasWarnings / +hasErrors  │
                          └────────────────────────────┘
```

## Lifecycle Diagram

```
  ┌──────────┐
  │  create  │
  └────┬─────┘
       │
       ▼
  ┌──────────────┐
  │  initialize  │   ← resets metrics & diagnostics
  └──────┬───────┘
         │
         ▼
  ┌──────────────┐
  │   prepare    │   ← parses RenderPaintNode into PathPaintOptions
  └──────┬───────┘       records allocation
         │
         ▼
  ┌──────────────┐
  │    paint     │   ← builds path, applies transform,
  └──────┬───────┘       draws shadows, fill, stroke
         │
         ├──────────────────────────────────┐
         │  (optional)                      │
         ▼                                  ▼
  ┌──────────────┐                   ┌──────────────┐
  │   cleanup    │                   │    paint     │ (next frame)
  └──────┬───────┘                   └──────┬───────┘
         │                                  │
         ▼                                  ▼
  ┌──────────────┐                   ┌──────────────┐
  │   dispose    │                   │   cleanup    │
  └──────────────┘                   └──────────────┘
```

## Sequence Diagram

```
  RenderEngine          PathPainter          PathPaintOptions        Canvas
       │                     │                      │                │
       │──initialize()──────▶│                      │                │
       │                     │                      │                │
       │──prepare(ctx)──────▶│                      │                │
       │                     │──fromNode(node)─────▶│                │
       │                     │◀──────options────────│                │
       │                     │                      │                │
       │──paint(ctx)────────▶│                      │                │
       │                     │──save()──────────────│───────────────▶│
       │                     │──_applyTransform()───│───────────────▶│
       │                     │──_drawShadows()──────│───────────────▶│
       │                     │──_drawFill()─────────│───────────────▶│
       │                     │──_drawStroke()───────│───────────────▶│
       │                     │──_drawDebug()────────│───────────────▶│
       │                     │──restore()───────────│───────────────▶│
       │◀────PaintResult─────│                      │                │
       │                     │                      │                │
       │──cleanup()─────────▶│                      │                │
       │                     │                      │                │
       │──dispose()─────────▶│                      │                │
```

## Public API

### PathCommand (sealed)

| Method | Description |
|--------|-------------|
| `PathCommand.fromMap(Map)` | Factory: creates correct subtype from `'type'` field |

### PathMoveTo

| Field | Type | Description |
|-------|------|-------------|
| `x` | `double` | Target X coordinate |
| `y` | `double` | Target Y coordinate |

### PathLineTo

| Field | Type | Description |
|-------|------|-------------|
| `x` | `double` | Target X coordinate |
| `y` | `double` | Target Y coordinate |

### PathCubicTo

| Field | Type | Description |
|-------|------|-------------|
| `controlX1`, `controlY1` | `double` | First control point |
| `controlX2`, `controlY2` | `double` | Second control point |
| `x`, `y` | `double` | End point |

### PathQuadraticTo

| Field | Type | Description |
|-------|------|-------------|
| `controlX`, `controlY` | `double` | Control point |
| `x`, `y` | `double` | End point |

### PathClose

No fields.

### PathPaintStyle

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `fillColor` | `Color?` | `null` | Fill color (`null` = no fill) |
| `strokeColor` | `Color?` | `null` | Stroke color (`null` = no stroke) |
| `strokeWidth` | `double` | `0.0` | Stroke width in logical pixels |
| `strokeCap` | `StrokeCap` | `butt` | Stroke cap style (`butt`, `round`, `square`) |
| `strokeJoin` | `StrokeJoin` | `miter` | Stroke join style (`miter`, `round`, `bevel`) |
| `shadows` | `List<PaintShadow>` | `[]` | Shadow definitions |
| `blendMode` | `BlendMode` | `srcOver` | Blend mode |
| `antiAlias` | `bool` | `true` | Anti-aliasing flag |

| Getter | Description |
|--------|-------------|
| `hasFill` | `true` if `fillColor != null` |
| `hasStroke` | `true` if `strokeWidth > 0` and `strokeColor != null` |
| `hasShadows` | `true` if `shadows` is non-empty |

| Method | Description |
|--------|-------------|
| `fromNode(RenderPaintNode)` | Creates style from render node properties |

### PathPaintOptions

| Property | Type | Default | Description |
|----------|------|---------|-------------|
| `commands` | `List<PathCommand>` | — | Ordered list of path drawing commands |
| `opacity` | `double` | `1.0` | Global opacity multiplier |
| `rotation` | `double` | `0.0` | Rotation in radians (about center of bounds) |
| `scaleX` | `double` | `1.0` | Horizontal scale factor |
| `scaleY` | `double` | `1.0` | Vertical scale factor |
| `visible` | `bool` | `true` | Visibility flag |
| `debugPaint` | `bool` | `false` | Enable debug overlay |
| `hitTestBounds` | `Rect?` | `null` | Custom hit-test bounding rect |
| `style` | `PathPaintStyle` | — | Paint style configuration |

| Method | Description |
|--------|-------------|
| `fromNode(RenderPaintNode)` | Creates options from render node properties |
| `computePaintBounds()` | Computes bounding rect accounting for strokes, shadows, rotation, and scale |

### PathPaintMetrics

| Property | Type | Description |
|----------|------|-------------|
| `pathsPainted` | `int` | Number of paths painted |
| `filledPaths` | `int` | Number of fill operations |
| `strokedPaths` | `int` | Number of stroke operations |
| `segmentsDrawn` | `int` | Total segments (moveTo, lineTo, etc.) |
| `shadowCount` | `int` | Number of shadows drawn |
| `cacheHits` | `int` | Cache hits |
| `cacheMisses` | `int` | Cache misses |
| `paintDuration` | `Duration` | Cumulative paint time |

| Method | Description |
|--------|-------------|
| `reset()` | Resets all counters to zero |
| `copy()` | Creates an independent clone |
| `operator +` | Merges two metrics instances |
| `averagePaintTimeMs` | Average paint time per path in milliseconds |

### PathPainterDiagnostics

| Property | Type | Description |
|----------|------|-------------|
| `operations` | `List<CanvasOperation>` | Chronological log of canvas operations |
| `warnings` | `List<String>` | Warning messages |
| `skipped` | `List<String>` | Skipped paint reasons |
| `errors` | `List<String>` | Error messages |
| `memoryAllocations` | `int` | Allocation counter |

| Method | Description |
|--------|-------------|
| `recordOperation(name)` | Logs a canvas operation |
| `recordWarning(msg)` | Records a warning |
| `recordSkipped(reason)` | Records a skipped paint |
| `recordError(msg)` | Records an error |
| `recordAllocation()` | Increments allocation counter |
| `reset()` | Clears all records |
| `merge(other)` | Merges another diagnostics instance |

| Getter | Description |
|--------|-------------|
| `totalOperations` | Total operations count |
| `totalDuration` | Sum of all operation durations |
| `hasWarnings` | Whether any warnings exist |
| `hasErrors` | Whether any errors exist |

### PathPainter

| Property | Type | Description |
|----------|------|-------------|
| `type` | `String` | Returns `'path'` |
| `capabilities` | `PaintCapabilities` | Returns `PaintCapabilities.advanced` |
| `metrics` | `PathPaintMetrics` | Read-only performance metrics |
| `diagnostics` | `PathPainterDiagnostics` | Read-only diagnostics |

| Method | Description |
|--------|-------------|
| `canPaint(RenderPaintNode)` | Returns `true` if `node.type == 'path'` |
| `initialize()` | Resets metrics and diagnostics to initial state |
| `prepare(PaintContext)` | Parses render node into paint options, records allocation |
| `paint(PaintContext)` | Builds path, applies transform, draws shadows/fill/stroke/debug; returns `PaintResult` |
| `cleanup()` | Clears cached options and path state |
| `dispose()` | Full cleanup of all resources |

## Usage Guide

```dart
// 1. Create the painter
final painter = PathPainter();
painter.initialize();

// 2. Define a render node (typically from a document or tree)
final node = RenderPaintNode(
  id: 'triangle',
  type: 'path',
  x: 0, y: 0, width: 200, height: 200,
  color: '#FF0000',
  properties: {
    'commands': [
      {'type': 'moveTo', 'x': 100, 'y': 10},
      {'type': 'lineTo', 'x': 180, 'y': 180},
      {'type': 'lineTo', 'x': 20, 'y': 180},
      {'type': 'closePath'},
    ],
  },
);

// 3. Create a paint context
final ctx = PaintContext(
  canvas: myCanvas,
  document: myDocument,
  renderTree: myRenderTree,
  renderNode: node,
  viewportWidth: 1000,
  viewportHeight: 600,
  scaleFactor: 1.0,
);

// 4. Prepare and paint
painter.prepare(ctx);
final result = painter.paint(ctx);

// 5. Check result
if (result.success) {
  print('Painted in ${result.duration.inMicroseconds}us');
}

// 6. Cleanup between frames
painter.cleanup();

// 7. Dispose when done
painter.dispose();
```

## Features Table

| Feature | Supported |
|---------|-----------|
| Fill paths | ✅ |
| Stroke paths | ✅ |
| Stroke cap control (butt/round/square) | ✅ |
| Stroke join control (miter/round/bevel) | ✅ |
| Cubic bezier curves | ✅ |
| Quadratic bezier curves | ✅ |
| Drop shadows | ✅ |
| Rotation | ✅ |
| Scale | ✅ |
| Opacity | ✅ |
| Visibility toggle | ✅ |
| Debug overlay | ✅ |
| Hit-test bounds | ✅ |
| Blend modes | ✅ |
| Anti-aliasing | ✅ |
| Performance metrics | ✅ |
| Diagnostics logging | ✅ |

## Performance Notes

- Each `paint()` call rebuilds the `Path` object from commands. For static geometry, cache the `Path` externally to avoid rebuilds.
- Shadows use `MaskFilter.blur`, which can be expensive on complex paths. Limit shadow count for high-frame-rate scenarios.
- Rotated and scaled paths use `canvas.save()` / `canvas.restore()` with matrix transforms. Overuse in deep stacks may cause save/restore overhead.
- Metrics are collected on every paint call. Consider disabling in release builds if the overhead of `Stopwatch` and counter increments is a concern.
- `computePaintBounds()` is O(n) in the number of commands. Cache the bounds if called frequently (e.g., every frame).
- Stroke width inflates paint bounds by `strokeWidth / 2` on each axis.
- Shadow bounds account for both the offset shift and the blur radius via `Rect.inflate()`.
- Rotation bounds are computed by rotating all four corners of the axis-aligned bounding box, which gives a conservative (potentially inflated) result.
