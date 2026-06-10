/// Supported layout modes for a theme canvas.
enum LayoutMode {
  /// Content is fixed at the center of the canvas.
  centered,

  /// Content fills the entire canvas proportionally.
  fill,

  /// Content fills the canvas without preserving aspect ratio.
  stretch,

  /// Content fits within the canvas, maintaining aspect ratio.
  fit,

  /// Content fills all edges of the canvas.
  fillAllEdges,
}
