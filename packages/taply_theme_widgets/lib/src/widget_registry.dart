import 'package:flutter/widgets.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';

/// Registry for custom theme widget builders.
class WidgetRegistry {
  final Map<String, Widget Function(RenderPaintNode node, ThemeEngine engine)>
      _widgetBuilders = {};

  void registerWidgetBuilder(
    String type,
    Widget Function(RenderPaintNode node, ThemeEngine engine) builder,
  ) {
    _widgetBuilders[type] = builder;
  }

  Widget? buildWidget(RenderPaintNode node, ThemeEngine engine) {
    final builder = _widgetBuilders[node.type];
    return builder?.call(node, engine);
  }

  List<String> get registeredTypes => _widgetBuilders.keys.toList();
}
