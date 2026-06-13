# LinePainter API Documentation

## UML ASCII Class Diagram

```
┌──────────────────────────┐     ┌─────────────────────────┐
│       BasePainter        │     │    PaintCapabilities     │
│ ──────────────────────── │     │ ──────────────────────── │
│ +type: String            │     │ +supportsOpacity: bool   │
│ +capabilities            │     │ +supportsTransform: bool │
│ +canPaint(node): bool    │     │ +supportsStroke: bool    │
│ +initialize()            │     │ +supportsShadow: bool    │
│ +prepare(ctx)            │     │ +supportsBlendMode: bool │
│ +paint(ctx): PaintResult │     └────────────┬────────────┘
│ +dispose()               │                  │
└───────────┬──────────────┘                  │
            │ extends                        │
┌───────────┴──────────────────────────────────────────────────┐
│                        LinePainter                            │
│ ───────────────────────────────────────────────────────────── │
│ - _metrics: LinePaintMetrics                                  │
│ - _diagnostics: LinePainterDiagnostics                        │
│ - _linePaint: Paint                                           │
│ - _shadowPaint: Paint                                         │
│ - _debugPaint: Paint                                          │
│ - _lastOptions: LinePaintOptions?                              │
│ ───────────────────────────────────────────────────────────── │
│ +metrics: LinePaintMetrics                                    │
│ +diagnostics: LinePainterDiagnostics                          │
│ +type: String                                                 │
│ +capabilities: PaintCapabilities                              │
│ +canPaint(node): bool                                         │
│ +initialize()                                                 │
│ +prepare(PaintContext)                                        │
│ +paint(PaintContext): PaintResult                              │
│ +cleanup()                                                    │
│ +dispose()                                                    │
│ +toString(): String                                           │
└───────────────────────────────────────────────────────────────┘

┌──────────────────────────┐    ┌───────────────────────────┐
│     LinePaintStyle       │    │    LinePaintOptions        │
│ ──────────────────────── │    │ ────────────────────────── │
│ +lineColor: Color?       │    │ +startX / startY: double   │
│ +strokeWidth: double     │    │ +endX / endY: double       │
│ +strokeCap: StrokeCap    │    │ +opacity: double           │
│ +shadows: List<PaintSha… │    │ +rotation: double          │
│ +blendMode: BlendMode    │    │ +scaleX / scaleY: double   │
│ +antiAlias: bool         │    │ +visible: bool             │
│ +hasLine: bool           │    │ +debugPaint: bool          │
│ +hasShadows: bool        │    │ +hitTestBounds: Rect?      │
│ +fromNode(node)          │    │ +style: LinePaintStyle     │
│ ──────────────────────── │    │ +cx: double                │
│                          │    │ +cy: double                │
│                          │    │ +computePaintBounds(): Rect│
│                          │    │ +fromNode(node)            │
│                          │    └───────────────────────────┘
│                          │
└──────────────────────────┘

┌──────────────────────────┐    ┌───────────────────────────┐
│    LinePaintMetrics      │    │  LinePainterDiagnostics    │
│ ──────────────────────── │    │ ────────────────────────── │
│ +linesPainted: int       │    │ +operations: List<Canva…> │
│ +shadowCount: int        │    │ +warnings: List<String>   │
│ +cacheHits / misses: int │    │ +skipped: List<String>    │
│ +paintDuration: Duration │    │ +errors: List<String>     │
│ +totalLength: double     │    │ +memoryAllocations: int   │
│ ──────────────────────── │    │ ────────────────────────── │
│ +recordLine(len)         │    │ +recordOperation(name)    │
│ +recordShadow()          │    │ +recordWarning(msg)       │
│ +recordCacheHit/Miss()   │    │ +recordSkipped(reason)    │
│ +recordDuration(d)       │    │ +recordError(msg)         │
│ +reset()                 │    │ +recordAllocation()       │
│ +copy(): Self            │    │ +reset()                  │
│ +operator+(other)        │    │ +merge(other)             │
│ +averagePaintTimeMs      │    │ +totalOperations: int     │
│ +toString(): String      │    │ +totalDuration: Duration  │
└──────────────────────────┘    │ +hasWarnings / hasErrors  │
                                │ +toString(): String       │
                                └───────────────────────────┘
```

## Lifecycle ASCII Diagram

```
   ┌──────────────┐
   │  initialize  │
   └──────┬───────┘
          │
   ┌──────▼───────┐
   │   prepare    │  ← receives PaintContext with RenderPaintNode
   │  (fromNode)  │
   └──────┬───────┘
          │
   ┌──────▼───────┐
   │    paint     │  ──→ PaintResult(success, duration, bounds)
   │              │
   │  ┌─────────────────────┐
   │  │ canvas.save()       │
   │  │ _applyTransform()   │  (rotation, scale around centre)
   │  │ _drawShadows()      │  (if hasShadows)
   │  │ _drawLine()         │  (if hasLine && visible)
   │  │ _drawDebug()        │  (if debugPaint)
   │  │ canvas.restore()    │
   │  └─────────────────────┘
   │              │
   └──────┬───────┘
          │
   ┌──────▼───────┐
   │   cleanup    │  clears _lastOptions, resets diagnostics
   └──────────────┘

   ┌──────────────┐
   │   dispose    │  clears everything
   └──────────────┘
```

## Sequence Diagram

```
  Caller         LinePainter          Canvas         Diagnostics / Metrics
    │                │                  │                   │
    │  prepare(ctx)  │                  │                   │
    │───────────────>│                  │                   │
    │                │  recordAlloc     │                   │
    │                │─────────────────────────────────────>│
    │                │                  │                   │
    │  paint(ctx)    │                  │                   │
    │───────────────>│                  │                   │
    │                │ save()           │                   │
    │                │─────────────────>│                   │
    │                │ recordOp(save)   │                   │
    │                │─────────────────────────────────────>│
    │                │                  │                   │
    │                │ translate/rotate │                   │
    │                │─────────────────>│                   │
    │                │                  │                   │
    │                │ drawLine         │                   │
    │                │─────────────────>│                   │
    │                │ recordOp(draw)   │                   │
    │                │─────────────────────────────────────>│
    │                │                  │                   │
    │                │ restore()        │                   │
    │                │─────────────────>│                   │
    │                │ recordOp(restore)│                   │
    │                │─────────────────────────────────────>│
    │                │                  │                   │
    │  PaintResult   │                  │                   │
    │<───────────────│                  │                   │
    │                │                  │                   │
    │  cleanup()     │                  │                   │
    │───────────────>│                  │                   │
    │                │  reset           │                   │
    │                │─────────────────────────────────────>│
```

## Public API

### `LinePainter`

| Method / Property | Return Type | Description |
|---|---|---|
| `type` | `String` | Returns `'line'` |
| `capabilities` | `PaintCapabilities` | Describes supported features |
| `canPaint(RenderPaintNode)` | `bool` | Returns `true` if `node.type == 'line'` |
| `initialize()` | `void` | Resets metrics and diagnostics |
| `prepare(PaintContext)` | `void` | Parses node into `LinePaintOptions` |
| `paint(PaintContext)` | `PaintResult` | Draws the line on the canvas |
| `cleanup()` | `void` | Clears cached options, resets diagnostics |
| `dispose()` | `void` | Full cleanup of all state |
| `metrics` | `LinePaintMetrics` | Access performance counters |
| `diagnostics` | `LinePainterDiagnostics` | Access debug operations/tracing |

### `LinePaintStyle`

| Property | Type | Description |
|---|---|---|
| `lineColor` | `Color?` | Line colour; `null` means no line |
| `strokeWidth` | `double` | Width of the stroke (default `1.0`) |
| `strokeCap` | `StrokeCap` | `butt`, `round`, or `square` |
| `shadows` | `List<PaintShadow>` | Shadow definitions |
| `blendMode` | `BlendMode` | Blend mode (default `srcOver`) |
| `antiAlias` | `bool` | Anti-aliasing flag |
| `hasLine` | `bool` | `true` when `lineColor != null && strokeWidth > 0` |
| `hasShadows` | `bool` | `true` when `shadows.isNotEmpty` |

### `LinePaintOptions`

| Property/Method | Type | Description |
|---|---|---|
| `startX`, `startY` | `double` | Line start point |
| `endX`, `endY` | `double` | Line end point |
| `opacity` | `double` | Overall opacity `0.0`–`1.0` |
| `rotation` | `double` | Rotation in radians |
| `scaleX`, `scaleY` | `double` | Scale factors |
| `visible` | `bool` | Whether to paint the line |
| `debugPaint` | `bool` | Show debug overlays |
| `hitTestBounds` | `Rect?` | Optional hit-test rectangle |
| `style` | `LinePaintStyle` | The style to apply |
| `cx`, `cy` | `double` | Midpoint of the line |
| `computePaintBounds()` | `Rect` | AABB including stroke, shadows, rotation |

### `LinePaintMetrics`

| Property/Method | Type | Description |
|---|---|---|
| `linesPainted` | `int` | Count of painted lines |
| `shadowCount` | `int` | Count of drawn shadows |
| `cacheHits`, `cacheMisses` | `int` | Cache statistics |
| `paintDuration` | `Duration` | Total accumulated paint time |
| `totalLength` | `double` | Sum of all line lengths |
| `averagePaintTimeMs` | `double` | Mean paint time per line (ms) |
| `reset()` | `void` | Zero all counters |
| `copy()` | `LinePaintMetrics` | Clone this instance |
| `operator+` | `LinePaintMetrics` | Merge two metric sets |

### `LinePainterDiagnostics`

| Property/Method | Type | Description |
|---|---|---|
| `operations` | `List<CanvasOperation>` | Recorded canvas operations |
| `warnings` | `List<String>` | Warning messages |
| `skipped` | `List<String>` | Skip reasons |
| `errors` | `List<String>` | Error messages |
| `memoryAllocations` | `int` | Allocation count |
| `totalOperations` | `int` | Count of operations |
| `totalDuration` | `Duration` | Sum of all operation durations |
| `hasWarnings` | `bool` | Any warnings present |
| `hasErrors` | `bool` | Any errors present |
| `reset()` | `void` | Clear all state |
| `merge(other)` | `void` | Combine with another instance |

## Usage Guide

```dart
final node = RenderPaintNode(
  id: 'myLine', type: 'line',
  x: 20, y: 50, width: 200, height: 0,  // horizontal
  color: '#E53935',
  strokeWidth: 3,
  rotation: 0.5,
);

final painter = LinePainter();
final ctx = PaintContext(
  canvas: myCanvas,
  document: myDocument,
  renderTree: myRenderTree,
  renderNode: node,
  viewportWidth: 800,
  viewportHeight: 600,
  scaleFactor: 1.0,
);

painter.prepare(ctx);
final result = painter.paint(ctx);
print('Painted in ${result.duration.inMicroseconds}us');
```

### Configuration via node properties

| Property | Type | Description |
|---|---|---|
| `startX`, `startY` | `num` | Override start point (default: `x`, `y`) |
| `endX`, `endY` | `num` | Override end point (default: `x + width`, `y + height`) |
| `strokeCap` | `String` | `'butt'`, `'round'`, or `'square'` |
| `shadows` | `List<Map>` | Shadow descriptors |
| `debugPaint` | `bool` | Enable debug overlays |
| `hitTestBounds` | `Map` | Hit-test area (`x`, `y`, `width`, `height`) |
| `antiAlias` | `bool` | Anti-aliasing toggle |

## Features Table

| Feature | Supported | Notes |
|---|---|---|
| Solid colour line | ✅ | Via `color` field |
| Stroke width | ✅ | Via `strokeWidth` field |
| Line caps (butt/round/square) | ✅ | Via `strokeCap` property |
| Opacity | ✅ | Via `opacity` field |
| Rotation | ✅ | Around line midpoint |
| Scale X/Y | ✅ | Around line midpoint |
| Shadows | ✅ | Multiple shadows supported |
| Blend modes | ✅ | Via `blendMode` property |
| Debug overlay | ✅ | Via `debugPaint` property |
| Hit-test bounds | ✅ | Separate from paint bounds |
| Visibility toggle | ✅ | Skips paint when `visible: false` |
| Null canvas handling | ✅ | Returns `PaintResult.failure` |
| Performance metrics | ✅ | Counters and timing |
| Diagnostic tracing | ✅ | Per-operation tracking |
| Memory allocation tracking | ✅ | Allocation counter |
| Error recovery | ✅ | try/catch in paint method |

## Performance Notes

- **Memory**: No allocations during `paint()` except the `Stopwatch` and result object. All `Paint` objects are reused.
- **Shadows**: Each shadow adds one `canvas.save()`/`restore()` pair and `MaskFilter.blur`. Expect O(n) cost per shadow.
- **Transform**: Rotation and scale are applied via canvas transforms (no pre-computed matrices).
- **Metrics overhead**: `Stopwatch` usage adds approximately 0.5–2 µs per paint cycle. Can be disabled if not needed.
- **Cache stats**: `cacheHits`/`cacheMisses` are available but no caching is implemented in the base painter.
