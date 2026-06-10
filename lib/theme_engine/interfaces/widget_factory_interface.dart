import 'package:flutter/widgets.dart';

/// Interface for a widget layer factory.
abstract class IWidgetFactory {
  /// The type identifier for this widget factory (e.g., `"text"`, `"image"`).
  String get type;

  /// Builds a Flutter [Widget] for the given layer [properties].
  Widget build(Map<String, dynamic> properties, BuildContext context);

  /// Returns `true` if this factory can handle the given [type].
  bool supports(String type);
}
