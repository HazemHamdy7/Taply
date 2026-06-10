/// Utility methods for JSON parsing and type coercion.
class JsonUtils {
  JsonUtils._();

  /// Safely extracts a [String] value from [json] at [key].
  static String? optionalString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    if (value != null) return value.toString();
    return null;
  }

  /// Safely extracts a required [String] value from [json] at [key].
  /// Throws [ArgumentError] if the key is missing or not a string.
  static String requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is String) return value;
    throw ArgumentError('Required string key "$key" is missing or invalid');
  }

  /// Safely extracts an optional [double] value from [json] at [key].
  static double? optionalDouble(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is num) return value.toDouble();
    return null;
  }

  /// Safely extracts a required [double] value from [json] at [key].
  static double requiredDouble(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is num) return value.toDouble();
    throw ArgumentError('Required double key "$key" is missing or invalid');
  }

  /// Safely extracts an optional [int] value from [json] at [key].
  static int? optionalInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    if (value is num) return value.toInt();
    return null;
  }

  /// Safely extracts a required [int] value from [json] at [key].
  static int requiredInt(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is int) return value;
    throw ArgumentError('Required int key "$key" is missing or invalid');
  }

  /// Safely extracts an optional [bool] value from [json] at [key].
  static bool? optionalBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is bool) return value;
    return null;
  }

  /// Safely extracts a required [bool] value from [json] at [key].
  static bool requiredBool(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is bool) return value;
    throw ArgumentError('Required bool key "$key" is missing or invalid');
  }

  /// Safely extracts an optional [Map<String, dynamic>] value from [json] at [key].
  static Map<String, dynamic>? optionalMap(
      Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is Map<String, dynamic>) return value;
    return null;
  }

  /// Safely extracts an optional [List<dynamic>] value from [json] at [key].
  static List<dynamic>? optionalList(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is List<dynamic>) return value;
    return null;
  }

  /// Safely extracts a [List<T>] by mapping each element through [fromJson].
  static List<T> optionalListOf<T>(
    Map<String, dynamic> json,
    String key,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final list = optionalList(json, key);
    if (list == null) return const [];
    return list
        .whereType<Map<String, dynamic>>()
        .map(fromJson)
        .toList();
  }
}
