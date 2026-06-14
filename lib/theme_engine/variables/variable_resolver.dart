import '../interfaces/variable_resolver_interface.dart';
import '../models/theme_variables.dart';

class VariableResolver implements IVariableResolver {
  final Map<String, dynamic> _resolved = {};
  ThemeVariables? _variables;

  @override
  dynamic resolve(String name) {
    if (_resolved.containsKey(name)) return _resolved[name];
    if (_variables == null) return null;

    final custom = _variables!.custom;
    if (custom.containsKey(name)) {
      final val = custom[name]!.value;
      _resolved[name] = val;
      return val;
    }

    final colors = _variables!.colors.swatches;
    for (final swatch in colors) {
      if (swatch.id == name) {
        _resolved[name] = swatch.color;
        return swatch.color;
      }
    }

    return null;
  }

  @override
  Map<String, dynamic> resolveAll(ThemeVariables variables) {
    _variables = variables;
    _resolved.clear();

    final result = <String, dynamic>{};
    for (final entry in variables.custom.entries) {
      result[entry.key] = _resolveValue(entry.value.value);
    }
    for (final swatch in variables.colors.swatches) {
      result[swatch.id] = swatch.color;
    }

    return result;
  }

  dynamic _resolveValue(dynamic value) {
    if (value is String && value.startsWith('\$')) {
      final resolved = resolve(value.substring(1));
      return resolved ?? value;
    }
    if (value is Map) {
      final result = <String, dynamic>{};
      for (final entry in value.entries) {
        result[entry.key.toString()] = _resolveValue(entry.value);
      }
      return result;
    }
    if (value is List) {
      return value.map(_resolveValue).toList();
    }
    return value;
  }

  @override
  bool hasVariableReference(dynamic value) {
    if (value is String) return value.contains('\$');
    if (value is Map) {
      return value.values.any((v) => hasVariableReference(v));
    }
    if (value is List) {
      return value.any((v) => hasVariableReference(v));
    }
    return false;
  }

  @override
  List<String> extractReferences(dynamic value) {
    final refs = <String>[];
    if (value is String) {
      final matches = RegExp(r'\$(\w+)').allMatches(value);
      for (final m in matches) {
        refs.add(m.group(1)!);
      }
    } else if (value is Map) {
      for (final v in value.values) {
        refs.addAll(extractReferences(v));
      }
    } else if (value is List) {
      for (final v in value) {
        refs.addAll(extractReferences(v));
      }
    }
    return refs;
  }

  void clear() {
    _resolved.clear();
    _variables = null;
  }
}
