import 'parse_result.dart';
import 'parser_context.dart';

abstract class InternalParser<T> {
  String get key;
  String get supportedVersion;

  bool canParse(String specVersion);

  ParseResult<T> parse(Map<String, dynamic> json, ParserContext context);

  Set<String> knownFields();

  void migrate(Map<String, dynamic> json, String fromVersion, String toVersion) {
  }
}
