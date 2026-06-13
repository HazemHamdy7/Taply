class LinePaintMetrics {
  int linesPainted = 0;
  int shadowCount = 0;
  int cacheHits = 0;
  int cacheMisses = 0;
  Duration paintDuration = Duration.zero;
  double totalLength = 0.0;

  void recordLine(double length) { linesPainted++; totalLength += length; }
  void recordShadow() { shadowCount++; }
  void recordCacheHit() { cacheHits++; }
  void recordCacheMiss() { cacheMisses++; }
  void recordDuration(Duration d) { paintDuration += d; }

  void reset() {
    linesPainted = 0; shadowCount = 0;
    cacheHits = 0; cacheMisses = 0;
    paintDuration = Duration.zero; totalLength = 0.0;
  }

  LinePaintMetrics copy() {
    final m = LinePaintMetrics();
    m.linesPainted = linesPainted; m.shadowCount = shadowCount;
    m.cacheHits = cacheHits; m.cacheMisses = cacheMisses;
    m.paintDuration = paintDuration; m.totalLength = totalLength;
    return m;
  }

  LinePaintMetrics operator +(LinePaintMetrics other) {
    final m = copy();
    m.linesPainted += other.linesPainted;
    m.shadowCount += other.shadowCount;
    m.cacheHits += other.cacheHits;
    m.cacheMisses += other.cacheMisses;
    m.paintDuration += other.paintDuration;
    m.totalLength += other.totalLength;
    return m;
  }

  double get averagePaintTimeMs {
    if (linesPainted == 0) return 0;
    return paintDuration.inMicroseconds / linesPainted / 1000.0;
  }

  @override
  String toString() =>
      'LinePaintMetrics(lines: $linesPainted, '
      'shadows: $shadowCount, '
      'cache: ${cacheHits}h/${cacheMisses}m, '
      'time: ${paintDuration.inMilliseconds}ms, '
      'avg: ${averagePaintTimeMs.toStringAsFixed(2)}ms, '
      'len: ${totalLength.toStringAsFixed(1)})';
}
