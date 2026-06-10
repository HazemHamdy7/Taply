# Terminology Consistency Report

## Cross-Document Comparison: Architecture · Theme Spec · SDK Spec

---

## 1. Layout Modes

| Mode | Architecture (§8.2) | Theme Spec (§9.3) | SDK Spec |
|---|---|---|---|
| Absolute | ✅ `{left,top,width,height}` | ✅ 9.3.1 same | — |
| Relative (fill) | ✅ `{left,top,right,height}` — called **"Relative (fill)"** | ✅ 9.3.2 called **"Relative Layout (Fill)"** | — |
| Percentage | ✅ `{"10%",...}` | ✅ 9.3.3 same | — |
| Center | ✅ `{centerX,centerY,width,height}` | ✅ 9.3.4 same | — |
| Fill (All Edges) | ❌ Not listed as a separate mode | ✅ 9.3.5 `{left,top,right,bottom}` — called **"Fill Layout (All Edges)"** | — |
| Aspect Ratio | ✅ `{aspectRatio:1}` | ✅ 9.3.6 same | — |

**Issues:**
- Architecture has **5 modes**; Spec has **6 modes** (Spec adds "Fill Layout (All Edges)" as a distinct mode)
- Naming: Architecture uses "Relative (fill)", Spec uses "Relative Layout (Fill)" — minor inconsistency

---

## 2. Animation Types

| Type | Architecture (§11) | Theme Spec (§14.4) | SDK Spec (§2.2.8) |
|---|---|---|---|
| `tween` | ❌ Not mentioned | ✅ Listed | — |
| `loop` | ❌ Not mentioned | ✅ Listed | — |
| `spring` | ❌ Not mentioned | ✅ Listed | — |
| `keyframe` | ✅ Described as "declarative keyframe timeline" | ✅ Listed | — |
| `sequence` | ❌ Not mentioned | ✅ Listed | ✅ "animation sequences and parallel groups" |
| `parallel` | ❌ Not mentioned | ✅ Listed | ✅ "animation sequences and parallel groups" |
| Triggers (onLoad, onTap, etc.) | ✅ Has trigger system (§11.2) | ✅ Has triggers (onTap, onAppear, onStateEnter, onStateExit) (§14.9) | — |

**Issues:**
- Architecture §11 is titled "Animation System" but only describes triggers and animatable properties — **NO taxonomy of animation types** (tween, spring, keyframe, etc.)
- Architecture only describes a `type: "timeline"` structure in §4.8
- The rich animation type taxonomy (tween, loop, spring, keyframe, sequence, parallel) exists **only in the Theme Spec**
- **MAJOR GAP**: Architecture and Spec use different trigger vocabularies: Architecture has `onLoad`, `onHover`, `onScroll`, `always`; Spec has `onTap`, `onAppear`, `onStateEnter`, `onStateExit`. Only `onTap` overlaps.

---

## 3. Effects

| Effect | Architecture (§10.2) | Theme Spec (§11.3) |
|---|---|---|
| blur | ✅ | ✅ |
| backdrop_blur | ✅ | ❌ Not listed as effect in §11.3 (exists as paint layer type §7.5.22) |
| glass | ✅ | ✅ |
| glow | ✅ | ✅ |
| shadow | ✅ | ✅ |
| inner_shadow | ✅ | ✅ |
| gradient_stroke | ✅ "gradient_stroke" | ✅ "gradient_overlay" (different name!) |
| noise | ✅ | ✅ |
| opacity | ✅ | ✅ |
| blend_mode | ✅ | ✅ |
| mask | ❌ Not listed as effect | ✅ 11.3.5 |
| neumorphism | ❌ Not listed | ✅ 11.4 |
| glassmorphism | ❌ Not listed | ✅ 11.5 |

**Issues:**
- Architecture has `backdrop_blur` as a separate effect; Spec does NOT list `backdrop_blur` as an effect (it's a paint layer type instead)
- Architecture: `gradient_stroke` vs Spec: `gradient_overlay` — **different names for similar concept**
- Spec has `mask` as an effect; Architecture has mask only as a paint layer type (§5.15)
- Spec has composite effects `neumorphism` and `glassmorphism`; Architecture has no equivalent

---

## 4. Validation Error Codes

| Code Format | Architecture | Theme Spec (§16.6) | SDK Spec (§17.3) |
|---|---|---|---|
| Module prefix | ❌ Not present | ❌ Bare codes: `REQUIRED_FIELD_MISSING` | ✅ Module prefix: `ENGINE_*`, `THEME_*`, `RENDER_*`, `SCENE_*`, `VARIABLE_*`, `VALIDATE_*`, `REGISTRY_*`, `PLUGIN_*`, `MARKETPLACE_*`, `AI_*` |
| Case | — | `SCREAMING_SNAKE_CASE` | `SCREAMING_SNAKE_CASE` |

**Key differences:**
- Theme Spec §16.6 codes are bare: `REQUIRED_FIELD_MISSING`, `TYPE_MISMATCH`, `DUPLICATE_ID`, `BROKEN_REFERENCE`, `UNDER_CONSTRAINED`, `OVER_CONSTRAINED`, `ZERO_DIMENSION`, `NEGATIVE_DIMENSION`, `INVALID_COLOR`, `INVALID_GRADIENT`, `CIRCULAR_ANCHOR`, `MISSING_ASSET`, `OVERSIZED_ASSET`, `UNUSED_VARIABLE`, `UNREACHABLE_LAYER`, `MISSING_STATE_TARGET`, `ANIMATION_NOT_FOUND`, `SCHEMA_DEPRECATED`
- SDK §17.3 codes use module prefixes: `ENGINE_ALREADY_INITIALIZED`, `THEME_NOT_FOUND`, `SCENE_INVALID_LAYER_ID`, `VARIABLE_NOT_FOUND`, `VALIDATE_SCHEMA_ERROR`, `REGISTRY_NOT_FOUND`, `PLUGIN_INSTALL_FAILED`, `MARKETPLACE_DOWNLOAD_FAILED`, `AI_GENERATION_FAILED`
- Architecture has **no error code system** — produces `ParseError` objects instead
- SDK §1.6.3 explicitly states: "Error codes use `SCREAMING_SNAKE_CASE` with a module prefix" — Spec §16.6 codes violate this convention

---

## 5. Event Names

| Domain | Architecture | Theme Spec | SDK Spec (§11.2) |
|---|---|---|---|
| Animation triggers | `onLoad`, `onTap`, `onHover`, `onScroll`, `always` | `onTap`, `onAppear`, `onStateEnter`, `onStateExit` | — |
| Engine events | — | — | `engine.initialized`, `engine.disposed`, `engine.error`, `engine.configurationChanged` |
| Theme events | — | — | `theme.loaded`, `theme.saved`, `theme.deleted`, `theme.changed`, `theme.exported`, `theme.imported`, `theme.installed`, `theme.uninstalled`, `theme.upgraded`, `theme.migrated` |
| Scene events | — | — | `scene.created`, `scene.changed`, `scene.layer.added`, `scene.layer.removed`, `scene.layer.moved`, `scene.layer.modified`, `scene.layer.selected`, `scene.layer.deselected` |
| Render events | — | — | `render.started`, `render.completed`, `render.failed`, `render.frame` |
| Animation events | — | — | `animation.started`, `animation.completed`, `animation.paused`, `animation.resumed`, `animation.looped` |
| Plugin events | — | — | `plugin.installed`, `plugin.removed`, `plugin.updated`, `plugin.activated`, `plugin.deactivated`, `plugin.error` |
| Marketplace events | — | — | `marketplace.downloadStarted`, `marketplace.downloadProgress`, `marketplace.downloadCompleted`, `marketplace.downloadFailed`, `marketplace.purchaseCompleted`, `marketplace.purchaseRestored` |

**Issues:**
- Three completely different naming conventions:
  - Architecture: `onXxx` (camelCase with "on" prefix)
  - Spec triggers: `onXxx` (same pattern — but different names than Architecture)
  - SDK events: `module.name` (dot-case with module prefix)
- Architecture's trigger `onLoad` and `always` do NOT appear in the Spec
- Spec's trigger `onAppear` does not appear in Architecture
- SDK event `theme.loaded`, `render.started`, etc. have NO equivalent in Architecture or Spec

---

## 6. Theme States

| Aspect | Architecture | Theme Spec (§13) | SDK Spec |
|---|---|---|---|
| State system | ❌ **Not mentioned anywhere** | ✅ Full section — §13 Theme States | ✅ References `states` in LayerDefinition (§6.4) and duplication (§4.6) |
| State types | — | `themeMode`, `interaction`, `field`, `platform`, `orientation`, `dimension`, `custom` | — |
| Layer state bindings | — | ✅ §13.5 | — |
| State groups | — | ✅ §13.6 | — |
| State triggers | — | ✅ §13.7 | — |

**Issues:**
- **MAJOR GAP**: Architecture has NO concept of "theme states" at all — no section, no discussion
- SDK references `states` in `LayerDefinition` and duplication but never defines what states are or how they work
- The complete state system exists exclusively in the Theme Spec — no cross-document alignment

---

## 7. Paint Layer Type Names

| Category | Architecture (§5.2) | Theme Spec (§7.5) | Match? |
|---|---|---|---|
| **Primitive** | rectangle, circle, oval, rounded_rectangle, polygon, triangle, hexagon, diamond | rectangle, rounded_rectangle, circle, oval, polygon, triangle, diamond, hexagon | ✅ Same set |
| **Path** | bezier_path, arc | bezier_path, arc | ✅ Same |
| **Line** | ❌ Not listed | line (§7.5.11) | ❌ Missing from Architecture |
| **SVG** | svg | ❌ Not a paint layer type | ❌ Architecture has it as paint layer; Spec handles via assets |
| **Image** | image | ❌ Not a paint layer type | ❌ Architecture has it as paint layer; Spec handles via assets |
| **Gradients** | mesh_gradient only | linear_gradient, radial_gradient, sweep_gradient, mesh_gradient (§7.5.12–15) | ❌ Architecture only has mesh_gradient |
| **Textures** | noise_texture, carbon_texture | noise (§7.5.16), paper_texture (§7.5.17), fabric_texture (§7.5.18), carbon_fiber (§7.5.19) | ❌ Noise/carbon renamed; Architecture missing paper/fabric |
| **Glass/Blur** | glass_layer, blur_layer | glass (§7.5.20), glass_panel (§7.5.21), backdrop_blur (§7.5.22), blur (§7.5.23) | ❌ Different names; Spec has glass_panel |
| **Shadow** | shadow, inner_shadow, outer_shadow | shadow (§7.5.24), inner_shadow (§7.5.25) | ❌ Architecture has outer_shadow; Spec doesn't (uses glow instead) |
| **Glow** | glow | glow (§7.5.26), outer_glow (§7.5.27) | ❌ Spec separates glow and outer_glow |
| **Decorative** | premium_borders, decorative_shapes, qr_frame, avatar_border, logo | premium_border (§7.5.36), decorative_shapes (§7.5.37) | ❌ `premium_borders` (plural) vs `premium_border` (singular); qr_frame/avatar_border/logo absent from Spec paint layers |
| **Particles** | particles, sparkles | particles (§7.5.29), sparkles (§7.5.28) | ✅ Same |
| **Patterns** | circuit_pattern, grid, floating_dots | circuit_pattern (§7.5.31), grid (§7.5.32), floating_dots (§7.5.30) | ✅ Same |
| **Organic** | wave, blob | wave (§7.5.33), blob (§7.5.34), organic_shapes (§7.5.35) | ❌ Spec has additional `organic_shapes` |
| **Mask/Clip** | mask, clip_path | mask (§7.5.38), clip_path (§7.5.39) | ✅ Same |
| **Composite** | opacity, blend_modes | opacity (§7.5.40), blend_mode (§7.5.42) | ❌ `blend_modes` (plural) vs `blend_mode` (singular) |
| **Transform** | ❌ Not listed | transform (§7.5.41), rotation (§7.5.43), scale (§7.5.44) | ❌ Missing from Architecture |
| **Repeat/Tile** | ❌ Not listed | repeat (§7.5.45), tile (§7.5.46) | ❌ Missing from Architecture |

**Key name mismatches:**
- `noise_texture` (Arch) → `noise` (Spec)
- `carbon_texture` (Arch) → `carbon_fiber` (Spec)
- `glass_layer` (Arch) → `glass` (Spec)
- `blur_layer` (Arch) → `blur` (Spec)
- `premium_borders` (Arch, plural) → `premium_border` (Spec, singular)
- `blend_modes` (Arch, plural) → `blend_mode` (Spec, singular)
- `svg` (Arch paint layer) → handled via assets in Spec
- `image` (Arch paint layer) → handled via assets in Spec

---

## 8. Widget Layer Type Names

| Widget | Architecture (§6.2) | Theme Spec (§8.4) | Match? |
|---|---|---|---|
| avatar | ✅ | ✅ | ✅ |
| companyLogo | ✅ | logo | ❌ Different name |
| qrCode | ✅ | qr | ❌ Different name |
| name | ✅ | ✅ | ✅ |
| jobTitle | ✅ | ✅ | ✅ |
| company | ✅ | ✅ | ✅ |
| tagline | ✅ | ✅ | ✅ |
| phone | ✅ | ✅ | ✅ |
| email | ✅ | ✅ | ✅ |
| website | ✅ | ✅ | ✅ |
| address | ✅ | ✅ | ✅ |
| socialIcons | ✅ | ✅ | ✅ |
| nfcBadge | ✅ | badges | ❌ Different name; Spec generalizes to "badges" |
| statistics | ✅ | ✅ | ✅ |
| buttons | ✅ | ✅ | ✅ |
| divider | ✅ | ✅ | ✅ |
| glassCard | ✅ | ✅ | ✅ |
| contactBlock | ✅ | ✅ | ✅ |
| footer | ✅ | ✅ | ✅ |
| biography | ❌ Not listed | ✅ §8.4.8 | ❌ Missing from Architecture |
| header | ❌ Not listed | ✅ §8.4.17 | ❌ Missing from Architecture |
| custom | ❌ Not listed | ✅ §8.4.22 | ❌ Missing from Architecture |

**Key mismatches:**
- `companyLogo` (Arch) → `logo` (Spec)
- `qrCode` (Arch) → `qr` (Spec)
- `nfcBadge` (Arch) → `badges` (Spec — a general container for multiple badge types)

---

## 9. Component Naming

| Aspect | Architecture (§9) | Theme Spec (§10) | SDK Spec (§8) |
|---|---|---|---|
| Invocation field | `"component": "profile_header"` (§9.2) | `"componentId": "profile_header"` (§10.5) | `componentId` (§8.3) |
| Slot system | ✅ Example uses `slots` object | ✅ Example uses `slots` object | ✅ SlotMap in ComponentDefinition |
| Built-in components | ✅ Listed in §9.3 | ✅ Listed in §10.8 | — |

**Issues:**
- **DIFFERENT FIELD NAME**: Architecture uses `"component"` while Spec and SDK use `"componentId"` for component invocation
- This is a **breaking inconsistency** — JSON payloads would fail depending on which document the parser follows

---

## 10. Variable Terminology

| Aspect | Architecture (§7) | Theme Spec (§4) | SDK Spec (§7) |
|---|---|---|---|
| Reference syntax | `$var.colors.primary` | `$var.colors.primary` | `$var:colors.primary` (colon instead of dot, §7.4) |
| Resolution chain | Layer → Component → Theme → Base Theme | Local → Component → Theme → Base Engine Defaults | Layer override → Component override → Component default → Theme default |
| Categories | colors, spacing, radius, typography, shadows, durations, opacity | colors, typography, radius, spacing, elevation, opacity, shadows, icons, animation, gradients, sizes, numbers, strings | (Uses variable paths like `colors.primary`) |
| Fallback syntax | — | `||` operator: `"$var.colors.customAccent\|\|#D4AF37"` | ✅ Fallback support mentioned |
| Scope types | — | Global, Theme, Component, Local, Instance | Layer override, Component override, Component default, Theme default |

**Issues:**
- **SDK uses DIFFERENT syntax**: `$var:colors.primary` (with colon) vs Architecture/Spec `$var.colors.primary` (with dot) — §7.4 of SDK
- Resolution chains across all three documents use slightly different wording for the same concept:
  - Architecture: "Layer → Component → Theme → Base Theme"
  - Spec: "Local (layer scope) → Component → Theme → Base Engine Defaults"
  - SDK: "Layer override → Component override → Component default → Theme default"
- Spec has variable categories not in Architecture: elevation, icons, animation, gradients, sizes, numbers, strings

---

## Summary of Critical Inconsistencies

### Breaking (would cause runtime failures if implemented as-is):
1. **Component invocation field**: Architecture uses `"component"`, Spec/SDK use `"componentId"`
2. **Variable reference syntax**: Architecture/Spec use `$var.colors.primary` (dot), SDK uses `$var:colors.primary` (colon)
3. **Widget type names**: `companyLogo` (Arch) vs `logo` (Spec); `qrCode` (Arch) vs `qr` (Spec)

### Major Conceptual Gaps:
1. **Theme States**: Entirely absent from Architecture, referenced but undefined in SDK, fully defined in Spec
2. **Animation type taxonomy**: Architecture lacks tween/spring/sequence/parallel — only Spec defines these
3. **Error code system**: Architecture has none; Spec uses bare codes; SDK uses module-prefixed codes — inconsistent
4. **Event naming**: Three completely different conventions (Arch: `onXxx`, Spec triggers, SDK: `dot.case`)

### Naming Inconsistencies:
1. **Paint types**: `noise_texture→noise`, `carbon_texture→carbon_fiber`, `glass_layer→glass`, `blur_layer→blur`, `premium_borders→premium_border`, `blend_modes→blend_mode`
2. **Effect names**: `gradient_stroke` (Arch) vs `gradient_overlay` (Spec)
3. **Layout mode names**: "Relative (fill)" (Arch) vs "Relative Layout (Fill)" (Spec)
4. **Paint layer scope**: Architecture has `svg`, `image`, `mask`, `clip_path`, `qr_frame`, `avatar_border`, `logo` as paint layers; Spec handles many of these differently or not at all as paint layers
