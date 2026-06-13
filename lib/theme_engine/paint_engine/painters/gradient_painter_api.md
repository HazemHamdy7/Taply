# GradientPainter API Reference

## Overview

GradientPainter renders linear, radial, and sweep gradients as standalone paint elements. It extends `BasePainter` and is auto-registered in `PaintRegistry` under the type `'gradient'`.

## UML Class Diagram

```
┌──────────────────┐     ┌──────────────────────┐
│   BasePainter    │     │ GradientPaintStyle    │
│ (abstract)       │     │──────────────────────│
│──────────────────│     │ - gradient: Gradient? │
│ + type           │◄────│ - gradientKind: String│
│ + capabilities   │     │ - colors: List<Color> │
│ + canPaint()     │     │ - stops: List<double>?│
│ + initialize()   │     │ - tileMode: TileMode  │
│ + prepare()      │     │ - shadows             │
│ + paint()        │     │ - blendMode           │
│ + dispose()      │     │ + fromNode()          │
└──────────────────┘     └──────────────────────┘
         ▲                        ▲
         │                        │
┌──────────────────┐     ┌──────────────────────┐
│ GradientPainter  │     │ GradientPaintOptions  │
│──────────────────│────▶│──────────────────────│
│ - _metrics       │     │ - rect: Rect         │
│ - _diagnostics   │     │ - borderRadiusTL/TR..│
│ - _fillPaint     │     │ - opacity, rotation  │
│ - _shadowPaint   │     │ - scaleX/Y           │
│ - _debugPaint    │     │ - visible            │
│ - _clipPath      │     │ - clipping, debug    │
│ + metrics        │     │ - hitTestBounds       │
│ + diagnostics    │     │ + fromNode()          │
│ + cleanup()      │     │ + computePaintBounds()│
└──────────────────┘     │ + toRRect()           │
                          └──────────────────────┘
```

## Lifecycle Diagram

```
initialize()
    │
    ▼
prepare(context) ────► GradientPaintOptions.fromNode(node)
    │                       └── GradientPaintStyle.fromNode(node)
    ▼                              └── _buildGradient()
paint(context)
    │
    ├─ canvas.save()
    ├─ _applyTransform()
    ├─ _applyClip()
    ├─ _drawShadows()
    ├─ _drawFill()
    ├─ _drawDebug() [if debugPaint]
    ├─ canvas.restore()
    │
    ▼
PaintResult (success / failure)
    │
    ▼
cleanup() / dispose()
```

## Public API

### GradientPaintStyle

| Member | Type | Description |
|--------|------|-------------|
| `gradient` | `Gradient?` | The resolved Flutter `Gradient` shader object |
| `gradientKind` | `String` | `'linear'`, `'radial'`, or `'sweep'` |
| `colors` | `List<Color>` | Color stops parsed from `gradientColors` |
| `stops` | `List<double>?` | Optional stop positions |
| `tileMode` | `TileMode` | Clamp / repeated / mirror |
| `shadows` | `List<PaintShadow>` | Drop shadows |
| `blendMode` | `BlendMode` | Compositing mode |
| `hasGradient` | `bool` | True if gradient was built successfully |
| `hasShadows` | `bool` | True if shadows list is non-empty |

### GradientPaintOptions

| Member | Type | Description |
|--------|------|-------------|
| `rect` | `Rect` | Bounding rectangle from node `x, y, width, height` |
| `borderRadiusTL...BL` | `double` | Per-corner radii |
| `opacity` | `double` | Opacity multiplier (0–1) |
| `rotation` | `double` | Rotation in radians |
| `scaleX`, `scaleY` | `double` | Scale factors |
| `visible` | `bool` | Visibility flag |
| `clipping` | `bool` | Clip to bounds |
| `debugPaint` | `bool` | Enable debug overlay |
| `hitTestBounds` | `Rect?` | Hit-test area override |
| `computePaintBounds()` | `Rect` | Full paint bounds including shadows/transform |
| `toRRect()` | `RRect` | Rounded rect from corner radii |

### GradientPainter

| Member | Type | Description |
|--------|------|-------------|
| `type` | `String` | Returns `'gradient'` |
| `capabilities` | `PaintCapabilities` | Advanced (all features) |
| `canPaint(node)` | `bool` | True when `node.type == 'gradient'` |
| `metrics` | `GradientPaintMetrics` | Runtime statistics |
| `diagnostics` | `GradientPainterDiagnostics` | Debug diagnostics |

### Properties Consumed from RenderPaintNode

| Property | Format | Used In |
|----------|--------|---------|
| `gradientKind` | `String` | Style: gradient type |
| `gradientColors` | `List<String>` | Style: hex color strings |
| `gradientStops` | `List<num>` | Style: stop positions (0–1) |
| `tileMode` | `String` | Style: clamp/repeated/mirror |
| `angle` | `num` | Linear: angle in degrees |
| `startX`, `startY`, `endX`, `endY` | `num` | Linear: explicit endpoints |
| `centerX`, `centerY` | `num` | Radial/Sweep: center point |
| `gradientRadius` | `num` | Radial: radius |
| `startAngle`, `endAngle` | `num` | Sweep: angle range in degrees |
| `borderRadius[TL/TR/BR/BL]` | `num` | Options: corner rounding |
| `clipping` | `bool` | Options: clip to bounds |
| `debugPaint` | `bool` | Options: debug overlay |
| `shadows` | `List<Map>` | Style: shadow definitions |
| `blendMode` | `String` | Style: blend mode name |
| `antiAlias` | `bool` | Style: anti-aliasing |

## Usage Guide

```dart
final node = RenderPaintNode(
  id: 'grad1', type: 'gradient',
  x: 50, y: 50, width: 200, height: 150,
  properties: {
    'gradientKind': 'linear',
    'gradientColors': ['#FF0000', '#0000FF'],
    'angle': 45,
    'borderRadius': 16,
    'shadows': [{'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4}],
  },
);
final painter = GradientPainter();
// ... prepare + paint
```

## Supported Features

- Linear, Radial, Sweep gradients
- Multi-color stops
- TileMode (clamp, repeated, mirrored)
- Rounded corners (uniform or per-corner)
- Rotation, scale, opacity
- Blend modes
- Drop shadows (multiple)
- Clipping
- Debug paint overlay

## Performance Notes

- Reuses 4 `Paint` objects (`_fillPaint`, `_shadowPaint`, `_debugPaint`, `_clipPath`)
- `Gradient` shader is created once in `fromNode()` (not per-frame)
- Shadows use `MaskFilter.blur` (performance cost proportional to blur radius)
- No allocations inside `paint()` except `Stopwatch`
