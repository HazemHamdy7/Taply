import 'json_path.dart';
import 'source_location.dart';

enum DiagnosticLevel { info, warning, error, fatal }

class ParserDiagnostic {
  final DiagnosticLevel level;
  final String message;
  final String code;
  final JsonPath jsonPath;
  final SourceLocation? sourceLocation;
  final Map<String, dynamic>? context;

  const ParserDiagnostic({
    required this.level,
    required this.message,
    required this.code,
    required this.jsonPath,
    this.sourceLocation,
    this.context,
  });

  bool get isError => level == DiagnosticLevel.error;
  bool get isWarning => level == DiagnosticLevel.warning;
  bool get isFatal => level == DiagnosticLevel.fatal;
  bool get isInfo => level == DiagnosticLevel.info;

  @override
  String toString() {
    final buf = StringBuffer('[$level] $code');
    buf.write(' at ${jsonPath.toString()}');
    if (sourceLocation != null) buf.write(' ${sourceLocation.toString()}');
    buf.write(': $message');
    return buf.toString();
  }
}
