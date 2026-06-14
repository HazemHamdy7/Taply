import 'dart:ui' show Rect;

/// Accumulated metrics from a rendering pass.
class PaintMetrics {
  int paintedNodes;
  int skippedNodes;
  int failedNodes;
  int recoveredNodes;
  Duration paintTime;
  int cacheHits;
  int cacheMisses;
  Rect? totalPaintBounds;
  final Map<String, int> elementCounts;
  final List<String> warnings;

  PaintMetrics({
    this.paintedNodes = 0,
    this.skippedNodes = 0,
    this.failedNodes = 0,
    this.recoveredNodes = 0,
    this.paintTime = Duration.zero,
    this.cacheHits = 0,
    this.cacheMisses = 0,
    this.totalPaintBounds,
    Map<String, int>? elementCounts,
    List<String>? warnings,
  })  : elementCounts = elementCounts ?? {},
        warnings = warnings ?? [];

  void recordPaint(Duration elapsed, {String? elementType, Rect? bounds}) {
    paintedNodes++;
    paintTime += elapsed;
    if (elementType != null) {
      elementCounts[elementType] = (elementCounts[elementType] ?? 0) + 1;
    }
    if (bounds != null) {
      extendBounds(bounds);
    }
  }

  void recordSkip() {
    skippedNodes++;
  }

  void recordFailure() {
    failedNodes++;
  }

  void recordRecovery() {
    recoveredNodes++;
  }

  void addWarning(String warning) {
    warnings.add(warning);
  }

  void extendBounds(Rect? bounds) {
    if (bounds == null) return;
    totalPaintBounds = totalPaintBounds == null
        ? bounds
        : totalPaintBounds!.expandToInclude(bounds);
  }

  int get totalProcessed =>
      paintedNodes + skippedNodes + failedNodes + recoveredNodes;

  int elementCountFor(String type) => elementCounts[type] ?? 0;

  double get averagePaintTimeMs {
    if (paintedNodes == 0) return 0;
    return paintTime.inMicroseconds / paintedNodes / 1000.0;
  }

  void reset() {
    paintedNodes = 0;
    skippedNodes = 0;
    failedNodes = 0;
    recoveredNodes = 0;
    paintTime = Duration.zero;
    cacheHits = 0;
    cacheMisses = 0;
    totalPaintBounds = null;
    elementCounts.clear();
    warnings.clear();
  }

  PaintMetrics copy() {
    return PaintMetrics(
      paintedNodes: paintedNodes,
      skippedNodes: skippedNodes,
      failedNodes: failedNodes,
      recoveredNodes: recoveredNodes,
      paintTime: paintTime,
      cacheHits: cacheHits,
      cacheMisses: cacheMisses,
      totalPaintBounds: totalPaintBounds,
      elementCounts: Map.from(elementCounts),
      warnings: List.from(warnings),
    );
  }

  @override
  String toString() =>
      'PaintMetrics(painted: $paintedNodes, skipped: $skippedNodes, '
      'failed: $failedNodes, recovered: $recoveredNodes, '
      'time: ${paintTime.inMilliseconds}ms, '
      'cache: ${cacheHits}h/${cacheMisses}m, '
      'elements: $elementCounts, warnings: ${warnings.length})';
}
