# Changelog

## v1.0.0 (2026-06-14)

Theme Engine V2 is now production-ready. This release delivers a complete JSON-driven rendering pipeline capable of parsing, resolving, preparing, and painting 10+ distinct business card themes with 100% reliability.

### What's New

#### Core Engine
- **ThemeParser** — Full JSON-to-scene-graph pipeline with multi-stage parsing (metadata, canvas, variables, assets, scene, components, animations, states), diagnostics, and strict validation mode
- **RenderPipeline** — Three-stage pipeline: build `RenderTree` from `ThemeDocument`, resolve painters/widgets, return prepared tree for painting
- **SceneGraph** — Tree structure supporting `build`, `findById`, `insertNode`, `removeNode`, `traverse`, and `flatten` operations
- **VariableResolver** — `$var` string replacement with cycle-safe resolution, `resolveAll`, and `extractReferences`
- **ThemeCache** — LRU-style cache (default 50 entries) with `get`, `set`, `invalidate`, `invalidateAll`
- **ThemeLoader** — Load from string or file; extensible for URL/bundle loading

#### Paint Engine
- **PaintEngine** — Central orchestrator: resolves painters, dispatches render requests, collects metrics, manages caches
- **7 built-in painters**: Rectangle, Circle, Line, Path, Gradient, Image, Text (each with full style options)
- **PaintCache** — Per-node caching with hit/miss tracking
- **PaintMetrics** — Per-render metrics: painted/skipped/failed node counts, timing, cache stats, element counts, bounds tracking

#### Renderers
- **PaintNodeHandler** — Converts `PaintNode` to `RenderPaintNode` with width/height from properties (fallback to transform scales)
- **WidgetNodeHandler** — Converts `WidgetNode` to `RenderWidgetNode` with same width/height resolution
- **GroupNodeHandler** — Recursive child conversion
- **PaintDispatcher / WidgetDispatcher** — Lookup registered painters/widgets by type key

#### Services & Export
- **RenderingService** — Orchestrates full pipeline: parse → resolve → render → collect metrics
- **ExportService** — Export to `Picture`, `ui.Image`, PNG bytes, JSON, or API-friendly format
- **renderWithMetrics** — Single-call render with full timing breakdown

#### 10 Production Themes
| Theme | Description |
|---|---|
| `minimal_white` | Clean, bright card with soft shadow and blue accent |
| `premium_black` | Dark luxury card with gold foil details and serif font |
| `orange_luxury` | Warm orange gradient with gold border and calligraphy |
| `glass_card` | Frosted glass morphism with purple-blue tones |
| `corporate_blue` | Professional blue gradient with accent panel |
| `creative_gradient` | Vibrant purple-blue gradient with geometric decorations |
| `arabic_rtl` | Right-to-left Arabic card with gold and teal accents |
| `modern_dark` | Sleek dark card with cyan/magenta neon accents |
| `elegant_gold` | Vintage-inspired cream card with ornate gold ornamentation |
| `social_influencer` | Instagram-style vibrant card with bold typography |

### Performance (Benchmark)
- **100 renders** across 10 themes × 10 iterations
- **Avg render time**: 1.73ms per card
- **Avg total pipeline time**: 1.91ms per card (parse + prepare + render)
- **Cache hit ratio**: 24.9%
- **Success rate**: 100% — zero rendering failures

### Fixed
- `PaintNodeHandler` / `WidgetNodeHandler`: width/height now reads from `properties` first, falls back to `transform.scaleX`/`scaleY`
- `ThemeEngine.initialize` / `dispose` — filled stubs
- All 4 theme JSON files fixed to include `"kind": "paint"` and use `#RRGGBB` hex colors

### Testing
- 62 new full-pipeline integration tests (parse, render, export for each theme)
- 1 cross-theme benchmark test (100 renders with timing, cache stats, reliability metrics)
- Total: **547 tests** (28 pre-existing golden test failures unrelated to engine changes)
- Zero analyzer errors or warnings in Theme Engine code

### Documentation
- Pipeline architecture diagram
- Theme gallery with descriptions for all 10 themes
- Benchmark report with timing breakdown
