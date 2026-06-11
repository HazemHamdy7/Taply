import 'parser_diagnostic.dart';

class ParseResult<T> {
  final T? value;
  final bool success;
  final List<ParserDiagnostic> diagnostics;
  final Map<String, Set<String>> unknownFields;

  const ParseResult({
    this.value,
    required this.success,
    this.diagnostics = const [],
    this.unknownFields = const {},
  });

  List<ParserDiagnostic> get errors =>
      diagnostics.where((d) => d.isError || d.isFatal).toList();

  List<ParserDiagnostic> get warnings =>
      diagnostics.where((d) => d.isWarning).toList();

  List<ParserDiagnostic> get infos =>
      diagnostics.where((d) => d.isInfo).toList();

  bool get hasErrors => errors.isNotEmpty;
  bool get hasFatal => diagnostics.any((d) => d.isFatal);
  bool get hasWarnings => warnings.isNotEmpty;

  T get requireValue {
    if (value == null) {
      throw StateError('ParseResult has no value');
    }
    return value as T;
  }

  T requireValueOrThrow() {
    if (hasFatal) {
      throw errors.first;
    }
    return requireValue;
  }

  ParseResult<R> map<R>(R Function(T) transform) {
    final v = value;
    return ParseResult<R>(
      value: v != null ? transform(v) : null,
      success: success,
      diagnostics: diagnostics,
      unknownFields: unknownFields,
    );
  }

  @override
  String toString() =>
      'ParseResult(success: $success, errors: ${errors.length}, '
      'warnings: ${warnings.length})';
}
