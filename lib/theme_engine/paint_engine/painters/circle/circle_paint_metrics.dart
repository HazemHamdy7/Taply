class CirclePaintMetrics {
  int circlesPainted = 0;
  int strokedCircles = 0;
  int shadowCount = 0;
  int cacheHits = 0;
  int cacheMisses = 0;
  Duration paintDuration = Duration.zero;
  double totalArea = 0.0;

  void recordCircle(double area) { circlesPainted++; totalArea += area; }
  void recordStroke() { strokedCircles++; }
  void recordShadow() { shadowCount++; }
  void recordCacheHit() { cacheHits++; }
  void recordCacheMiss() { cacheMisses++; }
  void recordDuration(Duration d) { paintDuration += d; }

  void reset() {
    circlesPainted = 0; strokedCircles = 0; shadowCount = 0;
    cacheHits = 0; cacheMisses = 0;
    paintDuration = Duration.zero; totalArea = 0.0;
  }

  CirclePaintMetrics copy() {
    final m = CirclePaintMetrics();
    m.circlesPainted = circlesPainted; m.strokedCircles = strokedCircles;
    m.shadowCount = shadowCount; m.cacheHits = cacheHits;
    m.cacheMisses = cacheMisses; m.paintDuration = paintDuration;
    m.totalArea = totalArea;
    return m;
  }

  CirclePaintMetrics operator +(CirclePaintMetrics other) {
    final m = copy();
    m.circlesPainted += other.circlesPainted;
    m.strokedCircles += other.strokedCircles;
    m.shadowCount += other.shadowCount;
    m.cacheHits += other.cacheHits;
    m.cacheMisses += other.cacheMisses;
    m.paintDuration += other.paintDuration;
    m.totalArea += other.totalArea;
    return m;
  }

  double get averagePaintTimeMs {
    if (circlesPainted == 0) return 0;
    return paintDuration.inMicroseconds / circlesPainted / 1000.0;
  }

  @override
  String toString() =>
      'CirclePaintMetrics(circles: $circlesPainted, '
      'strokes: $strokedCircles, shadows: $shadowCount, '
      'cache: ${cacheHits}h/${cacheMisses}m, '
      'time: ${paintDuration.inMilliseconds}ms, '
      'avg: ${averagePaintTimeMs.toStringAsFixed(2)}ms, '
      'area: ${totalArea.toStringAsFixed(1)})';
}
