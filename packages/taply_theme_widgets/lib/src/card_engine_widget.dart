import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';

/// A Flutter widget that renders a theme using the paint engine.
///
/// This is the core rendering widget that bridges the engine to Flutter's
/// rendering pipeline.
class CardEngineWidget extends StatelessWidget {
  final ThemeEngine engine;
  final ThemeDocument document;
  final PaintMetrics metrics;
  final double width;
  final double height;

  const CardEngineWidget({
    super.key,
    required this.engine,
    required this.document,
    required this.metrics,
    this.width = 600,
    this.height = 400,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        size: Size(width, height),
        painter: _CardEnginePainter(
          engine: engine,
          document: document,
          metrics: metrics,
        ),
      ),
    );
  }
}

class _CardEnginePainter extends CustomPainter {
  final ThemeEngine engine;
  final ThemeDocument document;
  final PaintMetrics metrics;

  _CardEnginePainter({
    required this.engine,
    required this.document,
    required this.metrics,
  });

  @override
  void paint(Canvas canvas, Size size) {
    engine.render(document, metrics, canvas,
        viewportWidth: size.width, viewportHeight: size.height);
  }

  @override
  bool shouldRepaint(_CardEnginePainter oldDelegate) => true;
}
