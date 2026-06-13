class PathPaintMetrics {
  int pathsPainted = 0;
  int filledPaths = 0;
  int strokedPaths = 0;
  int segmentsDrawn = 0;
  int shadowCount = 0;
  int cacheHits = 0;
  int cacheMisses = 0;
  Duration paintDuration = Duration.zero;

  void recordPath() { pathsPainted++; }
  void recordFill() { filledPaths++; }
  void recordStroke() { strokedPaths++; }
  void recordSegment() { segmentsDrawn++; }
  void recordShadow() { shadowCount++; }
  void recordCacheHit() { cacheHits++; }
  void recordCacheMiss() { cacheMisses++; }
  void recordDuration(Duration d) { paintDuration += d; }

  void reset() {
    pathsPainted = 0; filledPaths = 0; strokedPaths = 0;
    segmentsDrawn = 0; shadowCount = 0;
    cacheHits = 0; cacheMisses = 0;
    paintDuration = Duration.zero;
  }

  PathPaintMetrics copy() {
    final m = PathPaintMetrics();
    m.pathsPainted = pathsPainted; m.filledPaths = filledPaths;
    m.strokedPaths = strokedPaths; m.segmentsDrawn = segmentsDrawn;
    m.shadowCount = shadowCount; m.cacheHits = cacheHits;
    m.cacheMisses = cacheMisses; m.paintDuration = paintDuration;
    return m;
  }

  PathPaintMetrics operator +(PathPaintMetrics other) {
    final m = copy();
    m.pathsPainted += other.pathsPainted;
    m.filledPaths += other.filledPaths;
    m.strokedPaths += other.strokedPaths;
    m.segmentsDrawn += other.segmentsDrawn;
    m.shadowCount += other.shadowCount;
    m.cacheHits += other.cacheHits;
    m.cacheMisses += other.cacheMisses;
    m.paintDuration += other.paintDuration;
    return m;
  }

  double get averagePaintTimeMs {
    if (pathsPainted == 0) return 0;
    return paintDuration.inMicroseconds / pathsPainted / 1000.0;
  }

  @override
  String toString() =>
      'PathPaintMetrics(paths: $pathsPainted, '
      'fills: $filledPaths, strokes: $strokedPaths, '
      'segs: $segmentsDrawn, shadows: $shadowCount, '
      'cache: ${cacheHits}h/${cacheMisses}m, '
      'time: ${paintDuration.inMilliseconds}ms)';
}
