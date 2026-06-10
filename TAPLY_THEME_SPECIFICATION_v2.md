# Taply Theme Specification v2

**Official Engineering Specification**

| Field | Value |
|---|---|
| Specification ID | `taply-theme-spec-v2` |
| Version | `2.0.0` |
| Status | **DRAFT** |
| Author | Taply Engineering Team |
| Last Updated | June 2026 |
| Document Type | Engineering Specification |
| Supersedes | Taply Theme Spec v1 (legacy) |

---

## Table of Contents

1. [Theme Overview](#1-theme-overview)
2. [Theme Metadata Specification](#2-theme-metadata-specification)
3. [Canvas Specification](#3-canvas-specification)
4. [Theme Variables](#4-theme-variables)
5. [Asset Specification](#5-asset-specification)
6. [Scene Graph Specification](#6-scene-graph-specification)
7. [Paint Layer Specification](#7-paint-layer-specification)
8. [Widget Layer Specification](#8-widget-layer-specification)
9. [Layout System](#9-layout-system)
10. [Components](#10-components)
11. [Effects](#11-effects)
12. [Typography](#12-typography)
13. [Theme States](#13-theme-states)
14. [Animation Specification](#14-animation-specification)
15. [Theme Package Format](#15-theme-package-format)
16. [Validation Rules](#16-validation-rules)
17. [Performance Guidelines](#17-performance-guidelines)
18. [Security](#18-security)
19. [Versioning](#19-versioning)
20. [Appendices](#20-appendices)

---

## 1. Theme Overview

### 1.1 Purpose

The Taply Theme Specification v2 (TTSv2) defines a formal, implementation-independent data format for describing the complete visual rendering of a digital business card. A theme is a declarative document expressed in JSON that fully describes every pixel, every interaction, every animation, and every responsive behavior of a card rendering.

A theme is **not** a template with placeholders. A theme is a **complete scene graph** — a hierarchical description of visual layers, their properties, their relationships, and their behaviors.

### 1.2 Goals

| Goal | Description |
|---|---|
| **Implementation Independence** | Any rendering engine, on any platform, in any language, can consume a TTSv2 theme and produce an equivalent visual output. |
| **Full Declarativity** | Every visual aspect is described in data. No aspect of the card's appearance is determined by the rendering engine. |
| **Extensibility** | New layer types, effect types, widget types, and component types can be added without breaking existing themes. |
| **Version Safety** | Themes created for older specification versions render correctly on newer engines. Newer themes gracefully degrade on older engines. |
| **Marketplace Readiness** | Themes are self-contained packages with metadata, previews, licensing, and integrity verification suitable for distribution. |
| **AI Compatibility** | The specification is designed to be a target output format for generative AI systems. The schema is structured enough for constrained generation. |
| **Tooling Friendly** | The schema is machine-validatable (JSON Schema draft 2020-12). Tools can provide autocomplete, validation, and preview. |

### 1.3 Design Philosophy

```
┌─────────────────────────────────────────────────────────────────────┐
│                    DESIGN PHILOSOPHY                                  │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  A theme is a scene graph. It describes what to render,              │
│  not how to render it.                                              │
│                                                                      │
│  The JSON is the source of truth. The rendering engine                │
│  is a mechanical executor.                                           │
│                                                                      │
│  Every visual element is a layer. Layers are flat, ordered,           │
│  and composable. There is no implicit behavior.                      │
│                                                                      │
│  Design tokens are first-class citizens. Variables DRY up            │
│  themes and enable systematic theming.                               │
│                                                                      │
│  Responsiveness is declarative. Layout rules adapt to                 │
│  render context without branching engine logic.                      │
│                                                                      │
│  The specification is open. Anyone can build tools, engines,          │
│  or AI systems that consume or produce TTSv2 themes.                 │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.4 Core Principles

**P1 — Scene Graph Primacy.** Every theme resolves to a flat, ordered list of renderable layers. Groups, components, and templates are authoring conveniences that collapse to layers at parse time.

**P2 — Explicit Over Implicit.** No aspect of the card's appearance is determined by the engine's opinion. Font sizes, colors, positions, shadows, animations — everything is explicitly declared in the theme.

**P3 — Separation of Concerns.** The theme describes visual structure. Business data (user name, phone, etc.) is injected at render time through field bindings. The theme never contains personal data.

**P4 — Variable-Driven Consistency.** Design tokens (colors, typography, spacing) are defined once as variables and referenced throughout the theme. This ensures visual consistency and enables system-level theming.

**P5 — Responsive by Design.** Every layer can define responsive behaviors. The same theme produces optimal layouts from 240px watch displays to 4K desktop screens.

**P6 — Graceful Degradation.** Unknown properties are ignored, not rejected. Newer themes render with reduced fidelity on older engines, never with errors.

**P7 — Deterministic Rendering.** Identical theme + identical data + identical render dimensions produces identical pixel output across all platforms.

### 1.5 Rendering Philosophy

A rendering engine implementing TTSv2 must follow this execution model:

1. **Parse** — Convert JSON document to in-memory scene graph with full validation.
2. **Resolve** — Flatten all variable references, component expansions, and group hierarchies into an ordered layer list.
3. **Inject** — Merge business data (field values) into widget layer bindings.
4. **Layout** — Compute absolute pixel positions for every layer given the target render size.
5. **Paint** — Render paint layers onto a canvas in z-order, applying effects at each layer.
6. **Compose** — Position widget layers (interactive elements) on top of the painted canvas.
7. **Animate** — Drive any declared animations on the timeline.

The engine may optimize or reorder these phases as long as the observable output is equivalent.

### 1.6 JSON Philosophy

- The theme is a single valid JSON document (RFC 8259).
- Comments are permitted via `//` and `/* */` for authoring tools, following JSONC convention. Engines should strip comments before parsing.
- Property order is semantically meaningful only for `layers` arrays (rendering order). All object properties are unordered.
- Unknown properties are ignored. This enables forward compatibility.
- All string values are UTF-8.
- Numeric values use double-precision floating point.

### 1.7 Extensibility Philosophy

- New `type` values can be added to `layers`, `effects`, `components`, `widgets` without schema changes.
- Custom properties can be placed in `extensions` objects at any level.
- The engine's layer/widget/effect registries determine what types it supports. Unsupported types are logged as warnings and skipped.
- Theme authors can create extension specifications layered on top of TTSv2, provided they namespace their custom properties.

### 1.8 AI Compatibility

- The schema is designed for constrained LLM generation.
- Variable types are structurally inferable (not declared), simplifying generation.
- Components provide reusable patterns that reduce generation complexity.
- The flat layer list structure maps naturally to transformer-based sequence generation.
- Color values use standard hex and rgba formats that LLMs produce reliably.

### 1.9 Marketplace Compatibility

- Every theme is a self-contained package (`.taplytheme`) with metadata, preview, and integrity verification.
- Themes declare their license, price, and compatibility requirements.
- The specification separates presentation (theme) from data (business card), enabling safe marketplace distribution.

### 1.10 Future Compatibility

- The `schemaVersion` field uses strict semver. Engines reject incompatible major versions with a clear error.
- Minor version bumps add optional fields. Engines ignore unknown fields.
- Patch version bumps fix documentation or tighten validation. No behavioral change.
- A formal migration path exists between every major version.
- Deprecated fields carry a `deprecated` flag with a `deprecatedMessage` and `deprecatedVersion`.

### 1.11 Engine Architecture Reference

The engine components that implement this specification are defined in the **Taply Theme Engine V2 Architecture Specification**. Key component names referenced throughout this document:

| Component | Architecture Reference |
|---|---|
| `ThemeLoader` | Theme loading, caching, and source resolution |
| `ThemeParser` | JSON parsing, schema validation, AST construction |
| `VariableResolver` | Variable inheritance chain resolution |
| `AssetManager` | External asset loading and caching |
| `SceneGraph` | Immutable typed representation of a parsed theme |
| `LayoutEngine` | Constraint-based layout solving |
| `PaintRegistry` | Paint layer type registration and dispatch |
| `WidgetRegistry` | Widget layer type registration and dispatch |
| `ComponentRegistry` | Component definition storage and resolution |
| `Renderer` | Orchestration of layout, paint, and widget pipelines |
| `RenderPipeline` | Two-phase paint + widget rendering pipeline |
| `AnimationController` | Animation timeline evaluation and triggering |
| `ThemeValidator` | Theme structure and semantic integrity validation |
| `ExportPipeline` | Headless export pathway (image/PDF/SVG) |
| `FieldResolver` | Business data field binding resolution |

---

## 2. Theme Metadata Specification

### 2.1 Overview

The metadata block contains identifying, descriptive, and administrative information about the theme. It is the only non-visual section of the theme document. All engines MUST read this block first to determine compatibility and rendering eligibility.

### 2.2 Location

The metadata properties exist at the **root level** of the theme JSON document. They are siblings of `canvas`, `variables`, `layers`, `components`, `assets`, `animations`, and `responsive`.

### 2.3 Property Specifications

---

#### `$schema`

| Field | Value |
|---|---|
| JSON Key | `$schema` |
| Type | `string` (URI) |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | Any valid HTTPS URI pointing to a JSON Schema file |
| Validation Rules | If present, MUST be a valid URI. Engines MAY fetch the schema for validation. Unknown schemas MUST be ignored. |
| Description | A URI referencing the JSON Schema that validates this document. Intended for IDE tooling and CI pipelines. |
| Example | `"https://spec.taply.ai/schemas/theme/v2.json"` |

---

#### `schemaVersion`

| Field | Value |
|---|---|
| JSON Key | `schemaVersion` |
| Type | `string` (semver) |
| Required | `true` |
| Nullable | `false` |
| Allowed Values | `"2.0.0"` for this specification |
| Validation Rules | MUST be a valid semver string (MAJOR.MINOR.PATCH). The MAJOR version determines schema compatibility. Engines MUST reject documents with an unsupported MAJOR version. |
| Description | The version of the Taply Theme Specification that this document conforms to. |
| Example | `"2.0.0"` |

---

#### `id`

| Field | Value |
|---|---|
| JSON Key | `id` |
| Type | `string` |
| Required | `true` |
| Nullable | `false` |
| Default | (no default — required) |
| Allowed Values | Lowercase alphanumeric characters, hyphens, and underscores only. Must match regex `^[a-z0-9_-]{2,64}$`. Must be unique within a marketplace. |
| Validation Rules | MUST be 2–64 characters. MUST start with a lowercase letter. MUST contain only `[a-z0-9_-]`. |
| Description | Globally unique identifier for this theme. Used as the primary key in theme marketplaces, caching, and URL routing. |
| Example | `"luxury_black_gold"` |

---

#### `name`

| Field | Value |
|---|---|
| JSON Key | `name` |
| Type | `string` |
| Required | `true` |
| Nullable | `false` |
| Default | (no default — required) |
| Allowed Values | Any string 1–128 characters |
| Validation Rules | MUST be 1–128 characters. SHOULD be human-readable. |
| Description | Human-readable display name shown in theme galleries, marketplaces, and selection UI. |
| Example | `"Luxury Black & Gold"` |

---

#### `version`

| Field | Value |
|---|---|
| JSON Key | `version` |
| Type | `string` (semver) |
| Required | `true` |
| Nullable | `false` |
| Allowed Values | Valid semver string |
| Validation Rules | MUST be a valid semver string. SHOULD increment with each published update. |
| Description | The version of this specific theme. Independent of `schemaVersion`. Used for marketplace update checks. |
| Example | `"1.2.0"` |

---

#### `engineVersion`

| Field | Value |
|---|---|
| JSON Key | `engineVersion` |
| Type | `string` (semver) |
| Required | `false` |
| Nullable | `true` |
| Default | Same as `schemaVersion` |
| Validation Rules | MUST be a valid semver string if present. |
| Description | The version of the Taply rendering engine that generated this theme (if exported from Theme Studio). Read-only. Users SHOULD NOT set this manually. |
| Example | `"2.0.0"` |

---

#### `author`

| Field | Value |
|---|---|
| JSON Key | `author` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | Any string 1–128 characters |
| Validation Rules | None |
| Description | The name of the individual or organization that created the theme. |
| Example | `"Taply Studio"` |

---

#### `organization`

| Field | Value |
|---|---|
| JSON Key | `organization` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | Any string 1–128 characters |
| Validation Rules | None |
| Description | The organization or brand associated with the theme's creation. |
| Example | `"Taply Inc."` |

---

#### `description`

| Field | Value |
|---|---|
| JSON Key | `description` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | Any string 1–2000 characters |
| Validation Rules | SHOULD be 10–200 characters for gallery display. MAY be up to 2000 characters for detailed descriptions. |
| Description | A human-readable description of the theme's style, intended use, and notable features. |
| Example | `"A premium dark theme with gold accents and glassmorphism details. Perfect for executives and luxury brands."` |

---

#### `category`

| Field | Value |
|---|---|
| JSON Key | `category` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | `"uncategorized"` |
| Allowed Values | See Category Registry below |
| Validation Rules | MUST be one of the registered categories if present. Engines MAY register additional categories. |
| Description | The primary categorical grouping for the theme. Used for browsing, filtering, and recommendations. |
| Example | `"luxury"` |

**Category Registry v2.0:**

| Category | Description |
|---|---|
| `minimal` | Clean, minimalist design with ample whitespace |
| `modern` | Contemporary design with current aesthetic trends |
| `luxury` | Premium, high-end aesthetic with ornate details |
| `corporate` | Professional, conservative design suitable for business |
| `creative` | Artistic, unconventional, visually striking |
| `tech` | Technology-focused, digital aesthetic |
| `real_estate` | Property-focused design with photo emphasis |
| `medical` | Healthcare-appropriate, clean, trustworthy |
| `legal` | Law firm appropriate, traditional, authoritative |
| `education` | Academic, approachable design |
| `hospitality` | Hotel, restaurant, travel-oriented design |
| `fashion` | Trend-forward, style-focused aesthetic |
| `sports` | Athletic, energetic visual language |
| `entertainment` | Media, music, film-focused design |
| `art` | Gallery-worthy, expressive design |
| `wedding` | Romantic, elegant design for wedding vendors |
| `photography` | Image-forward design for photographers |
| `social` | Social media influencer-oriented design |
| `event` | Event planning and coordination focused |
| `fitness` | Health and wellness oriented design |
| `uncategorized` | Default category when none is specified |

---

#### `tags`

| Field | Value |
|---|---|
| JSON Key | `tags` |
| Type | `array<string>` |
| Required | `false` |
| Nullable | `true` |
| Default | `[]` |
| Allowed Values | Array of strings, each 1–32 characters, matching `^[a-z0-9_-]+$` |
| Validation Rules | Maximum 20 tags per theme. Each tag MUST be lowercase alphanumeric with hyphens or underscores. |
| Description | Search tags for discoverability. Tags augment the category for fine-grained filtering. |
| Example | `["dark", "gold", "premium", "glassmorphism", "elegant", "night"]` |

---

#### `preview`

| Field | Value |
|---|---|
| JSON Key | `preview` |
| Type | `string` (URI) |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | Relative path within theme package, or absolute URL |
| Validation Rules | If relative, MUST resolve to a file within the theme package. Engines SHOULD support common image formats (PNG, JPEG, WebP). |
| Description | Path or URL to a preview image of the theme (light mode). Recommended resolution: 1200×720 pixels, 16:9 aspect ratio. |
| Example | `"assets/previews/luxury_black_gold.png"` |

---

#### `thumbnail`

| Field | Value |
|---|---|
| JSON Key | `thumbnail` |
| Type | `string` (URI) |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | Relative path within theme package, or absolute URL |
| Validation Rules | If relative, MUST resolve to a file within the theme package. |
| Description | Path or URL to a smaller thumbnail image. Recommended resolution: 400×240 pixels. Used in grid views and search results. |
| Example | `"assets/thumbnails/luxury_black_gold_thumb.png"` |

---

#### `premium`

| Field | Value |
|---|---|
| JSON Key | `premium` |
| Type | `boolean` |
| Required | `false` |
| Nullable | `false` |
| Default | `false` |
| Allowed Values | `true`, `false` |
| Validation Rules | If `true`, `price` SHOULD be defined. |
| Description | Whether this theme is a premium (paid) theme. Free themes have this set to `false` or omitted. |
| Example | `true` |

---

#### `price`

| Field | Value |
|---|---|
| JSON Key | `price` |
| Type | `number` |
| Required | `false` |
| Nullable | `true` |
| Default | `0.0` |
| Allowed Values | Non-negative numbers, capped at `999.99` |
| Validation Rules | MUST be ≥ 0. MUST be ≤ 999.99. SHOULD have at most 2 decimal places. If `premium` is `true`, this MAY be 0 (free premium theme, e.g., loyalty rewards). |
| Description | The price of the theme in the store's configured currency. 0.0 indicates free. |
| Example | `1.99` |

---

#### `license`

| Field | Value |
|---|---|
| JSON Key | `license` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | `"all-rights-reserved"` |
| Allowed Values | See License Registry below |
| Validation Rules | MUST be one of the registered license identifiers. |
| Description | The license under which the theme is distributed. Determines usage rights for purchasers. |
| Example | `"standard-commercial"` |

**License Registry v2.0:**

| Identifier | Description |
|---|---|
| `all-rights-reserved` | Standard copyright. No reuse without permission. |
| `standard-commercial` | Purchaser may use for personal and commercial purposes on Taply platform. |
| `extended-commercial` | Purchaser may modify, rebrand, and use in any medium. |
| `royalty-free` | Free to use, modify, and distribute with attribution. |
| `creative-commons-by` | Creative Commons Attribution 4.0. |
| `creative-commons-by-nc` | Creative Commons Attribution-NonCommercial 4.0. |
| `creative-commons-zero` | CC0 — Public domain dedication. |
| `open-source` | Open source theme. Source available in repository. |
| `taply-exclusive` | Exclusive to Taply marketplace. |

---

#### `homepage`

| Field | Value |
|---|---|
| JSON Key | `homepage` |
| Type | `string` (URI) |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Validation Rules | MUST be a valid URI if present. |
| Description | URL to the theme's homepage, portfolio page, or designer's website. |
| Example | `"https://taply.ai/themes/luxury-black-gold"` |

---

#### `repository`

| Field | Value |
|---|---|
| JSON Key | `repository` |
| Type | `string` (URI) |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Validation Rules | MUST be a valid URI if present. SHOULD point to a source code repository. |
| Description | URL to the source repository for open-source themes. |
| Example | `"https://github.com/taply/themes/luxury-black-gold"` |

---

#### `rtl`

| Field | Value |
|---|---|
| JSON Key | `rtl` |
| Type | `boolean` |
| Required | `false` |
| Nullable | `false` |
| Default | `false` |
| Allowed Values | `true`, `false` |
| Validation Rules | If `true`, the theme layout mirrors for right-to-left scripts. |
| Description | Whether the theme has been designed with right-to-left (RTL) language support. If `true`, the layout engine automatically mirrors horizontal positions when rendering RTL content. |
| Example | `false` |

---

#### `darkMode`

| Field | Value |
|---|---|
| JSON Key | `darkMode` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | `"auto"` |
| Allowed Values | `"supported"`, `"unsupported"`, `"auto"`, `"dark-only"`, `"light-only"` |
| Validation Rules | None |
| Description | Indicates the theme's dark mode compatibility. `"supported"` means the theme has explicit dark mode styling. `"unsupported"` means the theme only works in light mode. `"auto"` means the engine should attempt automatic dark mode conversion. `"dark-only"` and `"light-only"` restrict rendering to a single mode. |
| Example | `"supported"` |

---

#### `lightMode`

| Field | Value |
|---|---|
| JSON Key | `lightMode` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | `"supported"` |
| Allowed Values | Same as `darkMode` |
| Validation Rules | None |
| Description | Analogous to `darkMode` for light mode. Most themes are light-mode by default. |
| Example | `"supported"` |

---

#### `supportedLanguages`

| Field | Value |
|---|---|
| JSON Key | `supportedLanguages` |
| Type | `array<string>` (BCP 47) |
| Required | `false` |
| Nullable | `true` |
| Default | `["en"]` |
| Allowed Values | Array of valid BCP 47 language tags |
| Validation Rules | Maximum 50 entries. Each entry MUST be a valid BCP 47 tag. |
| Description | List of languages that the theme's typography, layout, and RTL support have been tested with. |
| Example | `["en", "ar", "he", "zh", "ja", "ko"]` |

---

#### `createdAt`

| Field | Value |
|---|---|
| JSON Key | `createdAt` |
| Type | `string` (ISO 8601) |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Validation Rules | MUST be a valid ISO 8601 datetime string if present. |
| Description | Timestamp of the theme's initial creation. |
| Example | `"2026-05-15T10:30:00Z"` |

---

#### `updatedAt`

| Field | Value |
|---|---|
| JSON Key | `updatedAt` |
| Type | `string` (ISO 8601) |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Validation Rules | MUST be a valid ISO 8601 datetime string if present. SHOULD be ≥ `createdAt`. |
| Description | Timestamp of the theme's last modification. |
| Example | `"2026-06-01T14:22:00Z"` |

---

#### `minimumEngineVersion`

| Field | Value |
|---|---|
| JSON Key | `minimumEngineVersion` |
| Type | `string` (semver range) |
| Required | `false` |
| Nullable | `true` |
| Default | `"*"` (any version) |
| Allowed Values | Valid semver range expression (e.g., `">=2.0.0 <3.0.0"`, `"^2.0.0"`) |
| Validation Rules | MUST be a valid semver range expression if present. |
| Description | The minimum rendering engine version required to render this theme correctly. Engines SHOULD check this before attempting to render. |
| Example | `">=2.0.0"` |

---

#### `deprecated`

| Field | Value |
|---|---|
| JSON Key | `deprecated` |
| Type | `boolean` |
| Required | `false` |
| Nullable | `false` |
| Default | `false` |
| Allowed Values | `true`, `false` |
| Validation Rules | If `true`, `deprecatedMessage` SHOULD be defined. |
| Description | Whether this theme version is deprecated. Deprecated themes MAY still render but SHOULD be marked as such in theme galleries. |
| Example | `true` |

---

### 2.4 Complete Metadata Example

```jsonc
{
  "$schema": "https://spec.taply.ai/schemas/theme/v2.json",
  "schemaVersion": "2.0.0",

  "id": "luxury_black_gold",
  "name": "Luxury Black & Gold",
  "version": "1.2.0",
  "engineVersion": "2.0.0",
  "author": "Taply Studio",
  "organization": "Taply Inc.",
  "description": "A premium dark theme with gold accents and glassmorphism details.",
  "category": "luxury",
  "tags": ["dark", "gold", "premium", "glassmorphism", "elegant"],

  "premium": true,
  "price": 1.99,
  "license": "standard-commercial",

  "preview": "assets/previews/luxury_black_gold.png",
  "thumbnail": "assets/thumbnails/luxury_black_gold_thumb.png",
  "homepage": "https://taply.ai/themes/luxury-black-gold",

  "rtl": true,
  "darkMode": "supported",
  "lightMode": "unsupported",
  "supportedLanguages": ["en", "ar", "he"],

  "createdAt": "2026-05-15T10:30:00Z",
  "updatedAt": "2026-06-01T14:22:00Z",
  "minimumEngineVersion": ">=2.0.0",
  "deprecated": false
}
```

---

## 3. Canvas Specification

### 3.1 Overview

The canvas defines the **virtual design space** within which all layers are positioned. It establishes the coordinate system, dimensions, safety boundaries, and global visual properties of the card.

### 3.2 Design Units

**All positions and sizes in a TTSv2 theme are expressed in abstract design units, not physical pixels.**

Rationale: By using a virtual design space with a standard reference size (1000×600 design units), theme authors design once and the rendering engine scales the output to any physical display size. This eliminates device-specific layout code and ensures pixel-identical output across all screen sizes.

The standard design space is **1000 × 600 design units** at a **5:3 aspect ratio** (landscape). The engine scales uniformly: a layer at position (200, 100) with size (300, 200) in design units occupies `(200*scale, 100*scale, 300*scale, 200*scale)` physical pixels, where `scale = physicalWidth / canvas.width`.

### 3.3 Property Specifications

---

#### `width`

| Field | Value |
|---|---|
| JSON Key | `canvas.width` |
| Type | `integer` |
| Required | `true` |
| Nullable | `false` |
| Default | `1000` |
| Allowed Values | 100–10000 |
| Validation Rules | MUST be ≥ 100. MUST be ≤ 10000. SHOULD be 1000 for standard themes. |
| Description | The width of the design space in design units. All horizontal positions and widths in the theme are relative to this value. |
| Example | `1000` |

---

#### `height`

| Field | Value |
|---|---|
| JSON Key | `canvas.height` |
| Type | `integer` |
| Required | `true` |
| Nullable | `false` |
| Default | `600` |
| Allowed Values | 100–10000 |
| Validation Rules | MUST be ≥ 100. MUST be ≤ 10000. SHOULD maintain a reasonable aspect ratio with `width`. |
| Description | The height of the design space in design units. All vertical positions and heights in the theme are relative to this value. |
| Example | `600` |

---

#### `aspectRatio`

| Field | Value |
|---|---|
| JSON Key | `canvas.aspectRatio` |
| Type | `string` |
| Required | `false` |
| Nullable | `true` |
| Default | Computed from `width/height` |
| Allowed Values | String in format `"W:H"` where W and H are positive integers |
| Validation Rules | If present, MUST match regex `^\d+:\d+$`. The ratio `W/H` SHOULD equal `width/height`. If it doesn't, `W:H` is the display aspect ratio and `width/height` is the internal design coordinate ratio. |
| Description | The display aspect ratio of the card. Used for thumbnail generation, gallery display, and responsive variant selection. |
| Example | `"5:3"` |

---

#### `clipRadius`

| Field | Value |
|---|---|
| JSON Key | `canvas.clipRadius` |
| Type | `number` |
| Required | `false` |
| Nullable | `false` |
| Default | `0` |
| Allowed Values | 0–1000 |
| Validation Rules | MUST be ≥ 0. MUST be ≤ `min(canvas.width, canvas.height) / 2`. |
| Description | The corner radius applied to the card's bounding rectangle. A value of 0 produces sharp corners. Values > 0 produce rounded corners. The engine SHOULD clip all rendering to this rounded rectangle. |
| Example | `24` |

---

#### `clipShape`

| Field | Value |
|---|---|
| JSON Key | `canvas.clipShape` |
| Type | `string` |
| Required | `false` |
| Nullable | `false` |
| Default | `"rounded_rectangle"` |
| Allowed Values | `"rounded_rectangle"`, `"rectangle"`, `"circle"`, `"squircle"` |
| Validation Rules | MUST be one of the allowed values. |
| Description | The shape used to clip the card's contents. `circle` makes the card a perfect circle (width and height MUST be equal). `squircle` produces a super-ellipse shape with smoother corners. |
| Example | `"rounded_rectangle"` |

---

#### `padding`

| Field | Value |
|---|---|
| JSON Key | `canvas.padding` |
| Type | `object` or `number` |
| Required | `false` |
| Nullable | `true` |
| Default | `0` |
| Allowed Values | Object with optional `top`, `bottom`, `left`, `right` keys, each a non-negative number. Or a single number applied uniformly. |
| Validation Rules | Each value MUST be ≥ 0. Each value MUST be ≤ `min(canvas.width, canvas.height) / 2`. |
| Description | Uniform or per-edge padding inside the card bounds. Content layers should be positioned within the padded area. The engine SHOULD provide visual guides for the padding boundary in authoring tools. |
| Example | `{ "top": 32, "bottom": 32, "left": 40, "right": 40 }` |

---

#### `safeArea`

| Field | Value |
|---|---|
| JSON Key | `canvas.safeArea` |
| Type | `object` |
| Required | `false` |
| Nullable | `true` |
| Default | `null` (engine uses platform safe area insets) |
| Allowed Values | Object with optional `top`, `bottom`, `left`, `right` keys, each a non-negative number. Or `false` to disable safe area enforcement. |
| Validation Rules | If an object, each value MUST be ≥ 0. If `false`, no safe area enforcement. |
| Description | Insets from the card edges that must remain free of critical content. These account for device notches, status bars, and system UI. When `false`, the engine disables safe area enforcement and content can render edge-to-edge. |
| Example | `{ "top": 44, "bottom": 34, "left": 16, "right": 16 }` |

---

#### `coordinateSystem`

| Field | Value |
|---|---|
| JSON Key | `canvas.coordinateSystem` |
| Type | `string` |
| Required | `false` |
| Nullable | `false` |
| Default | `"top-left"` |
| Allowed Values | `"top-left"`, `"center"`, `"bottom-left"` |
| Validation Rules | MUST be one of the allowed values. |
| Description | The origin point of the coordinate system. `top-left` places (0,0) at the top-left corner. `center` places (0,0) at the center of the canvas. `bottom-left` places (0,0) at the bottom-left corner with Y increasing upward. |
| Example | `"top-left"` |

---

#### `origin`

| Field | Value |
|---|---|
| JSON Key | `canvas.origin` |
| Type | `object` |
| Required | `false` |
| Nullable | `true` |
| Default | `null` (uses `coordinateSystem` default origin) |
| Allowed Values | Object with `x` and `y` keys, each a number |
| Validation Rules | Both `x` and `y` MUST be present if the object is present. Values are in design units. |
| Description | Custom origin point offset relative to the coordinate system origin. Allows shifting the entire coordinate space. |
| Example | `{ "x": 500, "y": 300 }` |

---

#### `backgroundColor`

| Field | Value |
|---|---|
| JSON Key | `canvas.backgroundColor` |
| Type | `string` (color) |
| Required | `false` |
| Nullable | `true` |
| Default | `"#FFFFFF"` |
| Allowed Values | See Color Format Specification below |
| Validation Rules | MUST be a valid color string. |
| Description | The background color of the card. Rendered as the bottom-most layer beneath all paint layers. If `backgroundGradient` or `backgroundImage` is defined, this serves as a fallback while those assets load. |
| Example | `"#1A1A2E"` |

---

#### `backgroundGradient`

| Field | Value |
|---|---|
| JSON Key | `canvas.backgroundGradient` |
| Type | `object` |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | A gradient object as defined in Effects (§11) |
| Validation Rules | MUST be a valid gradient specification. |
| Description | A gradient rendered as the card's background. Overrides `backgroundColor` when present. |
| Example | `{ "kind": "linear", "colors": ["#0F0F1A", "#1A1A2E"], "angle": 180 }` |

---

#### `backgroundImage`

| Field | Value |
|---|---|
| JSON Key | `canvas.backgroundImage` |
| Type | `string` or `object` |
| Required | `false` |
| Nullable | `true` |
| Default | `null` |
| Allowed Values | A string (asset reference) or an object with `src`, `fit`, `opacity` |
| Validation Rules | If string, MUST reference a valid asset ID from `assets.images`. If object, MUST include `src`. |
| Description | An image rendered as the card's background. Overrides `backgroundGradient` and `backgroundColor` when present. |
| Example | `{ "src": "bg_pattern", "fit": "cover", "opacity": 0.15 }` |

---

#### `responsiveMode`

| Field | Value |
|---|---|
| JSON Key | `canvas.responsiveMode` |
| Type | `string` |
| Required | `false` |
| Nullable | `false` |
| Default | `"scale"` |
| Allowed Values | `"scale"`, `"contain"`, `"cover"`, `"width"`, `"height"` |
| Validation Rules | MUST be one of the allowed values. |
| Description | How the design space maps to physical screen dimensions. `scale` uniformly scales the design to fit. `contain` fits the design within the screen preserving aspect ratio. `cover` fills the screen possibly cropping. `width` fits to screen width. `height` fits to screen height. |
| Example | `"scale"` |

---

#### `deviceScaling`

| Field | Value |
|---|---|
| JSON Key | `canvas.deviceScaling` |
| Type | `string` |
| Required | `false` |
| Nullable | `false` |
| Default | `"auto"` |
| Allowed Values | `"auto"`, `"native"`, `1`, `1.5`, `2`, `3`, `4` |
| Validation Rules | If numeric, MUST be one of `1`, `1.5`, `2`, `3`, `4`. |
| Description | Controls image resolution scaling for retina/high-DPI displays. `auto` uses the device pixel ratio. `native` uses 1x (useful for export). Numeric values force a specific scale factor. |
| Example | `"auto"` |

---

### 3.4 Canvas Variants

The `canvas.variants` array allows a single theme to define multiple aspect ratio renderings:

```jsonc
"canvas": {
  "width": 1000,
  "height": 600,
  "variants": [
    {
      "id": "portrait",
      "width": 600,
      "height": 1000,
      "clipRadius": 24,
      "responsive": [ /* responsive overrides for portrait */ ]
    },
    {
      "id": "square",
      "width": 800,
      "height": 800,
      "clipRadius": 40,
      "responsive": [ /* responsive overrides for square */ ]
    },
    {
      "id": "social_share",
      "width": 1200,
      "height": 630,
      "clipRadius": 0,
      "responsive": [ /* responsive overrides for social share */ ]
    }
  ]
}
```

Each variant defines an alternative canvas configuration. The responsive rules in each variant adjust layer positions, sizes, and styles to accommodate the different aspect ratio. When the engine selects a variant (based on render context), it uses that variant's `width`, `height`, and `clipRadius` and applies the variant's responsive rules.

### 3.5 Color Format Specification

TTSv2 supports the following color formats:

| Format | Pattern | Example | Notes |
|---|---|---|---|
| Hex RGB | `#RRGGBB` | `#D4AF37` | Standard 6-digit hex |
| Hex RGBA | `#RRGGBBAA` | `#D4AF3780` | 8-digit hex with alpha |
| Hex short | `#RGB` | `#DAB` | 3-digit shorthand |
| Hex short alpha | `#RGBA` | `#DA8A` | 4-digit shorthand |
| CSS rgba | `rgba(R,G,B,A)` | `rgba(212,175,55,0.5)` | Decimal 0–255, alpha 0–1 |
| CSS rgb | `rgb(R,G,B)` | `rgb(212,175,55)` | No alpha |
| CSS hsl | `hsl(H,S%,L%)` | `hsl(45,65%,52%)` | Hue 0–360, Saturation/Lightness 0–100% |
| CSS hsla | `hsla(H,S%,L%,A)` | `hsla(45,65%,52%,0.5)` | With alpha |
| Named | `transparent` | `transparent` | Fully transparent (alpha 0) |
| Named | `white` | `white` | `#FFFFFF` |
| Named | `black` | `black` | `#000000` |

Engines MUST support all listed formats. Engines SHOULD parse colors case-insensitively.

### 3.6 Complete Canvas Example

```jsonc
"canvas": {
  "width": 1000,
  "height": 600,
  "aspectRatio": "5:3",
  "clipRadius": 24,
  "clipShape": "rounded_rectangle",
  "padding": { "top": 32, "bottom": 32, "left": 40, "right": 40 },
  "safeArea": { "top": 44, "bottom": 34, "left": 16, "right": 16 },
  "coordinateSystem": "top-left",
  "backgroundColor": "#1A1A2E",
  "backgroundGradient": { "kind": "linear", "colors": ["#0F0F1A", "#1A1A2E"], "angle": 180 },
  "responsiveMode": "scale",
  "deviceScaling": "auto",
  "variants": [
    {
      "id": "portrait",
      "width": 600,
      "height": 1000,
      "clipRadius": 24,
      "responsive": [
        { "conditions": { "variant": "portrait" }, "overrides": [] }
      ]
    }
  ]
}
```

---

## 4. Theme Variables

### 4.1 Overview

The variables system provides **named design tokens** that can be referenced throughout the theme. This enables:

- **Single-source-of-truth:** Change one variable value to update every usage.
- **Systematic theming:** Variables form a design token hierarchy.
- **Inheritance:** Themes can extend base themes by overriding specific variables.
- **Tooling:** Design token editors can visualize and edit all variables in one place.

### 4.2 Variable Categories

| Category | JSON Key | Values | Description |
|---|---|---|---|
| Colors | `variables.colors` | Color strings | Named color tokens |
| Typography | `variables.typography` | Typography objects | Named text style definitions |
| Radius | `variables.radius` | Numbers | Corner radius tokens |
| Spacing | `variables.spacing` | Numbers | Spacing/sizing tokens |
| Elevation | `variables.elevation` | Numbers | Z-depth/elevation tokens |
| Opacity | `variables.opacity` | Numbers (0–1) | Opacity tokens |
| Shadows | `variables.shadows` | Shadow objects | Box shadow definitions |
| Icons | `variables.icons` | Icon references | Icon asset references |
| Animation | `variables.animation` | Duration/easing objects | Animation timing tokens |
| Gradients | `variables.gradients` | Gradient objects | Reusable gradient definitions |
| Sizes | `variables.sizes` | Numbers | Named size tokens (avatar, border width, etc.) |
| Numbers | `variables.numbers` | Numbers | Arbitrary numeric constants |
| Strings | `variables.strings` | Strings | Arbitrary string constants |

### 4.3 Variable Declaration

Variables are declared under the `variables` key at the theme root:

```jsonc
"variables": {
  "colors": {
    "primary": "#1A1A2E",
    "accent": "#D4AF37",
    "accentLight": "#F0D78C",
    "textPrimary": "#FFFFFF",
    "textSecondary": "rgba(255,255,255,0.7)",
    "textMuted": "rgba(255,255,255,0.4)",
    "surface": "rgba(255,255,255,0.06)",
    "surfaceHover": "rgba(255,255,255,0.1)"
  },
  "typography": {
    "display": {
      "fontFamily": "Playfair Display",
      "fontSize": 34,
      "fontWeight": "700",
      "letterSpacing": 0.5,
      "lineHeight": 1.2,
      "color": "$var.colors.textPrimary"
    },
    "heading": {
      "fontFamily": "Inter",
      "fontSize": 14,
      "fontWeight": "600",
      "letterSpacing": 2.0,
      "color": "$var.colors.accent"
    },
    "body": {
      "fontFamily": "Inter",
      "fontSize": 12,
      "fontWeight": "400",
      "color": "$var.colors.textSecondary"
    }
  },
  "spacing": {
    "xs": 4,
    "sm": 8,
    "md": 16,
    "lg": 24,
    "xl": 32,
    "xxl": 48
  },
  "radius": {
    "sm": 4,
    "md": 8,
    "lg": 16,
    "xl": 24,
    "full": 999
  },
  "shadows": {
    "card": {
      "color": "rgba(0,0,0,0.3)",
      "offset": { "dx": 0, "dy": 8 },
      "blurRadius": 24,
      "spread": 0
    },
    "text": {
      "color": "rgba(0,0,0,0.4)",
      "offset": { "dx": 0, "dy": 2 },
      "blurRadius": 4
    }
  },
  "durations": {
    "fast": 150,
    "normal": 300,
    "slow": 500
  },
  "opacity": {
    "disabled": 0.38,
    "hint": 0.6,
    "medium": 0.74,
    "high": 0.87
  },
  "gradients": {
    "gold": {
      "kind": "linear",
      "colors": ["#D4AF37", "#F0D78C", "#B8860B"],
      "angle": 135,
      "stops": [0, 0.5, 1]
    }
  },
  "sizes": {
    "avatar": 100,
    "avatarBorder": 3,
    "icon": 24,
    "qrCode": 160,
    "borderWidth": 2
  }
}
```

### 4.4 Variable Reference Syntax

Variables are referenced using the `$var.{path}` syntax within any string value in the theme:

| Syntax | Example | Resolves To |
|---|---|---|
| Color | `"$var.colors.primary"` | `"#1A1A2E"` |
| Typography | `"$var.typography.display"` | `{ fontFamily: ..., fontSize: ... }` |
| Spacing | `"$var.spacing.lg"` | `24` (number) |
| Nested | `"$var.typography.body.color"` | The color property within body typography |

Variable references can appear in:
- Color properties
- Typography property objects
- Numeric properties (spacing, radius, opacity, etc.)
- Nested object values

### 4.5 Variable Type System

Variables are **implicitly typed** by their JSON value structure:

| JSON Value Structure | Inferred Type |
|---|---|
| `"#RRGGBB"` or `"rgba(...)"` or `"hsl(...)"` | color |
| `{ "kind": "linear", "colors": [...], ... }` | gradient |
| `{ "fontFamily": "...", "fontSize": N, ... }` | typography |
| `{ "color": "...", "offset": {...}, "blurRadius": N }` | shadow |
| `number` | number |
| `string` (not matching color patterns) | string |
| `true` / `false` | boolean |

### 4.6 Variable Inheritance

Variables follow a **four-level resolution chain**:

```
1. Local (layer scope)
2. Component (component definition scope)
3. Theme (root variables scope)
4. Base Engine Defaults (engine fallbacks)
```

#### Resolution Algorithm

```
resolve(path, context):
  1. If context.localVariables contains path → return context.localVariables[path]
  2. If context.componentVariables contains path → return context.componentVariables[path]
  3. If theme.variables contains path → return theme.variables[path]
  4. If engineDefaults contains path → return engineDefaults[path]
  5. Log warning: "Unresolved variable: {path}"
  6. Return type-appropriate fallback (null, 0, empty string)
```

### 4.7 Variable Overriding

Variables can be overridden at each scope level:

#### Layer-Level Override

```jsonc
{
  "id": "special_layer",
  "type": "rectangle",
  "variables": {
    "colors": { "accent": "#FF6B35" }
  },
  "fill": "$var.colors.accent"  // Resolves to "#FF6B35" (overridden)
}
```

#### Component-Level Override

```jsonc
"components": {
  "profile_header": {
    "variables": {
      "colors": { "primary": "#2A2A4E" }
    },
    "layers": [ /* ... */ ]
  }
}
```

#### Theme-Level (Root)

The root `variables` block defines the theme-wide defaults.

### 4.8 Variable Fallbacks

A variable reference can include a fallback value using the `||` operator:

```
"$var.colors.customAccent||#D4AF37"
```

If `$var.colors.customAccent` is unresolvable, the engine uses `#D4AF37`.

### 4.9 Variable Scopes

| Scope | Visibility | Lifetime | Defined In |
|---|---|---|---|
| Global | All themes | Engine session | Engine defaults |
| Theme | Current theme | Theme lifetime | Root `variables` block |
| Component | Current component invocation | Component expansion | Component definition `variables` block |
| Local | Current layer | Layer rendering | Layer `variables` block |
| Instance | Single usage | Expression evaluation | Inline in property |

### 4.10 Circular Reference Detection

Engines MUST detect circular variable references:

```
A → $var.B → $var.C → $var.A  (CIRCULAR)
```

Circular references MUST be reported as validation errors. The engine SHOULD break the cycle by using the last resolved value before the loop.

### 4.11 Variable Validation Rules

| Rule | Severity | Description |
|---|---|---|
| Unresolved variable | Warning | Variable reference could not be resolved at any scope |
| Type mismatch | Error | Variable value type doesn't match usage context (e.g., color used as font size) |
| Circular reference | Error | Variable references form a cycle |
| Unknown category | Warning | Variable category not in the standard registry |
| Override type mismatch | Warning | Override value type differs from base definition |

### 4.12 Base Engine Defaults

Engines MUST provide a set of base theme variables:

```jsonc
{
  "colors": {
    "textPrimary": "#000000",
    "textSecondary": "rgba(0,0,0,0.6)",
    "textInverse": "#FFFFFF",
    "surface": "rgba(255,255,255,0.05)",
    "surfaceDark": "rgba(0,0,0,0.05)"
  },
  "spacing": { "xs": 4, "sm": 8, "md": 16, "lg": 24, "xl": 32, "xxl": 48 },
  "radius": { "sm": 4, "md": 8, "lg": 16, "xl": 24, "full": 999 },
  "durations": { "fast": 150, "normal": 300, "slow": 500 },
  "opacity": { "disabled": 0.38, "hint": 0.6, "medium": 0.74, "high": 0.87 },
  "sizes": { "avatar": 100, "avatarBorder": 3, "icon": 24, "qrCode": 160 }
}
```

---

## 5. Asset Specification

### 5.1 Overview

The `assets` block declares all external files that the theme depends on. Assets are referenced by their `id` throughout the theme (in image layers, typography fontFamily, icon references, etc.).

### 5.2 Asset Categories

| Category | JSON Key | File Types | Description |
|---|---|---|---|
| Raster Images | `assets.images` | PNG, JPEG, WebP, AVIF, BMP | Photographs, patterns, textures |
| Vector Images | `assets.vectors` | SVG | Logos, icons, illustrations |
| Fonts | `assets.fonts` | TTF, OTF, WOFF, WOFF2 | Custom typefaces |
| Textures | `assets.textures` | PNG, JPEG, WebP | Repeating background textures |
| Patterns | `assets.patterns` | PNG, SVG | Decorative repeating patterns |
| Icons | `assets.icons` | SVG, PNG (multi-res) | Icon sets |

### 5.3 Image Asset Specification

```jsonc
{
  "assets": {
    "images": [
      {
        "id": "bg_pattern",
        "src": "assets/images/pattern.png",
        "type": "png",
        "width": 1000,
        "height": 600,
        "resolution": [1, 2, 3],
        "fit": "cover",
        "cache": true,
        "compression": "lossless",
        "version": "1.0.0",
        "alt": "Gold geometric pattern background"
      }
    ]
  }
}
```

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | string | **yes** | — | Unique identifier referenced by layers |
| `src` | string | **yes** | — | Path relative to theme root, or absolute URL |
| `type` | string | no | inferred from extension | `"png"`, `"jpeg"`, `"webp"`, `"avif"`, `"bmp"` |
| `width` | integer | no | null | Intrinsic width in pixels |
| `height` | integer | no | null | Intrinsic height in pixels |
| `resolution` | array<int> | no | `[1]` | Available resolutions for DPI targeting (1x, 2x, 3x) |
| `fit` | string | no | `"contain"` | `"cover"`, `"contain"`, `"fill"`, `"none"`, `"scaleDown"` |
| `cache` | boolean | no | `true` | Whether the engine should cache this asset |
| `compression` | string | no | `"lossy"` | `"lossless"`, `"lossy"` |
| `version` | string | no | `"1.0.0"` | Asset version for cache invalidation |
| `alt` | string | no | null | Alt text for accessibility |

### 5.4 SVG Asset Specification

```jsonc
{
  "assets": {
    "vectors": [
      {
        "id": "brand_icon",
        "src": "assets/vectors/brand_icon.svg",
        "colorizable": true,
        "keepAspectRatio": true,
        "version": "1.0.0"
      }
    ]
  }
}
```

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | string | **yes** | — | Unique identifier |
| `src` | string | **yes** | — | Path relative to theme root, or absolute URL |
| `colorizable` | boolean | no | `false` | Whether a `color` property can tint this SVG |
| `keepAspectRatio` | boolean | no | `true` | Preserve SVG's intrinsic aspect ratio |
| `version` | string | no | `"1.0.0"` | Asset version |

### 5.5 Font Asset Specification

```jsonc
{
  "assets": {
    "fonts": [
      {
        "family": "Playfair Display",
        "src": "assets/fonts/PlayfairDisplay-Regular.ttf",
        "weight": 400,
        "style": "normal",
        "unicodeRange": "U+0000-00FF",
        "fallback": ["Serif", "Georgia"],
        "version": "1.0.0"
      },
      {
        "family": "Playfair Display",
        "src": "assets/fonts/PlayfairDisplay-Bold.ttf",
        "weight": 700,
        "style": "normal"
      },
      {
        "family": "Playfair Display",
        "src": "assets/fonts/PlayfairDisplay-Italic.ttf",
        "weight": 400,
        "style": "italic"
      }
    ]
  }
}
```

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `family` | string | **yes** | — | Font family name. MUST match across weights/styles for the same family. |
| `src` | string | **yes** | — | Path relative to theme root, or absolute URL |
| `weight` | integer | no | `400` | 100–900 in increments of 100 |
| `style` | string | no | `"normal"` | `"normal"`, `"italic"`, `"oblique"` |
| `unicodeRange` | string | no | null | Unicode range for subset fonts |
| `fallback` | array<string> | no | `["sans-serif"]` | Fallback font families in order |
| `version` | string | no | `"1.0.0"` | Font version |

### 5.6 Remote Assets

Assets can reference remote URLs:

```jsonc
{
  "id": "user_avatar",
  "src": "https://cdn.taply.ai/assets/avatar_default.svg",
  "type": "svg",
  "remote": true
}
```

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `remote` | boolean | no | `false` | Indicates this asset is fetched from a remote URL |
| `fallbackSrc` | string | no | null | Fallback URL if the primary fails to load |
| `timeoutMs` | integer | no | `10000` | Timeout for remote asset loading |
| `headers` | object | no | null | HTTP headers for the request |

### 5.7 Embedded Assets

Small assets (under 10KB, particularly SVGs and icons) can be embedded directly:

```jsonc
{
  "assets": {
    "vectors": [
      {
        "id": "embedded_icon",
        "embedded": "<svg xmlns=\"...\">...</svg>",
        "type": "svg",
        "colorizable": true
      }
    ]
  }
}
```

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `embedded` | string | no | null | Raw asset content instead of a file path |

### 5.8 Asset Versioning

All asset types support `version` for cache invalidation. When the asset content changes, increment the version. The engine uses `id + version` as the cache key.

### 5.9 Asset Caching Rules

| Asset Type | Cache Strategy | Default TTL |
|---|---|---|---|
| Local images (bundle) | Memory LRU, 50MB max | Session |
| Remote images | Memory LRU + disk cache | 7 days |
| SVGs (parsed) | Memory WeakMap | GC lifetime |
| Fonts | Memory (permanent once loaded) | Session |
| Textures | Memory LRU, 20MB max | Session |

---

## 6. Scene Graph Specification

### 6.1 Overview

The **Taply Scene Graph** (implemented as `SceneGraph` in the engine) is the in-memory representation of a parsed, resolved, and validated theme. It is an **ordered tree** of typed nodes that describes every visual element, its properties, its spatial relationships, and its behaviors.

The scene graph is the bridge between the serialized JSON format and the rendering engine. All JSON processing (parsing, validation, variable resolution, component expansion) produces a scene graph. The rendering engine consumes only the scene graph.

### 6.2 Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        Scene Graph                               │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Scene (root)                                              │  │
│  │  ├── metadata: ThemeMetadata                               │  │
│  │  ├── variables: VariableMap                                │  │
│  │  ├── assets: AssetManifest                                │  │
│  │  ├── components: ComponentRegistry                         │  │
│  │  └── layers: LayerNode[] (ordered)                         │  │
│  │      ├── PaintLayerNode                                    │  │
│  │      │   ├── id, type, zIndex, visible, opacity           │  │
│  │      │   ├── constraints: Constraint                       │  │
│  │      │   ├── fill: FillDefinition                          │  │
│  │      │   ├── stroke: StrokeDefinition                     │  │
│  │      │   ├── effects: EffectNode[]                         │  │
│  │      │   └── transform: Transform                          │  │
│  │      ├── WidgetLayerNode                                   │  │
│  │      │   ├── id, type, zIndex, visible, opacity           │  │
│  │      │   ├── constraints: Constraint                       │  │
│  │      │   ├── field: string (field binding)                │  │
│  │      │   ├── style: TextStyle                              │  │
│  │      │   ├── params: Map (type-specific)                  │  │
│  │      │   └── conditional: Conditional                      │  │
│  │      ├── GroupNode                                         │  │
│  │      │   ├── id, zIndex, visible                           │  │
│  │      │   └── children: LayerNode[] (ordered)               │  │
│  │      └── ComponentNode                                     │  │
│  │          ├── componentId: string                           │  │
│  │          ├── slots: Map (slot overrides)                   │  │
│  │          └── variables: VariableMap (overrides)            │  │
│  │                                                              │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
│  ┌───────────────────────────────────────────────────────────┐  │
│  │  Animations: AnimationDefinition[]                         │  │
│  │  Responsive: ResponsiveRule[]                              │  │
│  └───────────────────────────────────────────────────────────┘  │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 6.3 Node Types

#### 6.3.1 Scene (Root)

The scene is the root node of the scene graph. It is created by the parser after validation and resolution.

| Property | Type | Description |
|---|---|---|
| `metadata` | ThemeMetadata | Parsed metadata fields |
| `variables` | VariableMap | Resolved variable definitions |
| `assets` | AssetManifest | Asset declarations and loaded references |
| `components` | ComponentRegistry | Parsed component definitions |
| `layers` | LayerNode[] | Ordered list of top-level layers |
| `animations` | AnimationDefinition[] | Animation timeline definitions |
| `responsive` | ResponsiveRule[] | Responsive override rules |

**Traversal:** Engines traverse the scene graph in a depth-first, pre-order manner. Widget and paint nodes are collected into a flat z-ordered list for rendering.

#### 6.3.2 Group Node

A group node contains child layers that share a common z-index offset and visibility state.

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | string | **yes** | Unique identifier |
| `type` | string | **yes** | Always `"group"` |
| `zIndex` | integer | no | Base z-index (children add to this) |
| `visible` | boolean | no | Visibility toggle |
| `opacity` | number | no | Group opacity (applied to all children) |
| `children` | LayerNode[] | **yes** | Ordered child layer nodes |
| `constraints` | Constraint | no | Constraints that define the group bounds |

#### 6.3.3 Layer Node (Base)

Every layer node extends this base:

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | string | **yes** | Unique identifier within the theme |
| `type` | string | **yes** | Layer type identifier |
| `zIndex` | integer | no | Rendering order (default: list index) |
| `visible` | boolean | no | Visibility toggle |
| `opacity` | number | no | Opacity multiplier (0–1) |
| `blendMode` | string | no | Blend mode compositing |
| `constraints` | Constraint | no | Layout constraints |
| `effects` | EffectNode[] | no | Array of effect applications |
| `extensions` | object | no | Custom extension properties |
| `animations` | object | no | Per-layer animation bindings |

#### 6.3.4 Paint Layer Node

Extends Layer Node with paint-specific properties:

| Property | Type | Description |
|---|---|---|
| `fill` | FillDefinition | Solid color, gradient, or pattern fill |
| `stroke` | StrokeDefinition | Border/outline stroke |
| `borderRadius` | BorderRadius | Per-corner radius |
| `params` | Map | Type-specific parameters |
| `transform` | Transform | Affine transform |

#### 6.3.5 Widget Layer Node

Extends Layer Node with widget-specific properties:

| Property | Type | Description |
|---|---|---|
| `field` | string | Business data field binding |
| `style` | TextStyle | Typography and text styling |
| `params` | Map | Type-specific widget parameters |
| `conditional` | Conditional | Conditional visibility rules |
| `placeholder` | string | Placeholder text when field is empty |

#### 6.3.6 Component Node

A component invocation node that is resolved during scene graph assembly:

| Property | Type | Description |
|---|---|---|
| `componentId` | string | Reference to a defined component |
| `slots` | Map<string, any> | Slot override values |
| `variables` | VariableMap | Variable overrides for this invocation |
| `constraints` | Constraint | Outer constraints for the component |

### 6.4 Scene Graph Properties

#### 6.4.1 Z-Index

- All layers have a `zIndex` property (integer).
- Layers without explicit `zIndex` default to their position in the array (0-based).
- Higher z-index layers render on top of lower z-index layers.
- Groups apply their z-index as a base offset; children within a group are offset relative to the group's z-index.
- The engine sorts all resolved layers by z-index ascending before rendering.

#### 6.4.2 Parent-Child Relationships

- The scene graph is a tree. Each node (except Scene) has exactly one parent.
- The parent reference is established during scene graph assembly, not during parsing.
- Layout constraints may reference parent dimensions (e.g., percentage-based sizing).
- Group nodes provide the parent context for their children.

#### 6.4.3 Visibility

- `visible: false` on a node hides that node and all its descendants.
- Hidden nodes are excluded from layout and rendering.
- The `conditional` property on widget nodes can dynamically set visibility based on field data.

#### 6.4.4 Locking

- `locked: true` on a node prevents it from being selected or modified in authoring tools.
- Locked nodes are rendered normally. Locking is a tooling concept, not a rendering concept.

#### 6.4.5 Clipping

- Group nodes can enable clipping: `clipContent: true`.
- When clipping is enabled, children are clipped to the group's bounding rectangle.
- Individual layers can also define their own clipping behavior via the `clip_path` layer type.

#### 6.4.6 Masking

- Layers can reference a mask layer via `maskLayer: "mask_layer_id"`.
- The mask layer provides the alpha channel for the masked content.
- Masking is applied during rendering using `saveLayer`.

### 6.5 Scene Graph Assembly Pipeline

```
Raw JSON
  ↓
1. Parse → Abstract Syntax Tree (unresolved)
  ↓
2. Validate → Semantic validation
  ↓
3. Resolve References → Expand $ref pointers
  ↓
4. Resolve Variables → Substitute $var references
  ↓
5. Expand Components → Replace component invocations with their layers
  ↓
6. Flatten Groups → Create parent-child graph
  ↓
7. Compute Z-Index → Assign z-indices to all layers
  ↓
8. Build Scene Graph → Immutable typed structure
  ↓
9. Cache Scene Graph → LRU cache for subsequent renders
```

### 6.6 Layer Ordering

The final rendering order is:

1. **Sort** all layers by their resolved `zIndex` (ascending).
2. Within the same z-index, **preserve original array order**.
3. Paint layers and widget layers are **interleaved** by z-index.
4. The sorter produces two lists for the renderer:
   - Paint order (all paint layers sorted by z-index)
   - Widget order (all widget layers sorted by z-index)

### 6.7 Nested Groups

Groups can contain other groups. During flattening:

1. The group's `zIndex` becomes a base offset for all descendants.
2. A child's effective `zIndex` = `group.zIndex + child.zIndex`.
3. Group `opacity` multiplies with child `opacity`.
4. Group `visible: false` hides all descendants.
5. Nested group constraints are resolved hierarchically.

### 6.8 Scene Serialization

The scene graph can be serialized back to JSON via the `SceneGraphCodec`. The round-trip (JSON → SceneGraph → JSON) SHOULD produce a semantically equivalent document. Floating-point precision differences (±0.001) are acceptable.

---

## 7. Paint Layer Specification

### 7.1 Overview

Paint layers are non-interactive visual elements rendered directly onto the card's canvas via drawing operations. They form the visual foundation of the card — backgrounds, gradients, shapes, textures, decorative elements, and visual effects.

Every paint layer type is identified by its `type` string. The engine's `PaintRegistry` maps type strings to rendering implementations (defined in the Architecture §2.2).

### 7.2 Paint Layer Properties

All paint layers share these common properties, plus type-specific `params`:

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | string | **yes** | — | Unique layer identifier |
| `type` | string | **yes** | — | Paint layer type (see catalog below) |
| `zIndex` | integer | no | list index | Rendering order |
| `visible` | boolean | no | `true` | Visibility toggle |
| `opacity` | number | no | `1.0` | Opacity (0.0–1.0) |
| `blendMode` | string | no | `"srcOver"` | Compositing blend mode |
| `constraints` | Constraint | **yes** | — | Position and size |
| `fill` | FillDef | no | null | Fill color, gradient, or pattern |
| `stroke` | StrokeDef | no | null | Border/outline stroke |
| `borderRadius` | BorderRadius | no | `0` | Per-corner radius |
| `effects` | EffectNode[] | no | `[]` | Visual effects applied to this layer |
| `transform` | Transform | no | identity | Affine transformation |
| `params` | object | no | `{}` | Type-specific parameters |
| `variables` | object | no | `{}` | Layer-scoped variable overrides |
| `animations` | object | no | `{}` | Animation bindings |
| `extensions` | object | no | `{}` | Custom extension properties |

### 7.3 Fill Specification

```jsonc
"fill": {
  "kind": "linear",       // "solid" | "linear" | "radial" | "sweep" | "image" | "noise"
  "color": "#D4AF37",     // For "solid"
  "colors": ["#1A1A2E", "#D4AF37"],  // For gradients
  "angle": 135,           // For linear gradient (degrees)
  "stops": [0, 0.5, 1],   // Gradient stop positions (0–1)
  "focalX": 0.5,          // For radial gradient
  "focalY": 0.5,          // For radial gradient
  "radius": 0.5,          // For radial gradient
  "src": "image_asset_id", // For "image" fill
  "fit": "cover",          // For "image" fill
  "seed": 42,             // For "noise" fill
  "scale": 1.5            // For "noise" fill
}
```

### 7.4 Stroke Specification

```jsonc
"stroke": {
  "color": "#D4AF37",
  "width": 2,
  "style": "solid",       // "solid" | "dashed" | "dotted"
  "dashPattern": [8, 4],  // For dashed: lengths of dash and gap
  "cap": "round",          // "butt" | "round" | "square"
  "join": "miter",         // "miter" | "round" | "bevel"
  "miterLimit": 4
}
```

### 7.5 Paint Layer Catalog

#### 7.5.1 Rectangle

**Type value:** `"rectangle"`

**Purpose:** The most fundamental paint layer. Renders a filled and/or stroked rectangle. Used for backgrounds, color blocks, panels, and frames.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |
| borderRadius | `borderRadius` | BorderRadius | no | `0` | Per-corner radius |

**BorderRadius specification:**

```jsonc
"borderRadius": 16,                    // Uniform radius
"borderRadius": { "all": 16 },         // Uniform radius (explicit)
"borderRadius": { "topLeft": 16, "topRight": 16, "bottomLeft": 0, "bottomRight": 0 }
```

**Validation rules:**
- `topLeft`, `topRight`, `bottomLeft`, `bottomRight` MUST each be ≥ 0.
- `topLeft` + `topRight` MUST ≤ layer width.
- `bottomLeft` + `bottomRight` MUST ≤ layer width.
- `topLeft` + `bottomLeft` MUST ≤ layer height.
- `topRight` + `bottomRight` MUST ≤ layer height.

**Performance:** Single rectangle draw operation. Border radius adds a rounded-rect draw. Both are GPU-efficient.

**Example:**

```jsonc
{
  "id": "card_background",
  "type": "rectangle",
  "zIndex": -10,
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" },
  "fill": { "kind": "linear", "colors": ["#0F0F1A", "#1A1A2E"], "angle": 180 },
  "stroke": { "color": "rgba(255,255,255,0.08)", "width": 1 },
  "borderRadius": { "bottomLeft": 16, "bottomRight": 16 }
}
```

#### 7.5.2 Rounded Rectangle

**Type value:** `"rounded_rectangle"`

**Purpose:** A rectangle with explicitly rounded corners. Semantically identical to `rectangle` with `borderRadius`. Provided as a convenience type for clarity when the rounding is the primary visual feature.

**Properties:** Same as `rectangle`. The presence of `borderRadius` is required (functional parity with rectangle).

**Performance:** Identical to rectangle with border radius.

**Example:**

```jsonc
{
  "id": "glass_panel",
  "type": "rounded_rectangle",
  "constraints": { "left": 500, "top": 40, "right": 40, "bottom": 40 },
  "fill": { "kind": "solid", "color": "rgba(255,255,255,0.06)" },
  "borderRadius": 16
}
```

#### 7.5.3 Circle

**Type value:** `"circle"`

**Purpose:** A perfect circle. Used for decorative dots, accent elements, avatar backgrounds, and badge indicators.

| Property | Path | Type | Required | Description |
|---|---|---|---|---|
| fill | `fill` | FillDef | no | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | Border stroke |
| center | `params.center` | object | no | Override center point `{x, y}` |
| radius | `params.radius` | number | no | Override radius (otherwise derived from constraint width/2) |

**Validation rules:**
- Layer width and height MUST be equal for a perfect circle. If not equal, the smaller dimension is used (centered).
- `radius` MUST be ≥ 0.

**Performance:** `drawCircle` — O(1), very GPU-efficient.

**Example:**

```jsonc
{
  "id": "accent_dot",
  "type": "circle",
  "constraints": { "centerX": 500, "centerY": 300, "width": 80, "height": 80 },
  "fill": { "kind": "radial", "colors": ["rgba(212,175,55,0.3)", "transparent"] },
  "stroke": { "color": "#D4AF37", "width": 2 }
}
```

#### 7.5.4 Oval

**Type value:** `"oval"`

**Purpose:** An ellipse with independent x and y radii. Used for organic backgrounds, light bloom effects, and decorative shapes.

| Property | Path | Type | Required | Description |
|---|---|---|---|---|
| fill | `fill` | FillDef | no | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | Border stroke |
| center | `params.center` | object | no | Override center point `{x, y}` |

**Validation rules:** None beyond standard constraint validation.

**Performance:** `drawOval` — O(1).

**Example:**

```jsonc
{
  "id": "bloom_light",
  "type": "oval",
  "constraints": { "centerX": 800, "centerY": 300, "width": 400, "height": 200 },
  "fill": { "kind": "radial", "colors": ["rgba(212,175,55,0.08)", "transparent"] },
  "opacity": 0.6,
  "blendMode": "screen"
}
```

#### 7.5.5 Polygon

**Type value:** `"polygon"`

**Purpose:** A regular polygon with N sides. Used for geometric decorative elements.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |
| sides | `params.sides` | integer | **yes** | — | Number of sides (≥ 3) |
| rotation | `params.rotation` | number | no | `0` | Rotation in degrees |

**Validation rules:**
- `sides` MUST be ≥ 3.
- `sides` MUST be ≤ 128 (practical limit).

**Performance:** Path construction is O(sides). Draw is O(1). Path SHOULD be cached on first render.

**Example:**

```jsonc
{
  "id": "deco_hexagon",
  "type": "polygon",
  "params": { "sides": 6, "rotation": 15 },
  "constraints": { "centerX": 200, "centerY": 200, "width": 60, "height": 60 },
  "fill": { "kind": "solid", "color": "rgba(212,175,55,0.3)" }
}
```

#### 7.5.6 Triangle

**Type value:** `"triangle"`

**Purpose:** An equilateral triangle. Used for directional arrows, decorative points, and accent marks.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |
| direction | `params.direction` | string | no | `"up"` | `"up"`, `"down"`, `"left"`, `"right"` |

**Validation rules:** `direction` MUST be one of the allowed values.

**Performance:** Path with 3 points — minimal overhead.

**Example:**

```jsonc
{
  "id": "accent_arrow",
  "type": "triangle",
  "params": { "direction": "right" },
  "constraints": { "left": 60, "top": 120, "width": 16, "height": 16 },
  "fill": { "kind": "solid", "color": "$var.colors.accent" }
}
```

#### 7.5.7 Diamond

**Type value:** `"diamond"`

**Purpose:** A square rotated 45°, producing a diamond shape. Used for luxury accents, gem-like decorations, and modern geometric elements.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |

**Performance:** Path with 4 points — minimal overhead.

**Example:**

```jsonc
{
  "id": "jewel_accent",
  "type": "diamond",
  "constraints": { "centerX": 900, "centerY": 80, "width": 24, "height": 24 },
  "fill": { "kind": "solid", "color": "$var.colors.accent" }
}
```

#### 7.5.8 Hexagon

**Type value:** `"hexagon"`

**Purpose:** A regular hexagon. Implemented as a convenience wrapper around polygon with sides=6. Used for honeycomb patterns, modern UI accents, and tech-themed designs.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |
| rotation | `params.rotation` | number | no | `0` | Rotation in degrees |

**Performance:** Same as polygon with sides=6.

**Example:**

```jsonc
{
  "id": "honeycomb_bg",
  "type": "hexagon",
  "constraints": { "centerX": 500, "centerY": 300, "width": 200, "height": 173 },
  "fill": { "kind": "solid", "color": "rgba(255,255,255,0.03)" }
}
```

#### 7.5.9 Bezier Path

**Type value:** `"bezier_path"`

**Purpose:** Renders an arbitrary path defined by SVG path data. Used for custom decorative shapes, swooshes, ribbons, and illustrations.

| Property | Path | Type | Required | Description |
|---|---|---|---|---|
| fill | `fill` | FillDef | no | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | Border stroke |
| d | `params.d` | string | **yes** | SVG path data string |

**Supported SVG commands:** `M`, `L`, `H`, `V`, `C`, `S`, `Q`, `T`, `A`, `Z` (and lowercase relative variants).

**Validation rules:**
- `params.d` MUST be a valid SVG path data string. Invalid commands SHOULD be logged as warnings and skipped.

**Performance:** Path parsing is O(path length). Parsed paths MUST be cached by the engine (keyed by the `d` string). Pre-caching at load time is recommended.

**Example:**

```jsonc
{
  "id": "ribbon",
  "type": "bezier_path",
  "params": {
    "d": "M 0,500 C 200,450 300,550 500,500 C 700,450 800,550 1000,500 L 1000,600 L 0,600 Z"
  },
  "fill": { "kind": "solid", "color": "rgba(212,175,55,0.12)" }
}
```

#### 7.5.10 Arc

**Type value:** `"arc"`

**Purpose:** A circular arc or pie slice. Used for gauge elements, decorative sweeps, and circular progress indicators.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |
| startAngle | `params.startAngle` | number | **yes** | — | Start angle in degrees (0 = 3 o'clock, clockwise) |
| sweepAngle | `params.sweepAngle` | number | **yes** | — | Arc sweep in degrees (positive = clockwise) |
| useCenter | `params.useCenter` | boolean | no | `false` | If true, draws a pie slice (arc + center lines) |

**Validation rules:**
- `startAngle` and `sweepAngle` are in degrees. Engines should convert to radians for drawing.
- `sweepAngle` of 360 with `useCenter: true` produces a full circle.

**Performance:** `drawArc` — O(1).

**Example:**

```jsonc
{
  "id": "deco_sweep",
  "type": "arc",
  "params": { "startAngle": -45, "sweepAngle": 90, "useCenter": false },
  "constraints": { "centerX": 500, "centerY": 300, "width": 400, "height": 400 },
  "stroke": { "color": "$var.colors.accent", "width": 2 }
}
```

#### 7.5.11 Line

**Type value:** `"line"`

**Purpose:** A straight line segment. Used for dividers, rules, underlines, and decorative lines.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| stroke | `stroke` | StrokeDef | **yes** | — | Line stroke (color, width) |
| x1 | `params.x1` | number | no | constraint left | Start X |
| y1 | `params.y1` | number | no | constraint top | Start Y |
| x2 | `params.x2` | number | no | constraint right | End X |
| y2 | `params.y2` | number | no | constraint bottom | End Y |

**Validation rules:** Line width SHOULD be ≥ 0.5 for visibility.

**Performance:** `drawLine` — O(1).

**Example:**

```jsonc
{
  "id": "section_divider",
  "type": "line",
  "params": { "x1": 40, "y1": 260, "x2": 460, "y2": 260 },
  "stroke": { "color": "rgba(212,175,55,0.3)", "width": 1, "style": "dashed", "dashPattern": [6, 4] }
}
```

#### 7.5.12 Linear Gradient

**Type value:** `"linear_gradient"`

**Purpose:** Renders a linear gradient as a standalone layer (as opposed to using the fill property on a shape). Useful for gradient backgrounds that don't need a shape.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| colors | `params.colors` | array | **yes** | — | Array of color strings |
| angle | `params.angle` | number | no | `0` | Gradient angle in degrees |
| stops | `params.stops` | array | no | evenly spaced | Stop positions (0–1) |
| startPoint | `params.startPoint` | object | no | derived from angle | Override start `{x, y}` |
| endPoint | `params.endPoint` | object | no | derived from angle | Override end `{x, y}` |

**Performance:** Creates a shader. O(1) draw operation.

**Example:**

```jsonc
{
  "id": "gradient_overlay",
  "type": "linear_gradient",
  "params": { "colors": ["#D4AF37", "#transparent"], "angle": 90 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.13 Radial Gradient

**Type value:** `"radial_gradient"`

**Purpose:** Renders a radial gradient as a standalone layer.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| colors | `params.colors` | array | **yes** | — | Array of color strings |
| focalX | `params.focalX` | number | no | `0.5` | Focal point X (0–1, relative to width) |
| focalY | `params.focalY` | number | no | `0.5` | Focal point Y (0–1, relative to height) |
| radius | `params.radius` | number | no | `0.5` | Gradient radius (0–1, relative to max dimension) |
| stops | `params.stops` | array | no | evenly spaced | Stop positions (0–1) |

**Performance:** Creates a shader. O(1) draw operation.

**Example:**

```jsonc
{
  "id": "radial_glow",
  "type": "radial_gradient",
  "params": { "colors": ["rgba(212,175,55,0.2)", "transparent"], "focalX": 0.8, "focalY": 0.5, "radius": 0.4 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.14 Sweep Gradient

**Type value:** `"sweep_gradient"`

**Purpose:** A gradient that sweeps around a center point (conical gradient). Used for circular progress, radar effects, and advanced decorative backgrounds.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| colors | `params.colors` | array | **yes** | — | Array of color strings |
| centerX | `params.centerX` | number | no | width/2 | Center X in design units |
| centerY | `params.centerY` | number | no | height/2 | Center Y in design units |
| startAngle | `params.startAngle` | number | no | `0` | Start angle in degrees |
| endAngle | `params.endAngle` | number | no | `360` | End angle in degrees |
| stops | `params.stops` | array | no | evenly spaced | Stop positions (0–1) |

**Performance:** Creates a shader. O(1) draw operation.

**Example:**

```jsonc
{
  "id": "sweep_accent",
  "type": "sweep_gradient",
  "params": { "colors": ["transparent", "$var.colors.accent", "transparent"], "startAngle": 0, "endAngle": 120 },
  "constraints": { "centerX": 500, "centerY": 300, "width": 400, "height": 400 }
}
```

#### 7.5.15 Mesh Gradient

**Type value:** `"mesh_gradient"`

**Purpose:** A multi-point gradient defined by a grid of control points, similar to Figma's mesh gradient or Adobe Illustrator's mesh tool. Used for premium, organic, and artistic backgrounds.

| Property | Path | Type | Required | Description |
|---|---|---|---|---|
| points | `params.points` | array | **yes** | Array of control point objects |
| blur | `params.blur` | number | no | Smoothing factor (0–1) |

**Control point object:**

```jsonc
{
  "x": 0.0,       // X position as fraction of width (0–1)
  "y": 0.0,       // Y position as fraction of height (0–1)
  "color": "#D4AF37"  // Color at this point
}
```

**Grid structure:** Points SHOULD form a rectangular grid. The engine infers the grid dimensions from the array. A 3×3 grid has 9 points (3 rows of 3).

**Validation rules:**
- Minimum 4 points (2×2 grid).
- Practical maximum: 64 points (8×8 grid).
- Each point MUST have `x`, `y`, and `color`.

**Performance:** GPU-intensive. Engines SHOULD use tessellation (e.g., `Canvas.drawVertices` with `VertexMode.triangleStrip`) for GPU-accelerated rendering. Pre-render to a cached `ui.Picture` for static meshes.

**Example:**

```jsonc
{
  "id": "premium_bg",
  "type": "mesh_gradient",
  "params": {
    "points": [
      { "x": 0, "y": 0, "color": "#0F0F1A" },
      { "x": 0.5, "y": 0, "color": "#1A1A2E" },
      { "x": 1, "y": 0, "color": "#16213E" },
      { "x": 0, "y": 0.5, "color": "#1A1A2E" },
      { "x": 0.5, "y": 0.5, "color": "#D4AF37" },
      { "x": 1, "y": 0.5, "color": "#1A1A2E" },
      { "x": 0, "y": 1, "color": "#0F0F1A" },
      { "x": 0.5, "y": 1, "color": "#16213E" },
      { "x": 1, "y": 1, "color": "#0F0F1A" }
    ],
    "blur": 0.3
  }
}
```

#### 7.5.16 Noise

**Type value:** `"noise"`

**Purpose:** Procedural Perlin/simplex noise texture. Used for paper texture, film grain, subtle background texture, and adding visual richness to flat colors.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| seed | `params.seed` | integer | no | `0` | Random seed for reproducibility |
| scale | `params.scale` | number | no | `1.0` | Noise scale (larger = smoother) |
| opacity | `params.opacity` | number | no | `0.05` | Overlay opacity (0–1) |
| octaves | `params.octaves` | integer | no | `3` | Number of noise octaves |
| color | `params.color` | color | no | `"#FFFFFF"` | Noise color |

**Validation rules:**
- `seed` SHOULD be 0–2147483647.
- `scale` MUST be > 0.
- `opacity` MUST be 0–1.
- `octaves` MUST be 1–8.

**Performance:** CPU-based noise generation is O(width × height × octaves). Engines MUST pre-render noise to a `ui.Image` at load time and cache it. Re-generate only when seed or scale changes.

**Example:**

```jsonc
{
  "id": "paper_texture",
  "type": "noise",
  "params": { "seed": 12345, "scale": 2, "opacity": 0.04, "octaves": 3, "color": "#FFFFFF" },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.17 Paper Texture

**Type value:** `"paper_texture"`

**Purpose:** Simulates the visual texture of paper — subtle grain, fiber patterns, and surface variation. Used for premium print-like business cards.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| type | `params.type` | string | no | `"laid"` | `"laid"`, `"vellum"`, `"parchment"`, `"canvas"`, `"watercolor"` |
| intensity | `params.intensity` | number | no | `0.3` | Texture intensity (0–1) |
| seed | `params.seed` | integer | no | `0` | Random seed |

**Performance:** Pre-rendered texture cached as `ui.Image`. Same performance class as noise.

**Example:**

```jsonc
{
  "id": "premium_paper",
  "type": "paper_texture",
  "params": { "type": "laid", "intensity": 0.2, "seed": 42 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.18 Fabric Texture

**Type value:** `"fabric_texture"`

**Purpose:** Simulates woven fabric textures — linen, silk, wool, tweed. Used for cards that convey warmth, luxury, or handcrafted quality.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| type | `params.type` | string | no | `"linen"` | `"linen"`, `"silk"`, `"wool"`, `"tweed"`, `"denim"` |
| color | `params.color` | color | no | `"#FFFFFF"` | Fabric base color |
| weaveDensity | `params.weaveDensity` | number | no | `0.5` | Weave density (0–1) |

**Performance:** Same as noise — pre-rendered and cached.

**Example:**

```jsonc
{
  "id": "linen_bg",
  "type": "fabric_texture",
  "params": { "type": "linen", "color": "#F5F0E8", "weaveDensity": 0.4 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.19 Carbon Fiber

**Type value:** `"carbon_fiber"`

**Purpose:** Carbon fiber weave pattern. Used for sporty, tech, automotive, and industrial-themed cards.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| scale | `params.scale` | number | no | `1.0` | Weave scale |
| color | `params.color` | color | no | `"#1A1A2E"` | Base color |
| highlight | `params.highlight` | color | no | `"#2A2A4E"` | Weave highlight color |
| opacity | `params.opacity` | number | no | `0.5` | Overall opacity |

**Performance:** Pre-rendered pattern tiled across the canvas. Efficient.

**Example:**

```jsonc
{
  "id": "carbon_bg",
  "type": "carbon_fiber",
  "params": { "scale": 1.5, "color": "#1A1A2E", "highlight": "#2A2A4E", "opacity": 0.5 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.20 Glass

**Type value:** `"glass"`

**Purpose:** Glassmorphism effect — a frosted glass appearance achieved through blur, tint, and subtle border. Used for panels, cards, and overlay sections.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| blur | `params.blur` | number | **yes** | — | Gaussian blur sigma |
| tint | `params.tint` | color | no | `"rgba(255,255,255,0.1)"` | Glass tint color with opacity |
| borderOpacity | `params.borderOpacity` | number | no | `0.1` | Border opacity (0–1) |
| borderColor | `params.borderColor` | color | no | `"#FFFFFF"` | Border color |
| borderWidth | `params.borderWidth` | number | no | `0.5` | Border width |
| borderRadius | `params.borderRadius` | BorderRadius | no | `0` | Corner radius |
| saturation | `params.saturation` | number | no | `1.0` | Color saturation multiplier |
| brightness | `params.brightness` | number | no | `1.0` | Brightness multiplier |

**Validation rules:**
- `blur` MUST be ≥ 0.5 and ≤ 100.
- `borderOpacity` MUST be 0–1.
- `saturation` MUST be ≥ 0 and ≤ 3.
- `brightness` MUST be ≥ 0 and ≤ 3.

**Performance:** Requires `saveLayer` + `BackdropFilter`. This is the most GPU-intensive effect. Limit to 0–2 glass layers per card. Engines SHOULD consider dropping the backdrop blur on low-end devices while preserving the tint and border.

**Example:**

```jsonc
{
  "id": "info_panel_glass",
  "type": "glass",
  "params": {
    "blur": 16,
    "tint": "rgba(212,175,55,0.08)",
    "borderOpacity": 0.15,
    "borderColor": "#FFFFFF",
    "borderWidth": 0.5,
    "borderRadius": 16,
    "saturation": 1.2
  },
  "constraints": { "left": 500, "top": 40, "right": 40, "bottom": 40 }
}
```

#### 7.5.21 Glass Panel

**Type value:** `"glass_panel"`

**Purpose:** A pre-configured glassmorphism layer optimized for panel/container use. Provides glass effects with sensible default padding and gives the glass a container-like behavior for widget children.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| blur | `params.blur` | number | no | `12` | Gaussian blur sigma |
| tint | `params.tint` | color | no | `"rgba(255,255,255,0.06)"` | Glass tint |
| padding | `params.padding` | number/object | no | `24` | Inner padding |

**Performance:** Same as `glass`.

**Example:**

```jsonc
{
  "id": "glass_contact_panel",
  "type": "glass_panel",
  "params": { "blur": 12, "tint": "rgba(255,255,255,0.06)", "padding": 24 },
  "constraints": { "left": 500, "top": 40, "width": 460, "height": 520 }
}
```

#### 7.5.22 Backdrop Blur

**Type value:** `"backdrop_blur"`

**Purpose:** Applies a gaussian blur to the content behind this layer. Does not add tint or border — pure blur. Used as a compositing step for complex effects.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| sigmaX | `params.sigmaX` | number | **yes** | — | Horizontal blur sigma |
| sigmaY | `params.sigmaY` | number | **yes** | — | Vertical blur sigma |
| tileMode | `params.tileMode` | string | no | `"clamp"` | `"clamp"`, `"mirror"`, `"repeat"`, `"decal"` |

**Validation rules:**
- `sigmaX` and `sigmaY` MUST be ≥ 0.5 and ≤ 100.

**Performance:** Uses `BackdropFilter` with `ImageFilter.blur`. Requires `saveLayer`. Same performance characteristics as glass, without the additional rendering passes.

**Example:**

```jsonc
{
  "id": "depth_blur",
  "type": "backdrop_blur",
  "params": { "sigmaX": 8, "sigmaY": 8, "tileMode": "mirror" },
  "constraints": { "left": 100, "top": 100, "width": 300, "height": 300 }
}
```

#### 7.5.23 Blur

**Type value:** `"blur"`

**Purpose:** Applies a gaussian blur to the layer's own content (not the backdrop). Used to soften specific elements.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| sigmaX | `params.sigmaX` | number | **yes** | — | Horizontal blur sigma |
| sigmaY | `params.sigmaY` | number | **yes** | — | Vertical blur sigma |

**Validation rules:** Same as `backdrop_blur`.

**Performance:** Uses `MaskFilter.blur()` instead of `BackdropFilter`, which is cheaper than backdrop blur.

**Example:**

```jsonc
{
  "id": "soft_glow",
  "type": "blur",
  "params": { "sigmaX": 4, "sigmaY": 4 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" },
  "fill": { "kind": "solid", "color": "$var.colors.accent" }
}
```

#### 7.5.24 Shadow

**Type value:** `"shadow"`

**Purpose:** Renders a drop shadow. Can be applied as a layer itself or as an effect on other layers.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| color | `params.color` | color | no | `"rgba(0,0,0,0.3)"` | Shadow color |
| offsetX | `params.offsetX` | number | no | `0` | Horizontal offset |
| offsetY | `params.offsetY` | number | no | `4` | Vertical offset |
| blurRadius | `params.blurRadius` | number | no | `12` | Blur radius |
| spread | `params.spread` | number | no | `0` | How much the shadow expands |
| style | `params.style` | string | no | `"outer"` | `"outer"`, `"inner"` |

**Validation rules:**
- `blurRadius` MUST be ≥ 0.
- `spread` MUST be ≥ -100 (negative spread shrinks the shadow).

**Performance:** Uses `saveLayer` + `MaskFilter.blur()`. One saveLayer per shadow. Expensive but acceptable for 1–3 shadows per card.

**Example:**

```jsonc
{
  "id": "card_drop_shadow",
  "type": "shadow",
  "params": { "color": "rgba(0,0,0,0.4)", "offsetX": 0, "offsetY": 8, "blurRadius": 24, "spread": 0 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.25 Inner Shadow

**Type value:** `"inner_shadow"`

**Purpose:** Renders a shadow inside the layer's bounds, creating a recessed/depressed appearance.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| color | `params.color` | color | no | `"rgba(0,0,0,0.3)"` | Shadow color |
| offsetX | `params.offsetX` | number | no | `0` | Horizontal offset |
| offsetY | `params.offsetY` | number | no | `2` | Vertical offset |
| blurRadius | `params.blurRadius` | number | no | `4` | Blur radius |

**Performance:** Uses `saveLayer` + clip + blur. Slightly more expensive than outer shadow.

**Example:**

```jsonc
{
  "id": "inset_shadow",
  "type": "inner_shadow",
  "params": { "color": "rgba(0,0,0,0.3)", "offsetX": 0, "offsetY": 2, "blurRadius": 4 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.26 Glow

**Type value:** `"glow"`

**Purpose:** An outer glow effect that makes elements appear to emit light.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| color | `params.color` | color | no | `"#D4AF37"` | Glow color |
| radius | `params.radius` | number | no | `16` | Glow spread radius |
| opacity | `params.opacity` | number | no | `0.4` | Glow opacity (0–1) |
| style | `params.style` | string | no | `"outer"` | `"outer"`, `"inner"` |

**Performance:** Uses `saveLayer` + `MaskFilter.blur()` with a larger blur radius. Similar cost to shadow.

**Example:**

```jsonc
{
  "id": "name_glow",
  "type": "glow",
  "params": { "color": "$var.colors.accent", "radius": 12, "opacity": 0.3, "style": "outer" },
  "constraints": { "left": 40, "top": 80, "width": 300, "height": 40 }
}
```

#### 7.5.27 Outer Glow

**Type value:** `"outer_glow"`

**Purpose:** An explicit outer glow layer. Semantically identical to `glow` with `style: "outer"`. Provided for clarity.

**Properties:** Same as `glow`.

#### 7.5.28 Sparkles

**Type value:** `"sparkles"`

**Purpose:** Decorative sparkle/star particles. Used for luxury themes, celebration designs, and premium accents.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| count | `params.count` | integer | **yes** | — | Number of sparkles |
| size | `params.size` | number | no | `8` | Sparkle size |
| color | `params.color` | color | no | `"#D4AF37"` | Sparkle color |
| opacity | `params.opacity` | number | no | `0.6` | Base opacity |
| seed | `params.seed` | integer | no | `0` | Random seed |
| animated | `params.animated` | boolean | no | `false` | Enable twinkle animation |
| twinkleSpeed | `params.twinkleSpeed` | number | no | `1.0` | Twinkling speed multiplier |

**Validation rules:**
- `count` MUST be ≥ 1 and ≤ 500.
- `size` MUST be ≥ 2 and ≤ 100.
- `opacity` MUST be 0–1.

**Performance:** Each sparkle is a small path. Static sparkles: O(count) draw calls. Animated sparkles: O(count) per frame with opacity modulation. For 100+ sparkles, batch rendering.

**Example:**

```jsonc
{
  "id": "luxury_sparkles",
  "type": "sparkles",
  "params": { "count": 30, "size": 8, "color": "$var.colors.accent", "opacity": 0.6, "seed": 7, "animated": true, "twinkleSpeed": 1.5 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.29 Particles

**Type value:** `"particles"`

**Purpose:** Dynamic particle field. Particles are small circles that can optionally drift/animate. Used for premium animated backgrounds, cosmic themes, and ambient effects.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| count | `params.count` | integer | **yes** | — | Number of particles |
| minRadius | `params.minRadius` | number | no | `0.5` | Minimum particle radius |
| maxRadius | `params.maxRadius` | number | no | `3` | Maximum particle radius |
| color | `params.color` | color | no | `"#FFFFFF"` | Particle color |
| alpha | `params.alpha` | number | no | `0.5` | Particle opacity (0–1) |
| seed | `params.seed` | integer | no | `0` | Placement seed |
| animated | `params.animated` | boolean | no | `false` | Enable particle drift |
| driftSpeed | `params.driftSpeed` | number | no | `5` | Drift speed in design units/second |
| driftDirection | `params.driftDirection` | number | no | `270` | Drift direction in degrees |
| glow | `params.glow` | boolean | no | `false` | Enable glow around particles |

**Validation rules:**
- `count` MUST be ≥ 1 and ≤ 3000.
- `minRadius` MUST be ≥ 0.1.
- `maxRadius` MUST be ≥ `minRadius`.
- `alpha` MUST be 0–1.
- `driftSpeed` MUST be ≥ 0.

**Performance:** Static: O(count) draw calls (SHOULD use `drawPoints(PointMode.points)` batching). Animated: O(count) per frame with position updates. Glow: each particle requires a second draw call. For 500+ particles with glow, pre-render a glow sprite and reuse.

**Example:**

```jsonc
{
  "id": "star_field",
  "type": "particles",
  "params": {
    "count": 150,
    "minRadius": 0.5,
    "maxRadius": 3,
    "color": "$var.colors.accent",
    "alpha": 0.5,
    "seed": 42,
    "animated": true,
    "driftSpeed": 5,
    "driftDirection": 270,
    "glow": true
  },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.30 Floating Dots

**Type value:** `"floating_dots"`

**Purpose:** Scattered dots decoration — a simpler, static alternative to particles. Used for ambient backgrounds and subtle texture.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| count | `params.count` | integer | **yes** | — | Number of dots |
| minRadius | `params.minRadius` | number | no | `1` | Minimum dot radius |
| maxRadius | `params.maxRadius` | number | no | `4` | Maximum dot radius |
| color | `params.color` | color | no | `"#FFFFFF"` | Dot color |
| opacity | `params.opacity` | number | no | `0.15` | Dot opacity (0–1) |
| seed | `params.seed` | integer | no | `0` | Random seed |

**Validation rules:** Same min/radius constraints as particles.

**Performance:** O(count) draw calls. Pre-render to cache for 1000+ dots.

**Example:**

```jsonc
{
  "id": "ambient_dots",
  "type": "floating_dots",
  "params": { "count": 200, "minRadius": 1, "maxRadius": 4, "color": "$var.colors.accent", "opacity": 0.15, "seed": 7 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.31 Circuit Pattern

**Type value:** `"circuit_pattern"`

**Purpose:** A procedural circuit board trace pattern. Used for tech-themed cards, startup brands, and engineer-appropriate designs.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| density | `params.density` | number | no | `0.3` | Trace density (0–1) |
| color | `params.color` | color | no | `"rgba(0,150,255,0.06)"` | Trace color |
| seed | `params.seed` | integer | no | `0` | Pattern generation seed |
| lineWidth | `params.lineWidth` | number | no | `1` | Trace line width |

**Validation rules:**
- `density` MUST be 0–1.
- Higher density values produce more complex patterns but at higher render cost.

**Performance:** Generated procedurally using recursive division. Pre-render to `ui.Image` cache. Regenerate only when seed or density changes.

**Example:**

```jsonc
{
  "id": "tech_bg",
  "type": "circuit_pattern",
  "params": { "density": 0.3, "color": "rgba(0,150,255,0.06)", "seed": 99, "lineWidth": 0.5 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.32 Grid

**Type value:** `"grid"`

**Purpose:** A ruled grid overlay. Used for blueprint-style cards, minimalist layouts, and alignment aids.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| stepX | `params.stepX` | number | **yes** | — | Horizontal grid spacing |
| stepY | `params.stepY` | number | **yes** | — | Vertical grid spacing |
| color | `params.color` | color | no | `"rgba(255,255,255,0.04)"` | Line color |
| strokeWidth | `params.strokeWidth` | number | no | `0.5` | Line width |
| style | `params.style` | string | no | `"lines"` | `"lines"`, `"dots"`, `"crosses"` |

**Validation rules:**
- `stepX` and `stepY` MUST be ≥ 1.
- For `dots` and `crosses` styles, dots are drawn at grid intersections.

**Performance:** Lines mode: (width/stepX) + (height/stepY) draw calls. Dots mode: (width/stepX) × (height/stepY) draw calls. Very fast.

**Example:**

```jsonc
{
  "id": "blueprint_grid",
  "type": "grid",
  "params": { "stepX": 50, "stepY": 50, "color": "rgba(255,255,255,0.04)", "strokeWidth": 0.5, "style": "lines" },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.33 Wave

**Type value:** `"wave"`

**Purpose:** A sine wave pattern. Used for wavy dividers, flowing backgrounds, and abstract decorative elements.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| amplitude | `params.amplitude` | number | **yes** | — | Wave height |
| frequency | `params.frequency` | number | **yes** | — | Wave frequency (number of cycles) |
| phase | `params.phase` | number | no | `0` | Phase shift in degrees |
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |
| direction | `params.direction` | string | no | `"horizontal"` | `"horizontal"`, `"vertical"` |

**Validation rules:**
- `amplitude` MUST be ≥ 0.
- `frequency` MUST be > 0 and ≤ 100.

**Performance:** Path constructed by iterating across the canvas dimension. O(canvas dimension × frequency). Cache path for static parameters.

**Example:**

```jsonc
{
  "id": "wave_divider",
  "type": "wave",
  "params": { "amplitude": 15, "frequency": 2, "phase": 0, "direction": "horizontal" },
  "fill": { "kind": "solid", "color": "rgba(212,175,55,0.15)" },
  "constraints": { "left": 0, "top": 280, "width": "100%", "height": 40 }
}
```

#### 7.5.34 Blob

**Type value:** `"blob"`

**Purpose:** An organic blob shape (metaball-like). Used for modern, organic backgrounds and liquid-style accents.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| points | `params.points` | integer | no | `8` | Number of control points (4–20) |
| seed | `params.seed` | integer | no | `0` | Random seed for blob generation |
| smoothness | `params.smoothness` | number | no | `0.4` | Curve smoothing (0–1) |
| fill | `fill` | FillDef | no | null | Fill color or gradient |
| stroke | `stroke` | StrokeDef | no | null | Border stroke |

**Validation rules:**
- `points` MUST be 4–20.
- `smoothness` MUST be 0–1.

**Performance:** Pre-generates path using cubic beziers from interpolated control points. Cache path for (seed, smoothness) combination.

**Example:**

```jsonc
{
  "id": "organic_accent",
  "type": "blob",
  "params": { "points": 8, "seed": 42, "smoothness": 0.4 },
  "fill": { "kind": "solid", "color": "rgba(212,175,55,0.06)" },
  "constraints": { "centerX": 800, "centerY": 200, "width": 300, "height": 200 }
}
```

#### 7.5.35 Organic Shapes

**Type value:** `"organic_shapes"`

**Purpose:** A composable set of organic/amorphous shapes that blend together. Provides a more sophisticated version of blobs with layering.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| shapes | `params.shapes` | array | **yes** | — | Array of organic shape definitions |
| blendMode | `params.blendMode` | string | no | `"multiply"` | Blend mode for overlapping shapes |

**Shape definition:**

```jsonc
{
  "type": "blob",
  "seed": 42,
  "points": 8,
  "smoothness": 0.4,
  "color": "rgba(212,175,55,0.06)",
  "scale": 1.0,
  "offsetX": 0,
  "offsetY": 0
}
```

**Performance:** Each shape is a blob path drawn with the specified blend mode. Composite cost.

**Example:**

```jsonc
{
  "id": "organic_composition",
  "type": "organic_shapes",
  "params": {
    "shapes": [
      { "type": "blob", "seed": 42, "points": 8, "smoothness": 0.3, "color": "rgba(212,175,55,0.08)", "scale": 1.2, "offsetX": -50 },
      { "type": "blob", "seed": 77, "points": 6, "smoothness": 0.5, "color": "rgba(255,100,100,0.05)", "scale": 0.8, "offsetX": 100, "offsetY": 50 }
    ],
    "blendMode": "multiply"
  }
}
```

#### 7.5.36 Premium Border

**Type value:** `"premium_border"`

**Purpose:** Elaborate decorative borders — gold frames, filigree, art deco, vintage, and geometric borders. Used for luxury, premium, and ceremonial business cards.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| style | `params.style` | string | **yes** | — | `"filigree"`, `"geometric"`, `"minimal"`, `"vintage"`, `"art_deco"`, `"scalloped"`, `"double_line"`, `"ornate"` |
| color | `params.color` | color | no | `"#D4AF37"` | Border color |
| width | `params.width` | number | no | `2` | Border stroke width |
| inset | `params.inset` | number | no | `16` | Distance from card edge |
| cornerStyle | `params.cornerStyle` | string | no | `"default"` | `"default"`, `"ornament"`, `"rounded"`, `"pointed"`, `"filigree"` |
| segments | `params.segments` | integer | no | `0` | Number of decorative segments (0 = continuous) |

**Validation rules:**
- `width` MUST be ≥ 0.5.
- `inset` MUST be ≥ 0.
- `segments` MUST be ≥ 0 and ≤ 100.

**Performance:** Each style is a pre-defined path composition. Path SHOULD be cached by style. Pre-render to `ui.Picture` and replay. `filigree` is the most complex style and SHOULD be pre-cached.

**Example:**

```jsonc
{
  "id": "gold_frame",
  "type": "premium_border",
  "params": {
    "style": "art_deco",
    "color": "$var.colors.accent",
    "width": 2,
    "inset": 16,
    "cornerStyle": "ornament",
    "segments": 0
  },
  "constraints": { "left": 12, "top": 12, "right": 12, "bottom": 12 }
}
```

#### 7.5.37 Decorative Shapes

**Type value:** `"decorative_shapes"`

**Purpose:** Ornamental shapes that don't fit into other categories — chevrons, brackets, flourishes, dot lines, corner accents.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| shape | `params.shape` | string | **yes** | — | `"chevron"`, `"bracket"`, `"flourish"`, `"dot_line"`, `"corner_accent"`, `"diamond_line"`, `"arrow"`, `"star"`, `"heart"` |
| color | `params.color` | color | no | `"#000000"` | Shape color |
| size | `params.size` | number | no | `12` | Shape size |
| count | `params.count` | integer | no | `1` | Number of repeated shapes |
| spacing | `params.spacing` | number | no | `24` | Spacing between repeated shapes |

**Performance:** Each shape is a small path. Very fast.

**Example:**

```jsonc
{
  "id": "chevron_divider",
  "type": "decorative_shapes",
  "params": { "shape": "chevron", "color": "$var.colors.accent", "size": 12, "count": 3, "spacing": 24 },
  "constraints": { "left": 40, "top": 260, "right": 460, "height": 20 }
}
```

#### 7.5.38 Mask

**Type value:** `"mask"`

**Purpose:** An alpha or luminance mask that controls the visibility of layers beneath it. Used for gradient fades, reveals, and text-as-mask effects.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| source | `params.source` | object | **yes** | — | Mask content (gradient, image, or shape) |
| mode | `params.mode` | string | no | `"alpha"` | `"alpha"`, `"luminance"` |
| invert | `params.invert` | boolean | no | `false` | Invert the mask |
| layers | `params.layers` | array<string> | no | `[]` (all underlying layers) | Layer IDs this mask applies to |

**Validation rules:**
- `source` MUST be a valid gradient, image reference, or shape definition.

**Performance:** Requires `saveLayer` to composite. Expensive — use sparingly.

**Example:**

```jsonc
{
  "id": "fade_mask",
  "type": "mask",
  "params": {
    "source": { "kind": "linear", "colors": ["black", "transparent", "transparent", "black"], "angle": 90 },
    "mode": "alpha",
    "invert": false,
    "layers": ["bg_deco", "particles"]
  }
}
```

#### 7.5.39 Clip Path

**Type value:** `"clip_path"`

**Purpose:** Clips all content within the layer's bounds to a specific path. Used for creative cropping, diagonal cuts, and circular reveals.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| path | `params.path` | string | **yes** | — | SVG path data string |
| clipBehavior | `params.clipBehavior` | string | no | `"antiAlias"` | `"antiAlias"`, `"hardEdge"` |

**Validation rules:**
- `path` MUST be a valid SVG path data string.

**Performance:** `clipPath` is reasonably efficient. Complex paths with many segments add CPU cost.

**Example:**

```jsonc
{
  "id": "diagonal_clip",
  "type": "clip_path",
  "params": { "path": "M 0,0 L 1000,0 L 1000,300 L 0,600 Z", "clipBehavior": "antiAlias" }
}
```

#### 7.5.40 Opacity

**Type value:** `"opacity"`

**Purpose:** Sets the opacity of content rendered beneath this layer. Used as a compositing step.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| value | `params.value` | number | **yes** | — | Opacity value (0–1) |

**Validation rules:** `value` MUST be 0–1.

**Performance:** Uses `saveLayer`. Minimal overhead for a single saveLayer pass.

**Example:**

```jsonc
{
  "id": "fade_overlay",
  "type": "opacity",
  "params": { "value": 0.5 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

#### 7.5.41 Transform

**Type value:** `"transform"`

**Purpose:** Applies an affine transformation (translation, rotation, scale, skew) to the content beneath this layer.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| translateX | `params.translateX` | number | no | `0` | X translation |
| translateY | `params.translateY` | number | no | `0` | Y translation |
| rotation | `params.rotation` | number | no | `0` | Rotation in degrees |
| scaleX | `params.scaleX` | number | no | `1.0` | X scale factor |
| scaleY | `params.scaleY` | number | no | `1.0` | Y scale factor |
| skewX | `params.skewX` | number | no | `0` | X skew (in degrees) |
| skewY | `params.skewY` | number | no | `0` | Y skew (in degrees) |
| originX | `params.originX` | number | no | `0` | Transform origin X |
| originY | `params.originY` | number | no | `0` | Transform origin Y |

**Performance:** Matrix multiplication at the canvas level. Very cheap.

**Example:**

```jsonc
{
  "id": "rotated_accent",
  "type": "transform",
  "params": { "rotation": 45, "originX": 500, "originY": 300 },
  "constraints": { "left": 400, "top": 200, "width": 200, "height": 200 },
  "fill": { "kind": "solid", "color": "$var.colors.accent" }
}
```

#### 7.5.42 Blend Mode

**Type value:** `"blend_mode"`

**Purpose:** Changes the compositing blend mode for content rendered beneath this layer.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| mode | `params.mode` | string | **yes** | — | Blend mode (see list below) |

**Supported blend modes:**

All standard Porter-Duff modes plus CSS compositing modes:

`srcOver`, `srcIn`, `srcOut`, `srcATop`, `dstOver`, `dstIn`, `dstOut`, `dstATop`, `xor`, `plus`, `modulate`, `screen`, `overlay`, `darken`, `lighten`, `colorDodge`, `colorBurn`, `hardLight`, `softLight`, `difference`, `exclusion`, `multiply`, `hue`, `saturation`, `color`, `luminosity`

**Performance:** Uses `saveLayer` with the blend mode. Some modes (hue, saturation, color, luminosity) are more expensive as they require color space conversion.

**Example:**

```jsonc
{
  "id": "overlay_accent",
  "type": "blend_mode",
  "params": { "mode": "overlay" },
  "fill": { "kind": "solid", "color": "$var.colors.accent" },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" },
  "opacity": 0.3
}
```

#### 7.5.43 Rotation

**Type value:** `"rotation"`

**Purpose:** Convenience type for rotating a layer. Semantically a subset of `transform`.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| angle | `params.angle` | number | **yes** | — | Rotation in degrees |
| originX | `params.originX` | number | no | layer center X | Rotation origin X |
| originY | `params.originY` | number | no | layer center Y | Rotation origin Y |

#### 7.5.44 Scale

**Type value:** `"scale"`

**Purpose:** Convenience type for scaling a layer. Semantically a subset of `transform`.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| factorX | `params.factorX` | number | **yes** | — | X scale factor |
| factorY | `params.factorY` | number | no | same as factorX | Y scale factor |
| originX | `params.originX` | number | no | layer center X | Scale origin X |
| originY | `params.originY` | number | no | layer center Y | Scale origin Y |

#### 7.5.45 Repeat

**Type value:** `"repeat"`

**Purpose:** Repeats a child layer in a grid pattern. Used for tiled backgrounds, pattern fills, and repeated decorative elements.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| countX | `params.countX` | integer | **yes** | — | Number of repetitions horizontally |
| countY | `params.countY` | integer | **yes** | — | Number of repetitions vertically |
| spacingX | `params.spacingX` | number | no | `0` | Horizontal spacing between repetitions |
| spacingY | `params.spacingY` | number | no | `0` | Vertical spacing between repetitions |
| child | `params.child` | LayerNode | **yes** | — | The layer to repeat |

**Performance:** Repeats the child's paint operations countX × countY times. For complex children, pre-render one instance to a `ui.Picture` and repeat the picture.

**Example:**

```jsonc
{
  "id": "diamond_pattern",
  "type": "repeat",
  "params": {
    "countX": 10,
    "countY": 6,
    "spacingX": 8,
    "spacingY": 8,
    "child": {
      "type": "diamond",
      "fill": { "kind": "solid", "color": "rgba(212,175,55,0.08)" },
      "constraints": { "width": 80, "height": 80 }
    }
  }
}
```

#### 7.5.46 Tile

**Type value:** `"tile"`

**Purpose:** Tiles a repeatable image or pattern across the layer bounds. Similar to CSS `background-repeat`.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| src | `params.src` | string | **yes** | — | Asset ID of the tile image |
| tileWidth | `params.tileWidth` | number | no | intrinsic width | Tile width in design units |
| tileHeight | `params.tileHeight` | number | no | intrinsic height | Tile height in design units |
| offsetX | `params.offsetX` | number | no | `0` | Horizontal tile offset |
| offsetY | `params.offsetY` | number | no | `0` | Vertical tile offset |

**Performance:** Tile as `ui.Image` fill pattern. GPU-efficient via image shader.

**Example:**

```jsonc
{
  "id": "tile_bg",
  "type": "tile",
  "params": { "src": "pattern_tile", "tileWidth": 100, "tileHeight": 100 },
  "constraints": { "left": 0, "top": 0, "width": "100%", "height": "100%" }
}
```

---

## 8. Widget Layer Specification

### 8.1 Overview

Widget layers are **interactive or content-bearing elements** that render on top of the painted canvas. Unlike paint layers, widget layers preserve platform-native behavior: text selection, accessibility, hit testing, and interactive feedback.

Widget layers display **business data** through **field bindings**. The theme declares which field each widget layer reads, and the rendering engine injects the actual values at render time.

### 8.2 Widget Layer Common Properties

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | string | **yes** | — | Unique layer identifier |
| `type` | string | **yes** | — | Widget type identifier |
| `zIndex` | integer | no | list index | Rendering order (relative to other widget/paint layers) |
| `visible` | boolean | no | `true` | Visibility toggle |
| `opacity` | number | no | `1.0` | Opacity (0–1) |
| `constraints` | Constraint | **yes** | — | Position and size in design units |
| `field` | string | depends | null | Business data field binding |
| `style` | TextStyle | no | `{}` | Typography and text style |
| `params` | object | no | `{}` | Type-specific parameters |
| `conditional` | Conditional | no | `{}` | Conditional visibility rules |
| `placeholder` | string | no | null | Text shown when field value is empty |
| `effects` | EffectNode[] | no | `[]` | Visual effects (supports shadow, glow) |
| `variables` | object | no | `{}` | Layer-scoped variable overrides |
| `extensions` | object | no | `{}` | Custom extension properties |

### 8.3 Conditional Visibility

```jsonc
"conditional": {
  "hideIfEmpty": true,           // Hide when field value is empty
  "hideIfEquals": "hidden",      // Hide when field value equals this string
  "showIfRegex": "^[+]",         // Show only if field matches regex
  "requireAll": ["phone", "email"], // Hide unless ALL specified fields have values
  "requireAny": ["phone", "email"]  // Hide unless ANY specified field has a value
}
```

### 8.4 Widget Layer Catalog

#### 8.4.1 Avatar

**Type value:** `"avatar"`

**Purpose:** Renders the user's profile photo. Can display as circle, rounded rectangle, hexagon, or diamond. Falls back to initials or an icon when no photo is available.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"avatar"` | Field containing the image URL/path |
| shape | `params.shape` | string | no | `"circle"` | `"circle"`, `"rounded_rectangle"`, `"hexagon"`, `"diamond"` |
| borderRadius | `params.borderRadius` | BorderRadius | no | shape default | Custom corner radius for `rounded_rectangle` |
| border | `params.border` | StrokeDef | no | null | Avatar border |
| fit | `params.fit` | string | no | `"cover"` | Image fit: `"cover"`, `"contain"`, `"fill"` |
| fallback | `params.fallback` | object | no | `{"type":"icon"}` | `{"type":"initials", "field":"fullName"}` or `{"type":"icon", "icon":"person"}` or `{"type":"none"}` |
| fallbackStyle | `params.fallbackStyle` | TextStyle | no | `{}` | Styling for initials/icon fallback |
| interactive | `params.interactive` | boolean | no | `false` | Enable tap to view full-size photo |
| shadow | `params.shadow` | ShadowDef | no | null | Drop shadow under avatar |

**Validation rules:**
- If `shape` is `"circle"`, width and height constraints SHOULD be equal.

**Example:**

```jsonc
{
  "id": "user_avatar",
  "type": "avatar",
  "zIndex": 10,
  "constraints": { "left": 40, "top": 40, "width": 80, "height": 80 },
  "field": "avatar",
  "params": {
    "shape": "circle",
    "border": { "width": 3, "color": "$var.colors.accent" },
    "fit": "cover",
    "fallback": { "type": "initials", "field": "fullName" },
    "interactive": true
  }
}
```

#### 8.4.2 Logo

**Type value:** `"logo"`

**Purpose:** Renders the company logo. Similar to avatar but with company-specific fallback behavior.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"companyLogo"` | Field containing the logo image URL/path |
| shape | `params.shape` | string | no | `"rounded_rectangle"` | `"circle"`, `"rounded_rectangle"`, `"none"` |
| borderRadius | `params.borderRadius` | BorderRadius | no | `8` | Corner radius |
| fit | `params.fit` | string | no | `"contain"` | Image fit |
| fallback | `params.fallback` | object | no | `{"type":"text","initials":"companyName"}` | Fallback when no logo |
| background | `params.background` | FillDef | no | null | Background behind the logo |

**Example:**

```jsonc
{
  "id": "company_logo",
  "type": "logo",
  "constraints": { "left": 40, "top": 140, "width": 60, "height": 60 },
  "field": "companyLogo",
  "params": {
    "shape": "rounded_rectangle",
    "borderRadius": 8,
    "fit": "contain",
    "fallback": { "type": "initials", "field": "companyName" }
  }
}
```

#### 8.4.3 QR

**Type value:** `"qr"`

**Purpose:** Renders a QR code that encodes the user's contact data or a URL.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| data | `params.data` | string | no | `"vcard"` | `"vcard"`, `"url"`, `"text"`, `"wifi"`, `"tel"`, `"mailto"`, `"custom"` |
| field | `params.field` | string | no | null | Custom data field (for `"custom"` type) |
| color | `params.color` | color | no | `"#000000"` | QR module color |
| backgroundColor | `params.backgroundColor` | color | no | `"#FFFFFF"` | QR background color |
| errorCorrection | `params.errorCorrection` | string | no | `"medium"` | `"low"`, `"medium"`, `"quartile"`, `"high"` |
| margin | `params.margin` | number | no | `4` | Margin around QR code in modules |
| embeddedLogo | `params.embeddedLogo` | object | no | null | Optional logo in QR center: `{"src":"$field.companyLogo", "size":24}` |
| shape | `params.shape` | string | no | `"square"` | `"square"`, `"circle"`, `"rounded"` |
| borderRadius | `params.borderRadius` | number | no | `0` | QR code corner radius |

**Validation rules:**
- `errorCorrection` higher levels (quartile, high) add more redundancy but reduce data capacity.
- `margin` MUST be ≥ 0 and ≤ 20.

**Example:**

```jsonc
{
  "id": "qr_code",
  "type": "qr",
  "zIndex": 10,
  "constraints": { "left": 680, "top": 160, "width": 160, "height": 160 },
  "params": {
    "data": "vcard",
    "color": "$var.colors.accent",
    "backgroundColor": "transparent",
    "errorCorrection": "high",
    "margin": 2,
    "embeddedLogo": { "src": "$field.companyLogo", "size": 32 }
  }
}
```

#### 8.4.4 Name

**Type value:** `"name"`

**Purpose:** Displays the contact's full name. The most prominent text element on the card.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"fullName"` | `"fullName"`, `"firstName"`, `"lastName"` |
| style | `style` | TextStyle | no | `{}` | Typography and styling |
| textAlign | `style.textAlign` | string | no | `"left"` | `"left"`, `"center"`, `"right"`, `"justify"` |

**Example:**

```jsonc
{
  "id": "user_name",
  "type": "name",
  "zIndex": 10,
  "constraints": { "left": 40, "top": 80, "right": 500, "height": 40 },
  "field": "fullName",
  "style": { "typography": "$var.typography.display" }
}
```

#### 8.4.5 Company

**Type value:** `"company"`

**Purpose:** Displays the company or organization name.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"companyName"` | Field containing company name |
| style | `style` | TextStyle | no | `{}` | Typography and styling |

**Example:**

```jsonc
{
  "id": "company_name",
  "type": "company",
  "constraints": { "left": 40, "top": 148, "right": 500, "height": 18 },
  "field": "companyName",
  "style": { "typography": "$var.typography.body" }
}
```

#### 8.4.6 Tagline

**Type value:** `"tagline"`

**Purpose:** Displays a short tagline or personal slogan.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"tagline"` | Field containing tagline |
| style | `style` | TextStyle | no | `{}` | Typography and styling |

**Example:**

```jsonc
{
  "id": "user_tagline",
  "type": "tagline",
  "constraints": { "left": 40, "top": 170, "right": 500, "height": 16 },
  "field": "tagline",
  "style": { "typography": "$var.typography.body" }
}
```

#### 8.4.7 Job Title

**Type value:** `"jobTitle"` (JSON key)

**Purpose:** Displays the contact's professional title or position.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"jobTitle"` | Field containing job title |
| style | `style` | TextStyle | no | `{}` | Typography and styling |

**Example:**

```jsonc
{
  "id": "user_title",
  "type": "jobTitle",
  "constraints": { "left": 40, "top": 124, "right": 500, "height": 20 },
  "field": "jobTitle",
  "style": { "typography": "$var.typography.heading" }
}
```

#### 8.4.8 Biography

**Type value:** `"biography"`

**Purpose:** Displays a short bio or about-me text. Multi-line support.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"aboutMe"` | Field containing biography |
| style | `style` | TextStyle | no | `{}` | Typography and styling |
| maxLines | `params.maxLines` | integer | no | `3` | Maximum lines of text |
| collapseMode | `params.collapseMode` | string | no | `"ellipsis"` | `"ellipsis"`, `"fade"`, `"none"` |

**Example:**

```jsonc
{
  "id": "user_bio",
  "type": "biography",
  "constraints": { "left": 40, "top": 200, "right": 500, "height": 48 },
  "field": "aboutMe",
  "style": { "typography": "$var.typography.body" },
  "params": { "maxLines": 3, "collapseMode": "fade" }
}
```

#### 8.4.9 Phone

**Type value:** `"phone"`

**Purpose:** Displays a phone number with an icon. Supports tap-to-call on mobile devices.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"phone"` | `"phone"`, `"mobileNumber"`, `"phone2"`, `"whatsappNumber"` |
| icon | `params.icon` | string | no | `"phone"` | Icon identifier |
| iconColor | `params.iconColor` | color | no | `"$var.colors.textSecondary"` | Icon color |
| iconSize | `params.iconSize` | number | no | `16` | Icon size in design units |
| tappable | `params.tappable` | boolean | no | `true` | Enable tap-to-call |
| label | `params.label` | string | no | null | Optional text label before the number |

**Example:**

```jsonc
{
  "id": "phone_row",
  "type": "phone",
  "constraints": { "left": 40, "top": 220, "right": 500, "height": 22 },
  "field": "phone",
  "params": { "icon": "phone", "iconColor": "$var.colors.accent" },
  "style": { "typography": "$var.typography.body" },
  "conditional": { "hideIfEmpty": true }
}
```

#### 8.4.10 Email

**Type value:** `"email"`

**Purpose:** Displays an email address with an icon. Supports tap-to-email on mobile devices.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"email"` | Field containing email |
| icon | `params.icon` | string | no | `"email"` | Icon identifier |
| iconColor | `params.iconColor` | color | no | `"$var.colors.textSecondary"` | Icon color |
| tappable | `params.tappable` | boolean | no | `true` | Enable tap-to-email |

**Example:**

```jsonc
{
  "id": "email_row",
  "type": "email",
  "constraints": { "left": 40, "top": 246, "right": 500, "height": 22 },
  "field": "email",
  "params": { "icon": "email", "iconColor": "$var.colors.accent" },
  "style": { "typography": "$var.typography.body" }
}
```

#### 8.4.11 Website

**Type value:** `"website"`

**Purpose:** Displays a website URL with an icon. Supports tap-to-open in browser.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"website"` | Field containing website URL |
| icon | `params.icon` | string | no | `"globe"` | Icon identifier |
| label | `params.label` | string | no | null | Display label (defaults to URL) |
| tappable | `params.tappable` | boolean | no | `true` | Enable tap-to-open |

**Example:**

```jsonc
{
  "id": "website_row",
  "type": "website",
  "constraints": { "left": 40, "top": 272, "right": 500, "height": 22 },
  "field": "website",
  "params": { "icon": "globe", "iconColor": "$var.colors.accent" },
  "style": { "typography": "$var.typography.body" }
}
```

#### 8.4.12 Address

**Type value:** `"address"`

**Purpose:** Displays a physical address with an icon.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| field | `field` | string | no | `"address"` | Field containing address |
| icon | `params.icon` | string | no | `"location"` | Icon identifier |
| tappable | `params.tappable` | boolean | no | `false` | Enable tap-to-open in maps |

**Example:**

```jsonc
{
  "id": "address_row",
  "type": "address",
  "constraints": { "left": 40, "top": 298, "right": 500, "height": 22 },
  "field": "address",
  "params": { "icon": "location", "iconColor": "$var.colors.accent" },
  "style": { "typography": "$var.typography.body" },
  "conditional": { "hideIfEmpty": true }
}
```

#### 8.4.13 Social Icons

**Type value:** `"socialIcons"`

**Purpose:** Renders a row or column of social media icon buttons. Each icon opens the respective profile when tapped.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fields | `params.fields` | array | **yes** | — | Array of social field names to display |
| iconSet | `params.iconSet` | string | no | `"monochrome"` | `"branded"`, `"monochrome"`, `"outlined"` |
| iconSize | `params.iconSize` | number | no | `22` | Icon size |
| spacing | `params.spacing` | number | no | `12` | Spacing between icons |
| color | `params.color` | color | no | `"$var.colors.textSecondary"` | Icon color (for monochrome/outlined) |
| shape | `params.shape` | string | no | `"none"` | Background shape: `"circle"`, `"rounded_rectangle"`, `"none"` |
| backgroundColor | `params.backgroundColor` | color | no | `"transparent"` | Background shape fill |
| layout | `params.layout` | string | no | `"row"` | `"row"`, `"column"`, `"grid"` |
| gridColumns | `params.gridColumns` | integer | no | `4` | Columns when layout is `"grid"` |

**Supported social field values:**
`linkedin`, `facebook`, `instagram`, `twitter`, `youtube`, `tiktok`, `snapchat`, `telegram`, `whatsapp`, `github`, `behance`, `dribbble`, `pinterest`, `medium`, `threads`, `discord`, `slack`, `wechat`, `line`, `signal`, `mastodon`, `bluesky`, `tumblr`, `reddit`, `twitch`, `vimeo`, `flickr`, `deviantart`, `codepen`, `gitlab`, `bitbucket`, `stackoverflow`, `producthunt`, `hashnode`, `devto`

**Example:**

```jsonc
{
  "id": "social_row",
  "type": "socialIcons",
  "constraints": { "left": 40, "top": 340, "right": 500, "height": 36 },
  "params": {
    "fields": ["linkedin", "instagram", "twitter", "github"],
    "iconSet": "monochrome",
    "iconSize": 22,
    "spacing": 12,
    "color": "$var.colors.textSecondary",
    "shape": "circle",
    "backgroundColor": "rgba(255,255,255,0.06)",
    "layout": "row"
  }
}
```

#### 8.4.14 Buttons

**Type value:** `"buttons"`

**Purpose:** Renders action buttons (Save Contact, Share, Call, Email, Directions, etc.).

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| buttons | `params.buttons` | array | **yes** | — | Array of button definitions |
| layout | `params.layout` | string | no | `"column"` | `"row"`, `"column"`, `"wrap"` |
| spacing | `params.spacing` | number | no | `8` | Spacing between buttons |

**Button definition:**

```jsonc
{
  "type": "addContact",      // Action type
  "label": "Save Contact",   // Button text
  "icon": "person_add",     // Optional icon
  "style": "filled",         // "filled" | "outlined" | "text" | "tonal"
  "backgroundColor": "$var.colors.accent",
  "textColor": "#1A1A2E",
  "borderColor": "$var.colors.accent",
  "borderRadius": 24,
  "fullWidth": true,
  "height": 44,
  "tappable": true
}
```

**Action types:** `"addContact"`, `"share"`, `"call"`, `"email"`, `"website"`, `"directions"`, `"message"`, `"whatsapp"`, `"copy"`, `"custom"`

**Example:**

```jsonc
{
  "id": "cta_buttons",
  "type": "buttons",
  "constraints": { "left": 580, "top": 400, "right": 40, "height": 100 },
  "params": {
    "layout": "column",
    "spacing": 8,
    "buttons": [
      { "type": "addContact", "label": "Save Contact", "style": "filled", "backgroundColor": "$var.colors.accent", "textColor": "#1A1A2E", "fullWidth": true, "borderRadius": 24 },
      { "type": "share", "label": "Share Card", "style": "outlined", "borderColor": "$var.colors.accent", "textColor": "$var.colors.accent", "fullWidth": true, "borderRadius": 24 }
    ]
  }
}
```

#### 8.4.15 Statistics

**Type value:** `"statistics"`

**Purpose:** Displays engagement statistics (profile views, connections, saves).

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fields | `params.fields` | array | **yes** | — | Stat field names |
| labels | `params.labels` | array | no | `[]` | Display labels for each stat |
| layout | `params.layout` | string | no | `"row"` | `"row"`, `"column"`, `"grid"` |
| valueStyle | `params.valueStyle` | TextStyle | no | `{}` | Styling for the numeric value |
| labelStyle | `params.labelStyle` | TextStyle | no | `{}` | Styling for the stat label |
| separator | `params.separator` | object | no | null | Visual separator between stats |

**Example:**

```jsonc
{
  "id": "stats_row",
  "type": "statistics",
  "constraints": { "left": 40, "top": 400, "right": 500, "height": 48 },
  "params": {
    "fields": ["views", "connections", "saves"],
    "labels": ["Profile Views", "Connections", "Saves"],
    "layout": "row",
    "valueStyle": { "fontSize": 18, "fontWeight": "700", "color": "$var.colors.accent" },
    "labelStyle": { "typography": "$var.typography.body" }
  }
}
```

#### 8.4.16 Footer

**Type value:** `"footer"`

**Purpose:** A footer section typically at the bottom of the card, showing branding, taglines, or additional information.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| text | `params.text` | string | no | `"Powered by Taply"` | Footer text content |
| field | `params.field` | string | no | null | Optional field binding for dynamic text |
| separator | `params.separator` | boolean | no | `false` | Show a top border separator |
| branding | `params.branding` | string | no | `"powered"` | `"powered"`, `"none"`, `"taply-badge"` |

**Example:**

```jsonc
{
  "id": "card_footer",
  "type": "footer",
  "constraints": { "left": 40, "bottom": 28, "right": 40, "height": 20 },
  "params": {
    "text": "Tap to connect — NFC & QR enabled",
    "style": { "color": "rgba(255,255,255,0.3)", "fontSize": 10, "textAlign": "center" },
    "separator": true,
    "branding": "powered"
  }
}
```

#### 8.4.17 Header

**Type value:** `"header"`

**Purpose:** A top section that can combine avatar, company logo, and title elements cohesively.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| layout | `params.layout` | string | no | `"row"` | `"row"`, `"column"`, `"row-reverse"` |
| spacing | `params.spacing` | number | no | `16` | Spacing between header elements |
| children | `params.children` | array | **yes** | — | Array of child widget layers |

**Example:**

```jsonc
{
  "id": "profile_header",
  "type": "header",
  "constraints": { "left": 40, "top": 40, "right": 40, "height": 120 },
  "params": {
    "layout": "row",
    "spacing": 16,
    "children": [
      { "type": "avatar", "field": "avatar", "constraints": { "width": 80, "height": 80 } },
      { "type": "name", "field": "fullName", "constraints": { "width": 200, "height": 40 } },
      { "type": "jobTitle", "field": "jobTitle", "constraints": { "width": 200, "height": 20 } }
    ]
  }
}
```

#### 8.4.18 Glass Card

**Type value:** `"glassCard"`

**Purpose:** A glassmorphism container that groups child widgets with a glass effect background.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| blur | `params.blur` | number | no | `12` | Glass blur sigma |
| tint | `params.tint` | color | no | `"rgba(255,255,255,0.05)"` | Glass tint |
| borderRadius | `params.borderRadius` | BorderRadius | no | `16` | Container corner radius |
| padding | `params.padding` | number/object | no | `20` | Inner padding |
| borderOpacity | `params.borderOpacity` | number | no | `0.1` | Glass border opacity |
| children | `params.children` | array | no | `[]` | Child widget layer IDs to include |

**Example:**

```jsonc
{
  "id": "contact_glass",
  "type": "glassCard",
  "constraints": { "left": 560, "top": 40, "width": 400, "height": 300 },
  "params": {
    "blur": 12,
    "tint": "rgba(255,255,255,0.05)",
    "borderRadius": 16,
    "padding": 24,
    "children": ["contact_block", "social_row"]
  }
}
```

#### 8.4.19 Divider

**Type value:** `"divider"`

**Purpose:** A visual separator line between sections.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| style | `params.style` | string | no | `"solid"` | `"solid"`, `"dashed"`, `"dotted"`, `"gradient"` |
| thickness | `params.thickness` | number | no | `1` | Line thickness |
| color | `params.color` | color | no | `"rgba(255,255,255,0.1)"` | Line color |

**Example:**

```jsonc
{
  "id": "section_divider",
  "type": "divider",
  "constraints": { "left": 40, "top": 380, "right": 500, "height": 1 },
  "params": { "style": "gradient", "color": "$var.colors.accent", "thickness": 1 }
}
```

#### 8.4.20 Badges

**Type value:** `"badges"`

**Purpose:** Displays status badges or indicators (NFC enabled, premium, verified, etc.).

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| badges | `params.badges` | array | **yes** | — | Array of badge definitions |
| layout | `params.layout` | string | no | `"row"` | `"row"`, `"column"`, `"wrap"` |
| spacing | `params.spacing` | number | no | `8` | Spacing between badges |

**Badge definition:**

```jsonc
{
  "type": "nfc",               // "nfc" | "premium" | "verified" | "custom"
  "label": "NFC Enabled",      // Badge text
  "icon": "nfc",               // Badge icon
  "color": "$var.colors.accent", // Badge color
  "backgroundColor": "rgba(212,175,55,0.1)",  // Badge background
  "borderRadius": 12
}
```

**Example:**

```jsonc
{
  "id": "badge_row",
  "type": "badges",
  "constraints": { "left": 680, "top": 340, "width": 160, "height": 60 },
  "params": {
    "layout": "column",
    "spacing": 4,
    "badges": [
      { "type": "nfc", "label": "NFC Enabled", "color": "$var.colors.accent" },
      { "type": "premium", "label": "Premium", "color": "$var.colors.accent" }
    ]
  }
}
```

#### 8.4.21 Contact Block

**Type value:** `"contactBlock"`

**Purpose:** A structured block rendering multiple contact fields with consistent styling and icons.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| fields | `params.fields` | array | **yes** | — | Array of contact field definitions |
| spacing | `params.spacing` | number | no | `12` | Vertical spacing between items |
| iconColor | `params.iconColor` | color | no | `"$var.colors.accent"` | Icon color for all items |

**Field definition:**

```jsonc
{
  "field": "phone",          // Field name to bind
  "icon": "phone",           // Icon identifier
  "label": "Phone",          // Optional label
  "tappable": true,          // Enable tap action
  "hideIfEmpty": true,       // Hide when field is empty
  "style": {}                // Per-field style override
}
```

**Example:**

```jsonc
{
  "id": "contact_block",
  "type": "contactBlock",
  "constraints": { "left": 580, "top": 80, "width": 360, "height": 220 },
  "params": {
    "spacing": 14,
    "iconColor": "$var.colors.accent",
    "fields": [
      { "field": "phone", "icon": "phone", "tappable": true },
      { "field": "email", "icon": "email", "tappable": true },
      { "field": "website", "icon": "globe", "tappable": true },
      { "field": "address", "icon": "location", "hideIfEmpty": true }
    ]
  }
}
```

#### 8.4.22 Custom Widgets

**Type value:** `"custom"`

**Purpose:** An extensibility point for custom widget types. The `customType` field identifies the specific custom widget implementation.

| Property | Path | Type | Required | Default | Description |
|---|---|---|---|---|---|
| customType | `params.customType` | string | **yes** | — | Custom widget type identifier |
| data | `params.data` | object | **yes** | — | Custom data payload |

**Example:**

```jsonc
{
  "id": "custom_widget",
  "type": "custom",
  "constraints": { "left": 40, "top": 400, "width": 200, "height": 60 },
  "params": {
    "customType": "calendar_availability",
    "data": {
      "timezone": "America/New_York",
      "showNextAvailable": true
    }
  }
}
```

### 8.5 Field Binding Reference

All field-based widget layers use the `field` property to bind to the data provided by the application. The complete registry of standard field names:

| Field Key | Type | Description |
|---|---|---|
| `fullName` | string | Full display name |
| `firstName` | string | First name |
| `lastName` | string | Last name |
| `jobTitle` | string | Professional title |
| `companyName` | string | Company/organization name |
| `tagline` | string | Short slogan or tagline |
| `aboutMe` | string | Biography or about text |
| `email` | string | Email address |
| `phone` | string | Primary phone number |
| `phone2` | string | Secondary phone number |
| `whatsappNumber` | string | WhatsApp number |
| `website` | string | Website URL |
| `address` | string | Physical address |
| `avatar` | string (URI) | Profile image URL/path |
| `companyLogo` | string (URI) | Company logo URL/path |
| `coverImage` | string (URI) | Cover/background image |
| `linkedin` | string (URL) | LinkedIn profile |
| `facebook` | string (URL) | Facebook profile |
| `instagram` | string (URL) | Instagram profile |
| `twitter` | string (URL) | X/Twitter profile |
| `youtube` | string (URL) | YouTube channel |
| `tiktok` | string (URL) | TikTok profile |
| `snapchat` | string (URL) | Snapchat profile |
| `telegram` | string (URL) | Telegram handle |
| `whatsapp` | string (URL) | WhatsApp link |
| `github` | string (URL) | GitHub profile |
| `behance` | string (URL) | Behance portfolio |
| `dribbble` | string (URL) | Dribbble profile |
| `pinterest` | string (URL) | Pinterest profile |
| `medium` | string (URL) | Medium profile |
| `threads` | string (URL) | Threads profile |
| `discord` | string (URL) | Discord username |
| `signal` | string (URL) | Signal username |
| `mastodon` | string (URL) | Mastodon profile |
| `bluesky` | string (URL) | Bluesky profile |
| `reddit` | string (URL) | Reddit profile |
| `twitch` | string (URL) | Twitch channel |
| `views` | number | Profile view count |
| `connections` | number | Connection count |
| `saves` | number | Save/bookmark count |
| `customField1`–`customField10` | string | Custom data fields |

The engine MUST accept any field key. Unknown field keys are passed through as-is. This ensures forward compatibility with new field types without engine updates.

---

## 9. Layout System

### 9.1 Overview

The layout system determines the **absolute position and size** of every layer within the card's canvas. It converts high-level constraint declarations into concrete pixel values through a deterministic solver.

The layout engine is a **constraint-based solver** that supports multiple positioning modes. These modes can be mixed within a single theme and even within a single layer's constraints.

### 9.2 Constraint Model

Every layer has a `constraints` object. The solver reads these constraints and computes a resolved `Rect` (left, top, width, height) in design units.

| Property | Type | Description |
|---|---|---|
| `left` | number / string / null | Distance from parent left edge |
| `top` | number / string / null | Distance from parent top edge |
| `right` | number / string / null | Distance from parent right edge |
| `bottom` | number / string / null | Distance from parent bottom edge |
| `width` | number / string / null | Explicit width |
| `height` | number / string / null | Explicit height |
| `centerX` | number / string / null | Center X position |
| `centerY` | number / string / null | Center Y position |
| `minWidth` | number | Minimum width constraint (≥ 0) |
| `maxWidth` | number | Maximum width constraint (≥ minWidth) |
| `minHeight` | number | Minimum height constraint (≥ 0) |
| `maxHeight` | number | Maximum height constraint (≥ minHeight) |
| `aspectRatio` | number | Enforce width/height ratio (MUST be > 0) |

Each value can be:
- A **fixed number** in design units: `40`
- A **percentage string**: `"50%"` (relative to the parent dimension)
- **`null`** or **omitted**: derived from other constraints or defaults

### 9.3 Layout Modes

#### 9.3.1 Absolute Layout

MOST explicit. All four values are provided.

```jsonc
"constraints": { "left": 40, "top": 80, "width": 300, "height": 40 }
```

**When to use:** Fixed-position elements that don't need to adapt (decorations, logos, avatars).

#### 9.3.2 Relative Layout (Fill)

Uses left + right (or top + bottom) to compute width (or height).

```jsonc
"constraints": { "left": 40, "top": 80, "right": 40, "height": 40 }
// width = parentWidth - 40 - 40 = parentWidth - 80
```

**When to use:** Text elements, contact blocks, full-width sections.

#### 9.3.3 Percentage Layout

Uses percentage strings relative to parent dimensions.

```jsonc
"constraints": { "left": "10%", "top": "10%", "width": "80%", "height": "80%" }
// left = parentWidth × 0.1, width = parentWidth × 0.8
```

**When to use:** Responsive backgrounds, symmetrical layouts.

#### 9.3.4 Center Layout

Positions a layer by its center point.

```jsonc
"constraints": { "centerX": 500, "centerY": 300, "width": 200, "height": 100 }
// left = 500 - 200/2 = 400, top = 300 - 100/2 = 250
```

**When to use:** Centered elements, badges, circular decorations.

#### 9.3.5 Fill Layout (All Edges)

```jsonc
"constraints": { "left": 20, "top": 20, "right": 20, "bottom": 20 }
// width = parentWidth - 40, height = parentHeight - 40
```

**When to use:** Margins, padding containers, frames.

#### 9.3.6 Aspect Ratio Layout

```jsonc
"constraints": { "left": 40, "top": 40, "width": 100, "aspectRatio": 1 }
// height = width / aspectRatio = 100
```

**When to use:** Square avatars, QR codes, images that must maintain ratio.

### 9.4 Solver Algorithm

The constraint solver processes each layer independently against its parent bounds:

```
Input: constraints object, parentRect
Output: resolved Rect

1. GATHER constraint values:
   left   = resolveValue(constraints.left,   parentRect.width)
   top    = resolveValue(constraints.top,    parentRect.height)
   right  = resolveValue(constraints.right,  parentRect.width)
   bottom = resolveValue(constraints.bottom, parentRect.height)
   width  = resolveValue(constraints.width,  parentRect.width)
   height = resolveValue(constraints.height, parentRect.height)
   centerX = resolveValue(constraints.centerX, parentRect.width)
   centerY = resolveValue(constraints.centerY, parentRect.height)

2. RESOLVE unknown dimensions:
   If width is null:
     if left != null && right != null:
       width = parentRect.width - left - right
     if centerX != null && left != null:
       width = (centerX - left) * 2
     if centerX != null && right != null && width == null:
       width = (parentRect.width - right - centerX) * 2
     if width < 0 → width = 0

   If height is null: (symmetrical logic)

3. RESOLVE unknown positions:
   If left is null:
     if right != null && width != null:
       left = parentRect.width - right - width
     if centerX != null && width != null:
       left = centerX - width / 2
     if left < 0 → left = 0

   If top is null: (symmetrical logic)

4. APPLY aspect ratio:
   if aspectRatio != null:
     if width != null && height == null:
       height = width / aspectRatio
     if height != null && width == null:
       width = height * aspectRatio

5. CLAMP to min/max:
   width  = clamp(width,  minWidth,  maxWidth)
   height = clamp(height, minHeight, maxHeight)

6. APPLY safe areas (if not ignored):
   left   = max(safeArea.left,   left)
   top    = max(safeArea.top,    top)
   right  = max(safeArea.right,  parentRect.width - width - left)
   bottom = max(safeArea.bottom, parentRect.height - height - top)

7. RETURN Rect.fromLTWH(left, top, width, height)
```

### 9.5 Anchor References

Layers can reference the computed positions of other layers using anchor syntax:

```jsonc
"constraints": {
  "left": "$anchor:name_label.left",
  "top": "$anchor:name_label.bottom + 8",
  "right": "$anchor:name_label.right",
  "height": 24
}
```

**Syntax rules:**
- `$anchor:layer_id.field` — references a specific field of the target layer's resolved rect
- `+ offset` or `- offset` — adds or subtracts an offset in design units
- Fields: `left`, `top`, `right`, `bottom`, `centerX`, `centerY`, `width`, `height`

**Validation rules:**
- The target layer MUST exist in the layers list.
- The target layer's constraints MUST be resolved before the anchor layer's.
- Circular anchor dependencies MUST be detected and reported as errors.

### 9.6 Alignment

The `alignment` property on a layer positions content within the layer's bounds:

```jsonc
"constraints": { "left": 40, "top": 80, "width": 300, "height": 40 },
"alignment": "centerLeft"
```

| Value | Behavior | Equivalent |
|---|---|---|
| `"topLeft"` | Default | Alignment(-1.0, -1.0) |
| `"topCenter"` | Top center | Alignment(0.0, -1.0) |
| `"topRight"` | Top right | Alignment(1.0, -1.0) |
| `"centerLeft"` | Center left | Alignment(-1.0, 0.0) |
| `"center"` | True center | Alignment(0.0, 0.0) |
| `"centerRight"` | Center right | Alignment(1.0, 0.0) |
| `"bottomLeft"` | Bottom left | Alignment(-1.0, 1.0) |
| `"bottomCenter"` | Bottom center | Alignment(0.0, 1.0) |
| `"bottomRight"` | Bottom right | Alignment(1.0, 1.0) |

### 9.7 Responsive Scaling

The responsive scaling mode determines how the design space maps to physical pixels:

| Mode | Behavior |
|---|---|
| `"scale"` | Uniformly scale design to fit render width. Height is determined by aspect ratio. |
| `"contain"` | Scale uniformly while preserving aspect ratio; add letterboxing if needed. |
| `"cover"` | Scale uniformly while covering the render area; crop if needed. |
| `"width"` | Scale to fit render width exactly; height scales proportionally. |
| `"height"` | Scale to fit render height exactly; width scales proportionally. |

### 9.8 Dynamic Sizing

Some widget layers support dynamic sizing based on content:

```jsonc
"constraints": {
  "left": 40,
  "top": 80,
  "right": 40
}
// height is dynamic based on content (text wraps, image scales)
```

**Dynamic sizing rules:**
- If `height` is omitted and the content determines size, the engine computes height after layout.
- Dynamic-height layers are resolved AFTER fixed-height layers.
- Sibling layers that anchor to a dynamic-height layer's bottom are resolved AFTER the dynamic height is computed.
- Two passes are allowed: first for fixed layers, second for dynamic layers.

### 9.9 Margins and Padding

```jsonc
// Margin: space OUTSIDE the layer's bounds
"margin": { "top": 8, "bottom": 8, "left": 0, "right": 0 }

// Padding: space INSIDE the layer's bounds (for container layers)
"padding": { "top": 16, "bottom": 16, "left": 20, "right": 20 }
```

- `margin` shifts the layer's resolved position by the margin values.
- `padding` reduces the content area within the layer by the padding values.
- Both can be a single number (uniform) or an object with per-edge values.

### 9.10 RTL Mirroring

When `theme.rtl` is `true` and the render context's text direction is RTL:

```
mirroredLeft = canvasWidth - originalRight - layerWidth
mirroredRight = canvasWidth - originalLeft - layerWidth
```

- The engine mirrors horizontal constraints (left ↔ right) when RTL mode is active.
- Layers with `"rtlStatic": true` are exempt from mirroring (e.g., logos, absolute decorative elements).
- Text alignment is also mirrored: `"left"` → `"right"`, `"right"` → `"left"`.

### 9.11 Adaptive Layout

The adaptive layout system enables the theme to define different layouts for different render contexts:

```jsonc
"constraints": {
  "adaptations": [
    { "condition": { "maxWidth": 360 }, "constraints": { "left": 16, "top": 120, "right": 16 } },
    { "condition": { "minWidth": 361, "maxWidth": 600 }, "constraints": { "left": 24, "top": 100, "right": 24 } }
  ],
  "default": { "left": 40, "top": 80, "right": 40, "height": 40 }
}
```

**Adaptation conditions:**
- `minWidth` / `maxWidth` — Width ranges
- `orientation` — `"portrait"`, `"landscape"`, `"square"`
- `platform` — `"ios"`, `"android"`, `"web"`
- `themeMode` — `"light"`, `"dark"`

---

## 10. Components

### 10.1 Overview

Components are **reusable, named compositions of layers** that can be invoked multiple times with different parameters (slots). They are the theming equivalent of functions — encapsulating a group of layers behind a named interface.

### 10.2 Component Definition

Components are defined in the `components` block at the theme root:

```jsonc
"components": {
  "profile_header": {
    "description": "Avatar + name + job title",
    "category": "header",
    "variables": {
      "colors": { "accent": "#D4AF37" }
    },
    "slots": {
      "avatar": { "type": "avatar", "required": false, "default": true },
      "nameStyle": { "type": "typography", "required": false }
    },
    "layers": [
      {
        "id": "avatar_layer",
        "type": "avatar",
        "constraints": { "left": 0, "top": 0, "width": 80, "height": 80 },
        "bind": { "from": "slot.avatar" }
      },
      {
        "id": "name_layer",
        "type": "name",
        "constraints": { "left": 100, "top": 10, "right": 0, "height": 36 },
        "field": "fullName",
        "style": { "bind": "slot.nameStyle" }
      }
    ]
  }
}
```

### 10.3 Component Definition Properties

| Property | Type | Required | Description |
|---|---|---|---|
| `description` | string | no | Human-readable description |
| `category` | string | no | Component category for tooling |
| `variables` | object | no | Component-scoped variable overrides |
| `slots` | object | no | Named slot definitions |
| `layers` | array | **yes** | Layer definitions (same schema as root layers) |

### 10.4 Slot Definitions

Slots define configurable parameters that callers can override:

```jsonc
"slots": {
  "avatar": {
    "type": "avatar",       // Expected type hint
    "required": false,       // Whether caller must provide this slot
    "default": true,         // Default value if caller doesn't override
    "description": "Avatar configuration"
  },
  "nameStyle": {
    "type": "typography",
    "required": false
  }
}
```

### 10.5 Component Invocation

Components are invoked inline in the `layers` array:

```jsonc
{
  "type": "component",
  "componentId": "profile_header",
  "zIndex": 10,
  "constraints": { "left": 40, "top": 40, "right": 40, "height": 120 },
  "slots": {
    "nameStyle": { "fontSize": 28 }
  },
  "variables": {
    "colors": { "accent": "#FF6B35" }
  }
}
```

| Property | Type | Required | Description |
|---|---|---|---|
| `type` | string | **yes** | MUST be `"component"` |
| `componentId` | string | **yes** | References a component in `components` |
| `slots` | object | no | Slot overrides |
| `variables` | object | no | Variable overrides for this invocation |
| `constraints` | Constraint | **yes** | Outer bounds of the component |
| `zIndex` | integer | no | Base z-index |

### 10.6 Component Resolution

During scene graph assembly, component invocations are resolved:

1. **Merge variables**: Invocation variables override component variables, which override theme variables.
2. **Merge slots**: Invocation slot values override component slot defaults.
3. **Expand layers**: Component layers are copied into the main layers list.
4. **Apply constraints**: Component constraints wrap all expanded layers.
5. **Bind slots**: Layers with `"bind": {"from": "slot.xxx"}` receive the slot override value.

### 10.7 Nested Components

Components can invoke other components:

```jsonc
"components": {
  "contact_section": {
    "layers": [
      {
        "type": "component",
        "componentId": "contact_row",
        "slots": { "field": "phone", "icon": "phone" }
      },
      {
        "type": "component",
        "componentId": "contact_row",
        "slots": { "field": "email", "icon": "email" }
      }
    ]
  },
  "contact_row": {
    "slots": {
      "field": { "type": "string", "required": true },
      "icon": { "type": "string", "required": true }
    },
    "layers": [
      {
        "id": "icon",
        "type": "svg",
        "params": { "src": "$slot.icon" }
      },
      {
        "id": "text",
        "type": "text",
        "field": "$slot.field"
      }
    ]
  }
}
```

### 10.8 Built-in Components

The following components are defined in the specification and SHOULD be provided as defaults by the engine:

| Component ID | Purpose | Slots |
|---|---|---|
| `profile_header` | Avatar + name + title | avatar, nameStyle, titleStyle |
| `company_header` | Logo + company + tagline | logo, companyStyle, taglineStyle |
| `contact_section` | Phone, email, website rows | fields, iconColor, spacing |
| `social_section` | Social media icons | fields, iconSize, spacing |
| `footer` | Bottom branding bar | text, branding, separator |
| `statistics_section` | Stats display | fields, labels, valueStyle |
| `qr_section` | QR code + label | qrParams, label, labelPosition |

---

## 11. Effects

### 11.1 Overview

Effects are **post-processing visual modifications** applied to a layer's rendered output. They use compositing (via `saveLayer`) to layer the effect on top of the base rendering.

Effects can be applied to any paint layer or widget layer via the `effects` array.

### 11.2 Common Effect Properties

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `type` | string | **yes** | — | Effect type identifier |
| `params` | object | depends | `{}` | Effect-specific parameters |
| `priority` | integer | no | `0` | Effect application order (higher = applied later/on top) |
| `mask` | MaskDef | no | null | Optional mask limiting the effect area |

### 11.3 Effect Catalog

#### 11.3.1 Blur

**Type value:** `"blur"`

Applies gaussian blur to the layer's content.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| sigmaX | `params.sigmaX` | **yes** | — | Horizontal blur sigma |
| sigmaY | `params.sigmaY` | **yes** | — | Vertical blur sigma |

**Performance:** Uses `MaskFilter.blur()`. Relatively cheap.

#### 11.3.2 Glass

**Type value:** `"glass"`

Applies the glassmorphism effect — blur + tint + border.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| blur | `params.blur` | **yes** | — | Gaussian blur sigma |
| tint | `params.tint` | no | `"rgba(255,255,255,0.1)"` | Glass overlay color |
| borderOpacity | `params.borderOpacity` | no | `0.1` | Border opacity |
| borderColor | `params.borderColor` | no | `"#FFFFFF"` | Border color |
| saturation | `params.saturation` | no | `1.0` | Color saturation (0–3) |

**Performance:** Uses `BackdropFilter` + `saveLayer`. Most expensive effect.

#### 11.3.3 Glow

**Type value:** `"glow"`

Adds an outer glow around the layer.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| color | `params.color` | no | `"#D4AF37"` | Glow color |
| radius | `params.radius` | **yes** | — | Glow spread radius |
| opacity | `params.opacity` | no | `0.4` | Glow opacity |

**Performance:** Uses `saveLayer` + `MaskFilter.blur()`.

#### 11.3.4 Gradient Overlay

**Type value:** `"gradient_overlay"`

Overlays a gradient on top of the layer.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| kind | `params.kind` | **yes** | — | `"linear"`, `"radial"`, `"sweep"` |
| colors | `params.colors` | **yes** | — | Gradient colors |
| stops | `params.stops` | no | evenly spaced | Stop positions |
| blendMode | `params.blendMode` | no | `"srcOver"` | How gradient composites with layer |

#### 11.3.5 Mask

**Type value:** `"mask"`

Applies an alpha or luminance mask to the layer.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| source | `params.source` | **yes** | — | Mask content (gradient, image, shape) |
| mode | `params.mode` | no | `"alpha"` | `"alpha"`, `"luminance"` |
| invert | `params.invert` | no | `false` | Invert the mask |

#### 11.3.6 Noise

**Type value:** `"noise"`

Overlays procedural noise on the layer.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| seed | `params.seed` | no | `0` | Random seed |
| opacity | `params.opacity` | no | `0.05` | Noise opacity |
| scale | `params.scale` | no | `1.0` | Noise scale |

#### 11.3.7 Shadow

**Type value:** `"shadow"`

Adds a drop shadow to the layer.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| color | `params.color` | no | `"rgba(0,0,0,0.3)"` | Shadow color |
| offsetX | `params.offsetX` | no | `0` | Horizontal offset |
| offsetY | `params.offsetY` | no | `4` | Vertical offset |
| blurRadius | `params.blurRadius` | no | `12` | Blur radius |
| spread | `params.spread` | no | `0` | Shadow spread |

#### 11.3.8 Inner Shadow

**Type value:** `"inner_shadow"`

Adds an inset shadow inside the layer bounds.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| color | `params.color` | no | `"rgba(0,0,0,0.3)"` | Shadow color |
| offsetX | `params.offsetX` | no | `0` | Horizontal offset |
| offsetY | `params.offsetY` | no | `2` | Vertical offset |
| blurRadius | `params.blurRadius` | no | `4` | Blur radius |

#### 11.3.9 Opacity

**Type value:** `"opacity"`

Overrides the layer's opacity.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| value | `params.value` | **yes** | — | Opacity (0–1) |

#### 11.3.10 Blend Mode

**Type value:** `"blend_mode"`

Changes the layer's compositing blend mode.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| mode | `params.mode` | **yes** | — | Blend mode identifier |

### 11.4 Neumorphism

**Type value:** `"neuomorphism"`

A combined effect that produces a neumorphic (soft UI) appearance using dual shadows.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| distance | `params.distance` | no | `6` | Shadow distance |
| blur | `params.blur` | no | `12` | Shadow blur |
| lightSource | `params.lightSource` | no | `"topLeft"` | `"topLeft"`, `"topRight"`, `"bottomLeft"`, `"bottomRight"` |
| shadowColorDark | `params.shadowColorDark` | no | `"rgba(0,0,0,0.3)"` | Dark shadow color |
| shadowColorLight | `params.shadowColorLight` | no | `"rgba(255,255,255,0.5)"` | Light shadow color |

### 11.5 Glassmorphism

**Type value:** `"glassmorphism"`

A combined effect producing a complete glassmorphic appearance.

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| blur | `params.blur` | **yes** | — | Backdrop blur sigma |
| tint | `params.tint` | no | `"rgba(255,255,255,0.1)"` | Color tint |
| saturation | `params.saturation` | no | `1.2` | Saturation boost |
| brightness | `params.brightness` | no | `1.0` | Brightness adjustment |
| borderOpacity | `params.borderOpacity` | no | `0.15` | Subtle edge border |

### 11.6 Effect Application Order

Effects are applied in `priority` order (ascending). Within the same priority, effects are applied in declaration order. Each effect wraps the previous result in a new `saveLayer`.

```
Layer content
  → Effect 1 (priority: 0) — applied first
  → Effect 2 (priority: 1) — applied on top
  → Effect 3 (priority: 2) — applied on top
  → Result
```

---

## 12. Typography

### 12.1 Overview

The typography system defines how text is styled across all widget layers. Typography can be defined as variables (reusable named styles) or inline in widget style properties.

### 12.2 TextStyle Properties

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `fontFamily` | string | no | platform default | Font family name |
| `fontSize` | number | no | `14` | Font size in design units |
| `fontWeight` | string/number | no | `"400"` | `"100"`–`"900"` or `"thin"`–`"black"` |
| `fontStyle` | string | no | `"normal"` | `"normal"`, `"italic"` |
| `letterSpacing` | number | no | `0` | Letter spacing in design units |
| `lineHeight` | number | no | `1.2` | Line height multiplier |
| `color` | color | no | `"#000000"` | Text color |
| `textAlign` | string | no | `"left"` | `"left"`, `"center"`, `"right"`, `"justify"` |
| `textTransform` | string | no | `"none"` | `"none"`, `"uppercase"`, `"lowercase"`, `"capitalize"` |
| `textDecoration` | string | no | `"none"` | `"none"`, `"underline"`, `"lineThrough"`, `"overline"` |
| `maxLines` | integer | no | `1` | Maximum text lines |
| `overflow` | string | no | `"ellipsis"` | `"ellipsis"`, `"clip"`, `"fade"` |

### 12.3 Google Fonts

Fonts can reference Google Fonts by family name. The engine SHOULD download Google Fonts on demand if they are not bundled with the theme or app.

```jsonc
"style": {
  "typography": {
    "fontFamily": "Playfair Display",
    "fontWeight": "700",
    "fontSize": 32
  }
}
```

### 12.4 Variable Fonts

Variable fonts (OpenType font variations) are supported:

```jsonc
"style": {
  "fontFamily": "Roboto Flex",
  "fontVariations": {
    "wdth": 100,    // Width axis
    "wght": 700,    // Weight axis
    "slnt": 0       // Slant axis
  }
}
```

| Property | Path | Type | Description |
|---|---|---|---|
| `fontVariations` | `style.fontVariations` | object | Map of OpenType axis tags to values |

### 12.5 Font Fallback

```jsonc
"style": {
  "fontFamily": "Playfair Display",
  "fallback": ["Georgia", "serif"]
}
```

| Property | Path | Type | Default | Description |
|---|---|---|---|---|
| `fallback` | `style.fallback` | array | `["sans-serif"]` | Ordered fallback font families |

### 12.6 Auto Resize

Text can auto-resize to fit its container:

```jsonc
"style": {
  "fontSize": 32,
  "autoResize": {
    "enabled": true,
    "minFontSize": 14,
    "maxFontSize": 48,
    "stepGranularity": 1
  }
}
```

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| `enabled` | `style.autoResize.enabled` | **yes** | — | Enable auto-resize |
| `minFontSize` | `style.autoResize.minFontSize` | no | `10` | Minimum font size |
| `maxFontSize` | `style.autoResize.maxFontSize` | no | original fontSize | Maximum font size |
| `stepGranularity` | `style.autoResize.stepGranularity` | no | `1` | Size decrement step |

### 12.7 RTL Text

RTL support is handled automatically based on the detected text direction of the content. Engines MUST:

1. Detect the text direction of the field value (using Unicode character ranges).
2. Set `TextDirection.rtl` for Arabic, Hebrew, Persian, Urdu, and similar scripts.
3. Mirror text alignment (`"left"` → `"right"`) for RTL content.
4. Respect explicit `textDirection` override if provided in style.

### 12.8 Localization

Field values are already localized by the application layer. The theme engine does not perform localization — it renders the values it receives. Theme authors can provide locale-specific typography through responsive rules:

```jsonc
"responsive": [
  {
    "conditions": { "language": "ar" },
    "overrides": [
      { "target": "user_name", "style": { "fontFamily": "Noto Naskh Arabic", "fontSize": 30 } }
    ]
  }
]
```

---

## 13. Theme States

### 13.1 Overview

Theme states allow layers to respond to **user interaction, application data, and context changes** by switching visual properties, visibility, or animations. This system eliminates the need for imperative code to handle common state-driven UI changes.

### 13.2 State Model

States are defined at the theme root under the `states` key:

```jsonc
"states": {
  "isLightMode": { "type": "themeMode", "value": "light" },
  "isDarkMode": { "type": "themeMode", "value": "dark" },
  "isTapped": { "type": "interaction", "value": "tap" },
  "isLongPressed": { "type": "interaction", "value": "longPress" },
  "isHovered": { "type": "interaction", "value": "hover" },
  "hasField": { "type": "field", "value": "phone" }
}
```

### 13.3 State Definition Properties

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `type` | string | **yes** | — | State category |
| `value` | string/object | **yes** | — | State value or parameters |
| `combine` | string | no | `"and"` | How to combine with parent states |
| `invert` | boolean | no | `false` | Invert the state condition |

### 13.4 State Types

| Type | Description | Trigger |
|---|---|---|
| `"themeMode"` | Light or dark mode | Engine detects system/app theme mode |
| `"interaction"` | User interaction | Gesture or pointer events |
| `"field"` | Field presence/value | Business data availability |
| `"platform"` | Platform detection | Render platform |
| `"orientation"` | Device orientation | Orientation change |
| `"dimension"` | Dimension breakpoint | Container resize |
| `"custom"` | Custom application state | Application-provided state map |

### 13.5 Layer State Bindings

Layers declare their state responsiveness:

```jsonc
{
  "id": "avatar",
  "type": "avatar",
  "constraints": { "left": 40, "top": 40, "width": 80, "height": 80 },
  "states": {
    "isHovered": {
      "effects": [
        { "type": "shadow", "params": { "color": "#D4AF37", "radius": 16 } }
      ],
      "scale": 1.05
    },
    "isTapped": {
      "scale": 0.95,
      "duration": 100
    }
  }
}
```

| Property | Path | Type | Description |
|---|---|---|---|
| `states` | layer.states | object | Map of state name to state behavior |
| `states.{name}.opacity` | states.{}.opacity | number | Opacity override when active (0–1) |
| `states.{name}.scale` | states.{}.scale | number | Scale override when active |
| `states.{name}.offsetX` | states.{}.offsetX | number | X offset when active |
| `states.{name}.offsetY` | states.{}.offsetY | number | Y offset when active |
| `states.{name}.visibility` | states.{}.visibility | boolean | Show/hide when active |
| `states.{name}.effects` | states.{}.effects | array | Effects to apply/replace when active |
| `states.{name}.style` | states.{}.style | object | Style overrides when active |
| `states.{name}.duration` | states.{}.duration | integer | Transition duration in ms |

### 13.6 State Groups

Multiple states can be combined into a group:

```jsonc
"stateGroups": {
  "interactive": {
    "states": ["isHovered", "isTapped", "isLongPressed"],
    "fallback": "default",
    "exclusive": true
  }
}
```

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `states` | array | **yes** | — | Ordered list of state keys to evaluate |
| `fallback` | string | no | `"default"` | State to apply when none match |
| `exclusive` | boolean | no | `false` | Only one state active at a time |

### 13.7 Global State Triggers

```jsonc
"stateTriggers": {
  "onThemeModeChanged": {
    "targets": ["background_light", "background_dark"],
    "action": "toggleVisibility"
  },
  "onFieldUpdated": {
    "field": "phone",
    "targets": ["phone_icon", "phone_label"],
    "action": "show"
  }
}
```

### 13.8 Animation Superposition

When multiple states on the same layer are active simultaneously, the engine resolves conflicts using a **priority-merge** strategy:

1. Higher-priority interactions override lower ones: `longPress` > `tap` > `hover`.
2. State properties that are not explicitly overridden remain at their base value.
3. Transitions use the longest `duration` among active states.

---

## 14. Animation

### 14.1 Overview

The animation system defines **timed transitions** between visual states. Animations can be applied to any numeric property: position, size, opacity, rotation, scale, color, gradient stops, or effect parameters.

### 14.2 Animation Definition

Animations are defined at the theme root:

```jsonc
"animations": {
  "fade_in": {
    "type": "tween",
    "duration": 300,
    "curve": "easeInOut",
    "properties": { "opacity": { "from": 0, "to": 1 } }
  },
  "slide_up": {
    "type": "tween",
    "duration": 400,
    "curve": "easeOutCubic",
    "properties": { "offsetY": { "from": 50, "to": 0 } }
  },
  "pulse": {
    "type": "loop",
    "duration": 2000,
    "curve": "easeInOutSine",
    "properties": { "scale": { "from": 1.0, "to": 1.05 } },
    "direction": "alternate",
    "repeat": -1
  }
}
```

### 14.3 Animation Definition Properties

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `type` | string | **yes** | — | Animation type |
| `duration` | integer | **yes** | — | Duration in milliseconds |
| `curve` | string | no | `"linear"` | Easing curve |
| `delay` | integer | no | `0` | Delay before start (ms) |
| `properties` | object | **yes** | — | Map of property to animation config |
| `direction` | string | no | `"normal"` | `"normal"`, `"reverse"`, `"alternate"` |
| `repeat` | integer | no | `0` | Repeat count (-1 = infinite) |

### 14.4 Animation Types

| Type | Description |
|---|---|
| `"tween"` | Single animation from A to B, runs once |
| `"loop"` | Continuous looping animation |
| `"spring"` | Physics-based spring animation |
| `"keyframe"` | Multi-point keyframe animation |
| `"sequence"` | Plays child animations sequentially |
| `"parallel"` | Plays child animations simultaneously |

### 14.5 Curves Catalog

| Curve Identifier | Behavior |
|---|---|
| `"linear"` | Constant speed |
| `"ease"` | Default ease |
| `"easeIn"` | Slow start |
| `"easeOut"` | Slow end |
| `"easeInOut"` | Slow start and end |
| `"easeInSine"` | Sine ease-in |
| `"easeOutSine"` | Sine ease-out |
| `"easeInOutSine"` | Sine ease-in-out |
| `"easeInCubic"` | Cubic ease-in |
| `"easeOutCubic"` | Cubic ease-out |
| `"easeInOutCubic"` | Cubic ease-in-out |
| `"bounceOut"` | Bounce at end |
| `"elasticOut"` | Elastic overshoot at end |
| `"snap"` | No interpolation, discrete jump at midpoint |

### 14.6 Property Animations

Each property in the `properties` map specifies:

| Field | Type | Required | Description |
|---|---|---|---|
| `from` | number/color | **yes** | Starting value |
| `to` | number/color | **yes** | Ending value |
| `unit` | string | no | `"designUnit"`, `"pixel"`, `"percent"`, `"deg"` |

Supported animatable properties:

| Property | Type | Description |
|---|---|---|
| `opacity` | number | 0–1 |
| `scale` | number | Scale factor |
| `rotation` | number | Rotation in degrees |
| `offsetX` | number | Horizontal offset |
| `offsetY` | number | Vertical offset |
| `width` | number | Width in design units |
| `height` | number | Height in design units |
| `color` | color | Color value |
| `gradientStops` | array | Gradient stop positions |
| `blurRadius` | number | Effect parameter |
| `shadowOffset` | number | Effect parameter |
| `letterSpacing` | number | Typography parameter |

### 14.7 Keyframe Animation

```jsonc
"bounce_entrance": {
  "type": "keyframe",
  "duration": 600,
  "keyframes": [
    { "time": 0.0, "properties": { "scale": 0.0, "opacity": 0.0 } },
    { "time": 0.5, "properties": { "scale": 1.2, "opacity": 1.0, "curve": "easeOut" } },
    { "time": 0.75, "properties": { "scale": 0.9 } },
    { "time": 1.0, "properties": { "scale": 1.0 } }
  ]
}
```

| Property | Path | Required | Default | Description |
|---|---|---|---|---|
| `keyframes` | animation.keyframes | **yes** | — | Array of keyframe objects |
| `time` | keyframes[].time | **yes** | — | Progress (0.0–1.0) |
| `properties` | keyframes[].properties | **yes** | — | Property values at this keyframe |
| `curve` | keyframes[].curve | no | animation.curve | Curve between this and next keyframe |

### 14.8 Spring Animation

```jsonc
"spring_in": {
  "type": "spring",
  "properties": { "scale": { "from": 0.5, "to": 1.0 } },
  "stiffness": 300,
  "damping": 20,
  "mass": 1.0
}
```

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `stiffness` | number | no | `200` | Spring stiffness (higher = faster) |
| `damping` | number | no | `15` | Damping coefficient (higher = less bounce) |
| `mass` | number | no | `1.0` | Mass (higher = slower) |

### 14.9 Layer Animation Binding

Layers bind to animations:

```jsonc
{
  "id": "avatar",
  "type": "avatar",
  "animations": {
    "entry": "fade_in",
    "loop": "pulse",
    "triggers": {
      "onTap": "bounce_entrance",
      "onAppear": "slide_up"
    }
  }
}
```

| Property | Path | Description |
|---|---|---|
| `animations` | layer.animations | Map of animation slots |
| `animations.entry` | layer.animations.entry | Plays when layer first renders |
| `animations.loop` | layer.animations.loop | Plays continuously |
| `animations.triggers` | layer.animations.triggers | Map of trigger names to animation IDs |
| `animations.triggers.onTap` | layer.animations.triggers.onTap | Plays on tap |
| `animations.triggers.onAppear` | layer.animations.triggers.onAppear | Plays on visibility change |
| `animations.triggers.onStateEnter` | layer.animations.triggers.onStateEnter | Plays when entering a state |
| `animations.triggers.onStateExit` | layer.animations.triggers.onStateExit | Plays when exiting a state |

### 14.10 Sequence and Parallel

```jsonc
"entrance_sequence": {
  "type": "sequence",
  "children": ["fade_in", "slide_up", "pulse"],
  "gap": 100
}

"grand_entrance": {
  "type": "parallel",
  "children": ["fade_in", "slide_up"]
}
```

| Property | Type | Description |
|---|---|---|
| `children` | array | Ordered list of child animation IDs |
| `gap` | integer | Gap between children in sequence (ms) |

---

## 15. Package Format

### 15.1 Overview

A theme package is a **self-contained archive** (`.taply` file) containing the theme JSON, all referenced assets, metadata, and signature files. Packages are the distribution unit for the Taply Theme Marketplace.

### 15.2 File Extension

- **Extension:** `.taply`
- **MIME type:** `application/vnd.taply.theme`
- **Magic bytes:** `0x54 0x41 0x50 0x4C` (`TAPL`)

### 15.3 Package Structure

```
example_theme.taply
├── theme.json                  # Theme definition (required)
├── manifest.json               # Package metadata (required)
├── assets/
│   ├── fonts/
│   │   ├── PlayfairDisplay-Regular.ttf
│   │   └── PlayfairDisplay-Bold.ttf
│   ├── images/
│   │   ├── logo.png
│   │   └── profile_placeholder.webp
│   └── icons/
│       ├── phone.svg
│       ├── email.svg
│       └── website.svg
├── preview/
│   ├── preview.png             # 1:1 marketplace preview
│   └── preview_card.png        # Card rendering preview
├── screenshots/
│   ├── screenshot_light.png    # Light mode screenshot
│   └── screenshot_dark.png     # Dark mode screenshot
└── signature.sig               # Author signature
```

### 15.4 Archive Format

The `.taply` package MUST use one of the following archive formats:

| Format | Compression | Best for |
|---|---|---|
| `.zip` | DEFLATE | Compatibility, previews |
| `.tar.gz` | GZIP | Unix workflows |

### 15.5 Manifest

File: `manifest.json`

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `packageName` | string | **yes** | — | Unique package identifier |
| `version` | semver | **yes** | — | Package version |
| `displayName` | string | **yes** | — | Human-readable name |
| `description` | string | no | — | Description for marketplace |
| `author` | object | **yes** | — | Author info |
| `author.name` | string | **yes** | — | Author display name |
| `author.id` | string | **yes** | — | Author platform ID |
| `author.email` | string | no | — | Contact email |
| `themeVersion` | semver | **yes** | — | Theme JSON schema version |
| `tags` | array | no | `[]` | Search tags |
| `categories` | array | no | `[]` | Marketplace categories |
| `license` | string | no | `"proprietary"` | License identifier |
| `minEngineVersion` | semver | no | — | Minimum engine version required |
| `price` | object | no | `{"free": true}` | Pricing model |
| `price.free` | boolean | no | `true` | Free or paid |
| `price.amount` | number | no | — | Price in cents |
| `price.currency` | string | no | `"USD"` | Currency code |

### 15.6 Asset Resolution

Assets referenced in `theme.json` are resolved from the package:

```
theme.json asset reference: "assets/icons/phone.svg"
                           → resolved to: package_root/assets/icons/phone.svg
```

**Resolution rules:**
1. Relative paths are resolved relative to the package root.
2. Absolute paths are NOT allowed.
3. Path traversal (`../`) is blocked.
4. Asset size is limited to the `assetSizeLimit` in the manifest.
5. Missing assets MUST produce a validation warning.

### 15.7 Asset Size Limits

| Asset Type | Default Limit |
|---|---|
| Images (raster) | 5 MB per file |
| Fonts | 10 MB per file |
| SVGs | 100 KB per file |
| Total package | 50 MB |

### 15.8 Bundle vs Remote

Assets can be bundled inside the package or referenced remotely:

```jsonc
// Bundled (recommended — offline-compatible)
"logo": { "src": "assets/images/logo.png" }

// Remote (dynamic — requires network)
"avatar": { "src": "https://cdn.example.com/avatars/default.png" }
```

**Remote asset rules:**
- Remote URIs MUST use `https://`.
- The engine SHOULD cache remote assets with an LRU eviction policy (default: 100 MB cache).
- The engine MUST respect `Cache-Control` headers.
- Remote failures (network, 404, 5xx) MUST be handled gracefully — use placeholder or skip.

### 15.9 Package Validation

Before installation, the engine MUST validate:

1. **Structural integrity:** Archive is not corrupted.
2. **Manifest presence:** `manifest.json` exists and is valid JSON.
3. **Theme presence:** `theme.json` exists and is valid JSON.
4. **Asset presence:** All referenced bundled assets exist.
5. **Schema validation:** `theme.json` validates against the current schema.
6. **Signature verification:** If `signature.sig` exists, verify against author's public key.

---

## 16. Validation

### 16.1 Overview

The validation system ensures that theme JSON documents conform to the schema, have semantic integrity, and contain no conflicting or ambiguous declarations. Validation is performed at design time (in the Studio) and load time (in the engine).

### 16.2 Validation Levels

| Level | Description | Behavior on Failure |
|---|---|---|
| `"error"` | Structural or semantic violation | Theme MUST NOT render |
| `"warning"` | Non-critical issue | Theme renders with degraded behavior |
| `"info"` | Informational suggestion | No behavioral impact |

### 16.3 Schema Validation

The JSON document is validated against the formal JSON Schema (detailed in Appendix B):

**Structural checks:**
- Required fields are present and non-null.
- Field types match the schema.
- Enumerated values are from the allowed set.
- Array lengths are within bounds.
- Object structures match expected patterns.

### 16.4 Semantic Validation

Beyond schema, the validator performs semantic checks:

#### 16.4.1 Duplicate Detection
- Duplicate layer `id` values within the same scope.
- Duplicate component names.
- Duplicate variable names.
- Duplicate animation names.

#### 16.4.2 Reference Integrity
- Field bindings reference valid fields.
- Animation references point to defined animations.
- Component invocations reference defined components.
- Anchor references target valid layer IDs.
- Font family names are available (bundled, Google Fonts, or system).
- State names reference defined states.

#### 16.4.3 Constraint Validation
| Check | Description |
|---|---|
| Zero-dimension layer | Width and height are both zero |
| Over-constrained | More than needed constraints specified |
| Under-constrained | Insufficient constraints to compute position/size |
| Invalid aspect ratio | `aspectRatio ≤ 0` |
| Negative dimensions | Computed width/height negative |
| Overlapping safe areas | Layer forced outside safe area |

#### 16.4.4 Color Validation
- Hex colors are 3, 4, 6, or 8 hex digits after `#`.
- RGB(A) values are within 0–255.
- HSL values: H 0–360, S/L 0–100%.
- Gradient stops are monotonically increasing 0–1.
- Gradient has at least 2 color stops.

#### 16.4.5 z-Index Validation
- No circular z-index dependencies.
- z-index values fit within engine limits (−2³¹ to 2³¹−1).
- Layers with identical z-index maintain declaration order.

### 16.5 Validation Report

The validator produces a structured report:

```jsonc
{
  "valid": false,
  "errors": [
    {
      "path": "$.layers[3].constraints",
      "message": "Missing both width and right constraint; position cannot be computed",
      "code": "UNDER_CONSTRAINED",
      "level": "error",
      "line": 127
    }
  ],
  "warnings": [
    {
      "path": "$.assets.images.logo",
      "message": "Referenced logo.png does not exist in package",
      "code": "MISSING_ASSET",
      "level": "warning",
      "line": 45
    }
  ],
  "infos": [
    {
      "path": "$.layers[0].id",
      "message": "Layer ID could be more descriptive: 'layer_1' → 'avatar_layer'",
      "code": "DESCRIPTIVE_ID",
      "level": "info",
      "line": 12
    }
  ]
}
```

### 16.6 Validation Error Codes

| Code | Level | Description |
|---|---|---|
| `REQUIRED_FIELD_MISSING` | error | A required field is absent |
| `TYPE_MISMATCH` | error | Field has wrong type |
| `INVALID_ENUM` | error | Value not in allowed set |
| `DUPLICATE_ID` | error | Duplicate layer/component/animation ID |
| `BROKEN_REFERENCE` | error | Reference to undefined object |
| `UNDER_CONSTRAINED` | error | Insufficient layout constraints |
| `OVER_CONSTRAINED` | warning | Conflicting layout constraints |
| `ZERO_DIMENSION` | warning | Layer has zero width or height |
| `NEGATIVE_DIMENSION` | error | Computed dimension is negative |
| `INVALID_COLOR` | error | Color string is malformed |
| `INVALID_GRADIENT` | error | Gradient has fewer than 2 stops |
| `CIRCULAR_ANCHOR` | error | Circular anchor dependency detected |
| `MISSING_ASSET` | warning | Bundled asset not found in package |
| `OVERSIZED_ASSET` | warning | Asset exceeds size limit |
| `UNUSED_VARIABLE` | info | Variable defined but never referenced |
| `UNREACHABLE_LAYER` | info | Layer with z-index below another visible layer |
| `MISSING_STATE_TARGET` | warning | State references undefined layer |
| `ANIMATION_NOT_FOUND` | error | Trigger references undefined animation |
| `SCHEMA_DEPRECATED` | warning | Using deprecated field |

### 16.7 Strict Mode

The validator can operate in **strict mode** for authoring environments:

```jsonc
"validation": {
  "mode": "strict"     // "default" | "strict" | "permissive"
}
```

| Mode | Behavior |
|---|---|
| `"default"` | Errors break, warnings log, infos ignore |
| `"strict"` | Errors and warnings both break rendering |
| `"permissive"` | Only structural errors break; semantics are best-effort |

### 16.8 Auto-Fix

Some validation issues can be auto-fixed:

| Issue | Auto-Fix Strategy |
|---|---|
| Missing optional field | Insert schema default value |
| Missing layer ID | Generate UUID-based ID |
| Under-constrained (single dimension) | Infer from parent bounds |
| Non-monotonic gradient stops | Sort stops ascending |
| Deprecated field | Replace with new field path |

---

## 17. Performance

### 17.1 Overview

The theme engine is a **GPU-friendly, compositor-first** rendering system. Performance targets are:

| Metric | Target | Device |
|---|---|---|
| Initial render | ≤ 16 ms | Mid-range Android (2021+) |
| Hot-reload | ≤ 8 ms | Same |
| Scrolling with effects | 60 fps | Same |
| Theme parse + validate | ≤ 50 ms | Same |
| Memory (loaded theme) | ≤ 8 MB | Same |
| Package download + extract | ≤ 500 ms (100 KB) | LTE |

### 17.2 Rendering Pipeline Optimizations

#### 17.2.1 Paint Caching

Layers with no animation and no dynamic binding are painted once to a bitmap and cached:

```jsonc
// Engine automatically caches:
{
  "id": "background_decor",
  "type": "linearGradient",
  "cacheHint": "static"    // "static" | "dynamic" | "auto" (default)
}
```

| `cacheHint` | Behavior |
|---|---|
| `"static"` | Painted once, never invalidated |
| `"dynamic"` | Re-painted every frame |
| `"auto"` | Engine decides based on presence of animations/bindings |

#### 17.2.2 Repaint Boundaries

Layers with `cacheHint: "static"` or that are children of static layers become repaint boundaries in Flutter's render tree:

```
┌─ RepaintBoundary ─────────────────┐
│  background_decor (static)        │ ← Cached layer
├───────────────────────────────────┤
│  name_label (dynamic)             │ ← Not cached, repaints independently
└───────────────────────────────────┘
```

#### 17.2.3 Compositing Layers

Effects that require `saveLayer` (blur, glass, glow) create compositing layers. The engine:

1. Groups consecutive effects into a single `saveLayer` where possible.
2. Avoids `saveLayer` when an effect's opacity is 0 or fully transparent.
3. Unnests compositing layers by flattening layer trees wherever possible.

### 17.3 JSON Parsing

- The engine MUST use a streaming JSON parser for initial parse.
- Theme JSON SHOULD NOT exceed 2 MB (uncompressed).
- Parsing uses a **single pass** — no schema validation during parse; validation runs separately on a separate isolate/thread.

### 17.4 Asset Loading

#### 17.4.1 Image Pipeline
1. **Metadata pass:** Load image dimensions without decoding pixels.
2. **Decode pass:** Decode at target resolution (never at full resolution).
3. **Cache pass:** Store decoded bitmap in an LRU cache.
4. **Eviction:** LRU eviction when cache exceeds 50 MB.

#### 17.4.2 Font Loading
- Fonts are loaded lazily — only when a layer uses the family.
- After first use, the font face stays in memory for the session.
- Google Fonts are fetched on demand and cached locally.

### 17.5 Pre-computation

The engine pre-computes the following during the load phase:

| Computation | When | Purpose |
|---|---|---|
| Constraint resolution | Load | All constraints → final Rects |
| Variable resolution | Load | All `$var:` references → values |
| Anchor position | Load | All `$anchor:` references → resolved values |
| Component expansion | Load | Component invocations → expanded layers |
| z-index sort | Load | Layer sort order |
| Repaint boundary assignment | Load | Static layer detection |

This means the render phase does ZERO computation — it only paints.

### 17.6 Memory Budget

| Category | Budget (per theme) |
|---|---|
| Theme JSON (parsed) | 2 MB |
| Bitmap cache | 50 MB (shared across themes) |
| Font cache | 20 MB (shared) |
| Shader cache | 10 MB (shared) |
| Animation state | 1 MB |
| **Total per theme** | **8 MB** (excl. shared caches) |

### 17.7 Network Budget

| Operation | Max Size | Max Time |
|---|---|---|
| Theme package download | 50 MB | 10s (WiFi) |
| Google Font download | 10 MB per font | 3s |
| Remote image download | 5 MB per image | 5s |
| Marketplace API response | 1 MB | 2s |

### 17.8 Performance Monitoring

The engine SHOULD expose the following performance metrics via a debug overlay or API:

| Metric | Description |
|---|---|
| `totalRenderTime` | Time from build() to composited frame (ms) |
| `paintTime` | Time spent in paint() (ms) |
| `cacheHitRate` | Bitmap cache hit rate (0–1) |
| `saveLayerCount` | Number of active saveLayer operations |
| `frameDropCount` | Number of frames exceeding 16ms budget |
| `memoryUsage` | Current memory usage (bytes) |
| `parseTime` | Theme JSON parse + validate time (ms) |
| `assetCount` | Number of loaded assets |

### 17.9 Threading Model

```
┌─────────────────────────────────────────────────────┐
│                   Main Isolate                       │
│  ┌──────────────┐  ┌──────────────┐  ┌───────────┐ │
│  │ Parse         │  │ Validate     │  │ Render     │ │
│  │ (streaming)   │→│ (schema)     │→│ (pre-comp) │ │
│  └──────────────┘  └──────────────┘  └───────────┘ │
├─────────────────────────────────────────────────────┤
│                Background Isolate                    │
│  ┌──────────────┐  ┌──────────────┐                 │
│  │ Asset decode  │  │ Font fetch    │                 │
│  └──────────────┘  └──────────────┘                 │
└─────────────────────────────────────────────────────┘
```

- **Main isolate:** Parse, validate, pre-compute, render.
- **Background isolate:** Image decoding, font fetching, asset download.
- **Communication:** Messages via `SendPort`/`ReceivePort`.
- **No blocking:** Network and disk I/O never block the main isolate.

---

## 18. Security

### 18.1 Overview

The security model treats **all theme content as untrusted**. Every theme package is sandboxed during load and render. The engine never executes arbitrary code from themes, and all asset references are validated against path traversal and SSRF attacks.

### 18.2 Sandboxing Principles

| Principle | Description |
|---|---|
| No code execution | Theme JSON is declarative — no callbacks, no scripts, no expressions |
| No file system access | Themes cannot read or write files outside the package |
| No network access (unless allowed) | Remote assets require explicit permission |
| No personal data exfiltration | Field bindings are read-only; theme cannot write back |
| No privilege escalation | Theme cannot access platform APIs beyond rendering |

### 18.3 Asset URL Validation

Remote asset URLs are validated against the following rules:

```
ALLOWED:
  https://cdn.taply.ai/assets/*
  https://fonts.googleapis.com/*
  https://fonts.gstatic.com/*

BLOCKED:
  http://*                    (no plain HTTP)
  file://*                    (no local file access)
  data:*                      (no data URIs — blocked by default)
  javascript:*                (N/A in Flutter, but blocked for future web renders)
  *[?*]                       (no query parameters — prevents tracking)
  *[#*]                       (no fragments)
```

The engine MAY allow custom URL schemes via a **security profile**:

```jsonc
// In engine configuration, NOT in the theme:
"securityProfile": {
  "allowedAssetOrigins": [
    "https://cdn.taply.ai",
    "https://fonts.googleapis.com"
  ],
  "allowDataUris": false,
  "maxRedirects": 2,
  "requireHttps": true
}
```

### 18.4 Field Isolation

Field bindings are **read-only**. The theme cannot mutate field values:

```jsonc
// VALID — reads field value into text layer
{ "field": "fullName" }

// INVALID — theme cannot modify field values
{ "field": "fullName", "write": true }   // Not a valid property
```

### 18.5 Package Integrity

#### 18.5.1 Signature Verification

Optional but RECOMMENDED for marketplace-published themes:

```
Package:          example_theme.taply
Signature file:   signature.sig
Algorithm:        Ed25519
Public key:       Embedded in marketplace author profile
Verification:     openssl dgst -sha512 -verify author_pub.pem -signature signature.sig theme.json
```

#### 18.5.2 Checksum Verification

The manifest MAY contain checksums:

```jsonc
"checksums": {
  "theme.json": "sha256:abc123...",
  "assets/images/logo.png": "sha256:def456..."
}
```

The engine MUST verify checksums if present. On mismatch, the engine MUST refuse to load the theme.

### 18.6 Resource Limits

| Resource | Limit | Enforcement |
|---|---|---|
| Layer count | 500 | Reject at parse time |
| Animation count | 50 | Warning at load time |
| Concurrent animations | 20 | Engine enforces cap |
| Effects per layer | 10 | Reject at parse time |
| Recursive component depth | 16 | Reject at component expansion |
| JSON depth | 128 | Reject at parse time |
| Total asset size | 50 MB | Reject at unpack time |
| Remote asset downloads per session | 100 | Engine enforces cap |

### 18.7 SSRF Prevention

- All remote URLs are resolved against the allowlist.
- IP-based URLs are blocked (e.g., `https://192.168.1.1/asset.png`).
- DNS rebinding protection: URL host is resolved and validated at fetch time, not just at parse time.
- Redirects are followed only within the same origin (or to an allowed origin).

### 18.8 Data Privacy

| Concern | Safeguard |
|---|---|
| Theme accesses fields | Read-only, no write-back |
| Theme sends telemetry | No network calls from theme (only asset fetching) |
| Font privacy | Google Fonts requests omit referrer and cookies |
| Image loading | No EXIF extraction or location data processing |
| Crash reporting | Theme crashes include no user data in reports |

### 18.9 Security Audit

All themes published to the Taply Marketplace undergo automated security scanning:

| Check | What it detects |
|---|---|
| Schema compliance | Non-standard fields that could contain payloads |
| URL scanning | Malicious or phishing domains |
| Asset scanning | Malware-embedded images or fonts |
| Size anomaly | Unusually large assets (steganography risk) |
| Field binding analysis | Suspicious field access patterns |

---

## 19. Versioning

### 19.1 Overview

The theme specification follows **Semantic Versioning 2.0** (`MAJOR.MINOR.PATCH`). This section defines what constitutes a breaking, additive, or patch-level change to the specification and how the engine handles version mismatches.

### 19.2 Spec Version

| Component | Current | Description |
|---|---|---|
| `specVersion` | `"2.0.0"` | Current specification version |

All themes MUST declare `specVersion` in their metadata:

```jsonc
"metadata": {
  "specVersion": "2.0.0",
  "name": "Business Card Pro",
  ...
}
```

### 19.3 Version Semantics

| Bump | Rule | Examples |
|---|---|---|
| **MAJOR** | Breaking change that breaks backward compatibility | Removing a field, changing field type, changing solver behavior, new parsing requirements |
| **MINOR** | Backward-compatible addition | New optional layer type, new optional property, new effect type |
| **PATCH** | Backward-compatible bug fix | Clarifying existing behavior, fixing spec ambiguity, adding validation rules |

### 19.4 Engine Version Compatibility

| Theme `specVersion` | Engine 2.0.x | Engine 2.1.x | Engine 3.0.x |
|---|---|---|---|
| `1.x.x` | ❌ Not supported | ❌ Not supported | ❌ Not supported |
| `2.0.x` | ✅ Full support | ✅ Full support | ⚠️ Migration required |
| `2.1.x` | ⚠️ MINOR features degraded | ✅ Full support | ⚠️ Migration required |
| `3.0.x` | ❌ Not supported | ❌ Not supported | ✅ Full support |

### 19.5 Migration Functions

The engine MAY include migration functions to upgrade themes from older MINOR versions:

```jsonc
// Theme declares specVersion "2.0.0"
// Engine is 2.1.0 — includes migration from 2.0 → 2.1

"migrations": {
  "2.0": {
    "to": "2.1",
    "changes": [
      {
        "action": "addDefault",
        "path": "$.canvas.background",
        "value": { "type": "solid", "color": "#FFFFFF" }
      },
      {
        "action": "renameField",
        "path": "$.metadata",
        "from": "version",
        "to": "specVersion"
      }
    ]
  },
  "2.1": {
    "to": "2.2",
    "changes": [...]
  }
}
```

### 19.6 Theme Lifecycle

```
Version 1.0.0 ──► 1.1.0 ──► 1.2.0 ──► 2.0.0 (breaking)
   ▲              ▲        ▲          ▲
   │              │        │          │
   └── Initial     └── Add   └── New    └── Redesigned
       release        effects   layers      state system
```

| Phase | Description |
|---|---|
| **Development** | Theme author creates/iterates; version is `0.x.x` |
| **Preview** | Theme is feature-complete but not published; version is `x.y.z-beta.N` |
| **Published** | Theme is available on marketplace; version is `x.y.z` |
| **Deprecated** | Theme is no longer available for new installs; existing users keep access |
| **Archived** | Theme is fully removed from marketplace |

### 19.7 Version Reporting

Engines MUST report version in their runtime metadata:

```jsonc
{
  "engineVersion": "2.1.0",
  "specVersion": "2.1.0",
  "builtWith": "Flutter 3.27",
  "platform": "Android",
  "apiLevel": 35
}
```

### 19.8 Schema Version History

| Version | Date | Changes |
|---|---|---|
| `2.0.0` | 2026-Q2 | Initial V2 specification |
| `2.0.1` | TBD | Patch: clarify anchor syntax edge cases |
| `2.1.0` | TBD | Minor: add neumorphism and glassmorphism effect types |
| `2.2.0` | TBD | Minor: add adaptive layout conditions |
| `3.0.0` | TBD | Major: TBD |

---

## 20. Appendices

### 20.1 Appendix A: Glossary

| Term | Definition |
|---|---|
| **Anchor** | A reference to another layer's resolved position, used in constraint expressions |
| **Assembly** | The process of expanding components and resolving variable references into flat scene graph |
| **Binding** | A reference from a theme layer to application-provided field data |
| **Canvas** | The virtual design surface; always 1000×600 design units |
| **Component** | A reusable group of layers with configurable slots |
| **Constraint** | A layout rule that determines a layer's position and size |
| **Design Unit** | An abstract unit (1/1000 of canvas width, 1/600 of canvas height) independent of device resolution |
| **Effect** | A post-processing visual modification composited on top of a layer |
| **Field** | A named piece of business data provided by the application |
| **Glassmorphism** | A visual style using transparency, blur, and border to simulate frosted glass |
| **Layer** | A single visual element in the theme (paint or widget) |
| **Neumorphism** | A visual style using dual shadows to create a soft extruded appearance |
| **Node** | A scene graph element — the runtime representation of a layer |
| **Paint Layer** | A layer rendered using Canvas painting operations (not native widgets) |
| **Registry** | The extensibility mechanism that maps type strings to renderer implementations |
| **Responsive** | The ability to adapt layout and styling to different device contexts |
| **Safe Area** | The region of the canvas guaranteed to be free from device notches, status bars, and system UI |
| **Scene Graph** | The runtime tree of themed elements, assembled from the JSON and ready for rendering |
| **Slot** | A configurable parameter in a component definition |
| **Spec Version** | The version of the Taply Theme Specification that a theme conforms to |
| **State** | A condition (interaction, mode, data presence) that triggers visual changes |
| **Theme** | A complete visual specification for a digital business card |
| **Validation** | The process of ensuring a theme JSON conforms to the schema and has semantic integrity |
| **Variable** | A named reusable value (color, gradient, number, typography, spacing) |
| **Widget Layer** | A layer rendered using native platform widgets (not Canvas painting) |
| **z-Index** | The stacking order of layers; higher values render on top |

### 20.2 Appendix B: Formal JSON Schema (Draft)

The following is a **non-normative** JSON Schema draft for the Taply Theme V2 format. Implementations SHOULD validate against this schema but MAY extend it via the Registry pattern.

```jsonc
{
  "$schema": "https://json-schema.org/draft/2020-12/schema",
  "$id": "https://schemas.taply.ai/theme/v2.json",
  "title": "Taply Theme V2",
  "type": "object",
  "required": ["metadata", "canvas", "layers"],
  "properties": {
    "metadata": {
      "type": "object",
      "required": ["name", "specVersion"],
      "properties": {
        "name": { "type": "string", "minLength": 1, "maxLength": 100 },
        "specVersion": {
          "type": "string",
          "pattern": "^\\d+\\.\\d+\\.\\d+$"
        },
        "description": { "type": "string", "maxLength": 500 },
        "author": { "type": "string" },
        "tags": {
          "type": "array",
          "items": { "type": "string" },
          "maxItems": 20
        },
        "settings": {
          "type": "object",
          "properties": {
            "rtl": { "type": "boolean" },
            "locale": { "type": "string", "pattern": "^[a-z]{2}(-[A-Z]{2})?$" }
          }
        }
      }
    },
    "canvas": {
      "type": "object",
      "required": ["width", "height"],
      "properties": {
        "width": { "type": "number", "const": 1000 },
        "height": { "type": "number", "const": 600 },
        "background": { "$ref": "#/definitions/PaintLayer" },
        "safeArea": {
          "type": "object",
          "properties": {
            "top": { "type": "number", "minimum": 0 },
            "bottom": { "type": "number", "minimum": 0 },
            "left": { "type": "number", "minimum": 0 },
            "right": { "type": "number", "minimum": 0 }
          }
        }
      }
    },
    "variables": {
      "type": "object",
      "properties": {
        "colors": {
          "type": "object",
          "additionalProperties": { "type": "string" }
        },
        "gradients": {
          "type": "object",
          "additionalProperties": { "$ref": "#/definitions/Gradient" }
        },
        "typography": {
          "type": "object",
          "additionalProperties": { "$ref": "#/definitions/Typography" }
        },
        "numbers": {
          "type": "object",
          "additionalProperties": { "type": "number" }
        },
        "spacing": {
          "type": "object",
          "additionalProperties": { "type": "number" }
        }
      }
    },
    "assets": {
      "type": "object",
      "properties": {
        "images": {
          "type": "object",
          "additionalProperties": {
            "type": "object",
            "required": ["src"],
            "properties": {
              "src": { "type": "string" },
              "fit": { "type": "string", "enum": ["cover", "contain", "fill", "fitWidth", "fitHeight", "none"] },
              "placeholder": { "type": "string" }
            }
          }
        },
        "fonts": {
          "type": "object",
          "additionalProperties": {
            "type": "object",
            "required": ["src"],
            "properties": {
              "src": { "type": "string" },
              "weight": { "type": "integer", "minimum": 100, "maximum": 900 },
              "style": { "type": "string", "enum": ["normal", "italic"] }
            }
          }
        },
        "svgs": {
          "type": "object",
          "additionalProperties": {
            "type": "object",
            "required": ["src"],
            "properties": {
              "src": { "type": "string" },
              "color": { "type": "string" }
            }
          }
        }
      }
    },
    "layers": {
      "type": "array",
      "items": { "$ref": "#/definitions/Layer" },
      "minItems": 1,
      "maxItems": 500
    },
    "components": {
      "type": "object",
      "additionalProperties": {
        "type": "object",
        "required": ["layers"],
        "properties": {
          "description": { "type": "string" },
          "category": { "type": "string" },
          "variables": { "type": "object" },
          "slots": {
            "type": "object",
            "additionalProperties": {
              "type": "object",
              "properties": {
                "type": { "type": "string" },
                "required": { "type": "boolean" },
                "default": {}
              }
            }
          },
          "layers": {
            "type": "array",
            "items": { "$ref": "#/definitions/Layer" }
          }
        }
      }
    },
    "animations": {
      "type": "object",
      "additionalProperties": {
        "type": "object",
        "required": ["type", "duration", "properties"],
        "properties": {
          "type": { "type": "string", "enum": ["tween", "loop", "spring", "keyframe", "sequence", "parallel"] },
          "duration": { "type": "integer", "minimum": 0 },
          "curve": { "type": "string" },
          "delay": { "type": "integer", "minimum": 0 },
          "properties": { "type": "object" },
          "direction": { "type": "string", "enum": ["normal", "reverse", "alternate"] },
          "repeat": { "type": "integer", "minimum": -1 },
          "children": { "type": "array", "items": { "type": "string" } },
          "stiffness": { "type": "number" },
          "damping": { "type": "number" },
          "mass": { "type": "number" },
          "keyframes": { "type": "array" }
        }
      }
    },
    "states": {
      "type": "object",
      "additionalProperties": {
        "type": "object",
        "required": ["type", "value"],
        "properties": {
          "type": { "type": "string", "enum": ["themeMode", "interaction", "field", "platform", "orientation", "dimension", "custom"] },
          "value": {},
          "combine": { "type": "string", "enum": ["and", "or"] },
          "invert": { "type": "boolean" }
        }
      }
    },
    "stateGroups": { "type": "object" },
    "stateTriggers": { "type": "object" }
  },
  "definitions": {
    "PaintLayer": {
      "type": "object",
      "required": ["type"],
      "properties": {
        "type": { "type": "string" },
        "constraints": { "$ref": "#/definitions/Constraints" },
        "opacity": { "type": "number", "minimum": 0, "maximum": 1 },
        "zIndex": { "type": "integer" },
        "effects": { "type": "array", "items": { "$ref": "#/definitions/Effect" } },
        "cacheHint": { "type": "string", "enum": ["static", "dynamic", "auto"] },
        "states": { "type": "object" },
        "animations": { "type": "object" }
      },
      "allOf": [
        { "if": { "properties": { "type": { "const": "solid" } } }, "then": { "required": ["color"] } },
        { "if": { "properties": { "type": { "const": "linearGradient" } } }, "then": { "required": ["colors"] } },
        { "if": { "properties": { "type": { "const": "radialGradient" } } }, "then": { "required": ["colors"] } },
        { "if": { "properties": { "type": { "const": "svg" } } }, "then": { "required": ["src"] } },
        { "if": { "properties": { "type": { "const": "image" } } }, "then": { "required": ["src"] } },
        { "if": { "properties": { "type": { "const": "shape" } } }, "then": { "required": ["shape"] } }
      ]
    },
    "WidgetLayer": {
      "type": "object",
      "required": ["type"],
      "properties": {
        "type": { "type": "string", "enum": ["text", "name", "phone", "email", "website", "address", "avatar", "company", "jobTitle", "socialIcon", "qrCode", "map", "link", "video", "button", "badge", "chip", "rating", "progress", "divider", "dateTime", "weather"] },
        "constraints": { "$ref": "#/definitions/Constraints" },
        "field": { "type": "string" },
        "style": { "type": "object" },
        "opacity": { "type": "number", "minimum": 0, "maximum": 1 },
        "zIndex": { "type": "integer" },
        "effects": { "type": "array", "items": { "$ref": "#/definitions/Effect" } },
        "states": { "type": "object" },
        "animations": { "type": "object" }
      }
    },
    "Constraints": {
      "type": "object",
      "properties": {
        "left": { "type": ["number", "string", "null"] },
        "top": { "type": ["number", "string", "null"] },
        "right": { "type": ["number", "string", "null"] },
        "bottom": { "type": ["number", "string", "null"] },
        "width": { "type": ["number", "string", "null"] },
        "height": { "type": ["number", "string", "null"] },
        "centerX": { "type": ["number", "string", "null"] },
        "centerY": { "type": ["number", "string", "null"] },
        "minWidth": { "type": "number", "minimum": 0 },
        "maxWidth": { "type": "number" },
        "minHeight": { "type": "number", "minimum": 0 },
        "maxHeight": { "type": "number" },
        "aspectRatio": { "type": "number", "exclusiveMinimum": 0 }
      }
    },
    "Effect": {
      "type": "object",
      "required": ["type"],
      "properties": {
        "type": { "type": "string" },
        "params": { "type": "object" },
        "priority": { "type": "integer" }
      }
    },
    "Gradient": {
      "type": "object",
      "required": ["colors"],
      "properties": {
        "kind": { "type": "string", "enum": ["linear", "radial", "sweep"] },
        "colors": { "type": "array", "minItems": 2, "items": { "type": "string" } },
        "stops": { "type": "array", "items": { "type": "number", "minimum": 0, "maximum": 1 } },
        "startX": { "type": "number" },
        "startY": { "type": "number" },
        "endX": { "type": "number" },
        "endY": { "type": "number" }
      }
    },
    "Typography": {
      "type": "object",
      "properties": {
        "fontFamily": { "type": "string" },
        "fontSize": { "type": "number", "minimum": 1 },
        "fontWeight": { "type": ["string", "number"] },
        "fontStyle": { "type": "string", "enum": ["normal", "italic"] },
        "letterSpacing": { "type": "number" },
        "lineHeight": { "type": "number", "minimum": 0 },
        "color": { "type": "string" },
        "textAlign": { "type": "string", "enum": ["left", "center", "right", "justify"] },
        "textTransform": { "type": "string", "enum": ["none", "uppercase", "lowercase", "capitalize"] },
        "textDecoration": { "type": "string", "enum": ["none", "underline", "lineThrough", "overline"] },
        "maxLines": { "type": "integer", "minimum": 1 },
        "overflow": { "type": "string", "enum": ["ellipsis", "clip", "fade"] }
      }
    },
    "Layer": {
      "oneOf": [
        { "$ref": "#/definitions/PaintLayer" },
        { "$ref": "#/definitions/WidgetLayer" },
        {
          "type": "object",
          "required": ["type", "componentId"],
          "properties": {
            "type": { "const": "component" },
            "componentId": { "type": "string" },
            "slots": { "type": "object" },
            "constraints": { "$ref": "#/definitions/Constraints" },
            "zIndex": { "type": "integer" }
          }
        }
      ]
    }
  }
}
```

This schema is a **living document** and will be versioned alongside the specification. The canonical schema lives at `https://schemas.taply.ai/theme/v2.json`.

### 20.3 Appendix C: V1 → V2 Migration Guide

#### 20.3.1 Conceptual Changes

| V1 Concept | V2 Equivalent | Migration Notes |
|---|---|---|
| `position` (x, y) | `constraints` (left, top, right, bottom, width, height) | Flattened; V2 uses constraint model |
| `size` (w, h) | `constraints` (width, height, min/max) | V2 supports dynamic sizing |
| `layerType` | `type` | Same concept, expanded enum |
| `style.color` (on text) | `style.typography.color` | Moved under nested `typography` |
| No variables | `variables` block | New concept in V2 |
| `children` (nested) | Flat `layers` array | V2 scene graph is flat; nesting via `zIndex` |
| No components | `components` block | New concept in V2 |
| No effects | `effects` array per layer | New concept in V2 |
| No animations | `animations` block | New concept in V2 |
| No states | `states` block | New concept in V2 |
| `package` (v1) | `.taply` package | Wrapper format; V1 packages need re-packaging |

#### 20.3.2 Automatic Migration Script

A migration script `taply-migrate-v1-to-v2.js` will be provided alongside the reference engine. The script performs:

1. **Property mapping:** Maps V1 field names to V2 equivalents.
2. **Constraint conversion:** Converts `position`/`size` → `constraints` block.
3. **Style nesting:** Wraps text `color`/`fontSize`/`fontFamily` under `style.typography`.
4. **Flattening:** Flattens nested `children` arrays into flat `layers` with `zIndex`.
5. **Variable extraction:** Detects repeated color/typography values and extracts them to `variables`.
6. **Validation:** Validates the output against the V2 schema.

#### 20.3.3 Breaking Changes Checklist

- [ ] `position` → `constraints` (object structure changed)
- [ ] `size` → `constraints.width` / `constraints.height`
- [ ] `style.color` → `style.typography.color`
- [ ] `style.fontSize` → `style.typography.fontSize`
- [ ] `style.fontFamily` → `style.typography.fontFamily`
- [ ] `layer_type` → `type`
- [ ] `text` type → widget layer with `"type": "text"`
- [ ] Image assets: `"src": "..."` required even for inline
- [ ] Background is now `canvas.background` object
- [ ] `children` removal — move all layers to top-level `layers` array

### 20.4 Appendix D: Change Log

| Version | Date | Author | Changes |
|---|---|---|---|
| 2.0.0-draft.1 | 2026-06-10 | Taply Engineering | Initial draft of V2 specification |
| 2.0.0-draft.2 | TBD | TBD | TBD |

### 20.5 Appendix E: References

1. **Flutter Rendering Pipeline:** Flutter documentation on `RenderObject`, `Layer`, and compositing.
2. **JSON Schema Draft 2020-12:** https://json-schema.org/specification
3. **Semantic Versioning 2.0:** https://semver.org
4. **Ed25519 Digital Signatures:** RFC 8032
5. **Material Design 3:** Google Material Design specification for reference typography and elevation.
6. **Variable Fonts:** OpenType Font Variations specification (Microsoft/Arabic Type Foundries).
7. **Figma Plugin API:** Reference for design tool integration patterns.

</parameter>
