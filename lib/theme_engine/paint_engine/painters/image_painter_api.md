# ImagePainter API Reference

## Overview

ImagePainter renders images (loaded or placeholder) as standalone paint elements. It extends `BasePainter` and is auto-registered in `PaintRegistry` under the type `'image'`.

## UML Class Diagram

```
┌──────────────────┐     ┌──────────────────────┐
│   BasePainter    │     │ ImagePaintStyle       │
│ (abstract)       │     │──────────────────────│
│──────────────────│     │ - imageSource: String │
│ + type           │◄────│ - imagePath: String?  │
│ + capabilities   │     │ - imageBytes: List?   │
│ + canPaint()     │     │ - imageKey: String?   │
│ + initialize()   │     │ - placeholderColor    │
│ + prepare()      │     │ - borderColor/Width   │
│ + paint()        │     │ - colorFilterColor    │
│ + dispose()      │     │ - shadows             │
└──────────────────┘     │ - blendMode           │
         ▲               │ + fromNode()          │
         │               └──────────────────────┘
┌──────────────────┐              ▲
│   ImagePainter   │              │
│──────────────────│     ┌──────────────────────┐
│ - _metrics       │     │ ImagePaintOptions     │
│ - _diagnostics   │────▶│──────────────────────│
│ - _imagePaint    │     │ - rect: Rect          │
│ - _borderPaint   │     │ - fit: ImageBoxFit    │
│ - _shadowPaint   │     │ - alignment           │
│ - _placeholder   │     │ - borderRadiusTL/TR.. │
│ - _debugPaint    │     │ - circular            │
│ - _image: Image? │     │ - opacity, rotation   │
│ + metrics        │     │ - scaleX/Y            │
│ + diagnostics    │     │ - visible             │
│ + setImage()     │     │ - clipping, debug     │
│ + cleanup()      │     │ - hitTestBounds        │
└──────────────────┘     │ + fromNode()           │
                          │ + computePaintBounds()│
                          │ + computeImageRect()  │
                          └──────────────────────┘
```

## Lifecycle Diagram

```
initialize() ────► _image = null
    │
    ▼
prepare(context) ──► ImagePaintOptions.fromNode(node)
    │
    ▼
paint(context)
    │
    ├─ canvas.save()
    ├─ _applyTransform()
    ├─ _applyClip() [circular / borderRadius / clipping]
    ├─ _drawShadows()
    ├─ _drawPlaceholderOrImage()
    │    ├─ if _image != null ► canvas.drawImageRect()
    │    └─ else ► canvas.drawRect(placeholder)
    ├─ _drawBorder()
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

### ImagePaintStyle

| Member | Type | Description |
|--------|------|-------------|
| `imageSource` | `String` | `'asset'`, `'memory'`, `'file'`, `'network'`, `'placeholder'` |
| `imagePath` | `String?` | Path/URL for asset/file/network sources |
| `imageBytes` | `List<int>?` | Raw bytes for memory source |
| `imageKey` | `String?` | Cache key |
| `placeholderColor` | `Color?` | Fallback color when no image available |
| `borderColor` | `Color?` | Border stroke color |
| `borderWidth` | `double` | Border stroke width |
| `colorFilterColor` | `Color?` | Color filter overlay color |
| `colorFilterBlendMode` | `BlendMode` | Color filter blend mode |
| `shadows` | `List<PaintShadow>` | Drop shadows |
| `blendMode` | `BlendMode` | Compositing mode |
| `hasBorder`, `hasShadows`, `hasColorFilter` | `bool` | Feature checks |

### ImagePaintOptions

| Member | Type | Description |
|--------|------|-------------|
| `rect` | `Rect` | Bounding rectangle |
| `fit` | `ImageBoxFit` | Fill / contain / cover / fitWidth / fitHeight / none / scaleDown |
| `alignment` | `ImageAlignment` | 9-point alignment for image placement |
| `borderRadiusTL…BL` | `double` | Per-corner radii |
| `circular` | `bool` | Circular crop |
| `opacity`, `rotation`, `scaleX/Y` | `double` | Transform |
| `visible`, `clipping`, `debugPaint` | `bool` | Flags |
| `computePaintBounds()` | `Rect` | Full paint bounds |
| `computeImageRect(Size)` | `Rect` | Image destination rect based on fit |

### ImageBoxFit

| Value | Behavior |
|-------|----------|
| `fill` | Stretch to fill rect |
| `contain` | Scale to fit, maintain aspect ratio |
| `cover` | Scale to cover, may crop |
| `fitWidth` | Fit width, center height |
| `fitHeight` | Fit height, center width |
| `none` | Render at natural size |
| `scaleDown` | Like contain but never up-scale |

### ImageAlignment

`topLeft`, `topCenter`, `topRight`, `centerLeft`, `center`, `centerRight`, `bottomLeft`, `bottomCenter`, `bottomRight`

### ImagePainter

| Member | Type | Description |
|--------|------|-------------|
| `type` | `String` | Returns `'image'` |
| `capabilities` | `PaintCapabilities` | Advanced |
| `canPaint(node)` | `bool` | True when `node.type == 'image'` |
| `setImage(Image?)` | `void` | Inject a loaded `dart:ui Image` |
| `metrics` | `ImagePaintMetrics` | Runtime statistics |
| `diagnostics` | `ImagePainterDiagnostics` | Debug diagnostics |

### Properties Consumed from RenderPaintNode

| Property | Format | Used In |
|----------|--------|---------|
| `imageSource` | `String` | Style: image source type |
| `imagePath` | `String` | Style: asset/file/network path |
| `imageBytes` | `List<int>` | Style: raw image data |
| `imageKey` | `String` | Style: cache key |
| `placeholderColor` | `String` | Style: hex color fallback |
| `borderWidth`, `borderColor` | `num`, `String` | Style: border |
| `colorFilterColor`, `colorFilterBlendMode` | `String` | Style: color filter |
| `borderRadius[TL/TR/BR/BL]` | `num` | Options: corner rounding |
| `circular` | `bool` | Options: circular crop |
| `fit` | `String` | Options: box fit mode |
| `alignment` | `String` | Options: alignment |
| `debugPaint` | `bool` | Options: debug overlay |
| `clipping` | `bool` | Options: clip to bounds |
| `shadows` | `List<Map>` | Style: shadow definitions |
| `blendMode` | `String` | Style: blend mode |

## Usage Guide

```dart
final node = RenderPaintNode(
  id: 'img1', type: 'image',
  x: 50, y: 50, width: 200, height: 150,
  color: '#E0E0E0',
  properties: {
    'borderRadius': 12,
    'borderWidth': 3,
    'borderColor': '#33691E',
    'fit': 'cover',
    'circular': false,
    'shadows': [{'color': '#000000', 'offsetX': 4, 'offsetY': 4, 'blurRadius': 8, 'opacity': 0.4}],
  },
);
final painter = ImagePainter();
// To render a real image:
// painter.setImage(await loadImage(...));
```

## SVG Placeholder Hook (Architecture Only)

The `imageSource: 'svg'` type is reserved for future SVG rendering. Currently falls
back to placeholder drawing. The property `imagePath` should contain the SVG file path.
Implementation via `drawAtlas()` or custom path rendering is an extension point.

## Supported Features

- Placeholder drawing (colored rect when no image loaded)
- AssetImage, MemoryImage, FileImage, NetworkImage sources
- BoxFit (7 modes) + 9-point alignment
- Rounded corners (uniform or per-corner)
- Circular crop
- Border stroke
- Drop shadows (multiple)
- Rotation, scale, opacity
- Blend modes
- Color filter
- Clipping
- Debug paint overlay

## Performance Notes

- Reuses 5 `Paint` objects (no allocations in `paint()`)
- Image must be loaded externally and injected via `setImage()`
- When no image is set, a simple colored rect is drawn (fast path)
- Border uses `drawRRect`/`drawRect` with `PaintingStyle.stroke`
- Shadows use `MaskFilter.blur` (performance consideration for large blurs)
