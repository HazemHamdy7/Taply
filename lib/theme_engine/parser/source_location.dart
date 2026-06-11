class SourceLocation {
  final int line;
  final int column;
  final int offset;

  const SourceLocation({
    required this.line,
    required this.column,
    required this.offset,
  });

  @override
  bool operator ==(Object other) =>
      other is SourceLocation &&
      line == other.line &&
      column == other.column &&
      offset == other.offset;

  @override
  int get hashCode => Object.hash(line, column, offset);

  @override
  String toString() => '[$line:$column]';
}
