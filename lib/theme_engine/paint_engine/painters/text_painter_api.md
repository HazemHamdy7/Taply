# TextPainterElement API Reference

## Overview

TextPainterElement renders styled text with support for plain text, Arabic RTL, mixed scripts, gradient fill, shadows, stroke outline, multiline, and ellipsis overflow. It extends `BasePainter` and is auto-registered in `PaintRegistry` under the type `'text'`.

## UML Class Diagram

```
┌──────────────────┐     ┌──────────────────────────┐
│   BasePainter    │     │ TextPaintStyle            │
│ (abstract)       │     │──────────────────────────│
│──────────────────│     │ - text: String            │
│ + type           │◄────│ - fontFamily: String?     │
│ + capabilities   │     │ - fontWeight: FontWeight  │
│ + canPaint()     │     │ - fontStyle: FontStyle    │
│ + initialize()   │     │ - fontSize: double        │
│ + prepare()      │     │ - letterSpacing: double?  │
│ + paint()        │     │ - wordSpacing: double?    │
│ + dispose()      │     │ - lineHeight: double?     │
└──────────────────┘     │ - textAlign: TextAlign    │
         ▲               │ - textDirection: TextDir  │
         │               │ - maxLines: int?          │
┌──────────────────┐     │ - ellipsis: String?       │
│ TextPainterElement│    │ - overflow: TextOverflow  │
│──────────────────│----▶│ - color: Color?           │
│ - _metrics       │     │ - gradient: Gradient?     │
│ - _diagnostics   │     │ - shadows: List<Shadow>   │
│ - _debugPaint    │     │ - strokeColor: Color?     │
│ - _lastOptions   │     │ - strokeWidth: double     │
│ - _fillPainter   │     │ + fromNode()              │
│ - _strokePainter │     │ + buildTextStyle()        │
│ + metrics        │     │ + buildStrokeTextStyle()  │
│ + diagnostics    │     └──────────────────────────┘
└──────────────────┘                ▲
         │                         │
         │              ┌──────────────────────────┐
         └─────────────▶│ TextPaintOptions           │
                        │──────────────────────────│
                        │ - rect: Rect              │
                        │ - text: String            │
                        │ - opacity, rotation       │
                        │ - scaleX/Y                │
                        │ - visible                 │
                        │ - clipping, debugPaint    │
                        │ + fromNode()              │
                        │ + computePaintBounds()    │
                        └──────────────────────────┘
```

## Lifecycle Diagram

```
initialize()
    │
    ▼
prepare(context) ────► TextPaintOptions.fromNode(node)
    │                       └── TextPaintStyle.fromNode(node)
    ▼                              └── buildTextStyle()
paint(context)                          └── buildStrokeTextStyle()
    │
    ├─ canvas.save()
    ├─ _applyTransform()
    ├─ _applyClip()
    ├─ layout fill TextPainter [reused instance]
    ├─ [if stroke] layout + paint stroke TextPainter [reused instance]
    ├─ [if gradient] re-layout fill with gradient shader
    ├─ paint fill TextPainter
    ├─ _checkOverflow()
    ├─ _drawDebug() [if debugPaint]
    ├─ canvas.restore()
    │
    ▼
PaintResult (success / failure)
    │
    ▼
dispose() ──► _fillPainter?.dispose()
              _strokePainter?.dispose()
```

## Sequence Diagram (paint flow)

```
TextPainterElement          PaintContext         TextPaintOptions     TextPaintStyle    TextPainter (Flutter)
      │                         │                      │                   │                 │
      │  prepare(ctx)           │                      │                   │                 │
      │────────────────────────▶│                      │                   │                 │
      │                         │  fromNode(node)      │                   │                 │
      │                         │─────────────────────▶│                   │                 │
      │                         │                      │ fromNode(node)    │                 │
      │                         │                      │──────────────────▶│                 │
      │                         │                      │                   │                 │
      │  paint(ctx)             │                      │                   │                 │
      │────────────────────────▶│                      │                   │                 │
      │                         │                      │                   │                 │
      │  canvas.save()          │                      │                   │                 │
      │  canvas.transform()     │                      │                   │                 │
      │  canvas.clipRect()      │                      │                   │                 │
      │                         │                      │                   │                 │
      │  _fillPainter.text = TS │                      │                   │                 │
      │  _fillPainter.layout()  │                      │                   │────────────────▶│
      │                         │                      │                   │                 │
      │  [if stroke]            │                      │                   │                 │
      │    _strokePainter.layout│                     │                   │───────────────▶│
      │    _strokePainter.paint()│                     │                   │                 │
      │                         │                      │                   │                 │
      │  [if gradient]          │                      │                   │                 │
      │    re-layout fill       │                      │                   │────────────────▶│
      │                         │                      │                   │                 │
      │  _fillPainter.paint()   │                      │                   │                 │
      │  canvas.restore()       │                      │                   │                 │
      │                         │                      │                   │                 │
```

## Public API

### TextPaintStyle

| Member | Type | Description |
|--------|------|-------------|
| `text` | `String` | Text content to render |
| `fontFamily` | `String?` | Font family name |
| `fontWeight` | `FontWeight` | Weight (normal, bold, w100–w900) |
| `fontStyle` | `FontStyle` | Normal or italic |
| `fontSize` | `double` | Font size in logical pixels (default 14) |
| `letterSpacing` | `double?` | Letter spacing |
| `wordSpacing` | `double?` | Word spacing |
| `lineHeight` | `double?` | Line height as a factor of font size |
| `textAlign` | `TextAlign` | Alignment within bounds |
| `textDirection` | `TextDirection` | LTR or RTL |
| `maxLines` | `int?` | Maximum visible lines |
| `ellipsis` | `String?` | Ellipsis marker |
| `softWrap` | `bool` | Whether to wrap at word boundaries |
| `overflow` | `TextOverflow` | Clip, fade, ellipsis, or visible |
| `color` | `Color?` | Text fill color |
| `gradient` | `Gradient?` | Gradient shader for text fill |
| `shadows` | `List<Shadow>` | Text shadows |
| `strokeColor` | `Color?` | Stroke outline color |
| `strokeWidth` | `double` | Stroke outline width |
| `blendMode` | `BlendMode` | Compositing blend mode |
| `hasGradient` | `bool` | True if gradient is set |
| `hasShadows` | `bool` | True if shadows list is non-empty |
| `hasStroke` | `bool` | True if strokeColor and strokeWidth > 0 |
| `buildTextStyle()` | `TextStyle` | Build fill TextStyle |
| `buildStrokeTextStyle()` | `TextStyle` | Build stroke TextStyle |

### TextPaintOptions

| Member | Type | Description |
|--------|------|-------------|
| `rect` | `Rect` | Bounding rectangle from node `x, y, width, height` |
| `text` | `String` | Text content (convenience) |
| `opacity` | `double` | Opacity multiplier (0–1) |
| `rotation` | `double` | Rotation in radians |
| `scaleX`, `scaleY` | `double` | Scale factors |
| `visible` | `bool` | Visibility flag |
| `clipping` | `bool` | Clip to bounds |
| `debugPaint` | `bool` | Enable debug overlay |
| `hitTestBounds` | `Rect?` | Hit-test area override |
| `computePaintBounds()` | `Rect` | Full paint bounds including shadows/stroke/transform |

### TextPainterElement

| Member | Type | Description |
|--------|------|-------------|
| `type` | `String` | Returns `'text'` |
| `capabilities` | `PaintCapabilities` | Advanced (opacity, transform, blend) |
| `canPaint(node)` | `bool` | True when `node.type == 'text'` |
| `metrics` | `TextPaintMetrics` | Runtime statistics |
| `diagnostics` | `TextPainterDiagnostics` | Debug diagnostics |

### TextPaintMetrics

| Member | Type | Description |
|--------|------|-------------|
| `charactersPainted` | `int` | Total characters rendered |
| `linesPainted` | `int` | Total lines rendered |
| `paragraphsCount` | `int` | Paragraph count |
| `cacheHits` / `cacheMisses` | `int` | Cache statistics |
| `layoutDuration` | `Duration` | Cumulative layout time |
| `paintDuration` | `Duration` | Cumulative paint time |
| `totalTimeMs` | `double` | Layout + paint in milliseconds |

### TextPainterDiagnostics

| Member | Type | Description |
|--------|------|-------------|
| `layoutOperations` | `List<String>` | Layout event log |
| `paintOperations` | `List<String>` | Paint event log |
| `warnings` | `List<String>` | Warning messages |
| `fallbackFonts` | `List<String>` | Fallback font usage |
| `missingGlyphs` | `List<String>` | Missing glyph reports |
| `overflow` | `List<String>` | Overflow events |
| `skipped` | `List<String>` | Skipped paint reasons |
| `errors` | `List<String>` | Error messages |

### Properties Consumed from RenderPaintNode

| Property | Format | Used In |
|----------|--------|---------|
| `text` | `String` | Style: text content |
| `fontFamily` | `String?` | Style: font family |
| `fontWeight` | `String` | Style: normal, bold, w100–w900 |
| `fontStyle` | `String` | Style: normal, italic |
| `fontSize` | `num` | Style: font size |
| `letterSpacing` | `num` | Style: letter spacing |
| `wordSpacing` | `num` | Style: word spacing |
| `lineHeight` | `num` | Style: line height factor |
| `textAlign` | `String` | Style: start, end, left, right, center, justify |
| `textDirection` | `String` | Style: ltr, rtl |
| `maxLines` | `int` | Style: max visible lines |
| `ellipsis` | `String` | Style: ellipsis marker text |
| `overflow` | `String` | Style: clip, fade, ellipsis, visible |
| `color` | `String` | Style: text fill color hex |
| `gradientKind` | `String` | Style: linear, radial, sweep |
| `gradientColors` | `List<String>` | Style: gradient stop colors |
| `gradientStops` | `List<num>` | Style: stop positions |
| `textShadows` | `List<Map>` | Style: shadow definitions |
| `strokeColor` | `String` | Style: stroke outline color |
| `strokeWidth` | `num` | Style: stroke outline width |
| `blendMode` | `String` | Style: blend mode |
| `antiAlias` | `bool` | Style: anti-aliasing |
| `clipping` | `bool` | Options: clip to bounds |
| `debugPaint` | `bool` | Options: debug overlay |

## Usage Guide

```dart
final node = RenderPaintNode(
  id: 'text1', type: 'text',
  x: 20, y: 20, width: 260, height: 50,
  properties: {
    'text': 'Hello, World!',
    'fontSize': 24,
    'color': '#000000',
    'fontWeight': 'bold',
    'textAlign': 'center',
    'gradientKind': 'linear',
    'gradientColors': ['#FF0000', '#0000FF'],
    'textShadows': [
      {'color': '#00000033', 'offsetX': 2, 'offsetY': 2, 'blurRadius': 4},
    ],
  },
);
final painter = TextPainterElement();
// ... prepare + paint
```

## Supported Features

- Plain text (English, Arabic, mixed scripts)
- RTL and LTR direction
- Font family, weight, style, size
- Letter spacing, word spacing, line height
- Text alignment (start, end, left, right, center, justify)
- Max lines with ellipsis overflow
- Gradient text fill (linear, radial, sweep)
- Text shadows (multiple)
- Stroke text outline
- Blend modes
- Rotation, scale, opacity
- Clipping
- Debug paint overlay
- Flutter TextPainter reuse (no per-frame allocations)

## Performance Notes

- Reuses 2 `TextPainter` instances (`_fillPainter`, `_strokePainter`)
- Reuses `TextStyle` objects (cached across paint calls)
- `TextPainter.layout()` is called on each paint (required by Flutter's text pipeline)
- Stroke text requires an additional layout (same text, different Paint foreground)
- Gradient text re-layouts with updated shader bounds
- `computeLineMetrics()` is called once per paint for overflow detection
- No allocations inside `paint()` except `Stopwatch` and `TextSpan` (minimal)
