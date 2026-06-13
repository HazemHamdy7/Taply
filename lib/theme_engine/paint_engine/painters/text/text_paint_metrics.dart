class TextPaintMetrics {
  int charactersPainted = 0;
  int linesPainted = 0;
  int paragraphsCount = 0;
  int cacheHits = 0;
  int cacheMisses = 0;
  Duration layoutDuration = Duration.zero;
  Duration paintDuration = Duration.zero;

  void recordCharacter(int count) { charactersPainted += count; }
  void recordLine(int count) { linesPainted += count; }
  void recordParagraph() { paragraphsCount++; }
  void recordCacheHit() { cacheHits++; }
  void recordCacheMiss() { cacheMisses++; }
  void recordLayoutTime(Duration d) { layoutDuration += d; }
  void recordPaintTime(Duration d) { paintDuration += d; }

  void reset() {
    charactersPainted = 0; linesPainted = 0; paragraphsCount = 0;
    cacheHits = 0; cacheMisses = 0;
    layoutDuration = Duration.zero; paintDuration = Duration.zero;
  }

  TextPaintMetrics copy() {
    final m = TextPaintMetrics();
    m.charactersPainted = charactersPainted; m.linesPainted = linesPainted;
    m.paragraphsCount = paragraphsCount; m.cacheHits = cacheHits;
    m.cacheMisses = cacheMisses; m.layoutDuration = layoutDuration;
    m.paintDuration = paintDuration;
    return m;
  }

  TextPaintMetrics operator +(TextPaintMetrics other) {
    final m = copy();
    m.charactersPainted += other.charactersPainted;
    m.linesPainted += other.linesPainted;
    m.paragraphsCount += other.paragraphsCount;
    m.cacheHits += other.cacheHits;
    m.cacheMisses += other.cacheMisses;
    m.layoutDuration += other.layoutDuration;
    m.paintDuration += other.paintDuration;
    return m;
  }

  double get totalTimeMs =>
      (layoutDuration.inMicroseconds + paintDuration.inMicroseconds) / 1000.0;

  @override
  String toString() =>
      'TextPaintMetrics(chars: $charactersPainted, lines: $linesPainted, '
      'paras: $paragraphsCount, cache: ${cacheHits}h/${cacheMisses}m, '
      'layout: ${layoutDuration.inMilliseconds}ms, '
      'paint: ${paintDuration.inMilliseconds}ms)';
}
