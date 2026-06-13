class GradientPaintMetrics {
  int gradientsPainted = 0;
  int linearCount = 0;
  int radialCount = 0;
  int sweepCount = 0;
  int shadowCount = 0;
  int cacheHits = 0;
  int cacheMisses = 0;
  Duration paintDuration = Duration.zero;
  double totalArea = 0.0;

  void recordGradient(double area, String kind) {
    gradientsPainted++;
    totalArea += area;
    switch (kind) {
      case 'linear': linearCount++; break;
      case 'radial': radialCount++; break;
      case 'sweep':  sweepCount++;  break;
    }
  }

  void recordShadow() { shadowCount++; }
  void recordCacheHit() { cacheHits++; }
  void recordCacheMiss() { cacheMisses++; }
  void recordDuration(Duration d) { paintDuration += d; }

  void reset() {
    gradientsPainted = 0; linearCount = 0; radialCount = 0; sweepCount = 0;
    shadowCount = 0; cacheHits = 0; cacheMisses = 0;
    paintDuration = Duration.zero; totalArea = 0.0;
  }

  GradientPaintMetrics copy() {
    final m = GradientPaintMetrics();
    m.gradientsPainted = gradientsPainted; m.linearCount = linearCount;
    m.radialCount = radialCount; m.sweepCount = sweepCount;
    m.shadowCount = shadowCount; m.cacheHits = cacheHits;
    m.cacheMisses = cacheMisses; m.paintDuration = paintDuration;
    m.totalArea = totalArea;
    return m;
  }

  GradientPaintMetrics operator +(GradientPaintMetrics other) {
    final m = copy();
    m.gradientsPainted += other.gradientsPainted;
    m.linearCount += other.linearCount;
    m.radialCount += other.radialCount;
    m.sweepCount += other.sweepCount;
    m.shadowCount += other.shadowCount;
    m.cacheHits += other.cacheHits;
    m.cacheMisses += other.cacheMisses;
    m.paintDuration += other.paintDuration;
    m.totalArea += other.totalArea;
    return m;
  }

  double get averagePaintTimeMs {
    if (gradientsPainted == 0) return 0;
    return paintDuration.inMicroseconds / gradientsPainted / 1000.0;
  }

  @override
  String toString() =>
      'GradientPaintMetrics(gradients: $gradientsPainted, '
      'L: $linearCount R: $radialCount S: $sweepCount, '
      'shadows: $shadowCount, cache: ${cacheHits}h/${cacheMisses}m, '
      'time: ${paintDuration.inMilliseconds}ms, '
      'avg: ${averagePaintTimeMs.toStringAsFixed(2)}ms)';
}
