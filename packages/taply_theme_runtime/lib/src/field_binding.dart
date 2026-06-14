import '../taply_theme_runtime.dart';

/// Binds a theme field to a data source in [BusinessCardData].
class FieldBinding {
  final String fieldName;
  final String dataKey;
  final String? defaultValue;
  final FieldValidator? validator;
  final String? transform;

  const FieldBinding({
    required this.fieldName,
    required this.dataKey,
    this.defaultValue,
    this.validator,
    this.transform,
  });

  /// Resolve the value of this binding from [data].
  String? resolve(BusinessCardData data) {
    final value = data[dataKey] ?? defaultValue;
    if (value == null) return null;
    if (validator != null && !validator!.isValid(value)) return defaultValue;
    return value;
  }
}
