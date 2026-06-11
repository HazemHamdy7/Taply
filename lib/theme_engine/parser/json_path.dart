class JsonPath {
  final List<String> _segments;

  const JsonPath() : _segments = const [];

  JsonPath._(this._segments);

  factory JsonPath.parse(String path) {
    if (path == r'$' || path.isEmpty) return const JsonPath();
    final parts = path.split('.').map((s) => s.trim()).toList();
    if (parts.first == r'$') parts.removeAt(0);
    return JsonPath._(parts);
  }

  JsonPath push(String segment) => JsonPath._([..._segments, segment]);

  JsonPath pushIndex(int index) => JsonPath._([..._segments, '[$index]']);

  JsonPath pop() {
    if (_segments.isEmpty) return this;
    return JsonPath._(_segments.sublist(0, _segments.length - 1));
  }

  bool get isRoot => _segments.isEmpty;

  List<String> get segments => List.unmodifiable(_segments);

  String get current => _segments.isEmpty ? r'$' : _segments.last;

  @override
  bool operator ==(Object other) =>
      other is JsonPath && _segments.equals(other._segments);

  @override
  int get hashCode => Object.hashAll(_segments);

  @override
  String toString() {
    if (_segments.isEmpty) return r'$';
    final buffer = StringBuffer(r'$');
    for (final s in _segments) {
      if (s.startsWith('[')) {
        buffer.write(s);
      } else {
        buffer.write('.$s');
      }
    }
    return buffer.toString();
  }
}

extension on List<String> {
  bool equals(List<String> other) {
    if (length != other.length) return false;
    for (var i = 0; i < length; i++) {
      if (this[i] != other[i]) return false;
    }
    return true;
  }
}
