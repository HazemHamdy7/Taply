import 'dart:ui' show Rect;

import 'paint_bounds.dart';

class PaintMetrics {
  int paintedNodes;
  int skippedNodes;
  int failedNodes;
  Duration paintTime;
  int cacheHits;
  int cacheMisses;
  Rect? totalPaintBounds;
  final Map<String, int> elementCounts;
  List<PaintBounds> elementBounds;

  PaintMetrics({
    this.paintedNodes = 0,
    this.skippedNodes = 0,
    this.failedNodes = 0,
    this.paintTime = Duration.zero,
    this.cacheHits = 0,
    this.cacheMisses = 0,
    this.totalPaintBounds,
    Map<String, int>? elementCounts,
    List<PaintBounds>? elementBounds,
  })  : elementCounts = elementCounts ?? {},
        elementBounds = elementBounds ?? [];

  void recordPaint(Duration elapsed, {String? elementType, Rect? bounds}) {
    paintedNodes++;
    paintTime += elapsed;
    if (elementType != null) {
      elementCounts[elementType] = (elementCounts[elementType] ?? 0) + 1;
    }
    if (bounds != null) {
      elementBounds.add(PaintBounds(rect: bounds, elementType: elementType ?? 'unknown'));
      extendBounds(bounds);
    }
  }

  void recordSkip() {
    skippedNodes++;
  }

  void recordFailure() {
    failedNodes++;
  }

  void recordCacheHit() {
    cacheHits++;
  }

  void recordCacheMiss() {
    cacheMisses++;
  }

  void extendBounds(Rect? bounds) {
    if (bounds == null) return;
    totalPaintBounds = totalPaintBounds == null
        ? bounds
        : totalPaintBounds!.expandToInclude(bounds);
  }

  int get totalProcessed => paintedNodes + skippedNodes + failedNodes;

  int elementCountFor(String type) => elementCounts[type] ?? 0;

  double get averagePaintTimeMs {
    if (paintedNodes == 0) return 0;
    return paintTime.inMicroseconds / paintedNodes / 1000.0;
  }

  void reset() {
    paintedNodes = 0;
    skippedNodes = 0;
    failedNodes = 0;
    paintTime = Duration.zero;
    cacheHits = 0;
    cacheMisses = 0;
    totalPaintBounds = null;
    elementCounts.clear();
    elementBounds.clear();
  }

  PaintMetrics copy() {
    return PaintMetrics(
      paintedNodes: paintedNodes,
      skippedNodes: skippedNodes,
      failedNodes: failedNodes,
      paintTime: paintTime,
      cacheHits: cacheHits,
      cacheMisses: cacheMisses,
      totalPaintBounds: totalPaintBounds,
      elementCounts: Map.from(elementCounts),
      elementBounds: List.from(elementBounds),
    );
  }

  @override
  String toString() =>
      'PaintMetrics(painted: $paintedNodes, skipped: $skippedNodes, '
      'failed: $failedNodes, time: ${paintTime.inMilliseconds}ms, '
      'cache: ${cacheHits}h/${cacheMisses}m, '
      'elements: $elementCounts)';
}
