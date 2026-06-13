import 'dart:ui' show Rect;

class PaintBounds {
  final Rect rect;
  final String elementType;
  final String? nodeId;

  const PaintBounds({
    required this.rect,
    required this.elementType,
    this.nodeId,
  });

  double get area => rect.width * rect.height;

  bool get isEmpty => rect.isEmpty;

  PaintBounds expandToInclude(PaintBounds other) {
    return PaintBounds(
      rect: rect.expandToInclude(other.rect),
      elementType: elementType,
      nodeId: nodeId,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PaintBounds &&
      rect == other.rect &&
      elementType == other.elementType &&
      nodeId == other.nodeId;

  @override
  int get hashCode => Object.hash(rect, elementType, nodeId);

  @override
  String toString() =>
      'PaintBounds(${rect.width}x${rect.height} @ ${rect.left},${rect.top}, type: $elementType)';
}
