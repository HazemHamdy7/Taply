import 'package:business_card/theme_engine/models/gradient_definition.dart';
import 'package:business_card/theme_engine/models/scene_node.dart';
import 'package:business_card/theme_engine/models/theme_canvas.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'package:business_card/theme_engine/models/theme_metadata.dart';
import 'package:business_card/theme_engine/models/theme_scene.dart';
import 'package:business_card/theme_engine/models/transform.dart';

class TemplateToThemeConverter {
  TemplateToThemeConverter._();

  static ThemeDocument convert(Map<String, dynamic> json) {
    final id = json['id'] as String? ?? 'default';
    final name = json['name'] as String? ?? 'Default';
    final width = (json['width'] as num?)?.toDouble() ?? 1000;
    final height = (json['height'] as num?)?.toDouble() ?? 600;
    final clipRadius = (json['clipRadius'] as num?)?.toDouble() ?? 0;

    final paintLayers = json['paintLayers'] as List<dynamic>? ?? [];
    final widgetLayers = json['widgetLayers'] as List<dynamic>? ?? [];

    final paintNodes = <SceneNode>[];
    for (int i = 0; i < paintLayers.length; i++) {
      final layer = paintLayers[i] as Map<String, dynamic>;
      final node = _convertPaintLayer(layer, i);
      if (node != null) paintNodes.add(node);
    }

    final widgetNodes = <SceneNode>[];
    for (int i = 0; i < widgetLayers.length; i++) {
      final layer = widgetLayers[i] as Map<String, dynamic>;
      final node = _convertWidgetLayer(layer, i);
      if (node != null) widgetNodes.add(node);
    }

    final sceneNodes = [
      ...paintNodes,
      ...widgetNodes,
    ];

    return ThemeDocument(
      metadata: ThemeMetadata(id: id, name: name),
      canvas: ThemeCanvas(
        width: width,
        height: height,
        cornerRadius: clipRadius,
      ),
      scene: ThemeScene(id: 'main', nodes: sceneNodes),
    );
  }

  static SceneNode? _convertPaintLayer(
    Map<String, dynamic> layer,
    int index,
  ) {
    final type = _str(layer['type']);
    if (type == null) return null;

    final id = 'paint_$index';
    final x = _num(layer['x']) ?? 0;
    final y = _num(layer['y']) ?? 0;
    final w = _num(layer['w']);
    final h = _num(layer['h']);
    final stroke = _str(layer['stroke']);
    final strokeWidth = _num(layer['strokeWidth']);
    final fill = layer['fill'] as Map<String, dynamic>?;
    final br = _num(layer['br']);

    final props = <String, dynamic>{};
    if (w != null) props['width'] = w;
    if (h != null) props['height'] = h;
    if (br != null) props['borderRadius'] = br;

    for (final key in layer.keys) {
      if (!const {
        'type', 'x', 'y', 'w', 'h', 'fill', 'stroke', 'strokeWidth', 'br',
        'cx', 'cy', 'x1', 'y1', 'x2', 'y2', 'size', 'count', 'spacing',
        'startY', 'fade', 'left', 'top', 'height',
      }.contains(key)) {
        props[key] = layer[key];
      }
    }

    GradientDefinition? gradient;
    String? color;

    if (fill != null) {
      final fillKind = _str(fill['kind']);
      if (fillKind != null && (fillKind == 'linear' || fillKind == 'radial')) {
        final fillColors = fill['colors'] as List<dynamic>?;
        if (fillColors != null && fillColors.isNotEmpty) {
          gradient = GradientDefinition(
            kind: fillKind,
            colors: fillColors.cast<String>(),
            angle: _num(fill['angle']) ?? 0,
            focalX: _num(fill['focalX']) ?? 0,
            focalY: _num(fill['focalY']) ?? 0,
            radius: _num(fill['radius']) ?? 1.0,
            stops: (fill['stops'] as List<dynamic>?)
                ?.map((s) => (s as num).toDouble())
                .toList(),
          );
        }
      } else {
        color = _str(fill['colors'] is List && (fill['colors'] as List).isNotEmpty
            ? (fill['colors'] as List).first as String
            : null);
      }
    }

    if (type == 'rect' || type == 'rrect') {
      return SceneNode.paint(
        id: id,
        type: 'rect',
        name: type,
        transform: Transform(x: x, y: y),
        color: color,
        gradient: gradient,
        strokeColor: stroke,
        strokeWidth: strokeWidth,
        properties: props,
      );
    }

    if (type == 'line') {
      props['x1'] = _num(layer['x1']) ?? x;
      props['y1'] = _num(layer['y1']) ?? y;
      props['x2'] = _num(layer['x2']);
      props['y2'] = _num(layer['y2']);
      return SceneNode.paint(
        id: id,
        type: 'line',
        name: 'line',
        transform: Transform(x: x, y: y),
        strokeColor: stroke,
        strokeWidth: strokeWidth,
        color: stroke,
        properties: props,
      );
    }

    props['type'] = type;
    for (final key in {'x1', 'y1', 'x2', 'y2', 'cx', 'cy', 'size', 'left', 'top', 'count', 'spacing', 'startY', 'fade', 'height'}) {
      if (layer.containsKey(key)) {
        props[key] = layer[key];
      }
    }

    return SceneNode.paint(
      id: id,
      type: type,
      name: type,
      transform: Transform(x: x, y: y),
      color: color,
      gradient: gradient,
      strokeColor: stroke,
      strokeWidth: strokeWidth,
      properties: props,
    );
  }

  static SceneNode? _convertWidgetLayer(
    Map<String, dynamic> layer,
    int index,
  ) {
    final type = _str(layer['type']);
    if (type == null) return null;

    final id = 'widget_$index';
    final x = _num(layer['x']) ?? 0;
    final y = _num(layer['y']) ?? 0;
    final field = _str(layer['field']);
    final fontSize = _num(layer['fontSize']);
    final color = _str(layer['color']);
    final fontWeight = _str(layer['fontWeight']);
    final maxLines = _num(layer['maxLines']);
    final size = _num(layer['size']);
    final shape = _str(layer['shape']);
    final rtlX = _num(layer['rtlX']);

    final extra = Map<String, dynamic>.from(layer);
    extra.removeWhere((k, _) => const {
      'type', 'field', 'x', 'y', 'fontSize', 'color', 'fontWeight',
      'maxLines', 'size', 'shape', 'rtlX',
    }.contains(k));

    final props = <String, dynamic>{
      ...extra,
    };
    if (rtlX != null) props['rtlX'] = rtlX;

    return SceneNode.widget(
      id: id,
      type: type,
      transform: Transform(x: x, y: y),
      field: field,
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
      maxLines: maxLines,
      size: size,
      shape: shape,
      properties: props,
    );
  }

  static String? _str(dynamic v) => v is String ? v : null;
  static double? _num(dynamic v) => (v is num) ? v.toDouble() : null;
}
