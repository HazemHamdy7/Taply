# Taply SDK Specification v2

**Official Software Development Kit Specification**

| Field | Value |
|---|---|
| Specification ID | `taply-sdk-spec-v2` |
| Version | `2.0.0` |
| Status | **DRAFT** |
| Author | Taply Engineering Team |
| Last Updated | June 2026 |
| Document Type | SDK Engineering Specification |
| Supersedes | Taply SDK Spec v1 (legacy) |

---

## Table of Contents

1. [SDK Overview](#1-sdk-overview)
2. [SDK Modules](#2-sdk-modules)
3. [Engine Lifecycle](#3-engine-lifecycle)
4. [Theme API](#4-theme-api)
5. [Rendering API](#5-rendering-api)
6. [Scene API](#6-scene-api)
7. [Variables API](#7-variables-api)
8. [Components API](#8-components-api)
9. [Registry API](#9-registry-api)
10. [Plugin API](#10-plugin-api)
11. [Event System](#11-event-system)
12. [Validation API](#12-validation-api)
13. [Marketplace API](#13-marketplace-api)
14. [DevTools API](#14-devtools-api)
15. [AI API](#15-ai-api)
16. [CLI Specification](#16-cli-specification)
17. [Error System](#17-error-system)
18. [Security](#18-security)
19. [Versioning](#19-versioning)
20. [Appendices](#20-appendices)

---

## 1. SDK Overview

### 1.1 Purpose

The Taply SDK (Software Development Kit) is the **official public API surface** of the Taply Design Platform. It is the single, stable, documented interface through which all consumers — Flutter applications, the Theme Studio, the Marketplace, the AI Generator, CLI tools, and third-party plugins — interact with Taply's rendering engine, theme management, and design capabilities.

The SDK is **not** a library or a framework. It is a **specification** — a contract between the platform and its consumers. Any implementation that conforms to this specification is a valid Taply SDK.

### 1.2 Goals

| Goal | Description |
|---|---|
| **Complete Coverage** | Every engine capability is accessible through the SDK. No hidden APIs. No backdoors. |
| **Implementation Independence** | The SDK is specified abstractly. Any language, any platform, any rendering backend can implement it. |
| **Developer Experience** | APIs are discoverable, predictable, consistent, and well-documented. The SDK reads like Flutter's documentation or the Figma Plugin API. |
| **Stability** | The SDK provides strong backward compatibility guarantees. Breaking changes are gated behind major versions and announced with deprecation windows. |
| **Extensibility** | The Registry and Plugin systems allow third-party code to extend every aspect of the platform without modifying the SDK. |
| **Security** | All capabilities are gated behind a permission system. Plugins and remote themes operate in a sandbox. |

### 1.3 Design Philosophy

```
┌─────────────────────────────────────────────────────────────────────┐
│                      SDK DESIGN PHILOSOPHY                            │
├─────────────────────────────────────────────────────────────────────┤
│                                                                      │
│  1. The SDK is the platform. If it's not in the SDK, it doesn't      │
│     exist for consumers.                                              │
│                                                                      │
│  2. Every API has one clear purpose. No overloaded methods.           │
│     No ambiguous parameter types.                                     │
│                                                                      │
│  3. Configuration over convention. Explicit is better than implicit.  │
│                                                                      │
│  4. Fail loudly during development. Fail gracefully in production.    │
│                                                                      │
│  5. Themes are data. The SDK never executes theme code.               │
│                                                                      │
│  6. Plugins extend but never override core behavior.                  │
│                                                                      │
│  7. Every operation is observable via the Event System.               │
│                                                                      │
│  8. Async by default. Sync only for trivial getters.                 │
│                                                                      │
│  9. Immutable inputs. The SDK never mutates caller data.             │
│                                                                      │
│ 10. Comprehensive error reporting. Every failure includes             │
│     a code, a message, a diagnostic, and a recovery hint.            │
│                                                                      │
└─────────────────────────────────────────────────────────────────────┘
```

### 1.4 Public API Principles

#### 1.4.1 Principle of Least Surprise

APIs behave as their names suggest. A method named `loadTheme` loads a theme; it does not validate, render, or cache. Side effects are always documented.

#### 1.4.2 Principle of Explicit Configuration

Every configurable behavior has a named parameter. Boolean flags are avoided in favor of enum values:

```
// PREFERRED
renderer.render(mode: RenderMode.preview)

// DISCOURAGED
renderer.render(preview: true)
```

#### 1.4.3 Principle of Fail-Fast Validation

Input validation happens at the SDK boundary, before any operation begins. Invalid inputs produce clear, actionable errors before internal state is modified.

#### 1.4.4 Principle of Observable State

Every meaningful state change emits an event. Consumers can observe, react to, and log all platform activity without polling or introspection.

#### 1.4.5 Principle of Backward Compatibility

Within a major version, all public APIs remain available. Deprecated APIs receive a deprecation notice and are not removed until the next major version.

### 1.5 API Classification

The SDK defines four stability levels for every API:

| Level | Label | Description | Deprecation Period |
|---|---|---|---|
| **Stable** | `@stable` | Fully supported. Breaking changes only in major versions. | 2 major versions |
| **Beta** | `@beta` | Feature-complete but may have minor API adjustments. | 1 major version |
| **Experimental** | `@experimental` | Under active development. May change or be removed. | None |
| **Deprecated** | `@deprecated` | Scheduled for removal. Replaced by newer API. | Until next major |

### 1.6 Naming Conventions

#### 1.6.1 Method Naming

| Pattern | Example |
|---|---|
| `verbNoun` | `loadTheme()`, `renderScene()`, `validateVariables()` |
| `getNoun` | `getLayerById()`, `getVariableValue()` |
| `setNoun` | `setVariableValue()`, `setThemeMetadata()` |
| `createNoun` | `createLayer()`, `createComponent()`, `createScene()` |
| `deleteNoun` | `deleteLayer()`, `deleteTheme()` |
| `isState` | `isLoaded()`, `isValid()`, `isRendering()` |
| `onEvent` | `onThemeLoaded()`, `onSceneChanged()` |

#### 1.6.2 Parameter Naming

- Parameters are **named** (not positional) for all methods with more than one parameter.
- Boolean parameters use positive phrasing: `enableAnimation`, not `disableAnimation`.
- Collection parameters are plural: `layerIds`, not `layerIdList`.
- Optional parameters have explicit defaults: `timeout: Duration(seconds: 30)`.

#### 1.6.3 Error Naming

- Error codes use `SCREAMING_SNAKE_CASE` with a module prefix: `THEME_LOAD_FAILED`, `SCENE_INVALID_LAYER_ID`.
- Error messages are complete sentences with recovery hints: "Theme file not found at path '/theme.taply'. Verify the path and ensure the file exists."

### 1.7 Module Prefixes

Every public API belongs to a module and is prefixed accordingly:

| Prefix | Module |
|---|---|
| `engine` | Engine Lifecycle |
| `theme` | Theme API |
| `render` | Rendering API |
| `scene` | Scene API |
| `variables` | Variables API |
| `components` | Components API |
| `registry` | Registry API |
| `plugins` | Plugin API |
| `events` | Event System |
| `validate` | Validation API |
| `marketplace` | Marketplace API |
| `devtools` | DevTools API |
| `ai` | AI API |

### 1.8 SDK Initialization

Before any SDK operation, the consumer must initialize the SDK:

```
engine.initialize(config)
```

The `config` object contains:

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `apiKey` | string | no | — | Marketplace API key |
| `cacheDirectory` | string | no | system temp | Cache location |
| `maxCacheSize` | integer | no | `104857600` | Max cache in bytes (100 MB) |
| `enableNetwork` | boolean | no | `true` | Allow remote asset fetching |
| `enablePlugins` | boolean | no | `true` | Allow plugin loading |
| `logLevel` | enum | no | `"warning"` | `"debug"`, `"info"`, `"warning"`, `"error"`, `"none"` |
| `permissions` | string[] | no | `[]` | Requested SDK permissions |
| `timeout` | integer | no | `30000` | Default operation timeout (ms) |

### 1.9 Architecture Reference

The internal engine components that power the SDK are defined in the **Taply Theme Engine V2 Architecture Specification**. This SDK specification references those components by their canonical names:

| Engine Component | SDK Module | Role |
|---|---|---|
| `ThemeLoader` | TaplyEngine, TaplyTheme | Theme loading and caching |
| `ThemeParser` | TaplyEngine (internal) | JSON parsing and AST construction |
| `SceneGraph` | TaplyScene | Immutable typed scene representation |
| `VariableResolver` | TaplyVariables | Variable inheritance resolution |
| `AssetManager` | TaplyEngine (internal) | External asset management |
| `LayoutEngine` | TaplyRenderer | Constraint-based layout solving |
| `PaintRegistry` | TaplyRenderer (internal) | Paint layer type dispatch |
| `WidgetRegistry` | TaplyRenderer (internal) | Widget layer type dispatch |
| `ComponentRegistry` | TaplyComponents | Component definition resolution |
| `Renderer` | TaplyRenderer | Rendering orchestration |
| `RenderPipeline` | TaplyRenderer (internal) | Two-phase paint + widget pipeline |
| `AnimationController` | TaplyEngine (internal) | Animation timeline evaluation |
| `ThemeValidator` | TaplyValidator | Theme integrity validation |
| `ExportPipeline` | TaplyExporter | Headless export pathway |

### 1.10 Thread Safety

All SDK operations are **thread-safe** by default. The SDK guarantees:

1. **No shared mutable state** — All internal state is isolated to the SDK instance.
2. **Async isolation** — Long-running operations (load, validate, render) never block the caller.
3. **Render isolation** — Rendering operations run on a dedicated render thread/isolate.
4. **Event ordering** — Events from the same source are delivered in order.

---

## 2. SDK Modules

### 2.1 Module Architecture

```
┌────────────────────────────────────────────────────────────────────────────┐
│                          TAPLY SDK ARCHITECTURE                             │
├────────────────────────────────────────────────────────────────────────────┤
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                        PUBLIC API LAYER                              │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │   │
│  │  │  Engine   │ │  Theme   │ │  Render  │ │  Scene   │ │Variables │ │   │
│  │  │ Lifecycle │ │   API    │ │   API    │ │   API    │ │   API    │ │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │   │
│  │  │Registry  │ │ Plugin   │ │  Event   │ │Validate  │ │Marketpl. │ │   │
│  │  │   API    │ │   API    │ │  System  │ │   API    │ │   API    │ │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐                           │   │
│  │  │ DevTools │ │   AI     │ │   CLI    │                           │   │
│  │  │   API    │ │   API    │ │   Spec   │                           │   │
│  │  └──────────┘ └──────────┘ └──────────┘                           │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                      INTERNAL ABSTRACTION LAYER                      │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │   │
│  │  │  Theme   │ │  Scene   │ │Variable  │ │  Asset   │ │  Effect  │ │   │
│  │  │  Store   │ │  Graph   │ │Resolver  │ │  Loader  │ │Compositor│ │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ │   │
│  │  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ │   │
│  │  │   Diff   │ │ Migration│ │  Export  │ │  Import  │ │ Package  │ │   │
│  │  │  Engine  │ │  Engine  │ │ Pipeline │ │ Pipeline │ │   Manager│ │   │
│  │  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘ │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
│  ┌────────────────────────────────────────────────────────────────────┐   │
│  │                     EVENT BUS (CROSS-CUTTING)                        │   │
│  └────────────────────────────────────────────────────────────────────┘   │
│                                                                            │
└────────────────────────────────────────────────────────────────────────────┘
```

### 2.2 Module Catalog

#### 2.2.1 TaplyEngine (Engine Lifecycle)

**Responsibility:** SDK initialization, configuration, lifecycle management, capability detection.

**Dependencies:** None (root module).

**Key Capabilities:**
- Initialize and dispose the SDK
- Check SDK version and available features
- Configure global settings (cache, network, logging)
- Request and verify permissions
- Detect runtime platform and capabilities

#### 2.2.2 TaplyTheme (Theme API)

**Responsibility:** Full lifecycle management of theme documents — loading, saving, exporting, importing, diffing, upgrading, and migration.

**Dependencies:** TaplyEngine, TaplyValidator, TaplyVariables, TaplyComponents.

**Key Capabilities:**
- Load theme from file, memory, package, remote URL, or marketplace
- Save theme to file or memory
- Export and import in multiple formats (.taply, .json, .zip)
- Duplicate, clone, reset themes
- Compare theme versions, compute diffs, apply patches
- Upgrade and migrate themes across spec versions

#### 2.2.3 TaplyRenderer (Rendering API)

**Responsibility:** All visual output — rendering, previewing, exporting to image/PDF/SVG, capturing widgets, and partial/incremental rendering.

**Dependencies:** TaplyEngine, TaplyScene, TaplyVariables, TaplyAssets.

**Key Capabilities:**
- Render a scene to the display
- Generate preview images at arbitrary sizes
- Export to PNG, JPEG, PDF, SVG
- Capture individual layers as widgets
- Render in background (off-screen) mode
- Render specific regions or layer subsets
- Incremental rendering for animated content

#### 2.2.4 TaplyScene (Scene API)

**Responsibility:** Scene graph manipulation — creating, querying, modifying, and serializing the layer tree.

**Dependencies:** TaplyEngine, TaplyVariables.

**Key Capabilities:**
- Create and manage scenes and groups
- Add, move, duplicate, delete layers
- Hide, lock, reorder layers
- Group and ungroup layers
- Layer selection and traversal
- Serialize to/from JSON

#### 2.2.5 TaplyVariables (Variables API)

**Responsibility:** Variable declaration, resolution, override, scoping, and inheritance across themes, components, and local scopes.

**Dependencies:** TaplyEngine.

**Key Capabilities:**
- Declare, read, update, delete variables
- Resolve variable references in theme documents
- Override variables at component and layer scope
- Variable inheritance and fallback chains
- Type inference and validation

#### 2.2.6 TaplyAssets (Asset API — internal module)

**Responsibility:** Asset loading, caching, resolution, and lifecycle.

**Dependencies:** TaplyEngine.

**Key Capabilities:**
- Load bundled and remote assets
- Cache decoded assets with LRU eviction
- Resolve asset references in theme documents
- Font loading and Google Fonts integration
- Asset lifecycle management

**Note:** This module has no direct public API. All asset operations are accessed through other modules (Renderer, Theme, Scene).

#### 2.2.7 TaplyMarketplace (Marketplace API)

**Responsibility:** Marketplace integration — searching, installing, purchasing, updating, and managing theme packages.

**Dependencies:** TaplyEngine, TaplyTheme.

**Key Capabilities:**
- Browse and search marketplace themes
- Install, update, remove themes
- Handle purchases and license verification
- Download with progress reporting
- Signature verification
- Restore previous purchases

#### 2.2.8 TaplyAnimation (Animation API)

**Responsibility:** Animation definition, playback, and lifecycle management.

**Dependencies:** TaplyEngine, TaplyScene.

**Key Capabilities:**
- Define and configure animations
- Start, stop, pause, resume playback
- Bind animations to layers and events
- Create animation sequences and parallel groups
- Animation curve and property management

#### 2.2.9 TaplyStudio (Studio API — design tool integration)

**Responsibility:** Design tool bridge — interface between Taply and design tools (Figma, Sketch, Adobe XD, Canva).

**Dependencies:** TaplyEngine, TaplyTheme, TaplyScene, TaplyVariables.

**Key Capabilities:**
- Import designs from design tools
- Export themes to design tool formats
- Two-way sync between design tools and Taply themes
- Design token extraction

#### 2.2.10 TaplyValidator (Validation API)

**Responsibility:** All validation — schema, semantic, constraint, reference, color, asset integrity.

**Dependencies:** TaplyEngine.

**Key Capabilities:**
- Validate entire themes or individual components
- Schema validation against JSON Schema
- Semantic validation (references, constraints, duplicates)
- Auto-fix for common issues
- Structured validation reports with codes, levels, and paths

#### 2.2.11 TaplyExporter (Export API)

**Responsibility:** Export themes to various output formats — image, document, package, code scaffolding.

**Dependencies:** TaplyEngine, TaplyRenderer, TaplyTheme.

**Key Capabilities:**
- Export to image formats (PNG, JPEG, WebP)
- Export to document formats (PDF, SVG)
- Export theme package (.taply)
- Export code scaffolding (Flutter widget tree skeleton)
- Batch export with progress reporting

#### 2.2.12 TaplyImporter (Import API)

**Responsibility:** Import themes from external formats and sources.

**Dependencies:** TaplyEngine, TaplyTheme, TaplyValidator.

**Key Capabilities:**
- Import from .taply packages
- Import from raw JSON
- Import from design tool formats
- Import legacy V1 themes with automatic migration
- Verify integrity during import

#### 2.2.13 TaplyPlugins (Plugin API)

**Responsibility:** Plugin lifecycle, registration, sandboxing, permissions, and dependency management.

**Dependencies:** TaplyEngine.

**Key Capabilities:**
- Discover, install, remove plugins
- Load and unload plugins
- Manage plugin permissions
- Resolve plugin dependencies
- Version compatibility checking
- Plugin sandbox enforcement

#### 2.2.14 TaplyRegistry (Registry API)

**Responsibility:** Type registration for all extensible systems — layers, widgets, effects, animations, validators, components, asset loaders.

**Dependencies:** TaplyEngine.

**Key Capabilities:**
- Register and unregister types
- Resolve types by identifier
- Query registered types with metadata
- Override resolution priority
- Discover available extensions

#### 2.2.15 TaplyDevTools (DevTools API)

**Responsibility:** Development tooling — inspection, monitoring, profiling, debugging.

**Dependencies:** TaplyEngine, TaplyScene, TaplyRenderer.

**Key Capabilities:**
- Scene inspector with live layer tree
- Layer property inspector
- Variable viewer with resolution tracing
- Performance monitoring (FPS, memory, render time)
- JSON viewer for raw theme document
- Theme diff viewer
- Validation report display

#### 2.2.16 TaplyAI (AI API)

**Responsibility:** AI-powered theme generation, optimization, and assistance.

**Dependencies:** TaplyEngine, TaplyTheme, TaplyValidator.

**Key Capabilities:**
- Generate complete themes from text prompts
- Generate color palettes
- Generate layouts
- Generate typography schemes
- Optimize existing themes
- Repair broken themes
- Convert images to theme designs
- Create preview images

---

## 3. Engine Lifecycle

### 3.1 Lifecycle States

The engine transitions through a defined set of states:

```
                 ┌──────────────┐
                 │  Uninitialized│
                 └──────┬───────┘
                        │
                        ▼
                 ┌──────────────┐
          ┌─────│  Initializing │─────┐
          │     └──────┬───────┘     │
          │            │             │
          │            ▼             │
          │     ┌──────────────┐     │
          │     │   Ready      │     │
          │     └──────┬───────┘     │
          │            │             │
          │            ▼             │
          │     ┌──────────────┐     │
          │     │  Loading     │     │
          │     └──────┬───────┘     │
          │            │             │
          │            ▼             │
          │     ┌──────────────┐     │
          │     │ Theme Loaded │     │
          │     └──────┬───────┘     │
          │            │             │
          │            ▼             │
          │     ┌──────────────┐     │
          │     │  Rendering   │     │
          │     └──────┬───────┘     │
          │            │             │
          │            ▼             │
          │     ┌──────────────┐     │
          └─────│  Disposed    │     │
                └──────────────┘     │
                                     │
                Error ───────────────┘
                State ──► Recover / Dispose
```

| State | Description |
|---|---|
| `uninitialized` | SDK not yet initialized. No operations possible. |
| `initializing` | SDK is initializing resources. Transient state. |
| `ready` | SDK initialized, no theme loaded. Basic queries work. |
| `loading` | Theme is being loaded and processed. Transient state. |
| `themeLoaded` | Theme loaded and resolved. Ready for scene access and rendering. |
| `rendering` | A render operation is in progress. Transient state. |
| `disposed` | SDK resources released. No further operations possible. |
| `error` | An unrecoverable error occurred. Engine must be re-initialized. |

### 3.2 Initialize Engine

```
engine.initialize(config) → Result<EngineHandle, EngineError>
```

**Description:** Initializes the SDK. Must be called once before any other operation.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `config` | EngineConfig | **yes** | — | Engine configuration |
| `config.apiKey` | string | no | — | Marketplace API key |
| `config.cacheDirectory` | string | no | system temp | Cache directory path |
| `config.maxCacheSize` | integer | no | 104857600 | Cache size limit in bytes |
| `config.enableNetwork` | boolean | no | true | Allow remote asset fetching |
| `config.enablePlugins` | boolean | no | true | Allow plugin loading |
| `config.logLevel` | enum | no | `"warning"` | Logging verbosity |
| `config.permissions` | string[] | no | [] | SDK permissions to request |
| `config.timeout` | integer | no | 30000 | Default timeout in ms |

**Returns:** `EngineHandle` — opaque handle representing the initialized SDK instance.

**Error Codes:**

| Code | Description |
|---|---|
| `ENGINE_ALREADY_INITIALIZED` | Initialize called when already initialized |
| `ENGINE_INIT_FAILED` | Generic initialization failure |
| `ENGINE_PERMISSION_DENIED` | Required permission not granted |
| `ENGINE_INVALID_CONFIG` | Configuration validation failed |

**Example:**

```
handle = engine.initialize(config: {
  apiKey: "mkp_abc123",
  cacheDirectory: "/tmp/taply_cache",
  enableNetwork: true,
  enablePlugins: true,
  logLevel: "info",
  permissions: ["theme.read", "theme.write", "marketplace.download"]
})
```

### 3.3 Load Theme

```
engine.loadTheme(handle, source) → Result<ThemeHandle, ThemeError>
```

**Description:** Loads a theme from the specified source into the engine.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `handle` | EngineHandle | **yes** | Initialized engine handle |
| `source` | ThemeSource | **yes** | Theme source specification |

**ThemeSource:**

| Property | Type | Description |
|---|---|---|
| `type` | enum | `"file"`, `"memory"`, `"package"`, `"remote"`, `"marketplace"` |
| `path` | string | File path (for `"file"`) |
| `data` | string | JSON string (for `"memory"`) |
| `packageId` | string | Marketplace package ID (for `"marketplace"`) |
| `url` | string | Remote URL (for `"remote"`) |
| `password` | string | Optional decryption password |

**Returns:** `ThemeHandle` — opaque handle for the loaded theme.

**Processing Pipeline:**

```
source
  → read bytes                                          [ThemeLoader]
  → decompress (if packaged)
  → decrypt (if encrypted)
  → parse JSON                                          [ThemeParser]
  → validate schema                                     [ThemeValidator]
  → resolve variables                                   [VariableResolver]
  → resolve assets                                      [AssetManager]
  → expand components                                   [ComponentRegistry]
  → resolve constraints                                 [LayoutEngine]
  → build scene graph                                   [SceneGraph]
  → assign z-order
  → return ThemeHandle
```

**Events Emitted:**

| Event | When |
|---|---|
| `theme.load.started` | Load operation began |
| `theme.load.progress` | Progress update (percentage) |
| `theme.load.completed` | Load completed successfully |
| `theme.load.failed` | Load failed |

### 3.4 Validate Theme

```
engine.validateTheme(handle, options) → Result<ValidationReport, ValidationError>
```

**Description:** Validates the currently loaded theme. Returns a structured validation report.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `handle` | EngineHandle | **yes** | — | Engine handle |
| `options.mode` | enum | no | `"default"` | `"default"`, `"strict"`, `"permissive"` |
| `options.categories` | string[] | no | all | Validation categories to check |

### 3.5 Resolve Variables

```
engine.resolveVariables(handle, scope) → Result<VariableMap, VariableError>
```

**Description:** Resolves all variable references in the loaded theme.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `handle` | EngineHandle | **yes** | — | Engine handle |
| `scope` | enum | no | `"theme"` | `"theme"`, `"component"`, `"local"` |

### 3.6 Resolve Assets

```
engine.resolveAssets(handle, assetReferences) → Result<AssetMap, AssetError>
```

**Description:** Resolves asset references, loading and caching them.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `handle` | EngineHandle | **yes** | Engine handle |
| `assetReferences` | AssetRef[] | **yes** | Asset references to resolve |

### 3.7 Create Scene

```
engine.createScene(handle, options) → Result<SceneHandle, SceneError>
```

**Description:** Creates a renderable scene from the loaded theme.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `handle` | EngineHandle | **yes** | — | Engine handle |
| `options.mode` | enum | no | `"render"` | `"render"`, `"preview"`, `"edit"` |
| `options.resolution` | Size | no | theme default | Output resolution |
| `options.variants` | Variant[] | no | [] | Theme variants to apply |

### 3.8 Build Widget Tree

```
engine.buildWidgetTree(sceneHandle, context) → Result<WidgetNode, RenderError>
```

**Description:** Builds a platform widget tree from the scene graph.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Scene handle |
| `context` | RenderContext | **yes** | Render context with platform info, safe areas, DPI |

### 3.9 Render Canvas

```
engine.renderCanvas(sceneHandle, output) → Result<RenderOutput, RenderError>
```

**Description:** Renders the scene to an output surface.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene handle |
| `output` | RenderOutput | **yes** | — | Output target specification |
| `output.type` | enum | **yes** | — | `"display"`, `"image"`, `"pdf"`, `"svg"`, `"buffer"` |
| `output.width` | integer | no | scene width | Output width in pixels |
| `output.height` | integer | no | scene height | Output height in pixels |
| `output.format` | enum | no | `"rgba"` | Pixel format |
| `output.quality` | integer | no | `95` | JPEG/WebP quality 0–100 |

### 3.10 Composite Layers

```
engine.compositeLayers(sceneHandle, layerIds) → Result<CompositeOutput, RenderError>
```

**Description:** Composites a subset of layers into a single output.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Scene handle |
| `layerIds` | string[] | **yes** | Layer IDs to composite |

### 3.11 Dispose

```
engine.dispose(handle) → Result<void, EngineError>
```

**Description:** Releases all SDK resources. After dispose, the engine handle is invalid.

**Cleanup Sequence:**

```
handle
  → stop all animations
  → release GPU resources
  → flush caches to disk
  → unload plugins
  → close network connections
  → free memory
  → mark handle as disposed
  → emit event "engine.disposed"
  → return
```

### 3.12 Error Recovery

```
engine.recover(handle, strategy) → Result<void, EngineError>
```

**Description:** Attempts to recover from an error state.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `handle` | EngineHandle | **yes** | — | Engine handle in error state |
| `strategy` | enum | no | `"auto"` | `"auto"`, `"reset"`, `"reload"`, `"clearCache"` |

**Recovery Strategies:**

| Strategy | Behavior |
|---|---|
| `"auto"` | Engine selects best recovery strategy |
| `"reset"` | Resets to ready state without disposing |
| `"reload"` | Reloads the last known good theme |
| `"clearCache"` | Clears caches and retries the failed operation |

---

## 4. Theme API

### 4.1 Module Overview

The Theme API manages the full lifecycle of theme documents. A theme is a self-contained JSON document (or `.taply` package) that describes a complete visual design.

All theme operations go through the `theme` module obtained from the initialized engine:

```
themeApi = engine.theme(handle)
```

### 4.2 Load Theme

```
themeApi.load(source) → Result<ThemeHandle, ThemeError>
```

**Description:** Loads a theme from the specified source. Returns a theme handle for subsequent operations.

**Parameters:** See section 3.3.

**Behavior:**
- If the theme is a `.taply` package, assets are extracted to the cache.
- If the theme references remote assets, they are downloaded on demand.
- Theme is validated during load. Load fails on structural errors.
- Variables are resolved after load. Variable resolution errors produce warnings, not failures.
- Component expansion happens after load.

### 4.3 Save Theme

```
themeApi.save(themeHandle, destination) → Result<void, ThemeError>
```

**Description:** Saves the theme to the specified destination.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Theme to save |
| `destination` | ThemeDestination | **yes** | Save destination |

**ThemeDestination:**

| Property | Type | Description |
|---|---|---|
| `type` | enum | `"file"`, `"memory"`, `"package"` |
| `path` | string | File path (for `"file"`) |
| `includeAssets` | boolean | Whether to bundle assets |
| `compress` | boolean | Whether to compress output |
| `encrypt` | boolean | Whether to encrypt output |

### 4.4 Export Theme

```
themeApi.export(themeHandle, format, options) → Result<ExportOutput, ExportError>
```

**Description:** Exports the theme to a specified format.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to export |
| `format` | enum | **yes** | — | `".taply"`, `".json"`, `".zip"` |
| `options.includeAssets` | boolean | no | `true` | Bundle assets in export |
| `options.compress` | boolean | no | `true` | Compress output |
| `options.includeMetadata` | boolean | no | `true` | Include author/source metadata |
| `options.prettyPrint` | boolean | no | `true` | Pretty-print JSON |

### 4.5 Import Theme

```
themeApi.import(source, options) → Result<ThemeHandle, ImportError>
```

**Description:** Imports a theme from an external format. Supports auto-detection of format.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `source` | ImportSource | **yes** | — | Source specification |
| `source.type` | enum | **yes** | — | `"file"`, `"memory"`, `"package"`, `"legacyV1"` |
| `source.path` | string | depends | — | File path |
| `source.data` | string | depends | — | Raw data |
| `options.autoMigrate` | boolean | no | `true` | Auto-migrate legacy formats |
| `options.validate` | boolean | no | `true` | Validate after import |
| `options.mergeStrategy` | enum | no | `"replace"` | `"replace"`, `"merge"`, `"dryRun"` |

### 4.6 Duplicate Theme

```
themeApi.duplicate(themeHandle, metadata) → Result<ThemeHandle, ThemeError>
```

**Description:** Creates a deep copy of the theme with new metadata.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Theme to duplicate |
| `metadata` | ThemeMetadata | **yes** | New metadata for the duplicate |

**Behavior:**
- Deep copies all layers, variables, components, animations, states.
- Does not copy runtime state (animation progress, active states).
- New theme receives a new unique ID.

### 4.7 Delete Theme

```
themeApi.delete(themeHandle) → Result<void, ThemeError>
```

**Description:** Deletes the theme and releases its resources.

**Behavior:**
- Releases cached assets for this theme.
- Stops any running animations.
- Emits `theme.deleted` event.
- The theme handle is invalidated.

### 4.8 Clone Theme

```
themeApi.clone(themeHandle, modifications) → Result<ThemeHandle, ThemeError>
```

**Description:** Creates a lightweight copy with optional modifications.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Theme to clone |
| `modifications` | ThemeModification[] | no | Modifications to apply |

**Difference from Duplicate:**
- Clone is a shallow copy with shared asset references (copy-on-write).
- Clone is cheaper than Duplicate for large themes.
- Clone is used for "Save As" and "Create Variant" workflows.

### 4.9 Reset Theme

```
themeApi.reset(themeHandle, scope) → Result<void, ThemeError>
```

**Description:** Resets theme properties to defaults.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to reset |
| `scope` | enum | no | `"all"` | `"all"`, `"layers"`, `"variables"`, `"components"`, `"animations"`, `"states"` |

### 4.10 Install Theme

```
themeApi.install(packageSource) → Result<ThemeHandle, InstallError>
```

**Description:** Installs a theme package into the local theme store.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `packageSource` | PackageSource | **yes** | Package to install |

**Installation Process:**

```
package
  → verify integrity (checksum)
  → verify signature (if present)
  → extract assets to managed storage
  → register in theme store
  → emit event "theme.installed"
  → return theme handle
```

### 4.11 Uninstall Theme

```
themeApi.uninstall(themeHandle) → Result<void, InstallError>
```

**Description:** Removes an installed theme from the local theme store.

**Behavior:**
- Removes theme from store registry.
- Deletes managed assets for this theme.
- Does not delete user-created themes.
- Emits `theme.uninstalled` event.

### 4.12 Preview Theme

```
themeApi.preview(themeHandle, options) → Result<PreviewImage, PreviewError>
```

**Description:** Generates a preview image of the theme.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to preview |
| `options.width` | integer | no | `400` | Preview width in pixels |
| `options.height` | integer | no | `240` | Preview height in pixels |
| `options.format` | enum | no | `"png"` | `"png"`, `"jpeg"`, `"webp"` |
| `options.themeMode` | enum | no | `"light"` | `"light"`, `"dark"`, `"both"` |

### 4.13 Compare Theme Versions

```
themeApi.compare(themeA, themeB, options) → Result<ThemeDiff, DiffError>
```

**Description:** Computes the structural and semantic differences between two theme versions.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeA` | ThemeHandle | **yes** | — | First theme (baseline) |
| `themeB` | ThemeHandle | **yes** | — | Second theme (comparison) |
| `options.scope` | enum | no | `"all"` | `"all"`, `"metadata"`, `"layers"`, `"variables"`, `"components"` |
| `options.includeUnchanged` | boolean | no | `false` | Include unchanged properties |

### 4.14 Theme Diff

The diff output is a structured object:

```
ThemeDiff {
  added: Change[]
  removed: Change[]
  modified: Change[]
  summary: {
    additions: integer
    removals: integer
    modifications: integer
    severity: "none" | "minor" | "major" | "breaking"
  }
}
```

Each `Change` contains:

| Property | Type | Description |
|---|---|---|
| `path` | string | JSON path to the changed property |
| `before` | any | Previous value |
| `after` | any | New value |
| `changeType` | enum | `"added"`, `"removed"`, `"modified"` |
| `breaking` | boolean | Whether the change is breaking |

### 4.15 Theme Upgrade

```
themeApi.upgrade(themeHandle, targetVersion) → Result<ThemeHandle, UpgradeError>
```

**Description:** Upgrades a theme from an older spec version to a newer one.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to upgrade |
| `targetVersion` | string | **yes** | — | Target spec version (e.g., "2.1.0") |

**Behavior:**
- Applies registered migration functions sequentially.
- Each migration transforms the theme from version N to N+1.
- If a migration fails, all changes are rolled back.
- The upgraded theme is returned as a new handle; the original is preserved.

### 4.16 Theme Migration

```
themeApi.migrate(themeHandle, migrations) → Result<ThemeHandle, MigrationError>
```

**Description:** Applies a custom set of migration transforms to a theme.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Theme to migrate |
| `migrations` | MigrationDef[] | **yes** | Ordered list of migration definitions |

**Migration Definition:**

| Property | Type | Description |
|---|---|---|
| `fromVersion` | string | Source version |
| `toVersion` | string | Target version |
| `changes` | MigrationChange[] | Ordered list of individual changes |

**MigrationChange:**

| Property | Type | Description |
|---|---|---|
| `action` | enum | `"add"`, `"remove"`, `"rename"`, `"move"`, `"transform"`, `"setDefault"` |
| `path` | string | JSON path to target |
| `value` | any | Value for add/setDefault operations |
| `fromPath` | string | Source path for move/rename operations |
| `transform` | string | Transformation function identifier |

---

## 5. Rendering API

### 5.1 Module Overview

The Rendering API controls all visual output of the Taply engine. It supports multiple rendering modes, output formats, resolutions, and partial rendering strategies.

```
renderApi = engine.renderer(handle)
```

### 5.2 Render

```
renderApi.render(sceneHandle, options) → Result<RenderResult, RenderError>
```

**Description:** Renders the scene to the display.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to render |
| `options.mode` | enum | no | `"normal"` | `"normal"`, `"preview"`, `"thumbnail"`, `"highQuality"` |
| `options.antialiasing` | boolean | no | `true` | Enable anti-aliasing |
| `options.animated` | boolean | no | `true` | Enable animation playback |
| `options.frameCallback` | function | no | — | Per-frame callback |

**Returns:**

| Property | Type | Description |
|---|---|---|
| `widget` | WidgetNode | Root widget of the rendered scene |
| `frameCount` | integer | Total frames rendered |
| `renderTime` | integer | Total render time in ms |
| `memoryUsage` | integer | Memory used during render |

### 5.3 Preview

```
renderApi.preview(sceneHandle, options) → Result<PreviewImage, RenderError>
```

**Description:** Generates a lower-resolution preview suitable for thumbnails and overviews.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to preview |
| `options.width` | integer | no | `400` | Preview width |
| `options.height` | integer | no | `240` | Preview height |
| `options.quality` | integer | no | `80` | Output quality 0–100 |

### 5.4 Thumbnail

```
renderApi.thumbnail(themeHandle, options) → Result<ThumbnailImage, RenderError>
```

**Description:** Generates a small thumbnail from the theme metadata preview layers.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to thumbnail |
| `options.width` | integer | no | `120` | Thumbnail width |
| `options.height` | integer | no | `72` | Thumbnail height |

### 5.5 Export PNG

```
renderApi.exportPng(sceneHandle, options) → Result<BinaryData, RenderError>
```

**Description:** Exports the scene as a PNG image.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to export |
| `options.width` | integer | no | scene width | Output width in pixels |
| `options.height` | integer | no | scene height | Output height in pixels |
| `options.scale` | number | no | `1.0` | Output scale factor |
| `options.background` | color | no | transparent | Background color |

### 5.6 Export JPEG

```
renderApi.exportJpeg(sceneHandle, options) → Result<BinaryData, RenderError>
```

**Description:** Exports the scene as a JPEG image.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to export |
| `options.width` | integer | no | scene width | Output width |
| `options.height` | integer | no | scene height | Output height |
| `options.quality` | integer | no | `90` | JPEG quality 0–100 |
| `options.scale` | number | no | `1.0` | Output scale factor |

### 5.7 Export PDF

```
renderApi.exportPdf(sceneHandle, options) → Result<BinaryData, RenderError>
```

**Description:** Exports the scene as a PDF document.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to export |
| `options.pageWidth` | number | no | scene width | Page width in points |
| `options.pageHeight` | number | no | scene height | Page height in points |
| `options.embedFonts` | boolean | no | `true` | Embed used fonts |
| `options.compress` | boolean | no | `true` | Compress PDF content |

### 5.8 Export SVG

```
renderApi.exportSvg(sceneHandle, options) → Result<string, RenderError>
```

**Description:** Exports the scene as an SVG document.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to export |
| `options.inlineAssets` | boolean | no | `false` | Inline image assets as base64 |
| `options.precision` | integer | no | `3` | Decimal precision for coordinates |
| `options.minify` | boolean | no | `false` | Minify SVG output |

### 5.9 Capture Widget

```
renderApi.captureWidget(sceneHandle, layerId, options) → Result<WidgetCapture, RenderError>
```

**Description:** Captures a specific layer as an independent widget for reuse outside the scene.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene containing the layer |
| `layerId` | string | **yes** | — | Layer to capture |
| `options.keepEffects` | boolean | no | `true` | Keep layer effects |
| `options.keepAnimations` | boolean | no | `true` | Keep layer animations |
| `options.size` | Size | no | layer size | Output size |

### 5.10 High Resolution Export

```
renderApi.exportHighRes(sceneHandle, options) → Result<BinaryData, RenderError>
```

**Description:** Exports at resolutions exceeding the scene's native resolution for print-quality output.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to export |
| `options.scale` | number | **yes** | — | Scale factor (2x, 3x, 4x) |
| `options.format` | enum | **yes** | — | `"png"`, `"jpeg"`, `"tiff"` |
| `options.colorSpace` | enum | no | `"sRGB"` | `"sRGB"`, `"AdobeRGB"`, `"P3"` |

### 5.11 Background Rendering

```
renderApi.renderInBackground(sceneHandle, options) → Result<RenderResult, RenderError>
```

**Description:** Renders the scene in a background thread/isolate without displaying it.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to render |
| `options.output` | RenderOutput | **yes** | — | Output target |
| `options.priority` | enum | no | `"normal"` | `"low"`, `"normal"`, `"high"` |
| `options.progressCallback` | function | no | — | Progress callback (0.0–1.0) |

### 5.12 Render Region

```
renderApi.renderRegion(sceneHandle, region, options) → Result<BinaryData, RenderError>
```

**Description:** Renders only a sub-region of the scene.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Scene to render |
| `region` | Rect | **yes** | Region to render in design units |
| `options.scale` | number | no | `1.0` | Scale factor for the region |

### 5.13 Partial Rendering

```
renderApi.renderPartial(sceneHandle, changedLayerIds) → Result<RenderPatch, RenderError>
```

**Description:** Incrementally renders only the layers that have changed since the last full render.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Scene to render |
| `changedLayerIds` | string[] | **yes** | IDs of layers that changed |

**Returns:**

| Property | Type | Description |
|---|---|---|
| `patches` | Rect[] | Regions that were re-rendered |
| `renderTime` | integer | Render time in ms |

### 5.14 Incremental Rendering

```
renderApi.enableIncrementalRendering(sceneHandle, options) → Result<void, RenderError>
```

**Description:** Enables automatic incremental rendering for the scene.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to configure |
| `options.maxFps` | integer | no | `60` | Maximum frames per second |
| `options.dirtyTracking` | enum | no | `"auto"` | `"auto"`, `"bounds"`, `"layer"` |

---

## 6. Scene API

### 6.1 Module Overview

The Scene API provides full access to the scene graph — the ordered collection of layers that forms the visual structure of a rendered theme.

```
sceneApi = engine.scene(handle)
```

### 6.2 Create Scene

```
sceneApi.create(options) → Result<SceneHandle, SceneError>
```

**Description:** Creates a new empty scene.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `options.width` | integer | no | `1000` | Canvas width in design units |
| `options.height` | integer | no | `600` | Canvas height in design units |
| `options.name` | string | no | `"Untitled"` | Scene name |

### 6.3 Create Group

```
sceneApi.createGroup(sceneHandle, options) → Result<LayerHandle, SceneError>
```

**Description:** Creates a group layer that can contain child layers.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Target scene |
| `options.name` | string | no | `"Group"` | Group name |
| `options.position` | integer | no | end | Insert position index |
| `options.parentGroupId` | string | no | root | Parent group ID |

### 6.4 Create Layer

```
sceneApi.createLayer(sceneHandle, layerDef, options) → Result<LayerHandle, SceneError>
```

**Description:** Creates a new layer in the scene.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Target scene |
| `layerDef` | LayerDefinition | **yes** | — | Layer type and properties |
| `options.position` | integer | no | end | Insert position |
| `options.parentGroupId` | string | no | root | Parent group ID |

**LayerDefinition:**

| Property | Type | Description |
|---|---|---|
| `type` | string | Layer type identifier (paint or widget) |
| `constraints` | Constraints | Layout constraints |
| `properties` | object | Type-specific properties |
| `effects` | EffectDef[] | Visual effects |
| `animations` | AnimationBinding[] | Animation bindings |
| `states` | StateBinding[] | State bindings |
| `visible` | boolean | Initial visibility |
| `locked` | boolean | Locked for editing |

### 6.5 Move Layer

```
sceneApi.moveLayer(sceneHandle, layerId, destination) → Result<void, SceneError>
```

**Description:** Moves a layer to a new position or parent group.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Target scene |
| `layerId` | string | **yes** | Layer to move |
| `destination` | MoveDestination | **yes** | New position |

**MoveDestination:**

| Property | Type | Description |
|---|---|---|
| `targetGroupId` | string | Target group or "root" |
| `position` | enum | `"first"`, `"last"`, `"before"`, `"after"` |
| `referenceLayerId` | string | Reference layer for before/after |

### 6.6 Duplicate Layer

```
sceneApi.duplicateLayer(sceneHandle, layerId, options) → Result<LayerHandle, SceneError>
```

**Description:** Creates a deep copy of a layer.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Target scene |
| `layerId` | string | **yes** | — | Layer to duplicate |
| `options.position` | enum | no | `"after"` | `"after"`, `"before"`, `"last"`, `"first"` |
| `options.duplicateChildren` | boolean | no | `true` | Duplicate child layers |

### 6.7 Delete Layer

```
sceneApi.deleteLayer(sceneHandle, layerId) → Result<void, SceneError>
```

**Description:** Removes a layer from the scene.

**Behavior:**
- If the layer is a group, all children are also deleted.
- Emits `scene.layer.removed` event.
- The layer handle is invalidated.

### 6.8 Hide Layer

```
sceneApi.hideLayer(sceneHandle, layerId, hidden) → Result<void, SceneError>
```

**Description:** Toggles layer visibility.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Target scene |
| `layerId` | string | **yes** | Target layer |
| `hidden` | boolean | **yes** | `true` to hide, `false` to show |

### 6.9 Lock Layer

```
sceneApi.lockLayer(sceneHandle, layerId, locked) → Result<void, SceneError>
```

**Description:** Toggles layer edit lock.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Target scene |
| `layerId` | string | **yes** | Target layer |
| `locked` | boolean | **yes** | `true` to lock, `false` to unlock |

### 6.10 Group Layers

```
sceneApi.groupLayers(sceneHandle, layerIds, options) → Result<LayerHandle, SceneError>
```

**Description:** Groups the specified layers into a new group layer.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Target scene |
| `layerIds` | string[] | **yes** | — | Layers to group |
| `options.groupName` | string | no | `"Group"` | New group name |
| `options.collapse` | boolean | no | `true` | Collapse group on creation |

### 6.11 Ungroup Layers

```
sceneApi.ungroupLayers(sceneHandle, groupId) → Result<string[], SceneError>
```

**Description:** Destroys the group and promotes its children to the parent level.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Target scene |
| `groupId` | string | **yes** | Group to ungroup |

### 6.12 Layer Ordering

```
sceneApi.reorderLayer(sceneHandle, layerId, zIndex) → Result<void, SceneError>
```

**Description:** Sets the explicit z-index of a layer.

```
sceneApi.bringToFront(sceneHandle, layerId) → Result<void, SceneError>
```

**Description:** Moves layer to the highest z-index.

```
sceneApi.sendToBack(sceneHandle, layerId) → Result<void, SceneError>
```

**Description:** Moves layer to the lowest z-index.

```
sceneApi.bringForward(sceneHandle, layerId) → Result<void, SceneError>
```

**Description:** Moves layer one step forward in z-order.

```
sceneApi.sendBackward(sceneHandle, layerId) → Result<void, SceneError>
```

**Description:** Moves layer one step backward in z-order.

### 6.13 Transform

```
sceneApi.transformLayer(sceneHandle, layerId, transform) → Result<void, SceneError>
```

**Description:** Applies a geometric transformation to a layer.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | Target scene |
| `layerId` | string | **yes** | Target layer |
| `transform` | LayerTransform | **yes** | Transform to apply |

**LayerTransform:**

| Property | Type | Description |
|---|---|---|
| `translationX` | number | X offset in design units |
| `translationY` | number | Y offset in design units |
| `rotation` | number | Rotation in degrees |
| `scaleX` | number | Horizontal scale factor |
| `scaleY` | number | Vertical scale factor |
| `anchorX` | number | Transform origin X (0–1) |
| `anchorY` | number | Transform origin Y (0–1) |
| `opacity` | number | Layer opacity (0–1) |

### 6.14 Selection

```
sceneApi.selectLayer(sceneHandle, layerId) → Result<void, SceneError>
```

**Description:** Selects a single layer by ID.

```
sceneApi.selectLayers(sceneHandle, layerIds) → Result<void, SceneError>
```

**Description:** Selects multiple layers.

```
sceneApi.selectAll(sceneHandle) → Result<string[], SceneError>
```

**Description:** Selects all layers. Returns selected layer IDs.

```
sceneApi.clearSelection(sceneHandle) → Result<void, SceneError>
```

**Description:** Clears the current selection.

```
sceneApi.getSelection(sceneHandle) → Result<string[], SceneError>
```

**Description:** Returns the currently selected layer IDs.

### 6.15 Traversal

```
sceneApi.getLayerById(sceneHandle, layerId) → Result<LayerInfo, SceneError>
```

**Description:** Gets layer information by ID.

```
sceneApi.getLayersByType(sceneHandle, type) → Result<LayerInfo[], SceneError>
```

**Description:** Finds all layers of a given type.

```
sceneApi.getLayersAtPoint(sceneHandle, point) → Result<LayerInfo[], SceneError>
```

**Description:** Returns all layers at a given coordinate, sorted by z-index (topmost first).

```
sceneApi.getParent(sceneHandle, layerId) → Result<string|null, SceneError>
```

**Description:** Returns the parent group ID for a layer.

```
sceneApi.getChildren(sceneHandle, groupId) → Result<string[], SceneError>
```

**Description:** Returns child layer IDs for a group.

```
sceneApi.traverse(sceneHandle, visitor) → Result<void, SceneError>
```

**Description:** Walks the entire layer tree, calling the visitor function for each layer.

**Visitor Function:**
```
visitor(layerInfo, depth) → TraversalDecision
```

**TraversalDecision:**
| Value | Behavior |
|---|---|
| `"continue"` | Continue traversal to next sibling |
| `"skipChildren"` | Skip this layer's children |
| `"stop"` | Stop all traversal |

### 6.16 Serialization

```
sceneApi.toJson(sceneHandle, options) → Result<string, SceneError>
```

**Description:** Serializes the scene to a JSON string.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to serialize |
| `options.prettyPrint` | boolean | no | `true` | Pretty-print JSON |
| `options.includeDefaults` | boolean | no | `false` | Include default values |

```
sceneApi.fromJson(jsonString) → Result<SceneHandle, SceneError>
```

**Description:** Deserializes a scene from JSON.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `jsonString` | string | **yes** | JSON scene definition |

---

## 7. Variables API

### 7.1 Module Overview

The Variables API manages theme variables — named reusable values that can be referenced throughout a theme. Variables support scoping, inheritance, override chains, and type inference.

```
variablesApi = engine.variables(handle)
```

### 7.2 Get Variable

```
variablesApi.get(themeHandle, variablePath, scope) → Result<VariableValue, VariableError>
```

**Description:** Retrieves a variable's resolved value.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme containing the variable |
| `variablePath` | string | **yes** | — | Variable path (e.g., `"colors.primary"`) |
| `scope` | enum | no | `"theme"` | `"theme"`, `"local"`, `"all"` |

### 7.3 Set Variable

```
variablesApi.set(themeHandle, variablePath, value, scope) → Result<void, VariableError>
```

**Description:** Sets a variable's value.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `variablePath` | string | **yes** | Variable path |
| `value` | VariableValue | **yes** | New value |
| `scope` | enum | no | `"theme"` |

### 7.4 Resolve Variable

```
variablesApi.resolve(themeHandle, expression) → Result<VariableValue, VariableError>
```

**Description:** Resolves a `$var.` expression to its concrete value.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Theme context |
| `expression` | string | **yes** | Variable expression (e.g., `"$var.colors.primary"`) |

**Behavior:**
- Resolves the variable reference through the entire scope chain.
- Returns the final resolved value.
- If the reference is invalid, returns a `VariableError` with code `VARIABLE_NOT_FOUND`.

### 7.5 Override Variable

```
variablesApi.override(themeHandle, variablePath, value, scope) → Result<OverrideHandle, VariableError>
```

**Description:** Temporarily overrides a variable's value within a scope.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `variablePath` | string | **yes** | Variable path |
| `value` | VariableValue | **yes** | Override value |
| `scope` | enum | **yes** | `"component"`, `"layer"`, `"render"` |

**Behavior:**
- Overrides do not modify the stored theme.
- Overrides are scoped to component, layer, or render contexts.
- Returns an `OverrideHandle` that can be used to remove the override.
- Overrides are automatically removed when their scope ends.

### 7.6 Create Variable

```
variablesApi.create(themeHandle, variablePath, value, options) → Result<void, VariableError>
```

**Description:** Creates a new variable.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Target theme |
| `variablePath` | string | **yes** | — | Variable path (e.g., `"colors.accent"`) |
| `value` | VariableValue | **yes** | — | Variable value |
| `options.type` | enum | no | inferred | Variable type hint |
| `options.description` | string | no | — | Human-readable description |
| `options.category` | string | no | — | Organization category |

### 7.7 Delete Variable

```
variablesApi.delete(themeHandle, variablePath) → Result<void, VariableError>
```

**Description:** Deletes a variable.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `variablePath` | string | **yes** | Variable path to delete |

**Behavior:**
- If the variable is referenced by layers, those references become unresolved.
- A validation warning is emitted for each broken reference.
- Emits `variables.deleted` event.

### 7.8 Variable Scopes

Variables exist in four scopes, resolved in order:

```
Layer override     (highest priority)
  ↓
Component override (local to component instance)
  ↓
Component default  (defined in component definition)
  ↓
Theme default      (defined at theme root — lowest priority)
```

**Scope Resolution:**

```
variablesApi.resolveWithScope(themeHandle, expression, scopeChain) → Result<VariableValue, VariableError>

scopeChain: ["layer:avatar_layer", "component:profile_header", "theme"]
```

### 7.9 Local Variables

Local variables are scoped to a single layer or component instance:

```
variablesApi.createLocal(componentHandle, variablePath, value) → Result<OverrideHandle, VariableError>
```

**Behavior:**
- Local variables override theme and component variables.
- Local variables are not serialized when exporting the theme.
- Local variables are discarded when the component is detached.

### 7.10 Inheritance

```
variablesApi.getInheritanceChain(themeHandle, variablePath) → Result<VariableInheritance, VariableError>
```

**Description:** Returns the full inheritance chain for a variable.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `chain` | InheritanceLink[] | Ordered list from lowest to highest priority |
| `resolvedValue` | VariableValue | The final resolved value |
| `resolvedFrom` | string | The scope that provided the final value |

### 7.11 Fallback

```
variablesApi.getWithFallback(themeHandle, variablePath, fallbackValue) → Result<VariableValue, VariableError>
```

**Description:** Gets a variable value, using a fallback if the variable is not defined.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `variablePath` | string | **yes** | Variable path |
| `fallbackValue` | VariableValue | **yes** | Fallback value |

---

## 8. Components API

### 8.1 Module Overview

The Components API provides the interface for defining, instantiating, managing, and reusing component definitions within themes.

```
componentsApi = engine.components(handle)
```

### 8.2 Create Component

```
componentsApi.create(themeHandle, componentDef) → Result<ComponentHandle, ComponentError>
```

**Description:** Creates a new component definition in the theme.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `componentDef` | ComponentDefinition | **yes** | Component definition |

**ComponentDefinition:**

| Property | Type | Required | Description |
|---|---|---|---|
| `id` | string | **yes** | Unique component identifier |
| `description` | string | no | Human-readable description |
| `category` | string | no | Organization category |
| `variables` | VariableMap | no | Component-scoped variable defaults |
| `slots` | SlotMap | no | Configurable slot definitions |
| `layers` | LayerDefinition[] | **yes** | Component layer tree |

### 8.3 Instantiate Component

```
componentsApi.instantiate(themeHandle, componentId, options) → Result<LayerHandle[], ComponentError>
```

**Description:** Creates an instance of a component in the scene.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Target theme |
| `componentId` | string | **yes** | — | Component to instantiate |
| `options.slots` | SlotOverride | no | — | Slot value overrides |
| `options.variables` | VariableMap | no | — | Variable overrides |
| `options.constraints` | Constraints | no | — | Outer constraints |

**Processing:**

```
componentId
  → load component definition
  → merge slot overrides
  → merge variable overrides
  → expand layer tree
  → apply constraints wrapper
  → create layer instances
  → return layer handles
```

### 8.4 Detach Component

```
componentsApi.detach(themeHandle, instanceLayerId) → Result<LayerHandle[], ComponentError>
```

**Description:** Detaches a component instance, converting it to regular editable layers.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `instanceLayerId` | string | **yes** | Component instance to detach |

**Behavior:**
- The component instance is replaced with its expanded layers.
- The layers lose their connection to the component definition.
- All overrides become permanent property values.
- Emits `components.detached` event.

### 8.5 Override Component

```
componentsApi.override(themeHandle, instanceLayerId, slotPath, value) → Result<void, ComponentError>
```

**Description:** Overrides a slot value on a component instance.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `instanceLayerId` | string | **yes** | Component instance |
| `slotPath` | string | **yes** | Slot path (e.g., `"nameStyle.fontSize"`) |
| `value` | any | **yes** | Override value |

### 8.6 Update Component

```
componentsApi.update(themeHandle, componentId, componentDef) → Result<void, ComponentError>
```

**Description:** Updates the component definition. All instances are updated on next render.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Target theme |
| `componentId` | string | **yes** | Component to update |
| `componentDef` | ComponentDefinition | **yes** | New component definition |

**Behavior:**
- Existing instances update on next render.
- Instances with overrides retain their overrides.
- If slots are removed, instance overrides for removed slots are discarded.

### 8.7 Slots

```
componentsApi.getSlots(themeHandle, componentId) → Result<SlotMap, ComponentError>
```

**Description:** Returns the slot definitions for a component.

```
componentsApi.setSlot(themeHandle, componentId, slotName, slotDef) → Result<void, ComponentError>
```

**Description:** Adds or updates a slot on a component.

**SlotDefinition:**

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `name` | string | **yes** | — | Slot identifier |
| `type` | string | no | `"any"` | Expected value type |
| `required` | boolean | no | `false` | Whether slot must be provided |
| `default` | any | no | — | Default value |
| `description` | string | no | — | Human-readable description |

### 8.8 Parameters

```
componentsApi.getParameters(themeHandle, componentId) → Result<ParameterMap, ComponentError>
```

**Description:** Returns all configurable parameters for a component (slots + variables).

```
componentsApi.setParameter(themeHandle, componentId, parameterPath, value) → Result<void, ComponentError>
```

**Description:** Sets a parameter value on a component definition.

### 8.9 Nested Components

Components can contain instances of other components. The SDK preserves the nesting hierarchy:

```
componentsApi.getNestingChain(themeHandle, instanceLayerId) → Result<ComponentChain, ComponentError>
```

**Returns:**

| Property | Type | Description |
|---|---|---|
| `chain` | ComponentRef[] | Ordered list from outermost to innermost |
| `depth` | integer | Nesting depth |

### 8.10 Reuse

```
componentsApi.findUsages(themeHandle, componentId) → Result<Usage[], ComponentError>
```

**Description:** Finds all instances of a component in the scene.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `usageCount` | integer | Total instance count |
| `usages` | Usage[] | Instance details (layer ID, parent, slot overrides) |

---

## 9. Registry API

### 9.1 Module Overview

The Registry API is the extensibility backbone of the Taply SDK. It manages the registration, discovery, and resolution of all extension types — layers, widgets, effects, animations, validators, asset loaders, and plugins.

```
registryApi = engine.registry(handle)
```

### 9.2 Registry Categories

| Registry | Registration Key | Extension Point |
|---|---|---|
| `layer` | type string | Paint layer renderers |
| `widget` | type string | Widget layer renderers |
| `component` | component ID | Built-in component definitions |
| `effect` | type string | Visual effect implementations |
| `animation` | type string | Animation type implementations |
| `curve` | identifier | Easing curve functions |
| `validator` | category | Custom validation rules |
| `assetLoader` | scheme | Custom asset loading protocols |
| `plugin` | plugin ID | Plugin modules |
| `migration` | version pair | Theme migration functions |
| `exporter` | format | Custom export format handlers |
| `importer` | format | Custom import format handlers |

### 9.3 Registration

```
registryApi.register(category, identifier, implementation, options) → Result<RegistrationHandle, RegistryError>
```

**Description:** Registers an extension implementation.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `category` | enum | **yes** | — | Registry category |
| `identifier` | string | **yes** | — | Unique type identifier |
| `implementation` | ExtensionDef | **yes** | — | Extension definition |
| `options.priority` | integer | no | `0` | Resolution priority (higher = preferred) |
| `options.replaceExisting` | boolean | no | `false` | Replace existing registration |
| `options.dependencies` | string[] | no | `[]` | Required dependency identifiers |

### 9.4 Replacement

```
registryApi.replace(category, identifier, implementation) → Result<RegistrationHandle, RegistryError>
```

**Description:** Replaces an existing registration. Requires the `replaceExisting` flag or explicit unregistration first.

```
registryApi.unregister(registrationHandle) → Result<void, RegistryError>
```

**Description:** Removes a registration.

### 9.5 Priority

The registry resolves type conflicts using a priority system:

```
registryApi.resolve(category, identifier, context) → Result<ExtensionDef, RegistryError>
```

**Resolution algorithm:**

```
1. Find all registrations for (category, identifier)
2. If none found → RegistryError NOT_FOUND
3. If one found → return it
4. If multiple found:
   a. Filter by version compatibility with context
   b. Sort by priority (descending)
   c. Return highest priority match
```

### 9.6 Dependencies

```
registryApi.getDependencyGraph(category) → Result<DependencyGraph, RegistryError>
```

**Description:** Returns the dependency graph for a registry category.

```
registryApi.checkDependencies(registrationHandle) → Result<DependencyStatus, RegistryError>
```

**Description:** Checks whether all dependencies are satisfied for a registration.

### 9.7 Override Rules

Override rules define how registered types interact:

| Rule | Behavior |
|---|---|
| **Soft override** | Plugin registration has lower priority than core — core always wins |
| **Hard override** | Explicit replacement with `replaceExisting: true` |
| **Chain** | Multiple implementations form a chain; output of one feeds the next |
| **Decorator** | A wrapper implementation that delegates to the original |

```
registryApi.setOverrideRule(category, identifier, rule) → Result<void, RegistryError>
```

**OverrideRule:**

| Property | Type | Description |
|---|---|---|
| `type` | enum | `"soft"`, `"hard"`, `"chain"`, `"decorator"` |
| `priority` | integer | Override priority |

### 9.8 Discovery

```
registryApi.list(category, filter) → Result<Registration[], RegistryError>
```

**Description:** Lists all registrations in a category, optionally filtered.

```
registryApi.find(searchTerm, category) → Result<Registration[], RegistryError>
```

**Description:** Searches for registrations by name, identifier, or description.

```
registryApi.getMetadata(registrationHandle) → Result<RegistrationMetadata, RegistryError>
```

**Description:** Returns metadata for a registration.

**RegistrationMetadata:**

| Property | Type | Description |
|---|---|---|
| `identifier` | string | Type identifier |
| `displayName` | string | Human-readable name |
| `description` | string | Description |
| `version` | string | Extension version |
| `author` | string | Extension author |
| `dependencies` | string[] | Dependency identifiers |
| `priority` | integer | Resolution priority |
| `source` | enum | `"core"`, `"plugin"`, `"user"` |

---

## 10. Plugin API

### 10.1 Module Overview

The Plugin API allows third-party developers to extend the Taply platform. Plugins are isolated modules that can register types with the Registry, subscribe to events, and provide custom functionality through the SDK.

```
pluginsApi = engine.plugins(handle)
```

### 10.2 Plugin Metadata

Every plugin must declare metadata:

**PluginMetadata:**

| Property | Type | Required | Default | Description |
|---|---|---|---|---|
| `id` | string | **yes** | — | Unique plugin identifier |
| `name` | string | **yes** | — | Display name |
| `version` | string | **yes** | — | Plugin version (semver) |
| `description` | string | no | — | Plugin description |
| `author` | string | no | — | Plugin author |
| `icon` | string | no | — | Plugin icon path |
| `minSdkVersion` | string | no | `"2.0.0"` | Minimum SDK version |
| `maxSdkVersion` | string | no | — | Maximum SDK version |
| `dependencies` | PluginDep[] | no | `[]` | Plugin dependencies |
| `permissions` | string[] | no | `[]` | Required permissions |
| `url` | string | no | — | Plugin homepage URL |

### 10.3 Plugin Installation

```
pluginsApi.install(pluginSource) → Result<PluginHandle, PluginError>
```

**Description:** Installs a plugin from a source.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `pluginSource` | PluginSource | **yes** | Plugin source |
| `pluginSource.type` | enum | **yes** | `"file"`, `"package"`, `"marketplace"`, `"remote"` |
| `pluginSource.path` | string | depends | File path |
| `pluginSource.url` | string | depends | Remote URL |

**Installation process:**

```
plugin package
  → verify structure
  → check SDK version compatibility
  → validate manifest
  → check permissions against granted set
  → resolve dependencies
  → extract to managed plugin directory
  → register plugin
  → emit event "plugin.installed"
  → return plugin handle
```

### 10.4 Plugin Lifecycle

Each plugin transitions through these states:

```
Installed  →  Loading  →  Loaded  →  Active  →  Unloading  →  Unloaded
                │           │          │
                ▼           ▼          ▼
              Error       Error      Error
```

| State | Description |
|---|---|
| `installed` | Plugin is on disk but not loaded |
| `loading` | Plugin is being prepared for execution |
| `loaded` | Plugin is loaded but not yet activated |
| `active` | Plugin is fully operational |
| `unloading` | Plugin is being shut down |
| `unloaded` | Plugin resources released |
| `error` | Plugin encountered a fatal error |

```
pluginsApi.load(pluginHandle) → Result<void, PluginError>
```

**Description:** Loads a plugin into memory.

```
pluginsApi.activate(pluginHandle) → Result<void, PluginError>
```

**Description:** Activates a loaded plugin. Plugin begins receiving events and registering types.

```
pluginsApi.deactivate(pluginHandle) → Result<void, PluginError>
```

**Description:** Deactivates a plugin without unloading it.

```
pluginsApi.unload(pluginHandle) → Result<void, PluginError>
```

**Description:** Unloads a plugin and releases its resources.

### 10.5 Plugin Registration

Plugins register their capabilities during the loading phase:

```
// Inside a plugin's load handler:
registryApi.register("effect", "myPlugin.customBlur", implementation)
registryApi.register("layer", "myPlugin.particleSystem", implementation)
eventsApi.subscribe("theme.loaded", onThemeLoaded)
```

### 10.6 Plugin Removal

```
pluginsApi.remove(pluginHandle) → Result<void, PluginError>
```

**Description:** Permanently removes a plugin and all its registrations.

**Behavior:**
- Deactivates the plugin.
- Unregisters all types registered by the plugin.
- Deletes plugin files from managed storage.
- Restores any overridden core types to their defaults.
- Emits `plugin.removed` event.

### 10.7 Plugin Update

```
pluginsApi.update(pluginHandle, newSource) → Result<PluginHandle, PluginError>
```

**Description:** Updates a plugin to a new version.

**Behavior:**
- Preserves plugin configuration and user data.
- Runs plugin migration if version change requires it.
- Replaces registrations with new versions.
- Rolls back on failure.

### 10.8 Plugin Dependencies

```
pluginsApi.resolveDependencies(pluginHandle) → Result<DependencyGraph, PluginError>
```

**Description:** Resolves the full dependency tree for a plugin.

**Dependency rules:**
- Circular dependencies are rejected.
- Version ranges use semver notation (`"^1.0.0"`, `">=2.0.0 <3.0.0"`).
- Missing dependencies produce a `PLUGIN_MISSING_DEPENDENCY` error.

### 10.9 Plugin Version Compatibility

```
pluginsApi.checkCompatibility(pluginHandle) → Result<CompatibilityReport, PluginError>
```

**Returns:**

| Property | Type | Description |
|---|---|---|
| `compatible` | boolean | Whether plugin is compatible |
| `sdkVersion` | string | Current SDK version |
| `minRequired` | string | Minimum SDK version required |
| `maxAllowed` | string | Maximum SDK version allowed |
| `issues` | CompatibilityIssue[] | Compatibility issues |

### 10.10 Security

#### 10.10.1 Sandbox

Plugins operate in a restricted sandbox:

| Resource | Access |
|---|---|
| File system | Plugin directory only |
| Network | Restricted to allowed origins |
| Theme data | Read-only by default |
| SDK internal state | No access |
| Other plugins | No access |
| User data | Explicit permission required |

#### 10.10.2 Permission System

Plugins must declare permissions in their manifest:

| Permission | Description |
|---|---|
| `theme.read` | Read theme content |
| `theme.write` | Modify theme content |
| `scene.read` | Read scene graph |
| `scene.write` | Modify scene graph |
| `network` | Make network requests |
| `file.read` | Read files outside plugin directory |
| `file.write` | Write files outside plugin directory |
| `user.data` | Access user profile data |
| `marketplace.read` | Read marketplace data |
| `marketplace.write` | Publish to marketplace |
| `render.override` | Override rendering behavior |
| `devtools` | Access DevTools APIs |

---

## 11. Event System

### 11.1 Module Overview

The Event System is a publish-subscribe event bus that provides observability across all SDK modules. Every meaningful state change produces an event that consumers can subscribe to.

**Relationship to Animation Triggers:** The SDK events use `dot.case` naming (`theme.loaded`, `render.started`) and represent SDK lifecycle observability. The Architecture and Specification define `onXxx` animation triggers (`onLoad`, `onTap`, `onAppear`, `onStateEnter`) which are theme-level declarative triggers evaluated by the `AnimationController` at render time. These are complementary domains: SDK events enable runtime instrumentation; theme triggers enable declarative animation authoring.

```
eventsApi = engine.events(handle)
```

### 11.2 Event Catalog

#### 11.2.1 Engine Events

| Event | Payload | Description |
|---|---|---|
| `engine.initialized` | `{ version, capabilities }` | SDK initialized |
| `engine.disposed` | `{ reason }` | SDK disposed |
| `engine.error` | `{ code, message, diagnostics }` | Unrecoverable error |
| `engine.configurationChanged` | `{ changes }` | Configuration updated |

#### 11.2.2 Theme Events

| Event | Payload | Description |
|---|---|---|
| `theme.loaded` | `{ themeId, name, specVersion }` | Theme loaded |
| `theme.saved` | `{ themeId, destination }` | Theme saved |
| `theme.deleted` | `{ themeId }` | Theme deleted |
| `theme.changed` | `{ themeId, changes }` | Theme modified |
| `theme.exported` | `{ themeId, format }` | Theme exported |
| `theme.imported` | `{ themeId, source }` | Theme imported |
| `theme.installed` | `{ packageId, version }` | Theme installed |
| `theme.uninstalled` | `{ packageId }` | Theme uninstalled |
| `theme.upgraded` | `{ themeId, from, to }` | Theme upgraded |
| `theme.migrated` | `{ themeId, fromVersion, toVersion }` | Theme migrated |
| `theme.validationCompleted` | `{ valid, errors, warnings }` | Validation finished |

#### 11.2.3 Scene Events

| Event | Payload | Description |
|---|---|---|
| `scene.created` | `{ sceneId }` | Scene created |
| `scene.changed` | `{ sceneId, changeType }` | Scene modified |
| `scene.layer.added` | `{ layerId, type, parentId }` | Layer added |
| `scene.layer.removed` | `{ layerId, parentId }` | Layer removed |
| `scene.layer.moved` | `{ layerId, from, to }` | Layer moved |
| `scene.layer.modified` | `{ layerId, properties }` | Layer properties changed |
| `scene.layer.selected` | `{ layerIds }` | Layer selected |
| `scene.layer.deselected` | `{ layerIds }` | Layer deselected |
| `scene.group.created` | `{ groupId, childIds }` | Group created |
| `scene.group.destroyed` | `{ groupId, childIds }` | Group destroyed |

#### 11.2.4 Render Events

| Event | Payload | Description |
|---|---|---|
| `render.started` | `{ sceneId, mode }` | Render started |
| `render.completed` | `{ frameCount, renderTime }` | Render completed |
| `render.failed` | `{ errorCode, message }` | Render failed |
| `render.frame` | `{ frameNumber, timestamp }` | Per-frame event |

#### 11.2.5 Animation Events

| Event | Payload | Description |
|---|---|---|
| `animation.started` | `{ animationId, layerId }` | Animation started |
| `animation.completed` | `{ animationId, layerId }` | Animation completed |
| `animation.paused` | `{ animationId, layerId }` | Animation paused |
| `animation.resumed` | `{ animationId, layerId }` | Animation resumed |
| `animation.looped` | `{ animationId, iteration }` | Animation loop iteration |

#### 11.2.6 Plugin Events

| Event | Payload | Description |
|---|---|---|
| `plugin.installed` | `{ pluginId, version }` | Plugin installed |
| `plugin.removed` | `{ pluginId }` | Plugin removed |
| `plugin.updated` | `{ pluginId, oldVersion, newVersion }` | Plugin updated |
| `plugin.activated` | `{ pluginId }` | Plugin activated |
| `plugin.deactivated` | `{ pluginId }` | Plugin deactivated |
| `plugin.error` | `{ pluginId, code, message }` | Plugin error |

#### 11.2.7 Marketplace Events

| Event | Payload | Description |
|---|---|---|
| `marketplace.downloadStarted` | `{ packageId, size }` | Download started |
| `marketplace.downloadProgress` | `{ packageId, progress }` | Download progress |
| `marketplace.downloadCompleted` | `{ packageId }` | Download completed |
| `marketplace.downloadFailed` | `{ packageId, error }` | Download failed |
| `marketplace.purchaseCompleted` | `{ packageId, transactionId }` | Purchase completed |
| `marketplace.purchaseRestored` | `{ packageIds }` | Purchases restored |

### 11.3 Dispatch

```
eventsApi.dispatch(eventName, payload) → Result<void, EventError>
```

**Description:** Dispatches an event to all subscribed handlers.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `eventName` | string | **yes** | Fully qualified event name |
| `payload` | object | **yes** | Event payload |

### 11.4 Subscription

```
eventsApi.subscribe(eventName, handler, options) → Result<SubscriptionHandle, EventError>
```

**Description:** Subscribes to an event.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `eventName` | string | **yes** | — | Event name or pattern |
| `handler` | function | **yes** | — | Event handler function |
| `options.priority` | integer | no | `0` | Handler priority |
| `options.once` | boolean | no | `false` | Auto-unsubscribe after first invocation |

**Event name patterns:**

| Pattern | Matches |
|---|---|
| `theme.loaded` | Exact event name |
| `theme.*` | All theme events |
| `*.loaded` | All loaded events across categories |
| `**` | All events |

```
eventsApi.unsubscribe(subscriptionHandle) → Result<void, EventError>
```

**Description:** Removes a subscription.

### 11.5 Priority

Handler execution order is determined by priority:

```
Higher priority handlers execute first.
Same priority = FIFO order (subscription order).
```

| Priority Range | Intended Use |
|---|---|
| `1000` and above | System handlers (engine internals) |
| `500`–`999` | Plugin handlers |
| `100`–`499` | Application handlers |
| `0`–`99` | User handlers |

### 11.6 Cancellation

Handlers can cancel event propagation:

```
handler(event) → EventResult

EventResult:
  "continue"   → Allow propagation to next handler
  "stop"       → Stop propagation immediately
  "modify"     → Modify payload and continue
```

### 11.7 Propagation

Event propagation follows these rules:

1. Events propagate in priority order (highest first).
2. Any handler can stop propagation by returning `"stop"`.
3. Handlers with the same priority execute in subscription order.
4. If a handler throws, the error is caught and logged.
5. Remaining handlers still execute after a handler error.

---

## 12. Validation API

### 12.1 Module Overview

The Validation API provides comprehensive validation of themes, scenes, variables, assets, and components. It produces structured reports with error codes, severity levels, and auto-fix suggestions.

```
validateApi = engine.validator(handle)
```

### 12.2 Validate Theme

```
validateApi.theme(themeHandle, options) → Result<ValidationReport, ValidationError>
```

**Description:** Validates a complete theme document.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to validate |
| `options.mode` | enum | no | `"default"` | `"default"`, `"strict"`, `"permissive"` |
| `options.categories` | string[] | no | all | Validation categories to check |
| `options.autoFix` | boolean | no | `false` | Auto-fix fixable issues |

### 12.3 Validate Scene

```
validateApi.scene(sceneHandle, options) → Result<ValidationReport, ValidationError>
```

**Description:** Validates a scene graph.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `sceneHandle` | SceneHandle | **yes** | — | Scene to validate |
| `options.checkConstraints` | boolean | no | `true` | Validate constraint resolution |
| `options.checkReferences` | boolean | no | `true` | Validate reference integrity |
| `options.checkZOrder` | boolean | no | `true` | Validate z-index ordering |

### 12.4 Validate Variables

```
validateApi.variables(themeHandle) → Result<ValidationReport, ValidationError>
```

**Description:** Validates all variable definitions and references.

**Checks performed:**
- Variable definition syntax
- Reference integrity (all `$var.` targets exist)
- Cyclic variable references
- Type consistency across overrides
- Unused variable detection

### 12.5 Validate Assets

```
validateApi.assets(themeHandle, options) → Result<ValidationReport, ValidationError>
```

**Description:** Validates asset references and availability.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to validate |
| `options.checkRemote` | boolean | no | `false` | Check remote asset availability |
| `options.checkSize` | boolean | no | `true` | Check asset size limits |

### 12.6 Validate Components

```
validateApi.components(themeHandle) → Result<ValidationReport, ValidationError>
```

**Description:** Validates all component definitions and instances.

**Checks performed:**
- Component definition completeness
- Slot type matching
- Circular component references
- Component instance slot satisfaction
- Recursive nesting depth limits

### 12.7 Auto Fix

```
validateApi.autoFix(themeHandle, issues) → Result<FixReport, ValidationError>
```

**Description:** Applies auto-fix strategies to correctable issues.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Theme to fix |
| `issues` | ValidationIssue[] | **yes** | Issues to fix (from validation report) |

**Fixable issues:**

| Issue | Auto-Fix Strategy |
|---|---|
| Missing optional field | Insert schema default |
| Missing layer ID | Generate UUID |
| Under-constrained (single dim) | Infer from parent bounds |
| Non-monotonic gradient stops | Sort stops ascending |
| Deprecated field | Replace with new path |
| Duplicate IDs | Append UUID suffix to duplicates |

### 12.8 Warnings

Warnings are non-blocking issues that the theme can render despite:

```
validateApi.suppressWarning(themeHandle, warningCode) → Result<void, ValidationError>
```

**Description:** Suppresses a specific warning for a theme.

```
validateApi.getSuppressedWarnings(themeHandle) → Result<string[], ValidationError>
```

**Description:** Returns all suppressed warning codes for a theme.

### 12.9 Errors

Errors are blocking issues that prevent theme rendering:

| Error Code | Description | Recovery |
|---|---|---|
| `REQUIRED_FIELD_MISSING` | Required field is absent | Add the missing field |
| `TYPE_MISMATCH` | Field has wrong type | Correct the field type |
| `INVALID_ENUM` | Value not in allowed set | Use a valid enum value |
| `DUPLICATE_ID` | Duplicate identifier | Rename one occurrence |
| `BROKEN_REFERENCE` | Reference to undefined object | Create the target or fix reference |
| `UNDER_CONSTRAINED` | Insufficient constraints | Add missing constraints |
| `NEGATIVE_DIMENSION` | Computed dimension is negative | Adjust constraints |
| `INVALID_COLOR` | Color string is malformed | Use valid color format |
| `INVALID_GRADIENT` | Gradient has fewer than 2 stops | Add color stops |
| `CIRCULAR_ANCHOR` | Circular anchor dependency | Break the cycle |
| `ANIMATION_NOT_FOUND` | Trigger references undefined animation | Define the animation |
| `COMPONENT_NOT_FOUND` | Component ID not found | Define component or fix reference |

### 12.10 Migration

```
validateApi.checkMigration(themeHandle) → Result<MigrationCheck, ValidationError>
```

**Description:** Checks whether the theme can be migrated to a newer spec version.

```
validateApi.dryRunMigration(themeHandle, targetVersion) → Result<DryRunReport, ValidationError>
```

**Description:** Simulates migration to identify potential issues without applying changes.

### 12.11 Schema Validation

```
validateApi.schema(themeHandle, schemaSource) → Result<ValidationReport, ValidationError>
```

**Description:** Validates the theme against a specific JSON Schema.

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | Theme to validate |
| `schemaSource` | SchemaSource | **yes** | Schema definition |
| `schemaSource.type` | enum | **yes** | `"spec"`, `"custom"`, `"url"` |
| `schemaSource.data` | string | depends | Schema JSON string or URL |

---

## 13. Marketplace API

### 13.1 Module Overview

The Marketplace API provides integration with the Taply Theme Marketplace — searching, browsing, installing, purchasing, and managing theme packages.

```
marketplaceApi = engine.marketplace(handle)
```

### 13.2 Install Theme

```
marketplaceApi.install(packageId, options) → Result<ThemeHandle, MarketplaceError>
```

**Description:** Downloads and installs a theme from the marketplace.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `packageId` | string | **yes** | — | Marketplace package ID |
| `options.version` | string | no | latest | Specific version to install |
| `options.progressCallback` | function | no | — | Download progress callback |

### 13.3 Remove Theme

```
marketplaceApi.remove(packageId) → Result<void, MarketplaceError>
```

**Description:** Removes an installed marketplace theme.

### 13.4 Update Theme

```
marketplaceApi.update(packageId) → Result<ThemeHandle, MarketplaceError>
```

**Description:** Updates a marketplace theme to the latest version.

### 13.5 Search Theme

```
marketplaceApi.search(query, options) → Result<SearchResults, MarketplaceError>
```

**Description:** Searches the marketplace for themes.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `query` | string | **yes** | — | Search query |
| `options.categories` | string[] | no | `[]` | Filter by category |
| `options.tags` | string[] | no | `[]` | Filter by tags |
| `options.sortBy` | enum | no | `"popular"` | `"popular"`, `"newest"`, `"rating"`, `"name"` |
| `options.page` | integer | no | `1` | Page number |
| `options.pageSize` | integer | no | `20` | Results per page |

### 13.6 Rate Theme

```
marketplaceApi.rate(packageId, rating, review) → Result<void, MarketplaceError>
```

**Parameters:**

| Parameter | Type | Required | Description |
|---|---|---|---|
| `packageId` | string | **yes** | Package to rate |
| `rating` | integer | **yes** | Rating 1–5 |
| `review` | string | no | Text review |

### 13.7 Download Theme

```
marketplaceApi.download(packageId, options) → Result<BinaryData, MarketplaceError>
```

**Description:** Downloads a theme package without installing it.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `packageId` | string | **yes** | — | Package to download |
| `options.version` | string | no | latest | Specific version |
| `options.verifySignature` | boolean | no | `true` | Verify package signature |

### 13.8 Upload Theme

```
marketplaceApi.upload(themeHandle, options) → Result<PackageInfo, MarketplaceError>
```

**Description:** Uploads a theme to the marketplace (requires publisher permissions).

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to publish |
| `options.pricing` | PricingModel | **yes** | — | Pricing configuration |
| `options.preview.image` | BinaryData | **yes** | — | Preview image |
| `options.preview.screenshots` | BinaryData[] | no | `[]` | Screenshots |
| `options.metadata` | PackageMetadata | **yes** | — | Marketplace metadata |

### 13.9 Verify Signature

```
marketplaceApi.verifySignature(packageId, signature, publicKey) → Result<boolean, MarketplaceError>
```

**Description:** Verifies a theme package's digital signature.

### 13.10 Purchase Theme

```
marketplaceApi.purchase(packageId) → Result<PurchaseReceipt, MarketplaceError>
```

**Description:** Purchases a paid theme.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `transactionId` | string | Purchase transaction ID |
| `receipt` | string | Purchase receipt data |
| `licenseKey` | string | License key for offline activation |

### 13.11 Restore Purchases

```
marketplaceApi.restorePurchases() → Result<Purchase[], MarketplaceError>
```

**Description:** Restores all previously purchased themes.

---

## 14. DevTools API

### 14.1 Module Overview

The DevTools API provides introspection, debugging, profiling, and inspection capabilities for theme development. It is designed for use by the Theme Studio, CLI tooling, and developer-facing UIs.

```
devtoolsApi = engine.devtools(handle)
```

### 14.2 Scene Inspector

```
devtoolsApi.inspectScene(sceneHandle) → Result<SceneTree, DevToolsError>
```

**Description:** Returns the full scene graph as an inspectable tree structure.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `root` | TreeNode | Root node |
| `layerCount` | integer | Total layer count |
| `groupCount` | integer | Total group count |
| `depth` | integer | Maximum nesting depth |

**TreeNode:**

| Property | Type | Description |
|---|---|---|
| `id` | string | Layer ID |
| `type` | string | Layer type |
| `name` | string | Layer name |
| `visible` | boolean | Visibility status |
| `locked` | boolean | Lock status |
| `zIndex` | integer | Z-index |
| `bounds` | Rect | Computed bounds |
| `children` | TreeNode[] | Child nodes |
| `properties` | object | Current property values |

### 14.3 Layer Inspector

```
devtoolsApi.inspectLayer(sceneHandle, layerId) → Result<LayerInspection, DevToolsError>
```

**Description:** Returns detailed information about a specific layer.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `id` | string | Layer ID |
| `type` | string | Layer type |
| `definition` | object | Raw layer definition |
| `resolvedConstraints` | Rect | Resolved bounds |
| `computedStyle` | object | Resolved style properties |
| `appliedEffects` | EffectInfo[] | Active effects |
| `activeAnimations` | AnimationInfo[] | Currently running animations |
| `activeState` | string | Currently active state |
| `variableReferences` | string[] | Variable references used |
| `fieldBinding` | string | Bound field (if widget) |
| `memoryEstimate` | integer | Estimated memory usage in bytes |

### 14.4 Widget Inspector

```
devtoolsApi.inspectWidget(sceneHandle, layerId) → Result<WidgetInspection, DevToolsError>
```

**Description:** Returns widget-specific inspection data for widget layers.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `widgetType` | string | Widget type |
| `resolvedText` | string | Resolved text content (if text-based) |
| `textStyle` | object | Resolved typography |
| `imageSource` | string | Image source URL/path (if image-based) |
| `interactive` | boolean | Whether widget supports interaction |
| `accessibilityLabel` | string | Accessibility label |

### 14.5 Variable Viewer

```
devtoolsApi.getVariableState(themeHandle) → Result<VariableState, DevToolsError>
```

**Description:** Returns the complete variable resolution state.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `variables` | VariableEntry[] | All variables with resolved values |
| `unresolved` | string[] | References that failed to resolve |
| `overrides` | OverrideEntry[] | Active overrides by scope |
| `inheritanceChains` | ChainEntry[] | Inheritance chain for each variable |

### 14.6 FPS Monitor

```
devtoolsApi.enableFpsMonitor(options) → Result<FpsHandle, DevToolsError>
```

**Description:** Starts collecting frame rate metrics.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `options.sampleSize` | integer | no | `60` | Number of frames to sample |
| `options.reportInterval` | integer | no | `1000` | Report interval in ms |

```
devtoolsApi.getFpsReport(fpsHandle) → Result<FpsReport, DevToolsError>
```

**Returns:**

| Property | Type | Description |
|---|---|---|
| `currentFps` | number | Current frames per second |
| `averageFps` | number | Average FPS over sample window |
| `minFps` | number | Minimum FPS observed |
| `maxFps` | number | Maximum FPS observed |
| `frameTimes` | integer[] | Individual frame render times in ms |
| `droppedFrames` | integer | Number of dropped frames |

### 14.7 Memory Monitor

```
devtoolsApi.enableMemoryMonitor(options) → Result<MemoryHandle, DevToolsError>
```

**Description:** Starts collecting memory usage metrics.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `currentUsage` | integer | Current memory in bytes |
| `peakUsage` | integer | Peak memory in bytes |
| `cacheSize` | integer | Cache memory in bytes |
| `assetCount` | integer | Number of loaded assets |
| `allocationBreakdown` | AllocationEntry[] | Memory by category |

### 14.8 Performance Timeline

```
devtoolsApi.startTimeline(options) → Result<TimelineHandle, DevToolsError>
```

**Description:** Starts recording a performance timeline.

```
devtoolsApi.stopTimeline(timelineHandle) → Result<TimelineReport, DevToolsError>
```

**Description:** Stops recording and returns the timeline.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `duration` | integer | Total recording duration in ms |
| `events` | TimelineEvent[] | Ordered timeline events |
| `totalRenderTime` | integer | Cumulative render time |
| `totalParseTime` | integer | Cumulative parse/validate time |
| `totalAssetLoadTime` | integer | Cumulative asset loading time |

### 14.9 Render Statistics

```
devtoolsApi.getRenderStatistics(sceneHandle) → Result<RenderStatistics, DevToolsError>
```

**Returns:**

| Property | Type | Description |
|---|---|---|
| `layerCount` | integer | Number of rendered layers |
| `saveLayerCount` | integer | Number of active saveLayer operations |
| `cacheHitRate` | number | Bitmap cache hit rate (0–1) |
| `paintTime` | integer | Time spent painting in ms |
| `compositingTime` | integer | Time spent compositing in ms |
| `shaderCompilationCount` | integer | Number of shader compilations |

### 14.10 JSON Viewer

```
devtoolsApi.getThemeJson(themeHandle, options) → Result<string, DevToolsError>
```

**Description:** Returns the raw theme JSON for inspection.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to inspect |
| `options.prettyPrint` | boolean | no | `true` | Pretty-print JSON |
| `options.resolved` | boolean | no | `false` | Show resolved values |

### 14.11 Theme Diff

```
devtoolsApi.diffThemes(themeHandleA, themeHandleB) → Result<ThemeDiff, DevToolsError>
```

**Description:** Returns a visual diff between two themes (same as `themeApi.compare` but with DevTools-specific formatting).

### 14.12 Theme Validator

```
devtoolsApi.openValidator(themeHandle) → Result<ValidatorSession, DevToolsError>
```

**Description:** Opens an interactive validation session for live validation during editing.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `sessionId` | string | Session identifier |
| `live` | boolean | Whether live validation is active |
| `report` | ValidationReport | Initial validation report |

---

## 15. AI API

### 15.1 Module Overview

The AI API provides programmatic access to Taply's AI-powered theme generation, optimization, and assistance capabilities. All AI operations are asynchronous and support progress reporting.

```
aiApi = engine.ai(handle)
```

### 15.2 Generate Theme

```
aiApi.generateTheme(prompt, options) → Result<ThemeHandle, AiError>
```

**Description:** Generates a complete theme from a natural language prompt.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `prompt` | string | **yes** | — | Natural language description |
| `options.style` | string | no | `"modern"` | Design style preference |
| `options.colorScheme` | string | no | auto | Color scheme preference |
| `options.variants` | integer | no | `1` | Number of variants to generate |
| `options.progressCallback` | function | no | — | Generation progress callback |

**Generation pipeline:**

```
prompt
  → analyze prompt (extract intent, style, colors, layout)
  → generate color palette
  → generate typography scheme
  → generate layout structure
  → generate layer definitions
  → validate output
  → create theme
  → return theme handle
```

### 15.3 Generate Palette

```
aiApi.generatePalette(baseColor, options) → Result<ColorPalette, AiError>
```

**Description:** Generates a complete color palette from a base color.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `baseColor` | color | **yes** | — | Base/primary color |
| `options.paletteSize` | integer | no | `5` | Number of colors |
| `options.harmonyRule` | enum | no | `"complementary"` | `"complementary"`, `"analogous"`, `"triadic"`, `"monochromatic"`, `"splitComplementary"` |
| `options.includeDarkMode` | boolean | no | `true` | Generate dark mode variant |

**Returns:**

| Property | Type | Description |
|---|---|---|
| `primary` | color | Primary color |
| `secondary` | color | Secondary color |
| `accent` | color | Accent color |
| `background` | color | Background color |
| `surface` | color | Surface color |
| `text` | color | Text color |
| `textSecondary` | color | Secondary text color |
| `darkMode` | ColorPalette | Dark mode variant (if requested) |

### 15.4 Generate Layout

```
aiApi.generateLayout(themeHandle, options) → Result<LayoutProposal[], AiError>
```

**Description:** Generates layout proposals for an existing theme.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Existing theme context |
| `options.constraint` | string | no | — | Layout constraint description |
| `options.proposals` | integer | no | `3` | Number of proposals |

### 15.5 Generate Typography

```
aiApi.generateTypography(themeHandle, options) → Result<TypographyScheme, AiError>
```

**Description:** Generates a typography scheme for a theme.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme context |
| `options.vibe` | enum | no | `"professional"` | `"professional"`, `"playful"`, `"elegant"`, `"minimal"`, `"bold"` |
| `options.includeGoogleFonts` | boolean | no | `true` | Include Google Font recommendations |

### 15.6 Optimize Theme

```
aiApi.optimize(themeHandle, options) → Result<ThemeHandle, AiError>
```

**Description:** Optimizes an existing theme for performance, accessibility, or visual harmony.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to optimize |
| `options.target` | enum | no | `"visual"` | `"visual"`, `"performance"`, `"accessibility"`, `"all"` |
| `options.constraints` | string[] | no | `[]` | Design constraints to preserve |

### 15.7 Validate Theme

```
aiApi.smartValidate(themeHandle, options) → Result<AiValidationReport, AiError>
```

**Description:** AI-powered validation that goes beyond schema checking — identifies visual issues, design inconsistencies, and usability problems.

**Returns:**

| Property | Type | Description |
|---|---|---|
| `schemaIssues` | ValidationIssue[] | Standard schema issues |
| `designIssues` | DesignIssue[] | AI-detected design problems |
| `suggestions` | Suggestion[] | Improvement suggestions |
| `confidenceScore` | number | AI confidence (0–1) |

### 15.8 Create Preview

```
aiApi.generatePreview(themeHandle, options) → Result<BinaryData, AiError>
```

**Description:** Generates a photorealistic preview of the theme rendered in a mock device frame.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `themeHandle` | ThemeHandle | **yes** | — | Theme to preview |
| `options.device` | enum | no | `"phone"` | `"phone"`, `"tablet"`, `"watch"` |
| `options.environment` | enum | no | `"studio"` | Background environment style |

### 15.9 Repair Theme

```
aiApi.repair(themeHandle) → Result<ThemeHandle, AiError>
```

**Description:** Attempts to intelligently repair a broken or invalid theme.

**Behavior:**
- Detects broken references and attempts to infer correct targets.
- Fills in missing required fields with AI-generated defaults.
- Resolves conflicting constraints by adjusting values.
- Generates missing assets (e.g., placeholder images).
- Returns a new theme handle for the repaired theme.

### 15.10 Convert Image To Theme

```
aiApi.imageToTheme(imageData, options) → Result<ThemeHandle, AiError>
```

**Description:** Analyzes an image and creates a theme that reproduces its visual style.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `imageData` | BinaryData | **yes** | — | Source image |
| `options.extractColors` | boolean | no | `true` | Extract color palette |
| `options.extractTypography` | boolean | no | `true` | Detect font styles |
| `options.extractLayout` | boolean | no | `false` | Detect layout structure |

### 15.11 Convert Prompt To Theme

```
aiApi.promptToTheme(prompt, referenceData, options) → Result<ThemeHandle, AiError>
```

**Description:** Generates a theme from a text prompt, optionally guided by reference data.

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `prompt` | string | **yes** | — | Theme description |
| `referenceData` | ReferenceData | no | — | Brand guidelines, colors, logos |
| `options.strictness` | number | no | `0.5` | How strictly to follow reference (0–1) |

---

## 16. CLI Specification

### 16.1 Overview

The Taply CLI provides command-line access to all major SDK capabilities. The CLI is designed for automation, CI/CD pipelines, batch operations, and developer tooling.

### 16.2 Command Structure

```
taply <command> [subcommand] [options] [arguments]
```

### 16.3 taply init

```
taply init [project-name] [options]
```

**Description:** Initializes a new Taply theme project.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--template` | string | `"blank"` | Starting template |
| `--name` | string | project name | Theme display name |
| `--author` | string | current user | Author name |
| `--output` | string | `"./"` | Output directory |
| `--force` | flag | false | Overwrite existing directory |

### 16.4 taply validate

```
taply validate [path] [options]
```

**Description:** Validates a theme file or package.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--mode` | string | `"default"` | `"default"`, `"strict"`, `"permissive"` |
| `--auto-fix` | flag | false | Auto-fix fixable issues |
| `--output` | string | `"text"` | `"text"`, `"json"`, `"html"` |
| `--report-file` | string | — | Write report to file |

**Exit codes:**

| Code | Meaning |
|---|---|
| `0` | Valid (no errors) |
| `1` | Warnings found |
| `2` | Errors found |
| `3` | Validation failed to run |

### 16.5 taply preview

```
taply preview [path] [options]
```

**Description:** Generates a preview image of a theme.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--width` | integer | `400` | Preview width |
| `--height` | integer | `240` | Preview height |
| `--format` | string | `"png"` | `"png"`, `"jpeg"`, `"webp"` |
| `--output` | string | `"preview.png"` | Output file path |
| `--theme-mode` | string | `"light"` | `"light"`, `"dark"`, `"both"` |

### 16.6 taply export

```
taply export [path] [format] [options]
```

**Description:** Exports a theme to the specified format.

**Formats:** `taply`, `json`, `png`, `jpeg`, `pdf`, `svg`, `zip`

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--output` | string | — | Output file path |
| `--scale` | number | `1.0` | Export scale factor |
| `--quality` | integer | `90` | Output quality (images) |
| `--include-assets` | flag | true | Bundle assets |
| `--pretty-print` | flag | true | Pretty-print JSON |

### 16.7 taply import

```
taply import [source] [options]
```

**Description:** Imports a theme from various source formats.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--format` | string | auto | Source format |
| `--output` | string | `"./"` | Output directory |
| `--auto-migrate` | flag | true | Auto-migrate legacy formats |
| `--name` | string | — | Override theme name |

### 16.8 taply package

```
taply package [path] [options]
```

**Description:** Packages a theme into a `.taply` distribution package.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--output` | string | — | Output .taply file path |
| `--sign` | flag | false | Sign package with key |
| `--key` | string | — | Signing key path |
| `--include-assets` | flag | true | Bundle assets |
| `--compress` | flag | true | Compress package |

### 16.9 taply install

```
taply install [source] [options]
```

**Description:** Installs a theme from a package, marketplace, or remote URL.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--source` | string | — | `"file"`, `"marketplace"`, `"remote"` |
| `--version` | string | latest | Version to install |
| `--marketplace-key` | string | — | Marketplace API key |

### 16.10 taply uninstall

```
taply uninstall [theme-id] [options]
```

**Description:** Uninstalls a theme.

### 16.11 taply doctor

```
taply doctor [options]
```

**Description:** Checks the system for Taply SDK requirements.

**Checks performed:**
- SDK version and integrity
- Platform compatibility
- Available disk space
- Network connectivity
- Plugin compatibility
- Cache health

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--fix` | flag | false | Attempt auto-fix for detected issues |
| `--verbose` | flag | false | Detailed diagnostic output |

### 16.12 taply upgrade

```
taply upgrade [target-version] [options]
```

**Description:** Upgrades a theme to the specified specification version.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--path` | string | `"."` | Theme path |
| `--dry-run` | flag | false | Show changes without applying |
| `--backup` | flag | true | Create backup before upgrade |

### 16.13 taply benchmark

```
taply benchmark [path] [options]
```

**Description:** Runs performance benchmarks on a theme.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--iterations` | integer | `100` | Number of benchmark iterations |
| `--output` | string | — | Benchmark report output path |
| `--metrics` | string[] | all | Metrics to collect |

### 16.14 taply generate

```
taply generate [prompt] [options]
```

**Description:** Generates a theme from a text prompt using AI.

**Options:**

| Option | Type | Default | Description |
|---|---|---|---|
| `--output` | string | `"./"` | Output directory |
| `--style` | string | `"modern"` | Design style |
| `--variants` | integer | `1` | Number of variants |
| `--preview` | flag | true | Generate preview images |

---

## 17. Error System

### 17.1 Overview

The Taply SDK uses a unified error model. Every operation returns a `Result<T, E>` type where `E` is a typed error. Errors are structured, hierarchical, and diagnostic-rich.

**Relationship to Theme Validation Codes:** The SDK error codes use module-prefixed `SCREAMING_SNAKE_CASE` (`ENGINE_*`, `THEME_*`, `VALIDATE_*`) for API-level errors. The Specification (§16.6) defines bare validation codes (`REQUIRED_FIELD_MISSING`, `TYPE_MISMATCH`) for theme-level data validation. SDK validation wrappers (e.g., `TaplyValidator`) can surface Theme Spec validation codes inside SDK `VALIDATE_SCHEMA_ERROR` payloads, bridging the two systems.

### 17.2 Error Model

Every error has the following structure:

```
TaplyError {
  code: string           // Machine-readable error code
  message: string        // Human-readable description
  details: string        // Detailed explanation
  recovery: string       // Recovery suggestion
  module: string         // Originating module
  severity: Severity     // Error severity level
  timestamp: integer     // Unix timestamp
  stackTrace: string     // SDK-side stack trace
  cause: TaplyError|null // Root cause (if chained)
}
```

### 17.3 Error Codes

#### 17.3.1 Engine Errors (`ENGINE_*`)

| Code | Severity | Description |
|---|---|---|
| `ENGINE_ALREADY_INITIALIZED` | error | SDK already initialized |
| `ENGINE_NOT_INITIALIZED` | error | SDK not yet initialized |
| `ENGINE_INIT_FAILED` | fatal | Initialization failed |
| `ENGINE_PERMISSION_DENIED` | error | Permission not granted |
| `ENGINE_INVALID_CONFIG` | error | Configuration invalid |
| `ENGINE_DISPOSED` | error | Operation on disposed engine |
| `ENGINE_TIMEOUT` | error | Operation timed out |
| `ENGINE_OUT_OF_MEMORY` | fatal | Memory limit exceeded |
| `ENGINE_UNSUPPORTED_PLATFORM` | error | Platform not supported |

#### 17.3.2 Theme Errors (`THEME_*`)

| Code | Severity | Description |
|---|---|---|
| `THEME_NOT_FOUND` | error | Theme file or package not found |
| `THEME_LOAD_FAILED` | error | Theme could not be loaded |
| `THEME_SAVE_FAILED` | error | Theme could not be saved |
| `THEME_PARSE_FAILED` | error | JSON parse failure |
| `THEME_INVALID_VERSION` | warning | Unsupported spec version |
| `THEME_CORRUPTED` | fatal | Theme data is corrupted |
| `THEME_ENCRYPTION_FAILED` | error | Encryption/decryption failed |
| `THEME_ALREADY_EXISTS` | error | Theme ID already in store |
| `THEME_MIGRATION_FAILED` | error | Migration could not complete |

#### 17.3.3 Render Errors (`RENDER_*`)

| Code | Severity | Description |
|---|---|---|
| `RENDER_FAILED` | error | Render operation failed |
| `RENDER_INVALID_SCENE` | error | Scene is invalid for rendering |
| `RENDER_OUTPUT_FAILED` | error | Output target could not be written |
| `RENDER_TIMEOUT` | error | Render exceeded time limit |
| `RENDER_UNSUPPORTED_FORMAT` | error | Export format not supported |

#### 17.3.4 Scene Errors (`SCENE_*`)

| Code | Severity | Description |
|---|---|---|
| `SCENE_INVALID_LAYER_ID` | error | Layer ID not found |
| `SCENE_INVALID_GROUP_ID` | error | Group ID not found |
| `SCENE_INVALID_PARENT` | error | Invalid parent group |
| `SCENE_CYCLIC_DEPENDENCY` | fatal | Circular group nesting |
| `SCENE_LAYER_LIMIT_EXCEEDED` | error | Layer limit (500) exceeded |

#### 17.3.5 Variable Errors (`VARIABLE_*`)

| Code | Severity | Description |
|---|---|---|
| `VARIABLE_NOT_FOUND` | warning | Variable reference not resolvable |
| `VARIABLE_CYCLIC_REFERENCE` | error | Circular variable dependency |
| `VARIABLE_TYPE_MISMATCH` | warning | Variable value type mismatch |
| `VARIABLE_SCOPE_CONFLICT` | warning | Variable scope conflict |
| `VARIABLE_ALREADY_EXISTS` | error | Variable already defined |

#### 17.3.6 Validation Errors (`VALIDATE_*`)

| Code | Severity | Description |
|---|---|---|
| `VALIDATE_SCHEMA_ERROR` | error | Schema validation failed |
| `VALIDATE_SEMANTIC_ERROR` | error | Semantic validation failed |
| `VALIDATE_CIRCULAR_REFERENCE` | error | Circular reference detected |
| `VALIDATE_DUPLICATE_ID` | error | Duplicate identifier found |

#### 17.3.7 Registry Errors (`REGISTRY_*`)

| Code | Severity | Description |
|---|---|---|
| `REGISTRY_NOT_FOUND` | error | Type not registered |
| `REGISTRY_ALREADY_EXISTS` | warning | Type already registered |
| `REGISTRY_DEPENDENCY_MISSING` | error | Required dependency not found |
| `REGISTRY_CYCLIC_DEPENDENCY` | error | Circular dependency in registry |

#### 17.3.8 Plugin Errors (`PLUGIN_*`)

| Code | Severity | Description |
|---|---|---|
| `PLUGIN_INSTALL_FAILED` | error | Plugin installation failed |
| `PLUGIN_INCOMPATIBLE_VERSION` | error | Plugin version incompatible |
| `PLUGIN_MISSING_DEPENDENCY` | error | Plugin dependency not met |
| `PLUGIN_PERMISSION_DENIED` | error | Plugin permission not granted |
| `PLUGIN_CRASHED` | fatal | Plugin encountered fatal error |
| `PLUGIN_SANDBOX_VIOLATION` | fatal | Plugin violated sandbox rules |

#### 17.3.9 Marketplace Errors (`MARKETPLACE_*`)

| Code | Severity | Description |
|---|---|---|
| `MARKETPLACE_NOT_FOUND` | error | Package not found |
| `MARKETPLACE_DOWNLOAD_FAILED` | error | Download failed |
| `MARKETPLACE_PURCHASE_FAILED` | error | Purchase failed |
| `MARKETPLACE_SIGNATURE_INVALID` | error | Package signature invalid |
| `MARKETPLACE_NETWORK_ERROR` | error | Network connectivity issue |

#### 17.3.10 AI Errors (`AI_*`)

| Code | Severity | Description |
|---|---|---|
| `AI_GENERATION_FAILED` | error | AI generation failed |
| `AI_INVALID_PROMPT` | error | Prompt could not be processed |
| `AI_QUOTA_EXCEEDED` | error | AI request quota exceeded |
| `AI_CONTENT_FILTERED` | warning | Generated content blocked by filter |

### 17.4 Severity Levels

| Level | Behavior | Example |
|---|---|---|
| `fatal` | Operation stops. SDK may need re-initialization. | Engine OOM |
| `error` | Operation fails. SDK continues. | Theme load fails |
| `warning` | Operation succeeds with degraded behavior. | Variable not found |
| `info` | No behavioral impact. | Deprecation notice |

### 17.5 Recoverable vs Fatal

**Recoverable errors** return a result that the caller can handle:

```
result = themeApi.load(source)
match result:
  Success(handle) → continue
  Error(THEME_NOT_FOUND) → show file picker
  Error(THEME_PARSE_FAILED) → show parse error with line number
```

**Fatal errors** throw or return a result that requires re-initialization:

```
result = engine.initialize(config)
match result:
  Error(ENGINE_INIT_FAILED) → cannot proceed, must fix config
  Error(ENGINE_OUT_OF_MEMORY) → must free resources
```

### 17.6 Diagnostics

```
error.getDiagnostics() → Diagnostics
```

**Returns:**

| Property | Type | Description |
|---|---|---|
| `code` | string | Error code |
| `message` | string | Human-readable message |
| `details` | string | Technical details |
| `recovery` | string | Suggested recovery |
| `module` | string | Originating module |
| `severity` | string | Severity level |
| `timestamp` | integer | Error timestamp |
| `path` | string | JSON path (if applicable) |
| `line` | integer | Line number (if applicable) |
| `cause` | TaplyError | Chained cause (if any) |
| `stackTrace` | string | SDK call stack |
| `suggestions` | string[] | Recovery suggestions |

### 17.7 Logging

```
engine.setLogLevel(level)
```

**Log levels:** `"debug"`, `"info"`, `"warning"`, `"error"`, `"none"`

```
engine.getLogs(filter) → Result<LogEntry[], EngineError>
```

**Parameters:**

| Parameter | Type | Required | Default | Description |
|---|---|---|---|---|
| `filter.level` | enum | no | all | Minimum log level |
| `filter.module` | string | no | all | Module filter |
| `filter.since` | integer | no | — | Unix timestamp start |
| `filter.until` | integer | no | — | Unix timestamp end |
| `filter.limit` | integer | no | `100` | Maximum entries |

### 17.8 Tracing

```
engine.startTrace(options) → Result<TraceHandle, EngineError>
```

**Description:** Starts a performance trace for debugging.

```
engine.stopTrace(traceHandle) → Result<TraceReport, EngineError>
```

**Returns:**

| Property | Type | Description |
|---|---|---|
| `operations` | TraceEntry[] | Ordered operation trace |
| `totalDuration` | integer | Total trace duration in ms |
| `slowestOperation` | string | Slowest operation name |
| `operationCount` | integer | Total operations traced |

### 17.9 Debug Information

```
engine.getDebugInfo() → Result<DebugInfo, EngineError>
```

**Returns:**

| Property | Type | Description |
|---|---|---|
| `sdkVersion` | string | SDK version |
| `engineVersion` | string | Engine implementation version |
| `platform` | string | Runtime platform |
| `uptime` | integer | SDK uptime in seconds |
| `memoryUsage` | integer | Current memory usage |
| `cacheStats` | CacheStats | Cache hit/miss statistics |
| `activeThemeCount` | integer | Themes currently loaded |
| `activePluginCount` | integer | Plugins currently active |
| `registeredTypes` | RegistrySummary | Types registered by category |

---

## 18. Security

### 18.1 Overview

The Taply SDK is designed with a defense-in-depth security model. All external inputs — themes, plugins, assets, marketplace packages — are treated as untrusted until verified.

### 18.2 SDK Permissions

The SDK operates on a capability-based permission model. Consumers request permissions during initialization:

```
engine.initialize(config: {
  permissions: ["theme.read", "theme.write", "marketplace.download"]
})
```

#### 18.2.1 Permission Categories

| Category | Permissions | Description |
|---|---|---|
| Theme | `theme.read`, `theme.write` | Read and modify theme documents |
| Scene | `scene.read`, `scene.write` | Read and modify scene graphs |
| Network | `network` | Make network requests |
| File | `file.read`, `file.write` | Access file system outside managed directories |
| User | `user.data` | Access user profile and data fields |
| Marketplace | `marketplace.read`, `marketplace.write` | Access marketplace APIs |
| Render | `render.override` | Override rendering behavior |
| System | `devtools` | Access development tooling APIs |

#### 18.2.2 Permission Verification

```
engine.verifyPermission(permission) → Result<boolean, EngineError>
```

**Description:** Checks whether a specific permission is granted.

### 18.3 Sandbox

#### 18.3.1 Theme Sandbox

Themes operate in a read-only sandbox:

| Capability | Allowed |
|---|---|
| Read field data | ✅ Yes (via field bindings) |
| Write field data | ❌ No |
| Read file system | ❌ No (only package assets) |
| Write file system | ❌ No |
| Network access | ❌ No (only configured asset origins) |
| Execute code | ❌ No (declarative only) |
| Access other themes | ❌ No |
| Access SDK internals | ❌ No |

#### 18.3.2 Plugin Sandbox

Plugins operate in a restricted sandbox:

| Capability | Default | With Permission |
|---|---|---|
| Read theme data | ✅ Yes | ✅ Yes |
| Write theme data | ❌ No | ✅ Yes (with `theme.write`) |
| Read scene graph | ✅ Yes | ✅ Yes |
| Modify scene graph | ❌ No | ✅ Yes (with `scene.write`) |
| Network access | ❌ No | ✅ Yes (with `network`) |
| File system (own directory) | ✅ Yes | ✅ Yes |
| File system (other) | ❌ No | ✅ Yes (with `file.read`/`file.write`) |
| User data access | ❌ No | ✅ Yes (with `user.data`) |
| Render override | ❌ No | ✅ Yes (with `render.override`) |
| Access other plugins | ❌ No | ❌ No |
| Access SDK internals | ❌ No | ❌ No |

### 18.4 Plugin Isolation

Each plugin runs in an isolated context:

1. **Process/Isolate isolation** — Plugins run in a separate isolate or process.
2. **Memory isolation** — No shared memory between plugins or between plugin and core.
3. **Message passing** — Communication only through the Event Bus and Registry.
4. **Resource quotas** — CPU, memory, and network quotas per plugin.
5. **Crash isolation** — A plugin crash does not affect the SDK or other plugins.

### 18.5 Remote Asset Restrictions

```
┌──────────────────────────────────────────────────┐
│               ASSET URL VALIDATION                │
├──────────────────────────────────────────────────┤
│                                                   │
│  ALLOWED SCHEMES:                                 │
│    https:// ✓                                     │
│                                                   │
│  BLOCKED SCHEMES:                                 │
│    http://  ✗  (no plain HTTP)                    │
│    file://  ✗  (no local file access)             │
│    data:    ✗  (no data URIs)                     │
│    ftp://   ✗  (no FTP)                           │
│                                                   │
│  BLOCKED PATTERNS:                                │
│    IP-based hosts  ✗  (no 192.168.x.x, etc.)      │
│    Localhost       ✗  (no 127.0.0.1, localhost)   │
│    Internal TLDs   ✗  (no .local, .internal)       │
│    Query params    ✗  (no tracking parameters)     │
│    Fragments       ✗  (no # fragments)            │
│                                                   │
│  REDIRECT POLICY:                                 │
│    Same origin     ✅                              │
│    Cross-origin    ❌                              │
│    Max redirects   2                               │
│                                                   │
└──────────────────────────────────────────────────┘
```

### 18.6 Marketplace Signature Verification

All marketplace packages are digitally signed:

| Property | Value |
|---|---|
| Algorithm | Ed25519 |
| Signature file | `signature.sig` within `.taply` package |
| Signed content | `theme.json` SHA-512 hash |
| Public key source | Marketplace author profile |
| Verification timing | On install and on load |

```
marketplaceApi.verifySignature(packageId, signature, publicKey) → boolean
```

### 18.7 License Verification

```
marketplaceApi.verifyLicense(themeHandle) → Result<LicenseStatus, MarketplaceError>
```

**Returns:**

| Status | Description |
|---|---|
| `"licensed"` | Theme is properly licensed |
| `"expired"` | License has expired |
| `"invalid"` | License is invalid or tampered |
| `"unlicensed"` | Theme is not licensed (free or trial) |

---

## 19. Versioning

### 19.1 Overview

The Taply SDK follows **Semantic Versioning 2.0.0**. This section defines the versioning strategy, deprecation policy, migration paths, and API stability levels.

### 19.2 SDK Version

| Component | Current |
|---|---|
| `sdkVersion` | `"2.0.0"` |
| `specVersion` | `"2.0.0"` |
| `engineVersion` | `"2.0.0"` |

### 19.3 Semantic Versioning

| Bump | Rule | Examples |
|---|---|---|
| **MAJOR** | Breaking API change | Removing a method, changing parameter types, changing return types |
| **MINOR** | Backward-compatible addition | New methods, new modules, new optional parameters |
| **PATCH** | Backward-compatible fix | Bug fixes, documentation clarifications, error message improvements |

### 19.4 Deprecation

```
@deprecated("Use renderApi.exportPng instead", since: "2.1.0", removal: "3.0.0")
```

**Deprecation policy:**

1. Deprecated APIs receive the `@deprecated` label with migration guidance.
2. Deprecated APIs remain functional for at least one major version.
3. Deprecated APIs produce a warning when called.
4. Removal only happens in a MAJOR release.

### 19.5 Migration

```
engine.migrateSdk(fromVersion, toVersion) → Result<void, EngineError>
```

**Description:** Migrates SDK-internal state and cached data between versions.

**Migration guarantees:**
- All themes created in version N can be loaded in version N+1 (minor/patch).
- Theme files are never modified during SDK upgrade.
- Plugin compatibility is checked on SDK version change.

### 19.6 Compatibility Matrix

| SDK Version | Spec 2.0.x | Spec 2.1.x | Spec 3.0.x |
|---|---|---|---|
| SDK 2.0.x | ✅ Full | ⚠️ Degraded | ❌ |
| SDK 2.1.x | ✅ Full | ✅ Full | ⚠️ Migration |
| SDK 3.0.x | ⚠️ Migration | ⚠️ Migration | ✅ Full |

### 19.7 API Stability Levels

| Level | Label | Description | Breaking Changes |
|---|---|---|---|
| **Stable** | `@stable` | Fully supported public API | Only in major versions |
| **Beta** | `@beta` | Feature-complete, may adjust | Before next stable |
| **Experimental** | `@experimental` | Under development | Any time |
| **Internal** | `@internal` | Not for public use | Any time |
| **Deprecated** | `@deprecated` | Scheduled for removal | Next major version |

### 19.8 Experimental APIs

Experimental APIs are marked with `@experimental` and:

1. May change or be removed without notice.
2. Require explicit opt-in: `engine.enableExperimental("featureName")`.
3. Produce a warning on each use.
4. Are excluded from backward compatibility guarantees.

```
engine.enableExperimental("aiApi") → Result<void, EngineError>
```

---

## 20. Appendices

### 20.1 Appendix A: Naming Conventions

#### 20.1.1 API Naming Rules

| Element | Convention | Example |
|---|---|---|
| Module | `PascalCase` | `TaplyRenderer` |
| Method | `camelCase` | `loadTheme()` |
| Parameter | `camelCase` | `themeHandle` |
| Enum | `PascalCase` | `RenderMode` |
| Enum value | `snake_case` | `"high_quality"` |
| Error code | `SCREAMING_SNAKE_CASE` | `THEME_NOT_FOUND` |
| Event name | `dot.case` | `theme.loaded` |
| Variable path | `dot.case` | `colors.accent` |

#### 20.1.2 Reserved Keywords

The following identifiers are reserved and cannot be used as variable names, component IDs, or layer IDs:

```
theme, engine, sdk, api, render, scene, layer, component,
variable, asset, plugin, event, validate, registry, marketplace,
devtools, ai, config, options, handle, result, error, type,
id, name, version, metadata, properties, constraints, effects,
animations, states, slots, params, source, target, scope
```

### 20.2 Appendix B: Best Practices

#### 20.2.1 SDK Usage

1. **Initialize once** — Call `engine.initialize()` once at application startup.
2. **Reuse handles** — Cache and reuse `ThemeHandle` and `SceneHandle` objects.
3. **Dispose explicitly** — Call `engine.dispose()` when the SDK is no longer needed.
4. **Handle errors** — Always check `Result` types. Never ignore errors.
5. **Async operations** — Never block the main thread waiting for SDK operations.
6. **Resource limits** — Respect layer count and asset size limits.
7. **Validate early** — Validate themes before attempting to render them.

#### 20.2.2 Plugin Development

1. **Declare permissions** — Only request permissions your plugin actually needs.
2. **Version properly** — Use semantic versioning for plugins.
3. **Clean up** — Unregister all registrations when the plugin is unloaded.
4. **Sandbox compliance** — Never attempt to bypass the sandbox.
5. **Error handling** — Catch all errors; never crash the host.
6. **Async safety** — Use async operations for long-running tasks.

#### 20.2.3 Theme Development

1. **Use variables** — DRY themes with variables. Avoid hardcoded values.
2. **Validate before export** — Always validate themes before packaging.
3. **Optimize assets** — Use appropriate image formats and sizes.
4. **Test both modes** — Test themes in light and dark mode.
5. **Respect constraints** — Don't use fixed dimensions when relative would work.

### 20.3 Appendix C: SDK Guidelines

#### 20.3.1 Extension Guidelines

Extensions (registered types) must:

1. Have a unique identifier following `reverse-domain` notation: `com.example.myLayer`.
2. Declare their SDK version dependency.
3. Provide metadata: name, description, version, author.
4. Handle all error states gracefully.
5. Not block the main thread.
6. Clean up resources when unregistered.

#### 20.3.2 Plugin Guidelines

Plugins must:

1. Include a complete `plugin.json` manifest.
2. Declare all permissions they require.
3. Implement the `activate()` and `deactivate()` lifecycle methods.
4. Handle version compatibility checks.
5. Provide user-visible error messages.
6. Not modify core SDK behavior.

#### 20.3.3 Performance Guidelines

1. Avoid registering types that are never used.
2. Minimize effect complexity (prefer simple effects over composite ones).
3. Use `cacheHint: "static"` for layers that don't change.
4. Limit animation complexity to 20 concurrent animations.
5. Batch marketplace API calls when possible.

### 20.4 Appendix D: Migration Examples

#### 20.4.1 SDK 1.x to 2.x

| V1 API | V2 API | Notes |
|---|---|---|
| `engine.init(config)` | `engine.initialize(config)` | Method renamed |
| `theme.validate()` | `validateApi.theme(handle)` | Moved to Validator module |
| `scene.addLayer(def)` | `sceneApi.createLayer(handle, def)` | Scene methods moved to module |
| `engine.render()` | `renderApi.render(handle)` | Render methods moved to module |
| `events.on(name, cb)` | `eventsApi.subscribe(name, cb)` | Event methods moved to module |
| `Plugin.install(path)` | `pluginsApi.install(source)` | Unified install API |

#### 20.4.2 API Migration Patterns

```
// V1
engine.init({apiKey: "..."});
engine.loadTheme("path/to/theme.json");
engine.render();
engine.dispose();

// V2
handle = engine.initialize({apiKey: "..."});
themeHandle = engine.theme(handle).load({type: "file", path: "path/to/theme.json"});
sceneHandle = engine.scene(handle).create();
renderApi = engine.renderer(handle);
renderApi.render(sceneHandle);
engine.dispose(handle);
```

### 20.5 Appendix E: Glossary

| Term | Definition |
|---|---|
| **Asset** | A binary resource (image, font, SVG) referenced by a theme |
| **Component** | A reusable, parameterizable group of layers with defined slots |
| **Constraint** | A layout rule that determines a layer's position and size |
| **Effect** | A post-processing visual modification applied to a layer |
| **Event** | A notification dispatched through the Event Bus when state changes |
| **Handle** | An opaque reference to an SDK object (theme, scene, layer) |
| **Layer** | A single visual element in the scene graph |
| **Module** | A logical group of related API methods |
| **Package** | A distributable `.taply` archive containing a theme and its assets |
| **Permission** | A capability that must be granted before an API can be used |
| **Plugin** | A third-party extension that integrates with the SDK via the Plugin API |
| **Registry** | The central catalog of registered types (layers, effects, plugins) |
| **Result** | A container type that holds either a success value or an error |
| **Sandbox** | The security boundary that restricts what themes and plugins can do |
| **Scene** | The runtime layer tree, assembled from a theme, ready for rendering |
| **Scene Graph** | The ordered hierarchy of layers that forms the visual structure |
| **Scope** | The context within which a variable is defined and resolved |
| **Slot** | A configurable parameter in a component definition |
| **Theme** | A complete declarative JSON document describing a card's visual design |
| **Variable** | A named reusable value (color, number, typography) |

### 20.6 Appendix F: API Quick Reference

#### Core Initialization

```
handle = engine.initialize(config)
engine.dispose(handle)
engine.getDebugInfo()
```

#### Theme Operations

```
themeApi = engine.theme(handle)
themeApi.load(source)
themeApi.save(handle, dest)
themeApi.export(handle, format, options)
themeApi.import(source)
themeApi.duplicate(handle, metadata)
themeApi.delete(handle)
themeApi.compare(a, b)
themeApi.upgrade(handle, version)
```

#### Rendering

```
renderApi = engine.renderer(handle)
renderApi.render(scene, options)
renderApi.preview(scene, options)
renderApi.exportPng(scene, options)
renderApi.exportJpeg(scene, options)
renderApi.exportPdf(scene, options)
renderApi.exportSvg(scene, options)
renderApi.captureWidget(scene, layerId)
renderApi.renderInBackground(scene, options)
```

#### Scene Graph

```
sceneApi = engine.scene(handle)
sceneApi.create(options)
sceneApi.createLayer(scene, def)
sceneApi.createGroup(scene, options)
sceneApi.deleteLayer(scene, layerId)
sceneApi.moveLayer(scene, layerId, dest)
sceneApi.duplicateLayer(scene, layerId)
sceneApi.groupLayers(scene, layerIds)
sceneApi.ungroupLayers(scene, groupId)
sceneApi.toJson(scene)
sceneApi.fromJson(json)
```

#### Variables

```
variablesApi = engine.variables(handle)
variablesApi.get(theme, path)
variablesApi.set(theme, path, value)
variablesApi.resolve(theme, expression)
variablesApi.create(theme, path, value)
variablesApi.delete(theme, path)
```

#### Components

```
componentsApi = engine.components(handle)
componentsApi.create(theme, def)
componentsApi.instantiate(theme, componentId)
componentsApi.detach(theme, instanceId)
componentsApi.override(theme, instanceId, slotPath, value)
componentsApi.update(theme, componentId, def)
```

#### Registry

```
registryApi = engine.registry(handle)
registryApi.register(category, id, impl)
registryApi.unregister(handle)
registryApi.resolve(category, id, context)
registryApi.list(category)
```

#### Plugins

```
pluginsApi = engine.plugins(handle)
pluginsApi.install(source)
pluginsApi.remove(handle)
pluginsApi.load(handle)
pluginsApi.activate(handle)
pluginsApi.deactivate(handle)
pluginsApi.update(handle, source)
```

#### Events

```
eventsApi = engine.events(handle)
eventsApi.subscribe(name, handler)
eventsApi.unsubscribe(handle)
eventsApi.dispatch(name, payload)
```

#### Validation

```
validateApi = engine.validator(handle)
validateApi.theme(theme, options)
validateApi.scene(scene, options)
validateApi.variables(theme)
validateApi.assets(theme)
validateApi.components(theme)
validateApi.autoFix(theme, issues)
```

#### Marketplace

```
marketplaceApi = engine.marketplace(handle)
marketplaceApi.search(query)
marketplaceApi.install(packageId)
marketplaceApi.remove(packageId)
marketplaceApi.update(packageId)
marketplaceApi.purchase(packageId)
marketplaceApi.restorePurchases()
marketplaceApi.upload(theme, options)
```

#### AI

```
aiApi = engine.ai(handle)
aiApi.generateTheme(prompt)
aiApi.generatePalette(baseColor)
aiApi.optimize(theme)
aiApi.repair(theme)
aiApi.imageToTheme(imageData)
aiApi.promptToTheme(prompt, reference)
```

#### DevTools

```
devtoolsApi = engine.devtools(handle)
devtoolsApi.inspectScene(scene)
devtoolsApi.inspectLayer(scene, layerId)
devtoolsApi.getVariableState(theme)
devtoolsApi.enableFpsMonitor()
devtoolsApi.getRenderStatistics(scene)
devtoolsApi.startTimeline()
```

### 20.7 Appendix G: Change Log

| Version | Date | Author | Changes |
|---|---|---|---|
| 2.0.0-draft.1 | 2026-06-10 | Taply Engineering | Initial SDK specification draft |
| 2.0.0-draft.2 | TBD | TBD | TBD |

### 20.8 Appendix H: References

1. **Flutter SDK Documentation** — Reference for API documentation style and patterns.
2. **Figma Plugin API** — Reference for plugin architecture and sandboxing.
3. **VS Code Extension API** — Reference for extension lifecycle and contribution points.
4. **Semantic Versioning 2.0** — https://semver.org
5. **JSON Schema Draft 2020-12** — https://json-schema.org/specification
6. **Ed25519 Digital Signatures** — RFC 8032
7. **Capability-Based Security** — Reference for permission system design.


