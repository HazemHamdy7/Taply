# Taply Theme Engine V2 — Architecture Specification

**Status:** Internal Design Document  
**Version:** 2.0.0-draft  
**Author:** Principal Flutter Architect, Rendering Engine Engineering  
**Date:** June 2026  

---

## Table of Contents

1. [System Overview](#1-system-overview)
2. [High-Level Architecture](#2-high-level-architecture)
3. [Folder Structure](#3-folder-structure)
4. [JSON Specification](#4-json-specification)
5. [Layer System](#5-layer-system)
6. [Widget Layer System](#6-widget-layer-system)
7. [Theme Variables](#7-theme-variables)
8. [Responsive Layout Engine](#8-responsive-layout-engine)
9. [Components](#9-components)
10. [Effects System](#10-effects-system)
11. [Animation System](#11-animation-system)
12. [Theme States](#12-theme-states)
13. [Theme Marketplace](#13-theme-marketplace)
14. [Theme Studio](#14-theme-studio)
15. [AI Theme Generator](#15-ai-theme-generator)
16. [Rendering Pipeline](#16-rendering-pipeline)
17. [Extensibility](#17-extensibility)
18. [Performance](#18-performance)
19. [Future Roadmap](#19-future-roadmap)

---

## 1. System Overview

### 1.1 Engine Responsibilities

The Taply Theme Engine V2 is a **declarative, JSON-driven rendering runtime** that transforms structured theme definitions into pixel-perfect business card renderings on a Flutter canvas.

**Core responsibilities:**

- **Parsing** — Convert raw JSON theme definitions into a typed, validated in-memory scene graph
- **Resolution** — Resolve theme variables, inheritance chains, and responsive rules into concrete values
- **Layout** — Compute absolute positions for every layer element using a constraint-based layout solver
- **Rendering** — Paint all layers onto the Flutter canvas through an optimized, layer-sorted pipeline
- **Composition** — Overlay interactive widget layers (text, images, buttons) at computed positions
- **Animation** — Drive timeline-based and interactive animations defined in the theme JSON
- **Caching** — Maintain a multi-level cache (theme, asset, parsed scene) to eliminate redundant work
- **Export** — Provide a pure-canvas rendering pathway that does not depend on the widget tree

### 1.2 Design Philosophy

```
┌──────────────────────────────────────────────────────────────────┐
│                        Design Principles                         │
├──────────────────────────────────────────────────────────────────┤
│                                                                  │
│  1. JSON is the source of truth — Flutter knows nothing about    │
│     card layout; it only executes the scene graph.               │
│                                                                  │
│  2. Every pixel is data-driven — No hardcoded positions, sizes,  │
│     colors, or effects exist in rendering code.                  │
│                                                                  │
│  3. Composition over inheritance — Layers, effects, and          │
│     components compose via a flat, ordered scene graph.          │
│                                                                  │
│  4. Schema-first development — The JSON schema drives the        │
│     engine's capabilities; code follows the schema.              │
│                                                                  │
│  5. Zero knowledge of card semantics — The engine does not know  │
│     what a "business card" is; it renders layers.                │
│                                                                  │
└──────────────────────────────────────────────────────────────────┘
```

### 1.3 Key Architectural Decisions

| Decision | Choice | Rationale |
|---|---|---|
| Rendering target | `CustomPainter` + `Stack` | Paint layers go to Canvas for performance; widget layers overlay on Stack for interactivity |
| Scene graph | Flat ordered list | Avoid tree traversal overhead; layers never need structural changes at runtime |
| Layout system | Constraint-based with anchors | Enables responsive positioning without nested layout passes |
| Variable resolution | Inheritance chain with override layers | Theme authors define defaults once, override per component |
| Serialization | JSON with versioned schema | Forward-compatible, human-editable, language-agnostic |
| Extensibility | Registry pattern | New layer types register themselves; the engine never needs modification |
| Animation | Declarative keyframe timeline | JSON defines timeline; runtime evaluates at 60fps |

### 1.4 Theme Loading Process

```
ThemeRequest (id, version, source)
  → ThemeLoader
    1. Cache check (key = themeId@version) → hit → return SceneGraph
    2. Fetch JSON (bundle / local file / remote URL)
    3. Schema validation against versioned schema
    4. Version compatibility check
    5. Parse → AST (recursive descent)
    6. Reference resolution ($ref)
    7. Variable resolution ($var)
    8. Build SceneGraph (immutable)
    9. Cache result (LRU, max 20 entries)
    → return SceneGraph
```

### 1.5 Rendering Pipeline (High Level)

```
Theme JSON → JSON Parser → Resolver → Scene Graph → Layout Solver
→ Layer Sorter (z-order) → Paint Pipeline (PaintRegistry → Canvas)
→ Widget Pipeline (WidgetRegistry → Stack) → Final Frame
```

---

## 2. High-Level Architecture

### 2.1 Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        TAPLY THEME ENGINE V2                             │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌───────────────────┐     ┌───────────────────┐     ┌───────────────┐  │
│  │   ThemeLoader      │     │   VariableResolver│     │  AssetManager │  │
│  │   - LRU Cache     │     │   - Inheritance   │     │  - Image      │  │
│  │   - Fetch (bundle │     │     Chain         │     │    Cache      │  │
│  │     /file/network)│     │   - Type Coercion │     │  - Font       │  │
│  └────────┬──────────┘     └────────┬──────────┘     │    Cache      │  │
│           │                         │                 │  - SVG Cache  │  │
│           ▼                         ▼                 └───────────────┘  │
│  ┌──────────────────────────────────────────────────────────────────┐    │
│  │               ThemeParser                                         │    │
│  │  JSON Schema Validator → AST Builder → Reference Resolver ($ref) │    │
│  │  → Variable Resolver → SceneGraph Builder → Version Check        │    │
│  └──────────────────────────────┬───────────────────────────────────┘    │
│                                 ▼                                       │
│                        ▼                                                  │
│  ┌────────────────────────────────────────────────┐                      │
│  │           SceneGraph (immutable)                │                      │
│  │  Metadata | Variables | Components | Layers[]   │                      │
│  └─────────────────────┬──────────────────────────┘                      │
│                        ▼                                                  │
│  ┌────────────────────────────────────────────────┐                      │
│  │            LayoutEngine                         │                      │
│  │  Constraint Solver | Anchor Resolver            │                      │
│  │  Responsive Rule Applier                        │                      │
│  └─────────────────────┬──────────────────────────┘                      │
│                        ▼                                                  │
│  ┌────────────────────────────────────────────────┐                      │
│  │            Layer Sorter                         │                      │
│  │  Sort by zIndex, flatten groups                │                      │
│  └─────────────────────┬──────────────────────────┘                      │
│                        ▼                                                  │
│  ┌──────────────────────────────────┐  ┌────────────────────────────┐    │
│  │       Paint Pipeline             │  │     Widget Pipeline         │    │
│  │  PaintRegistry → LayerPainter   │  │  WidgetRegistry → Widget   │    │
│  │  EffectApplier                   │  │  Positioned in Stack        │    │
│  └──────────────────────────────────┘  └──────────┬─────────────────┘    │
│                        │                         │                        │
│                        ▼                         ▼                        │
│  ┌────────────────────────────────────────────────┐                      │
│  │           Composite Frame Builder               │                      │
│  │  ClipRRect → Stack(CustomPaint, widgets[])     │                      │
│  └────────────────────────────────────────────────┘                      │
│                                                                          │
│  ┌────────────────────────────────────────────────┐                      │
│  │           AnimationController                   │                      │
│  │  Timeline | Easing | Event Triggers            │                      │
│  └────────────────────────────────────────────────┘                      │
│                                                                          │
└─────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Module Descriptions

| Module | Responsibility |
|---|---|
| **ThemeLoader** | Load, cache, serve theme definitions. Sources: bundle assets, local files, remote URLs. LRU cache with 20-entry max. |
| **ThemeParser** | Multi-phase pipeline: schema validation → AST construction → reference resolution → variable resolution → SceneGraph assembly. Produces structured ParseError objects. |
| **VariableResolver** | Walks inheritance chain (layer → component → theme → base) to resolve all `$var` references. Detects circular references. Coerces types on use. |
| **FieldResolver** | Resolves business data field bindings (`$field.*`) to concrete values from the user's card data. Field-agnostic — accepts any key. |
| **AssetManager** | Manages external assets: images (wraps cached_network_image), fonts (pre-loads custom fonts), SVGs (parses to ui.Path, cached). |
| **ThemeCache** | LRU cache for parsed ThemeData and SceneGraph objects. 20-entry max. Invalidated on version change or explicit clear. |
| **ThemeValidator** | Validates theme structure, semantic integrity, reference integrity. Produces typed validation errors with severity levels. Supports auto-fix. |
| **SceneGraph** | Immutable typed container: metadata, variables, components, layers (paint/widget/group), animations, responsive rules. Thread-safe, deterministic. |
| **LayoutEngine** | Constraint-based layout solver. Resolves absolute/relative/percentage/anchor constraints to pixel Rects. Applies responsive rules and safe areas. |
| **PaintRegistry** | Maps paint layer type strings to LayerPainter implementations. Plugins register new painters here. |
| **WidgetRegistry** | Maps widget layer type strings to WidgetBuilder implementations. Plugins register new widgets here. |
| **ComponentRegistry** | Stores and resolves reusable component definitions. Supports nesting, slots, and parameter overrides. |
| **EffectRegistry** | Maps effect type strings to EffectPainter implementations. Supports composite effects (neumorphism, glassmorphism). |
| **Renderer** | Orchestrates layout, paint, and widget pipelines. Accepts SceneGraph + render size → produces rendered frame. |
| **RenderPipeline** | Two-phase pipeline: paint layers (CustomPainter) followed by widget overlay (Stack). Optimized via repaint boundaries and compositing layers. |
| **ExportPipeline** | Headless render pathway: SceneGraph → LayoutEngine → PaintPipeline → image/PDF/SVG output. No widget tree dependency. |
| **AnimationController** | Drives timeline-based and interactive animations. Evaluates keyframes, easing curves, and triggers at 60fps. Supports tween, spring, sequence, and parallel compositions. |
| **CompositeFrameBuilder** | Assembles final tree: ClipRRect → SizedBox → Stack(CustomPaint, positioned widgets). |

---

## 3. Folder Structure

```
lib/
└── theme_engine/
    ├── engine/
    │   ├── engine.dart                    # Barrel export
    │   ├── theme_engine.dart             # Top-level orchestrator
    │   ├── animation/
    │   │   ├── animation_controller.dart
    │   │   ├── animation_registry.dart
    │   │   ├── interpolators.dart
    │   │   ├── keyframe_evaluator.dart
    │   │   ├── easing.dart
    │   │   └── triggers.dart
    │   ├── loader/
    │   │   ├── theme_loader.dart
    │   │   ├── theme_cache.dart
    │   │   ├── theme_fetcher.dart
    │   │   └── theme_request.dart
    │   ├── parser/
    │   │   ├── json_parser.dart
    │   │   ├── schema_validator.dart
    │   │   ├── ast_builder.dart
    │   │   ├── reference_resolver.dart
    │   │   ├── variable_resolver.dart
    │   │   ├── scene_graph_builder.dart
    │   │   ├── parse_error.dart
    │   │   └── version_compatibility.dart
    │   ├── resolver/
    │   │   ├── variable_resolver.dart
    │   │   ├── inheritance_chain.dart
    │   │   └── type_coercion.dart
    │   └── scene_graph/
    │       ├── scene_graph.dart
    │       ├── layer_node.dart
    │       ├── paint_layer_node.dart
    │       ├── widget_layer_node.dart
    │       ├── group_node.dart
    │       ├── component_node.dart
    │       ├── theme_metadata.dart
    │       ├── variable_map.dart
    │       └── animation_node.dart
    │
    ├── renderer/
    │   ├── renderer.dart
    │   ├── card_renderer.dart
    │   ├── composite_frame_builder.dart
    │   ├── layout/
    │   │   ├── layout_engine.dart
    │   │   ├── constraint_solver.dart
    │   │   ├── constraint.dart
    │   │   ├── anchor_resolver.dart
    │   │   ├── responsive_rule_applier.dart
    │   │   ├── layout_context.dart
    │   │   └── percentage_converter.dart
    │   ├── painters/
    │   │   ├── layer_painter.dart
    │   │   ├── paint_registry.dart
    │   │   ├── paint_context.dart
    │   │   ├── rect_painter.dart
    │   │   ├── circle_painter.dart
    │   │   ├── oval_painter.dart
    │   │   ├── rounded_rect_painter.dart
    │   │   ├── polygon_painter.dart
    │   │   ├── triangle_painter.dart
    │   │   ├── hexagon_painter.dart
    │   │   ├── diamond_painter.dart
    │   │   ├── bezier_path_painter.dart
    │   │   ├── arc_painter.dart
    │   │   ├── svg_painter.dart
    │   │   ├── image_painter.dart
    │   │   ├── gradient_painter.dart
    │   │   ├── noise_painter.dart
    │   │   ├── carbon_painter.dart
    │   │   ├── wave_painter.dart
    │   │   ├── blob_painter.dart
    │   │   ├── circuit_painter.dart
    │   │   ├── grid_painter.dart
    │   │   ├── dots_painter.dart
    │   │   ├── particles_painter.dart
    │   │   ├── sparkles_painter.dart
    │   │   ├── border_painter.dart
    │   │   ├── decorative_shape_painter.dart
    │   │   ├── qr_frame_painter.dart
    │   │   ├── clip_path_painter.dart
    │   │   └── mask_painter.dart
    │   ├── effects/
    │   │   ├── effect.dart
    │   │   ├── effect_applier.dart
    │   │   ├── effect_registry.dart
    │   │   ├── blur_effect.dart
    │   │   ├── backdrop_blur_effect.dart
    │   │   ├── glass_effect.dart
    │   │   ├── glow_effect.dart
    │   │   ├── shadow_effect.dart
    │   │   ├── inner_shadow_effect.dart
    │   │   ├── gradient_overlay_effect.dart
    │   │   ├── noise_effect.dart
    │   │   ├── opacity_effect.dart
    │   │   └── blend_mode_effect.dart
    │   └── widgets/
    │       ├── widget_factory.dart
    │       ├── widget_registry.dart
    │       ├── widget_layer_context.dart
    │       ├── avatar_widget.dart
    │       ├── company_logo_widget.dart
    │       ├── qr_code_widget.dart
    │       ├── name_widget.dart
    │       ├── job_title_widget.dart
    │       ├── company_widget.dart
    │       ├── tagline_widget.dart
    │       ├── phone_widget.dart
    │       ├── email_widget.dart
    │       ├── website_widget.dart
    │       ├── address_widget.dart
    │       ├── social_icons_widget.dart
    │       ├── nfc_badge_widget.dart
    │       ├── statistics_widget.dart
    │       ├── button_widget.dart
    │       ├── divider_widget.dart
    │       ├── glass_card_widget.dart
    │       ├── contact_block_widget.dart
    │       └── footer_widget.dart
    │
    ├── components/
    │   ├── component_registry.dart
    │   ├── component_parser.dart
    │   ├── component_resolver.dart
    │   ├── built_in/
    │   │   ├── profile_header_component.dart
    │   │   ├── company_header_component.dart
    │   │   ├── contact_section_component.dart
    │   │   ├── social_section_component.dart
    │   │   ├── footer_component.dart
    │   │   ├── statistics_section_component.dart
    │   │   └── qr_section_component.dart
    │   └── composition/
    │       ├── component_composer.dart
    │       └── slot.dart
    │
    ├── models/
    │   ├── theme_definition.dart
    │   ├── layer_definition.dart
    │   ├── paint_layer_definition.dart
    │   ├── widget_layer_definition.dart
    │   ├── component_definition.dart
    │   ├── animation_definition.dart
    │   ├── variable_definition.dart
    │   ├── responsive_rule.dart
    │   ├── constraint_definition.dart
    │   ├── effect_definition.dart
    │   └── asset_manifest.dart
    │
    ├── json/
    │   ├── schemas/
    │   │   ├── theme_schema_v2.json
    │   │   ├── theme_schema_v3.json
    │   │   ├── layer_schema.json
    │   │   └── effect_schema.json
    │   └── codecs/
    │       ├── scene_graph_codec.dart
    │       ├── theme_codec.dart
    │       └── variable_codec.dart
    │
    ├── themes/
    │   ├── theme_manager.dart
    │   ├── theme_validator.dart
    │   ├── theme_migration.dart
    │   └── template_pack.dart
    │
    ├── extensions/
    │   ├── color_extensions.dart
    │   ├── string_extensions.dart
    │   ├── alignment_extensions.dart
    │   └── offset_extensions.dart
    │
    ├── utils/
    │   ├── logging.dart
    │   ├── clock.dart
    │   ├── throttler.dart
    │   ├── metrics.dart
    │   └── assertions.dart
    │
    └── exports/
        └── export_renderer.dart
```

### 3.1 Folder Descriptions

| Folder | Purpose |
|---|---|
| `engine/` | Core engine — loading, parsing, resolving, scene graph, animation |
| `engine/loader/` | Theme loading from all sources with LRU caching |
| `engine/parser/` | Multi-phase JSON parsing pipeline |
| `engine/resolver/` | Variable and inheritance resolution |
| `engine/scene_graph/` | Immutable typed representation of a rendered theme |
| `engine/animation/` | Animation timeline, keyframes, easing, triggers |
| `renderer/` | Rendering — layout, paint, widgets, effects |
| `renderer/layout/` | Constraint-based layout solver |
| `renderer/painters/` | All paint layer types (one file per type) |
| `renderer/effects/` | All visual effects (one file per effect) |
| `renderer/widgets/` | All widget layer types (one file per type) |
| `components/` | Reusable component definitions and built-in components |
| `models/` | Plain data classes representing JSON structure |
| `json/` | JSON schemas for validation and codecs for serialization |
| `themes/` | Theme lifecycle management |
| `extensions/` | Dart extension methods for type parsing |
| `utils/` | Shared utilities |
| `exports/` | Canvas-only export path (no widget tree) |

---

## 4. JSON Specification

### 4.1 Document Structure

```jsonc
{
  "$schema": "https://taply.ai/schemas/theme/v2.json",
  "schemaVersion": "2.0.0",

  "id": "luxury_black_gold",
  "name": "Luxury Black & Gold",
  "description": "Premium dark theme with gold accents",
  "author": "Taply Studio",
  "version": "1.2.0",

  "canvas": { "width": 1000, "height": 600, "clipRadius": 24 },

  "variables": { /* ... */ },
  "assets": { /* ... */ },
  "definitions": { /* ... */ },
  "components": { /* ... */ },

  "layers": [ /* ... */ ],
  "animations": [ /* ... */ ],
  "responsive": [ /* ... */ ]
}
```

### 4.2 Metadata

| Field | Type | Required | Description |
|---|---|---|---|
| `$schema` | string | no | URL to schema definition |
| `schemaVersion` | string | **yes** | Semver of schema this theme targets |
| `id` | string | **yes** | Unique kebab-case identifier |
| `name` | string | **yes** | Human-readable name |
| `version` | string | **yes** | Version of this theme (semver) |
| `category` | string | no | Theme category |
| `tags` | string[] | no | Search tags |
| `preview` | string | no | Preview image path or URL |
| `minEngineVersion` | string | no | Minimum required engine version |
| `maxEngineVersion` | string | no | Maximum supported engine version |

### 4.3 Canvas

```jsonc
"canvas": {
  "width": 1000,
  "height": 600,
  "aspectRatio": "5:3",
  "clipRadius": 24,
  "clipShape": "rounded_rectangle",
  "backgroundColor": "#FFFFFF",
  "safeAreas": { "top": 20, "bottom": 20, "left": 20, "right": 20 },
  "orientation": "landscape",
  "variants": [
    {
      "id": "portrait_compact",
      "width": 600,
      "height": 1000,
      "responsive": [ /* overrides for this variant */ ]
    }
  ]
}
```

**Design-space canvas rationale:** All coordinates use design-space units (default 1000×600). The engine scales uniformly to actual render size. This decouples design from device resolution.

### 4.4 Variables

```jsonc
"variables": {
  "colors": {
    "primary": "#1A1A2E",
    "accent": "#D4AF37",
    "textPrimary": "#FFFFFF",
    "textSecondary": "rgba(255,255,255,0.7)"
  },
  "spacing": { "xs": 4, "sm": 8, "md": 16, "lg": 24, "xl": 32 },
  "radius": { "sm": 4, "md": 8, "lg": 16, "xl": 24, "full": 999 },
  "typography": {
    "name": { "fontFamily": "Playfair Display", "fontSize": 32, "fontWeight": "700" }
  },
  "shadows": {
    "card": { "color": "rgba(0,0,0,0.3)", "offset": { "dx": 0, "dy": 8 }, "blurRadius": 24 }
  },
  "durations": { "fast": 150, "normal": 300, "slow": 500 },
  "opacity": { "disabled": 0.38, "medium": 0.74 }
}
```

### 4.5 Assets

```jsonc
"assets": {
  "images": [
    {
      "id": "bg_pattern",
      "src": "assets/images/gold_pattern.png",
      "type": "png",
      "fit": "cover"
    }
  ],
  "fonts": [
    { "family": "Playfair Display", "src": "assets/fonts/PlayfairDisplay-Regular.ttf", "weight": 400 }
  ],
  "definitions": {
    "gold_gradient": {
      "kind": "linear",
      "colors": ["#D4AF37", "#F0D78C", "#B8860B"],
      "angle": 135
    }
  }
}
```

### 4.6 Layer Base Structure

```jsonc
{
  "id": "unique_id",
  "type": "rectangle",
  "zIndex": 0,
  "visible": true,
  "opacity": 1.0,
  "blendMode": "srcOver",

  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" },

  "fill": { "kind": "linear", "colors": ["#1A1A2E", "#16213E"], "angle": 180 },

  "stroke": { "color": "#D4AF37", "width": 2, "style": "solid", "dashPattern": [8, 4] },

  "borderRadius": { "topLeft": 0, "topRight": 0, "bottomLeft": 0, "bottomRight": 0 },

  "effects": [ { "type": "shadow", "params": { "color": "rgba(0,0,0,0.2)", "offset": { "dx": 0, "dy": 4 }, "blur": 12 } } ],

  "animations": { "entry": { "type": "fadeIn", "duration": 300, "delay": 0 } }
}
```

### 4.7 Widget Layer Structure

```jsonc
{
  "id": "user_name",
  "type": "name",
  "zIndex": 100,
  "constraints": { "left": 40, "top": 80, "right": 40, "height": 40 },
  "field": "fullName",
  "style": { "typography": "$var.typography.name", "textAlign": "left", "maxLines": 1, "overflow": "ellipsis" },
  "placeholder": "Your Name",
  "conditional": { "hideIfEmpty": false }
}
```

### 4.8 Animation Structure

```jsonc
{
  "type": "timeline",
  "id": "card_entry",
  "trigger": "onLoad",
  "duration": 600,
  "loop": false,
  "yoyo": false,
  "tracks": [
    {
      "target": "bg_rect",
      "property": "opacity",
      "keyframes": [
        { "time": 0, "value": 0 },
        { "time": 0.3, "value": 1, "ease": "easeOut" }
      ]
    },
    {
      "target": "user_name",
      "property": "translateY",
      "keyframes": [
        { "time": 0, "value": 20 },
        { "time": 0.5, "value": 0, "ease": "cubicBezier(0.25, 0.1, 0.25, 1.0)" }
      ]
    }
  ]
}
```

### 4.9 Responsive Rules

```jsonc
"responsive": [
  {
    "id": "compact",
    "conditions": { "maxWidth": 360 },
    "overrides": [
      { "target": "user_name", "style": { "fontSize": 22 } },
      { "target": "contact_section", "constraints": { "left": 16, "top": 200, "right": 16 } }
    ]
  }
]
```

**Conditions:** `minWidth`, `maxWidth`, `minHeight`, `maxHeight`, `orientation`, `platform`, `themeMode`. Multiple conditions are AND-ed.

### 4.10 Theme Versioning

- `schemaVersion` follows semver (`MAJOR.MINOR.PATCH`).
- **MAJOR** — breaking changes; engine rejects incompatible versions.
- **MINOR** — backward-compatible additions; engine ignores unknown fields.
- **PATCH** — fixes to schema documentation or validation rules.
- The engine ships with `version_compatibility.dart` mapping version ranges to migration functions.
- Lower version themes are upgraded in-memory via migration functions.
- Higher versions log a warning and attempt forward-compatible parsing.

---

## 5. Layer System

### 5.1 Design Overview

Layers are **self-contained rendering units** in a flat ordered list. Every type implements the same interface:

```dart
// Conceptual interface (NOT Dart code)
interface LayerPainter {
  void paint(Canvas canvas, Rect resolvedRect, PaintContext context);
}
```

Each painter is registered in `PaintRegistry` via a factory function. The engine loops through sorted layers and delegates painting to the appropriate registered painter.

### 5.2 Layer Types

| Category | Layer Types | Notes |
|---|---|---|
| **Primitive Shapes** | rectangle, circle, oval, rounded_rectangle, polygon, triangle, hexagon, diamond | Basic Canvas draw operations. O(1) each. |
| **Path Shapes** | bezier_path, arc, line | SVG path strings, circular arcs, and straight lines. Cache parsed paths. |
| **Gradients** | linear_gradient, radial_gradient, sweep_gradient, mesh_gradient | Procedural gradient fills. Mesh gradient pre-renders to ui.Image cache. |
| **Images** | svg, image | Raster and vector images via AssetManager. |
| **Textures** | noise, paper_texture, fabric_texture, carbon_fiber | Procedural background textures. Pre-render to ui.Image cache. |
| **Glass/Blur** | glass, glass_panel, backdrop_blur, blur | BackdropFilter effects. Uses saveLayer. Expensive — limit to 0-2 per card. |
| **Organic** | wave, blob, organic_shapes | Sine waves, metaball-like organic shapes, and generic organics. Cache paths. |
| **Glow/Shadow** | glow, outer_glow, shadow, inner_shadow | MaskFilter-based effects via saveLayer. |
| **Patterns** | circuit_pattern, grid, floating_dots | Procedural repeating patterns. |
| **Particles** | particles, sparkles | Dynamic particle systems with optional animation. |
| **Decorative** | premium_border, decorative_shapes, qr_frame, avatar_border, logo | High-value visual elements for premium cards. |
| **Mask/Clip** | mask, clip_path | Canvas clipping and alpha/luminance masking. |
| **Composite** | opacity, blend_mode | Layer compositing controls. |
| **Transform** | transform, rotation, scale | Layer geometric transformations. |
| **Repeat/Tile** | repeat, tile | Pattern repetition and tiling. |

### 5.3 Primitive Shapes

#### 5.3.1 Rectangle
**Purpose:** Solid or stroked rectangle, typically for backgrounds.
**Performance:** `Canvas.drawRect` — O(1). Border radius uses `Canvas.drawDRRect`.

```jsonc
{
  "type": "rectangle",
  "id": "main_bg",
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" },
  "fill": { "kind": "linear", "colors": ["#0F0F1A", "#1A1A2E"], "angle": 180 },
  "borderRadius": { "bottomLeft": 16, "bottomRight": 16 },
  "stroke": { "color": "rgba(255,255,255,0.08)", "width": 1 }
}
```

#### 5.3.2 Circle
**Purpose:** Perfect circle for decorative dots, avatar backgrounds, accent elements.
**Performance:** `Canvas.drawCircle` — O(1).

```jsonc
{
  "type": "circle",
  "id": "accent_dot",
  "constraints": { "centerX": 500, "centerY": 300, "width": 80, "height": 80 },
  "fill": { "kind": "radial", "colors": ["rgba(212,175,55,0.3)", "transparent"] }
}
```

#### 5.3.3 Oval
**Purpose:** Elliptical shape for decorative backgrounds, organic accent areas.

```jsonc
{
  "type": "oval",
  "id": "glow_ellipse",
  "constraints": { "centerX": 800, "centerY": 300, "width": 400, "height": 200 },
  "fill": { "kind": "radial", "colors": ["rgba(212,175,55,0.08)", "transparent"] }
}
```

#### 5.3.4 Rounded Rectangle
**Purpose:** Rectangle with per-corner rounding for cards, panels, buttons.

```jsonc
{
  "type": "rounded_rectangle",
  "id": "glass_card",
  "constraints": { "left": 40, "top": 40, "right": 40, "bottom": 40 },
  "fill": { "kind": "solid", "color": "rgba(255,255,255,0.06)" },
  "borderRadius": { "topLeft": 16, "topRight": 16, "bottomLeft": 16, "bottomRight": 16 }
}
```

#### 5.3.5 Polygon
**Purpose:** Generic N-sided polygon for decorative geometric elements.

```jsonc
{
  "type": "polygon",
  "id": "deco_hex",
  "constraints": { "centerX": 200, "centerY": 200, "width": 60, "height": 60 },
  "params": { "sides": 6, "rotation": 15 },
  "fill": { "kind": "solid", "color": "$var.colors.accent" },
  "opacity": 0.3
}
```

#### 5.3.6 Triangle
**Purpose:** Equilateral triangle for directional arrows, decorative accents.

```jsonc
{
  "type": "triangle",
  "id": "accent_arrow",
  "constraints": { "left": 60, "top": 120, "width": 16, "height": 16 },
  "params": { "direction": "right" },
  "fill": { "kind": "solid", "color": "$var.colors.accent" }
}
```

#### 5.3.7 Hexagon
**Purpose:** Six-sided polygon for modern geometric layouts, honeycomb patterns. Implemented as polygon with sides:6.

```jsonc
{
  "type": "hexagon",
  "id": "honeycomb_bg",
  "constraints": { "centerX": 500, "centerY": 300, "width": 200, "height": 173 },
  "fill": { "kind": "solid", "color": "rgba(255,255,255,0.03)" }
}
```

#### 5.3.8 Diamond
**Purpose:** Rotated square (45°) for luxury accents, jewelry-style elements.

```jsonc
{
  "type": "diamond",
  "id": "jewel_accent",
  "constraints": { "centerX": 900, "centerY": 80, "width": 24, "height": 24 },
  "fill": { "kind": "solid", "color": "$var.colors.accent" }
}
```

### 5.4 Path Shapes

#### 5.4.1 Bezier Path
**Purpose:** Arbitrary cubic/quadratic bezier paths for custom decorative shapes.

```jsonc
{
  "type": "bezier_path",
  "id": "ribbon",
  "params": {
    "d": "M 0,500 C 200,450 300,550 500,500 C 700,450 800,550 1000,500 L 1000,600 L 0,600 Z"
  },
  "fill": { "kind": "solid", "color": "rgba(212,175,55,0.12)" }
}
```

#### 5.4.2 Arc
**Purpose:** Circular arc or pie slice for gauge elements, decorative sweeps.

```jsonc
{
  "type": "arc",
  "id": "deco_sweep",
  "constraints": { "centerX": 500, "centerY": 300, "width": 400, "height": 400 },
  "params": { "startAngle": -45, "sweepAngle": 90, "useCenter": false },
  "stroke": { "color": "$var.colors.accent", "width": 2 }
}
```

#### 5.4.3 SVG
**Purpose:** Render SVG vector files for complex logos, icons, intricate decorations.

```jsonc
{
  "type": "svg",
  "id": "brand_logo",
  "params": { "src": "assets/icons/brand_logo.svg", "color": "$var.colors.accent", "fit": "contain" }
}
```

### 5.5 Image Layers

#### 5.5.1 Image
**Purpose:** Raster image rendering for backgrounds, patterns, user photos.

```jsonc
{
  "type": "image",
  "id": "user_photo",
  "params": { "src": "$field.avatar", "fit": "cover", "borderRadius": 50 }
}
```

### 5.6 Texture / Effect Layers

#### 5.6.1 Mesh Gradient
**Purpose:** Advanced multi-point gradient with control points (Figma-style mesh gradient).

```jsonc
{
  "type": "mesh_gradient",
  "id": "premium_bg",
  "params": {
    "points": [
      { "x": 0, "y": 0, "color": "#0F0F1A" },
      { "x": 0.5, "y": 0.5, "color": "#D4AF37" },
      { "x": 1, "y": 1, "color": "#0F0F1A" }
    ],
    "blur": 0.3
  }
}
```

#### 5.6.2 Noise Texture
**Purpose:** Perlin/simplex noise overlay for paper texture, film grain.

```jsonc
{
  "type": "noise",
  "id": "paper_texture",
  "params": { "seed": 12345, "scale": 2, "opacity": 0.04, "octaves": 3 }
}
```

#### 5.6.3 Carbon Texture
**Purpose:** Carbon fiber weave pattern for sporty/industrial themes.

```jsonc
{
  "type": "carbon_fiber",
  "id": "carbon_bg",
  "params": { "scale": 1.5, "color": "#1A1A2E", "highlight": "#2A2A4E", "opacity": 0.5 }
}
```

### 5.7 Glass / Blur Layers

#### 5.7.1 Glass Layer
**Purpose:** Glassmorphism — blurred, semi-transparent surface with subtle border.

```jsonc
{
  "type": "glass",
  "id": "info_panel",
  "params": {
    "blur": 16,
    "tint": "rgba(212,175,55,0.08)",
    "borderOpacity": 0.15,
    "borderRadius": 16
  }
}
```

#### 5.7.2 Blur Layer
**Purpose:** Simple gaussian blur of content beneath.

```jsonc
{
  "type": "blur",
  "id": "depth_bg",
  "params": { "sigmaX": 8, "sigmaY": 8 }
}
```

### 5.8 Organic Shapes

#### 5.8.1 Wave
**Purpose:** Sine wave pattern for wavy dividers, flowing backgrounds.

```jsonc
{
  "type": "wave",
  "id": "wave_divider",
  "params": { "amplitude": 15, "frequency": 2, "phase": 0, "direction": "horizontal" },
  "fill": { "kind": "solid", "color": "$var.colors.accent" },
  "opacity": 0.15
}
```

#### 5.8.2 Blob
**Purpose:** Organic blob shape (metaball-like) for modern backgrounds.

```jsonc
{
  "type": "blob",
  "id": "organic_accent",
  "params": { "points": 8, "seed": 42, "smoothness": 0.4 },
  "fill": { "kind": "solid", "color": "rgba(212,175,55,0.06)" }
}
```

### 5.9 Glow / Shadow Effects

#### 5.9.1 Glow
**Purpose:** Outer/inner glow effect on elements.

```jsonc
{
  "type": "glow",
  "id": "glow_effect",
  "applyTo": "user_name",
  "params": { "color": "$var.colors.accent", "radius": 16, "opacity": 0.4, "style": "outer" }
}
```

#### 5.9.2 Shadow / Inner Shadow / Outer Shadow
**Purpose:** Drop shadows for depth and elevation.

```jsonc
{
  "type": "shadow",
  "id": "card_shadow",
  "applyTo": "glass_panel",
  "params": { "color": "rgba(0,0,0,0.3)", "offset": { "dx": 0, "dy": 8 }, "blurRadius": 24, "style": "outer" }
}

{
  "type": "inner_shadow",
  "id": "inset_shadow",
  "applyTo": "avatar_border",
  "params": { "color": "rgba(0,0,0,0.4)", "offset": { "dx": 0, "dy": 2 }, "blurRadius": 4 }
}
```

### 5.10 Pattern Layers

#### 5.10.1 Circuit Pattern
**Purpose:** Circuit board trace pattern for tech-themed cards.

```jsonc
{
  "type": "circuit_pattern",
  "id": "tech_bg",
  "params": { "density": 0.3, "color": "rgba(0,150,255,0.06)", "seed": 99 }
}
```

#### 5.10.2 Grid
**Purpose:** Ruled grid overlay for blueprint/minimal layouts.

```jsonc
{
  "type": "grid",
  "id": "blueprint_grid",
  "params": { "stepX": 50, "stepY": 50, "color": "rgba(255,255,255,0.04)", "strokeWidth": 0.5, "style": "lines" }
}
```

#### 5.10.3 Floating Dots
**Purpose:** Scattered dots for ambient backgrounds, cosmic themes.

```jsonc
{
  "type": "floating_dots",
  "id": "ambient_dots",
  "params": { "count": 200, "minRadius": 1, "maxRadius": 4, "color": "$var.colors.accent", "opacity": 0.15, "seed": 7 }
}
```

### 5.11 Particle Systems

#### 5.11.1 Particles
**Purpose:** Dynamic particle field with optional animation for premium animated backgrounds.

```jsonc
{
  "type": "particles",
  "id": "star_field",
  "params": {
    "count": 150, "minRadius": 0.5, "maxRadius": 3,
    "color": "$var.colors.accent", "alpha": 0.5, "seed": 42,
    "animated": true, "driftSpeed": 5, "driftDirection": 270, "glow": true
  }
}
```

#### 5.11.2 Sparkles
**Purpose:** Star/sparkle decorative elements for luxury themes.

```jsonc
{
  "type": "sparkles",
  "id": "luxury_sparkles",
  "params": {
    "count": 30, "size": 8, "color": "$var.colors.accent", "opacity": 0.6, "seed": 7,
    "animated": true, "twinkleSpeed": 1
  }
}
```

### 5.12 Premium Decorative Layers

#### 5.12.1 Premium Borders
**Purpose:** Elaborate decorative borders — gold frames, filigree, art deco.

```jsonc
{
  "type": "premium_border",
  "id": "gold_frame",
  "params": { "style": "art_deco", "color": "$var.colors.accent", "width": 2, "inset": 16, "cornerStyle": "ornament" }
}
```

#### 5.12.2 Decorative Shapes
**Purpose:** Chevrons, brackets, flourishes, dot lines, corner accents.

```jsonc
{
  "type": "decorative_shapes",
  "id": "chevron_divider",
  "params": { "shape": "chevron", "color": "$var.colors.accent", "size": 12, "count": 3 }
}
```

#### 5.12.3 QR Frame
**Purpose:** Decorative frame around QR code.

```jsonc
{
  "type": "qr_frame",
  "id": "qr_frame",
  "params": {
    "shape": "rounded_rectangle", "padding": 12, "borderRadius": 16,
    "fill": { "kind": "solid", "color": "rgba(255,255,255,0.05)" },
    "stroke": { "color": "$var.colors.accent", "width": 1 },
    "label": "Scan to connect", "labelPosition": "bottom"
  }
}
```

### 5.13 Avatar Border

```jsonc
{
  "type": "avatar_border",
  "id": "avatar_frame",
  "params": { "shape": "circle", "width": 3, "color": "$var.colors.accent", "style": "gradient", "padding": 2 }
}
```

### 5.14 Logo

```jsonc
{
  "type": "logo",
  "id": "company_logo",
  "params": {
    "src": "$field.companyLogo", "fit": "contain", "shape": "rounded_rectangle",
    "fallback": { "type": "text", "initials": "$field.companyName" }
  }
}
```

### 5.15 Mask / Clip

#### 5.15.1 Mask
**Purpose:** Alpha/luminance mask controlling visibility of layers beneath.

```jsonc
{
  "type": "mask",
  "id": "fade_mask",
  "params": {
    "source": { "type": "gradient", "colors": ["black", "transparent", "transparent", "black"], "angle": 90 },
    "mode": "alpha",
    "layers": ["bg_deco", "particles"]
  }
}
```

#### 5.15.2 Clip Path
**Purpose:** Clip rendering to a specific path for creative cropping.

```jsonc
{
  "type": "clip_path",
  "id": "diagonal_clip",
  "params": { "path": "M 0,0 L 1000,0 L 1000,300 L 0,600 Z", "clipBehavior": "antiAlias" }
}
```

### 5.16 Composite Effects

#### 5.16.1 Opacity
```jsonc
// As layer property or effect
{ "type": "opacity", "params": { "value": 0.5 }, "applyTo": "layer_id" }
```

#### 5.16.2 Blend Modes
**Supported:** srcOver, screen, overlay, darken, lighten, multiply, colorDodge, colorBurn, hardLight, softLight, difference, exclusion, hue, saturation, color, luminosity, and all Porter-Duff modes.

```jsonc
{
  "type": "blend_mode",
  "id": "overlay_accent",
  "params": { "mode": "overlay", "fill": { "kind": "solid", "color": "$var.colors.accent" } }
}
```

---

## 6. Widget Layer System

### 6.1 Design Overview

Widget layers are **Flutter widgets overlaid on top of the CustomPaint canvas**. They preserve native text selection, accessibility, and hit testing. Every type implements:

```dart
// Conceptual interface (NOT Dart code)
interface WidgetBuilder {
  Widget build(WidgetLayerContext context);
}
```

### 6.2 Widget Layer Catalog

| Widget Type | Field(s) | Purpose |
|---|---|---|
| `avatar` | avatar | Profile photo with shape/border/fallback |
| `logo` | companyLogo | Company logo with shape/border/fallback |
| `qr` | — (auto) | QR code encoding user's vCard |
| `name` | fullName | Contact name |
| `jobTitle` | jobTitle | Professional title |
| `company` | companyName | Company/organization |
| `tagline` | tagline | Tagline/slogan |
| `phone` | phone, mobileNumber, whatsappNumber | Phone with icon and tap-to-call |
| `email` | email | Email with icon and tap-to-email |
| `website` | website | Website with icon and tap-to-open |
| `address` | address | Physical address with icon |
| `socialIcons` | social fields | Social media icon row/column |
| `badges` | — | Status badges and indicators (NFC, premium, verified, etc.) |
| `statistics` | view stats | Engagement statistics display |
| `buttons` | — | CTA buttons (add contact, share, etc.) |
| `divider` | — | Visual separator |
| `glassCard` | — | Glassmorphism container for children |
| `contactBlock` | contact fields | Structured contact section |
| `footer` | — | Bottom branding/tagline section |

### 6.3 Field Name Reference

| JSON key | Data Source |
|---|---|
| `fullName`, `firstName`, `lastName` | User's name |
| `jobTitle` | Professional title |
| `companyName` | Company/organization |
| `tagline` | Slogan/tagline |
| `email` | Email address |
| `phone`, `phone2`, `whatsappNumber` | Phone numbers |
| `website` | Website URL |
| `address` | Physical address |
| `linkedin`, `facebook`, `instagram`, `twitter`, `youtube`, `tiktok`, `snapchat`, `telegram`, `github`, `behance`, `dribbble`, `pinterest`, `medium` | Social media URLs |
| `avatar` | Profile image |
| `companyLogo` | Company logo image |
| `coverImage` | Card cover image |

Fields not in this list are passed through as-is. The engine binds field keys to values from `WidgetLayerContext` without knowledge of what a "card" is.

---

## 7. Theme Variables

### 7.1 Purpose

Reusable design tokens referenced throughout the theme JSON. Provides consistency, maintainability, and inheritance.

### 7.2 Categories

| Category | Example | Type |
|---|---|---|
| `colors` | `"#D4AF37"` / `"rgba(...)"` | Color |
| `spacing` | `16` | double |
| `radius` | `12` | double |
| `typography` | `{ fontFamily, fontSize, ... }` | TextStyle |
| `shadows` | `{ color, offset, blurRadius }` | ShadowDefinition |
| `durations` | `300` | int (ms) |
| `opacity` | `0.5` | double |

### 7.3 Reference Syntax

`$var.colors.primary`, `$var.typography.heading`, `$var.spacing.lg`

### 7.4 Resolution Algorithm

```
resolve(variable, context):
  1. Layer-local overrides → if found, return
  2. Component variables → if found, return
  3. Theme-level variables → if found, return
  4. Base theme defaults → if found, return
  5. Unresolved: log warning, return default for type
```

### 7.5 Override System

Variables can be overridden at theme level, component level, and layer level. The resolution chain is: Layer → Component → Theme → Base Theme.

### 7.6 Type Inference

Variables are typed by inference from their JSON value shape, not declaration. If a color variable is used where a number is expected, the resolver reports a type mismatch error.

---

## 8. Responsive Layout Engine

### 8.1 Constraint Types

| Field | Type | Description |
|---|---|---|
| `left`, `top`, `right`, `bottom` | number / string / null | Edge distances |
| `width`, `height` | number / string / null | Explicit dimensions |
| `centerX`, `centerY` | number / string / null | Center anchors |
| `minWidth`, `maxWidth` | number | Clamping |
| `minHeight`, `maxHeight` | number | Clamping |
| `aspectRatio` | number | Width/height ratio enforcement |

Values can be: fixed number, percentage string (`"50%"`), or null (derived from other constraints).

### 8.2 Layout Modes

- **Absolute:** `{ left: 40, top: 80, width: 200, height: 40 }`
- **Relative (fill):** `{ left: 40, top: 80, right: 40, height: 40 }` → width = parentWidth - 80
- **Fill (All Edges):** `{ left: 40, top: 40, right: 40, bottom: 40 }` → stretches to fill all available space
- **Percentage:** `{ left: "10%", top: "10%", width: "80%", height: "80%" }`
- **Center:** `{ centerX: 500, centerY: 300, width: 200, height: 100 }`
- **Aspect Ratio:** `{ left: 40, top: 40, width: 100, aspectRatio: 1 }`

### 8.3 Anchor References

Layers can reference other layer positions: `"$anchor:layer_id.field + offset"`.

### 8.4 Safe Areas

Canvas defines `safeAreas: { top, bottom, left, right }`. Layers are clamped to safe areas unless `"ignoreSafeArea": true`.

### 8.5 Responsive Override Rules

Rules define conditions (minWidth, maxWidth, orientation, platform, themeMode) and overrides (constraints, style, params, visible). Rules evaluated in order; first match wins.

---

## 9. Components

### 9.1 Definition

Components are **reusable, named compositions of layers** with configurable slots.

```jsonc
"components": {
  "profile_header": {
    "description": "Avatar + name + job title block",
    "slots": {
      "avatar": { "type": "avatar", "default": true },
      "nameStyle": { "type": "typography", "default": { "fontSize": 32 } }
    },
    "layers": [ /* ... */ ]
  }
}
```

### 9.2 Invocation

Components are invoked in layers via `{ "type": "component", "componentId": "profile_header", "layers": [ /* slot overrides */ ] }`. The component resolver expands the definition and merges slot overrides.

### 9.3 Built-in Components

| Component | Contents |
|---|---|
| `profile_header` | Avatar + name + job title |
| `company_header` | Logo + company name + tagline |
| `contact_section` | Phone/email/website rows |
| `social_section` | Social media icons |
| `footer` | Branding/tagline bar |
| `statistics_section` | Stats row |
| `qr_section` | QR code + label |

---

## 10. Effects System

### 10.1 Design

Effects wrap layer painting with visual post-processing. Each effect type implements:

```dart
// Conceptual interface (NOT Dart code)
interface EffectPainter {
  void apply(Canvas canvas, Rect rect, PaintContext context, VoidCallback paintLayer);
}
```

Effects are applied via `canvas.saveLayer()`. The layer is painted into an offscreen buffer, then the effect composites it back.

### 10.2 Effect Types

| Effect | Params | Performance |
|---|---|---|
| blur | sigmaX, sigmaY | saveLayer + ImageFilter.blur |
| backdrop_blur | sigmaX, sigmaY | BackdropFilter (needs saveLayer) |
| glass | blur, tint, borderOpacity | Combined blur + tint + border |
| glow | color, radius, opacity | MaskFilter.blur |
| shadow | color, offset, blurRadius, spread | saveLayer + MaskFilter |
| inner_shadow | color, offset, blurRadius | saveLayer + clip + blur |
| gradient_overlay | gradient, width | Gradient overlay effect |
| mask | mode, source | Alpha/luminance masking via saveLayer |
| noise | seed, scale, opacity | Perlin noise overlay |
| opacity | value | saveLayer + alpha |
| blend_mode | mode | saveLayer + blend mode |

**Composite effects** (combinations of primitive effects):

| Composite Effect | Composition | Notes |
|---|---|---|
| neumorphism | shadow + inner_shadow + gradient_overlay | Creates soft UI inset/outset appearance |
| glassmorphism | blur + glass + backdrop_blur | Frosted glass appearance with backdrop |

---

## 11. Animation System

### 11.1 Design

Declarative animation definitions entirely in JSON. The AnimationController evaluates animation timelines at 60fps, interpolating property values between keyframes. Supported animation primitives: tween, spring, keyframe, sequence, parallel.

### 11.2 Animation Types

#### 11.2.1 Classification

| Type | Description | Use Case |
|---|---|---|
| `tween` | Linear interpolation between start/end values over a duration | Simple transitions (fade in, slide) |
| `spring` | Physics-based animation with stiffness/damping | Bouncy, natural-feeling motion |
| `keyframe` | Multi-point timeline with per-keyframe easing | Complex choreographed sequences |
| `sequence` | Ordered list of animations played one after another | Multi-step reveals |
| `parallel` | Multiple animations running simultaneously | Coordinated multi-element motion |
| `loop` | Infinite repetition of any animation type | Continuous ambient effects |

#### 11.2.2 Triggers

| Trigger | Description |
|---|---|
| `onLoad` | Plays once when card first renders |
| `onTap` | Plays on tap |
| `onHover` | Plays on hover (web/desktop) |
| `onAppear` | Plays when layer becomes visible (scroll into view, state change) |
| `onStateEnter` | Plays when a specific theme state activates |
| `onStateExit` | Plays when a specific theme state deactivates |

### 11.3 Animatable Properties

opacity, translateX, translateY, scale, rotation, color, borderRadius, shadow, blur, width, height, backgroundColor

### 11.4 Supported Easing

`linear`, `easeIn`, `easeOut`, `easeInOut`, `cubicBezier(x1, y1, x2, y2)`, `bounce`, `elastic`, `anticipate`

### 11.5 Performance Considerations

- Animated properties that trigger layout/repaint use `AnimatedBuilder` or `ValueNotifier` for minimal rebuild scope.
- Particle animations use `Canvas` paint with time-based position updates (no widget rebuilds).
- Use `TickerProviderStateMixin` on the parent render widget.
- Animations can be disabled via `"animated": false` in theme metadata for low-power mode.
- Prefer `transform` animations over layout animations for GPU acceleration.

---

## 12. Theme States

### 12.1 Design

Theme States define **contextual visual variants** within a single theme. A theme can declare multiple states — dark mode, pressed state, focused state, platform-specific rendering — and bind each layer's properties to different values per state.

States are resolved at render time based on runtime context (device, interaction, field state). The engine evaluates the active state set and merges property overrides onto the base layer definition.

### 12.2 State Model

| Aspect | Description |
|---|---|
| **State types** | themeMode (light/dark), interaction (normal/hovered/pressed/focused/disabled/loading), field (populated/empty/error), platform (ios/android/web), orientation (portrait/landscape), dimension (compact/medium/expanded), custom |
| **Resolution** | Multiple states can be active simultaneously. Layer-level bindings define which properties change per state. Conflict resolution: most specific state wins. |
| **State groups** | Named groups of states (e.g., "interactive": {normal, hovered, pressed}). Groups simplify authoring by grouping related states. |
| **Global triggers** | State changes can trigger animations. Theme-defined transitions between states. |

### 12.3 Integration

- States are defined in the theme JSON under a `states` root key (detailed in the Specification §13).
- The `ThemeStateResolver` component evaluates active states at render time.
- Animation triggers `onStateEnter` and `onStateExit` bridge states to the Animation System (§11).
- State-driven property overrides compose with variable resolution: variables are resolved first, then state overrides are applied.

---

## 13. Theme Marketplace

### 13.1 Theme Packaging

Themes are distributed as `.taply_theme` bundles — a ZIP file containing:

- `theme.json` — The theme definition
- `preview.png` — Preview image (600×360)
- `preview_dark.png` — Optional dark mode preview
- `fonts/` — Custom font files
- `assets/` — Images, SVGs, patterns used by the theme

### 13.2 Theme Metadata (Bundle Manifest)

```jsonc
{
  "themeId": "luxury_black_gold",
  "name": "Luxury Black & Gold",
  "version": "1.2.0",
  "author": "Taply Studio",
  "category": "luxury",
  "tags": ["dark", "gold", "premium"],
  "price": 0.99,
  "currency": "USD",
  "previewUrl": "https://cdn.taply.ai/previews/luxury_black_gold.png",
  "fileSize": 245000,
  "minAppVersion": "2.0.0",
  "ratings": { "average": 4.7, "count": 128 }
}
```

### 13.3 Theme Lifecycle

- **Download:** From marketplace API → save to app documents directory
- **Install:** Validate bundle → extract → register in `ThemeManager`
- **Update:** Check for newer version → download → replace
- **Remove:** Unregister → delete files
- **Reset:** Revert to factory themes

### 13.4 Premium vs Free

- Free themes ship with the app in `assets/themes/`
- Premium themes are downloaded from the marketplace
- Premium themes can have limited-time trials
- Engine enforces no runtime distinction — all themes are SceneGraphs

---

## 14. Theme Studio

### 14.1 Architecture
### 14.2 Operations
### 14.3 Export Pipeline

Studio edit → SceneGraph mutations → JSON serialization → theme bundle creation (including asset collection).

---

## 15. AI Theme Generator

### 15.1 Architecture
### 15.2 Pipeline
### 15.3 Output

- `theme.json` — Valid theme definition
- `preview.png` — Rendered preview
- `variables.json` — Color/font variables for further editing
- `prompt.json` — Original prompt + settings for regeneration

---

## 16. Rendering Pipeline

### 16.1 Full Pipeline
### 16.2 Export Pipeline (no widget tree)

```
1. CardRenderer.buildExport()
2. PictureRecorder + Canvas (at export resolution, e.g., 1080px width)
3. LayoutEngine.solve() at export resolution
4. Paint Pipeline onto PictureRecorder canvas (no widget pipeline)
5. PictureRecorder.endRecording() → ui.Picture
6. Picture.toImage() → ui.Image
7. Image.toByteData(format: PNG) → Uint8List
8. Write to file or share
```

---

## 17. Extensibility

### 17.1 Principles
### 17.2 Registry Pattern
### 17.3 Adding a New Paint Layer
### 17.4 Adding a New Widget Layer
### 17.5 Strategy Pattern

The variable resolver uses strategy pattern for type coercion — each variable type has a `CoercionStrategy` that validates and transforms the value to the expected Dart type.

---

## 18. Performance

### 18.1 Caching Strategy
### 18.2 Repaint Boundaries
### 18.3 Layer Pruning
### 18.4 Image Optimization
### 18.5 Canvas Optimization
### 18.6 GPU Considerations
### 18.7 Memory Optimization

- SceneGraphs are kept as compact Dart objects (not JSON strings) in memory.
- Variable resolution happens once at load time, not per frame.
- Responsive rule evaluation is O(R) where R is the number of rules (typically < 20).
- Animation timeline interpolation uses cached easing curves (pre-computed look-up tables).

---

## 19. Future Roadmap

### Version 2.0 (Initial Implementation)
- Complete paint layer system (all primitive shapes, path shapes, textures, patterns, particles)
- Complete widget layer system (all widget types)
- JSON parsing pipeline with schema validation and variable resolution
- Constraint-based layout engine
- Component system with built-in components
- Theme marketplace download/install/update
- Export renderer
- Animation system (fade, translate, scale)

### Version 3.0
- Theme Studio V1 (basic layer editing, property inspector)
- AI Theme Generator V1 (prompt → theme.json)
- Advanced animation (hover, parallax, shimmer)
- Multi-variant canvas (landscape + portrait + square in one theme)
- Theme variant inheritance
- Performance profiler (show repaint cost per layer in debug mode)

### Version 4.0
- Theme Studio V2 (drag-and-drop, undo/redo, real-time preview)
- AI Theme Generator V2 (style transfer from reference images)
- Plugin system (third-party layer types via packages)
- Collaborative theme editing (WebSocket-based)
- A/B testing engine (test theme variants against user engagement)
- Runtime theme hot-reload for development

### Version 5.0
- Theme Studio V3 (animation timeline editor, keyframe visual editor)
- AI Theme Generator V3 (generate from Behance/Pinterest URL)
- Procedural AI-generated backgrounds (DALL-E/Stable Diffusion integration)
- Real-time collaborative editing
- Theme subscription marketplace (Netflix-style for themes)
- Dynamic theme mutation (user edits in-app without Theme Studio)
- WebGL/Impeller-optimized rendering pipeline
- AR card preview (point phone at NFC tag to see card in AR)

---

## Appendix A: Migration from V1 to V2

The V1 engine used a monolithic `TemplatePainter` with a massive switch statement, and `TemplateRenderer` with hardcoded widget positioning. Migration to V2:

| V1 Component | V2 Replacement | Migration Path |
|---|---|---|
| `TemplateModel` | `SceneGraph` | Rewrite parser; V1 JSON auto-converted via migration function |
| `PaintLayer` | `PaintLayerNode` | Each V1 type maps to a V2 painter + effect |
| `WidgetLayer` | `WidgetLayerNode` | V1 types map to V2 widget builders |
| `TemplatePainter` (switch) | `PaintRegistry` | Each V1 case becomes a registered painter |
| `TemplateRenderer` (if-else) | `WidgetRegistry` | Each V1 widget type becomes a registered builder |
| `TemplateLoader` | `ThemeLoader` with LRU cache | New caching layer added |
| Hardcoded field list | Field-agnostic binding | V2 accepts any field key; no predefined list |
| `#RRGGBB@AA` color | Full CSS color support | Migration function converts V1 colors |

---

*End of Architecture Specification — Taply Theme Engine V2*
