import 'dart:ui' show Rect;

class PaintMetrics {
  int paintedNodes;
  int skippedNodes;
  int failedNodes;
  Duration paintTime;
  int cacheHits;
  int cacheMisses;
  Rect? totalPaintBounds;

  PaintMetrics({
    this.paintedNodes = 0,
    this.skippedNodes = 0,
    this.failedNodes = 0,
    this.paintTime = Duration.zero,
    this.cacheHits = 0,
    this.cacheMisses = 0,
    this.totalPaintBounds,
  });

  void recordPaint(Duration elapsed) {
    paintedNodes++;
    paintTime += elapsed;
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
    );
  }

  @override
  String toString() =>
      'PaintMetrics(painted: $paintedNodes, skipped: $skippedNodes, '
      'failed: $failedNodes, time: ${paintTime.inMilliseconds}ms, '
      'cache: ${cacheHits}h/${cacheMisses}m)';
}
