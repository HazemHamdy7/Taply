import '../models/theme_document.dart';

/// Shared context passed to every [ValidationRule] during validation.
class ValidationContext {
  final ThemeDocument document;
  final Set<String> _nodeIds = {};

  ValidationContext({required this.document});

  bool hasNodeId(String id) => _nodeIds.contains(id);

  bool registerNodeId(String id) => _nodeIds.add(id);
}
