class TemplateModel {
  final String id;
  final String name;
  final double width;
  final double height;
  final double clipRadius;
  final List<PaintLayer> paintLayers;
  final List<WidgetLayer> widgetLayers;

  const TemplateModel({
    required this.id,
    required this.name,
    required this.width,
    required this.height,
    this.clipRadius = 0,
    this.paintLayers = const [],
    this.widgetLayers = const [],
  });

  factory TemplateModel.fromJson(Map<String, dynamic> json) {
    return TemplateModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      width: (json['width'] as num?)?.toDouble() ?? 1000,
      height: (json['height'] as num?)?.toDouble() ?? 600,
      clipRadius: (json['clipRadius'] as num?)?.toDouble() ?? 0,
      paintLayers: (json['paintLayers'] as List<dynamic>?)
              ?.map((e) => PaintLayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      widgetLayers: (json['widgetLayers'] as List<dynamic>?)
              ?.map((e) => WidgetLayer.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class PaintLayer {
  final String type;
  final double? x, y, w, h, br;
  final String? stroke;
  final double? strokeWidth;
  final Map<String, dynamic>? fill;
  final Map<String, dynamic> extra;

  const PaintLayer({
    required this.type,
    this.x, this.y, this.w, this.h, this.br,
    this.stroke, this.strokeWidth,
    this.fill,
    this.extra = const {},
  });

  factory PaintLayer.fromJson(Map<String, dynamic> json) {
    final extra = Map<String, dynamic>.from(json);
    extra.removeWhere((k, _) => [
      'type', 'x', 'y', 'w', 'h', 'br', 'stroke', 'strokeWidth', 'fill',
    ].contains(k));
    return PaintLayer(
      type: json['type'] as String? ?? '',
      x: (json['x'] as num?)?.toDouble(),
      y: (json['y'] as num?)?.toDouble(),
      w: (json['w'] as num?)?.toDouble(),
      h: (json['h'] as num?)?.toDouble(),
      br: (json['br'] as num?)?.toDouble(),
      stroke: json['stroke'] as String?,
      strokeWidth: (json['strokeWidth'] as num?)?.toDouble(),
      fill: json['fill'] is Map ? json['fill'] as Map<String, dynamic> : null,
      extra: extra,
    );
  }
}

class WidgetLayer {
  final String type;
  final String? field;
  final double x, y;
  final double? fontSize;
  final String? color;
  final String? fontWeight;
  final double? maxLines;
  final double? size;
  final String? shape;
  final double? rtlX;
  final Map<String, dynamic> extra;

  const WidgetLayer({
    required this.type,
    this.field,
    required this.x,
    required this.y,
    this.fontSize,
    this.color,
    this.fontWeight,
    this.maxLines,
    this.size,
    this.shape,
    this.rtlX,
    this.extra = const {},
  });

  factory WidgetLayer.fromJson(Map<String, dynamic> json) {
    final extra = Map<String, dynamic>.from(json);
    extra.removeWhere((k, _) => [
      'type', 'field', 'x', 'y', 'fontSize', 'color', 'fontWeight',
      'maxLines', 'size', 'shape', 'rtlX',
    ].contains(k));
    return WidgetLayer(
      type: json['type'] as String? ?? '',
      field: json['field'] as String?,
      x: (json['x'] as num?)?.toDouble() ?? 0,
      y: (json['y'] as num?)?.toDouble() ?? 0,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      color: json['color'] as String?,
      fontWeight: json['fontWeight'] as String?,
      maxLines: (json['maxLines'] as num?)?.toDouble(),
      size: (json['size'] as num?)?.toDouble(),
      shape: json['shape'] as String?,
      rtlX: (json['rtlX'] as num?)?.toDouble(),
      extra: extra,
    );
  }

  double get effectiveX => rtlX ?? x;
}
