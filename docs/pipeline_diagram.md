# Theme Engine V2 — Rendering Pipeline

```mermaid
flowchart LR
    A["Theme JSON\n(assets/themes/*.json)"] --> B["ThemeLoader\n(loadFromString/File)"]
    B --> C["ThemeParser\n(metadata, canvas, variables,\n assets, scene, components)"]
    C --> D["ThemeDocument\n(typed in-memory model)"]
    D --> E["RenderPipeline.prepare()"]
    
    subgraph E [RenderPipeline]
        direction TB
        E1["RenderTreeBuilder.build()\n(SceneNode → RenderNode tree)"]
        E2["PaintDispatcher.resolve()\n(assign IPainter per node)"]
        E3["WidgetDispatcher.resolve()\n(assign IWidgetBuilder per node)"]
        E1 --> E2 --> E3
    end
    
    E --> F["RenderTree\n(canvas + viewport + root group)"]
    F --> G["PaintEngine.render()"]
    
    subgraph G [PaintEngine]
        direction TB
        G1["Flatten tree\n(RenderGroup → RenderPaintNode list)"]
        G2["For each node:\n skip invisible → resolve painter →\n check cache → paint → record metrics"]
        G3["Return PaintMetrics\n(painted/failed nodes, timing, cache stats)"]
        G1 --> G2 --> G3
    end
    
    G --> H["ExportService\n(renderToPicture / renderToImage /\n renderToPngBytes / renderWithMetrics)"]
    H --> I1["ui.Picture"]
    H --> I2["ui.Image"]
    H --> I3["PNG bytes"]
    H --> I4["PaintMetrics"]
```

## Pipeline Stages

### 1. Load
- `ThemeLoader.loadFromFile()` / `loadFromString()` reads raw JSON

### 2. Parse
- `ThemeParser` runs a multi-stage pipeline:
  - `MetadataParser` → `ThemeMetadata`
  - `CanvasParser` → `ThemeCanvas`
  - `VariablesParser` → `ThemeVariables`
  - `AssetsParser` → `ThemeAssets`
  - `SceneParser` (via `SceneNodeConverter`) → `List<SceneNode>`
  - `ComponentParser`, `AnimationParser`, `StateParser`

### 3. Prepare
- `RenderTreeBuilder.build()` converts `SceneNode` tree → `RenderNode` tree
- `PaintDispatcher` assigns `IPainter` instances to each `RenderPaintNode`
- Output: `RenderTree` with canvas metadata + root `RenderGroup`

### 4. Paint
- `PaintEngine.render()` flattens tree, iterates nodes:
  - Skip invisible nodes
  - Resolve `BasePainter` via `PainterResolver`
  - Check `PaintCache` (hit → skip)
  - Call `painter.prepare()` + `painter.paint()`
  - Record timing, bounds, metrics

### 5. Export
- `ExportService` wraps the full pipeline:
  - `renderToPicture()` → `ui.Picture`
  - `renderToImage()` → `ui.Image`
  - `renderToPngBytes()` → `Uint8List`
  - `renderWithMetrics()` → `PaintMetrics`

## Key Components

| Component | File | Role |
|---|---|---|
| ThemeParser | `lib/theme_engine/parser/` | JSON → ThemeDocument |
| RenderPipeline | `lib/theme_engine/renderer/render_pipeline.dart` | ThemeDocument → RenderTree |
| PaintEngine | `lib/theme_engine/paint_engine/engine.dart` | RenderTree → painted output |
| ExportService | `lib/theme_engine/export/export_service.dart` | Render → image/file formats |
| RenderingService | `lib/theme_engine/services/rendering_service.dart` | Orchestrate full pipeline |
