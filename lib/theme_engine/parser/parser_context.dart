import 'json_path.dart';
import 'parser_diagnostic.dart';
import 'parser_options.dart';
import 'source_location.dart';

class ParserContext {
  final ParserOptions options;
  final JsonPath jsonPath;
  final SourceLocation? sourceLocation;
  final List<ParserDiagnostic> diagnostics;
  final Map<String, Set<String>> unknownFields;
  final String specVersion;
  final int depth;

  ParserContext({
    required this.options,
    required this.specVersion,
    this.jsonPath = const JsonPath(),
    this.sourceLocation,
    List<ParserDiagnostic>? diagnostics,
    Map<String, Set<String>>? unknownFields,
    this.depth = 0,
  })  : diagnostics = diagnostics ?? [],
        unknownFields = unknownFields ?? {};

  bool get isStrict => options.strictMode;
  bool get isLenient => options.lenientMode;

  void addWarning(String message, {String code = 'W001', Map<String, dynamic>? context}) {
    diagnostics.add(ParserDiagnostic(
      level: DiagnosticLevel.warning,
      message: message,
      code: code,
      jsonPath: jsonPath,
      sourceLocation: sourceLocation,
      context: context,
    ));
  }

  void addError(String message, {String code = 'E001', Map<String, dynamic>? context}) {
    diagnostics.add(ParserDiagnostic(
      level: DiagnosticLevel.error,
      message: message,
      code: code,
      jsonPath: jsonPath,
      sourceLocation: sourceLocation,
      context: context,
    ));
  }

  void addFatal(String message, {String code = 'F001', Map<String, dynamic>? context}) {
    diagnostics.add(ParserDiagnostic(
      level: DiagnosticLevel.fatal,
      message: message,
      code: code,
      jsonPath: jsonPath,
      sourceLocation: sourceLocation,
      context: context,
    ));
  }

  void addUnknownField(String field) {
    final key = jsonPath.toString();
    unknownFields.putIfAbsent(key, () => {});
    unknownFields[key]!.add(field);
  }

  ParserContext push(String segment) {
    return ParserContext(
      options: options,
      specVersion: specVersion,
      jsonPath: jsonPath.push(segment),
      sourceLocation: sourceLocation,
      diagnostics: diagnostics,
      unknownFields: unknownFields,
      depth: depth + 1,
    );
  }

  ParserContext pushIndex(int index) {
    return ParserContext(
      options: options,
      specVersion: specVersion,
      jsonPath: jsonPath.pushIndex(index),
      sourceLocation: sourceLocation,
      diagnostics: diagnostics,
      unknownFields: unknownFields,
      depth: depth + 1,
    );
  }

  bool get maxDepthExceeded => depth >= options.maxDepth;
}
