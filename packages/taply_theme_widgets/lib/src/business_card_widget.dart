import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';
import 'package:taply_theme_runtime/taply_theme_runtime.dart';

import 'card_engine_widget.dart';

/// A complete business card widget with runtime data binding.
///
/// Combines the theme engine renderer with runtime data resolution.
class BusinessCardWidget extends StatefulWidget {
  final ThemeEngine engine;
  final ThemeDocument document;
  final CardRuntime runtime;
  final double width;
  final double height;

  const BusinessCardWidget({
    super.key,
    required this.engine,
    required this.document,
    required this.runtime,
    this.width = 600,
    this.height = 400,
  });

  @override
  State<BusinessCardWidget> createState() => _BusinessCardWidgetState();
}

class _BusinessCardWidgetState extends State<BusinessCardWidget> {
  late final PaintMetrics _metrics;

  @override
  void initState() {
    super.initState();
    _metrics = widget.engine.createMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return CardEngineWidget(
      engine: widget.engine,
      document: widget.document,
      metrics: _metrics,
      width: widget.width,
      height: widget.height,
    );
  }

  @override
  void dispose() {
    widget.runtime.dispose();
    super.dispose();
  }
}
