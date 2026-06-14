import 'data_provider.dart';
import 'expression_resolver.dart';

class FieldResolver {
  static final RegExp _templatePattern = RegExp(r'\$\{([^}]+)\}');

  String resolve(
    String template,
    BusinessCardData data, [
    ExpressionResolver? expressionResolver,
  ]) {
    final resolver = expressionResolver ?? ExpressionResolver();
    return template.replaceAllMapped(_templatePattern, (match) {
      final inner = match.group(1)!;
      final trimmed = inner.trim();
      if (trimmed.contains('(')) {
        final result = resolver.evaluate(trimmed, data);
        return result?.toString() ?? '';
      }
      final value = data.resolve(trimmed);
      return value?.toString() ?? '';
    });
  }

  bool containsTemplate(String value) {
    return _templatePattern.hasMatch(value);
  }

  List<String> extractFieldRefs(String template) {
    final refs = <String>[];
    for (final match in _templatePattern.allMatches(template)) {
      final inner = match.group(1)!.trim();
      refs.add(inner);
    }
    return refs;
  }

  String stripTemplateSyntax(String template) {
    return template.replaceAll(RegExp(r'\$\{|\}'), '');
  }
}
