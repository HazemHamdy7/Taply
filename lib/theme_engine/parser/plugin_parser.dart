import 'internal_parser.dart';
import 'parse_result.dart';
import 'parser_context.dart';

abstract class PluginParser<T> extends InternalParser<T> {
  String get pluginName;
  String get pluginVersion;

  bool canHandle(Map<String, dynamic> json, ParserContext context);

  @override
  ParseResult<T> parse(Map<String, dynamic> json, ParserContext context);
}

abstract class CustomNodeParser extends InternalParser<Map<String, dynamic>> {
  String get nodeKind;

  bool canParseNode(Map<String, dynamic> json, ParserContext context);

  @override
  ParseResult<Map<String, dynamic>> parse(
      Map<String, dynamic> json, ParserContext context);
}
