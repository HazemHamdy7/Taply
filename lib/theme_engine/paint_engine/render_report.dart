import 'paint_metrics.dart';

class RenderReport {
  final int totalNodes;
  final int paintedNodes;
  final int skippedNodes;
  final int recoveredNodes;
  final int failedNodes;
  final List<String> warnings;
  final Duration totalPaintTime;
  final Map<String, int> elementCounts;

  const RenderReport({
    required this.totalNodes,
    required this.paintedNodes,
    required this.skippedNodes,
    required this.recoveredNodes,
    required this.failedNodes,
    required this.totalPaintTime,
    this.warnings = const [],
    this.elementCounts = const {},
  });

  double get compatibilityScore {
    final total = paintedNodes + recoveredNodes + failedNodes;
    if (total == 0) return 100.0;
    return (paintedNodes + recoveredNodes) / total * 100.0;
  }

  bool get allPassed => failedNodes == 0;

  int get totalProcessed => paintedNodes + skippedNodes + recoveredNodes + failedNodes;

  factory RenderReport.fromMetrics(int totalNodes, PaintMetrics metrics) {
    return RenderReport(
      totalNodes: totalNodes,
      paintedNodes: metrics.paintedNodes,
      skippedNodes: metrics.skippedNodes,
      recoveredNodes: metrics.recoveredNodes,
      failedNodes: metrics.failedNodes,
      totalPaintTime: metrics.paintTime,
      warnings: List.from(metrics.warnings),
      elementCounts: Map.from(metrics.elementCounts),
    );
  }

  @override
  String toString() =>
      'RenderReport(total: $totalNodes, painted: $paintedNodes, '
      'skipped: $skippedNodes, recovered: $recoveredNodes, '
      'failed: $failedNodes, score: ${compatibilityScore.toStringAsFixed(1)}%, '
      'warnings: ${warnings.length})';
}
