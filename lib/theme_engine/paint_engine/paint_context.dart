import 'dart:ui' show Canvas;

import '../models/theme_document.dart';
import '../renderer/render_node.dart';
import '../renderer/render_tree.dart';

enum PaintThemeMode { light, dark, system }

class PaintContext {
  final Canvas? canvas;
  final ThemeDocument document;
  final RenderTree renderTree;
  final RenderPaintNode renderNode;
  final double viewportWidth;
  final double viewportHeight;
  final double scaleFactor;
  final Map<String, dynamic> variables;
  final Map<String, dynamic> assets;
  final bool isRtl;
  final PaintThemeMode themeMode;
  final double devicePixelRatio;

  const PaintContext({
    this.canvas,
    required this.document,
    required this.renderTree,
    required this.renderNode,
    required this.viewportWidth,
    required this.viewportHeight,
    required this.scaleFactor,
    this.variables = const {},
    this.assets = const {},
    this.isRtl = false,
    this.themeMode = PaintThemeMode.light,
    this.devicePixelRatio = 1.0,
  });

  double get designWidth => renderTree.canvasWidth;
  double get designHeight => renderTree.canvasHeight;

  PaintContext copyWith({
    Canvas? canvas,
    ThemeDocument? document,
    RenderTree? renderTree,
    RenderPaintNode? renderNode,
    double? viewportWidth,
    double? viewportHeight,
    double? scaleFactor,
    Map<String, dynamic>? variables,
    Map<String, dynamic>? assets,
    bool? isRtl,
    PaintThemeMode? themeMode,
    double? devicePixelRatio,
  }) {
    return PaintContext(
      canvas: canvas ?? this.canvas,
      document: document ?? this.document,
      renderTree: renderTree ?? this.renderTree,
      renderNode: renderNode ?? this.renderNode,
      viewportWidth: viewportWidth ?? this.viewportWidth,
      viewportHeight: viewportHeight ?? this.viewportHeight,
      scaleFactor: scaleFactor ?? this.scaleFactor,
      variables: variables ?? this.variables,
      assets: assets ?? this.assets,
      isRtl: isRtl ?? this.isRtl,
      themeMode: themeMode ?? this.themeMode,
      devicePixelRatio: devicePixelRatio ?? this.devicePixelRatio,
    );
  }

  PaintContext forNode(RenderPaintNode node) {
    return copyWith(renderNode: node);
  }
}
