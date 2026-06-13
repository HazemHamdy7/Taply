import 'dart:ui' show Rect;

class PaintResult {
  final bool success;
  final Duration duration;
  final List<String> warnings;
  final List<String> diagnostics;
  final Rect? paintBounds;
  final String? elementType;

  const PaintResult({
    required this.success,
    required this.duration,
    this.warnings = const [],
    this.diagnostics = const [],
    this.paintBounds,
    this.elementType,
  });

  bool get hasWarnings => warnings.isNotEmpty;
  bool get hasDiagnostics => diagnostics.isNotEmpty;

  static const PaintResult skipped = PaintResult(
    success: true,
    duration: Duration.zero,
  );

  static PaintResult failure(String message, {Duration? duration}) {
    return PaintResult(
      success: false,
      duration: duration ?? Duration.zero,
      diagnostics: [message],
    );
  }

  @override
  String toString() =>
      'PaintResult(success: $success, duration: ${duration.inMicroseconds}us, '
      'warnings: ${warnings.length}, diagnostics: ${diagnostics.length})';
}
