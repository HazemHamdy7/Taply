class TextPainterDiagnostics {
  final List<String> layoutOperations = [];
  final List<String> paintOperations = [];
  final List<String> warnings = [];
  final List<String> fallbackFonts = [];
  final List<String> missingGlyphs = [];
  final List<String> overflow = [];
  final List<String> skipped = [];
  final List<String> errors = [];
  int memoryAllocations = 0;

  void recordLayoutOp(String op) { layoutOperations.add(op); }
  void recordPaintOp(String op) { paintOperations.add(op); }
  void recordWarning(String msg) { warnings.add(msg); }
  void recordFallbackFont(String font) { fallbackFonts.add(font); }
  void recordMissingGlyph(String char) { missingGlyphs.add(char); }
  void recordOverflow(String details) { overflow.add(details); }
  void recordSkipped(String reason) { skipped.add(reason); }
  void recordError(String msg) { errors.add(msg); }
  void recordAllocation() { memoryAllocations++; }

  void reset() {
    layoutOperations.clear(); paintOperations.clear(); warnings.clear();
    fallbackFonts.clear(); missingGlyphs.clear(); overflow.clear();
    skipped.clear(); errors.clear(); memoryAllocations = 0;
  }

  void merge(TextPainterDiagnostics other) {
    layoutOperations.addAll(other.layoutOperations);
    paintOperations.addAll(other.paintOperations);
    warnings.addAll(other.warnings);
    fallbackFonts.addAll(other.fallbackFonts);
    missingGlyphs.addAll(other.missingGlyphs);
    overflow.addAll(other.overflow);
    skipped.addAll(other.skipped);
    errors.addAll(other.errors);
    memoryAllocations += other.memoryAllocations;
  }

  int get totalLayoutOps => layoutOperations.length;
  int get totalPaintOps => paintOperations.length;
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;
  bool get hasOverflow => overflow.isNotEmpty;

  @override
  String toString() =>
      'TextPainterDiagnostics(layout: $totalLayoutOps, paint: $totalPaintOps, '
      'warnings: ${warnings.length}, fallbacks: ${fallbackFonts.length}, '
      'missing: ${missingGlyphs.length}, overflow: ${overflow.length}, '
      'skipped: ${skipped.length}, errors: ${errors.length}, '
      'allocs: $memoryAllocations)';
}
