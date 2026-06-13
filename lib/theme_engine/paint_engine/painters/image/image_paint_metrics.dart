class ImagePaintMetrics {
  int imagesPainted = 0;
  int placeholderCount = 0;
  int borderCount = 0;
  int shadowCount = 0;
  int cacheHits = 0;
  int cacheMisses = 0;
  Duration paintDuration = Duration.zero;
  double totalArea = 0.0;

  void recordImage(double area) { imagesPainted++; totalArea += area; }
  void recordPlaceholder() { placeholderCount++; }
  void recordBorder() { borderCount++; }
  void recordShadow() { shadowCount++; }
  void recordCacheHit() { cacheHits++; }
  void recordCacheMiss() { cacheMisses++; }
  void recordDuration(Duration d) { paintDuration += d; }

  void reset() {
    imagesPainted = 0; placeholderCount = 0; borderCount = 0;
    shadowCount = 0; cacheHits = 0; cacheMisses = 0;
    paintDuration = Duration.zero; totalArea = 0.0;
  }

  ImagePaintMetrics copy() {
    final m = ImagePaintMetrics();
    m.imagesPainted = imagesPainted; m.placeholderCount = placeholderCount;
    m.borderCount = borderCount; m.shadowCount = shadowCount;
    m.cacheHits = cacheHits; m.cacheMisses = cacheMisses;
    m.paintDuration = paintDuration; m.totalArea = totalArea;
    return m;
  }

  ImagePaintMetrics operator +(ImagePaintMetrics other) {
    final m = copy();
    m.imagesPainted += other.imagesPainted;
    m.placeholderCount += other.placeholderCount;
    m.borderCount += other.borderCount;
    m.shadowCount += other.shadowCount;
    m.cacheHits += other.cacheHits;
    m.cacheMisses += other.cacheMisses;
    m.paintDuration += other.paintDuration;
    m.totalArea += other.totalArea;
    return m;
  }

  double get averagePaintTimeMs {
    if (imagesPainted == 0) return 0;
    return paintDuration.inMicroseconds / imagesPainted / 1000.0;
  }

  @override
  String toString() =>
      'ImagePaintMetrics(images: $imagesPainted, '
      'placeholders: $placeholderCount, borders: $borderCount, '
      'shadows: $shadowCount, cache: ${cacheHits}h/${cacheMisses}m, '
      'time: ${paintDuration.inMilliseconds}ms)';
}
