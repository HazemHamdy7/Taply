import '../taply_theme_runtime.dart';

/// Provides a snapshot of the runtime data context for rendering.
class DataContext {
  final BusinessCardData data;
  final Map<String, String> resolvedFields;
  final Map<String, String> expressions;

  const DataContext({
    required this.data,
    required this.resolvedFields,
    required this.expressions,
  });
}
