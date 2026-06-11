import 'json_path.dart';

sealed class ParserException implements Exception {
  final String message;
  final String? code;
  final JsonPath? jsonPath;

  const ParserException(this.message, {this.code, this.jsonPath});

  @override
  String toString() {
    final buf = StringBuffer('$runtimeType');
    if (code != null) buf.write('[$code]');
    if (jsonPath != null) buf.write(' at ${jsonPath.toString()}');
    buf.write(': $message');
    return buf.toString();
  }
}

class ParserFormatException extends ParserException {
  const ParserFormatException(super.message, {super.code, super.jsonPath});
}

class ParserValidationException extends ParserException {
  const ParserValidationException(super.message, {super.code, super.jsonPath});
}

class ParserMissingFieldException extends ParserException {
  final String field;

  const ParserMissingFieldException(this.field, {super.code, super.jsonPath})
      : super('Required field "$field" is missing');

  @override
  String toString() => 'ParserMissingFieldException: "$field" at '
      '${jsonPath.toString()}';
}

class ParserTypeMismatchException extends ParserException {
  final String field;
  final String expectedType;
  final String actualType;

  const ParserTypeMismatchException({
    required this.field,
    required this.expectedType,
    required this.actualType,
    super.code,
    super.jsonPath,
  }) : super('Field "$field" expected $expectedType but got $actualType');
}

class ParserVersionException extends ParserException {
  final String version;

  const ParserVersionException(this.version, {super.code, super.jsonPath})
      : super('Unsupported theme version "$version"');
}

class ParserMigrationException extends ParserException {
  final String fromVersion;
  final String toVersion;

  const ParserMigrationException(this.fromVersion, this.toVersion,
      {super.code, super.jsonPath})
      : super('Migration from $fromVersion to $toVersion failed');
}

class ParserInternalException extends ParserException {
  const ParserInternalException(super.message, {super.code, super.jsonPath});
}

class ParserPluginException extends ParserException {
  final String pluginName;

  const ParserPluginException(this.pluginName, super.message,
      {super.code, super.jsonPath});
}
