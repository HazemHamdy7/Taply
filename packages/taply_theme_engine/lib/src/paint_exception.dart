/// Exception thrown during the paint pipeline.
class PaintException implements Exception {
  final String message;
  final String? type;
  final String? nodeId;

  const PaintException(this.message, {this.type, this.nodeId});

  @override
  String toString() {
    final buf = StringBuffer('PaintException');
    if (type != null) buf.write('[type=$type]');
    if (nodeId != null) buf.write('[node=$nodeId]');
    buf.write(': $message');
    return buf.toString();
  }
}
