class CanvasOperation {
  final String name;
  final Duration duration;
  final Map<String, dynamic> details;
  const CanvasOperation({
    required this.name,
    this.duration = Duration.zero,
    this.details = const {},
  });
  @override
  String toString() => '$name(${duration.inMicroseconds}us)';
}

class LinePainterDiagnostics {
  final List<CanvasOperation> operations = [];
  final List<String> warnings = [];
  final List<String> skipped = [];
  final List<String> errors = [];
  int memoryAllocations = 0;

  void recordOperation(String name, {Duration? duration, Map<String, dynamic>? details}) {
    operations.add(CanvasOperation(
      name: name, duration: duration ?? Duration.zero,
      details: details ?? const {},
    ));
  }
  void recordWarning(String msg) { warnings.add(msg); }
  void recordSkipped(String reason) { skipped.add(reason); }
  void recordError(String msg) { errors.add(msg); }
  void recordAllocation() { memoryAllocations++; }
  void reset() { operations.clear(); warnings.clear(); skipped.clear(); errors.clear(); memoryAllocations = 0; }

  void merge(LinePainterDiagnostics other) {
    operations.addAll(other.operations); warnings.addAll(other.warnings);
    skipped.addAll(other.skipped); errors.addAll(other.errors);
    memoryAllocations += other.memoryAllocations;
  }

  int get totalOperations => operations.length;
  Duration get totalDuration {
    Duration d = Duration.zero;
    for (final op in operations) { d += op.duration; }
    return d;
  }
  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasErrors => errors.isNotEmpty;

  @override
  String toString() =>
      'LinePainterDiagnostics(ops: $totalOperations, '
      'warnings: ${warnings.length}, errors: ${errors.length}, '
      'skipped: ${skipped.length}, allocs: $memoryAllocations)';
}
