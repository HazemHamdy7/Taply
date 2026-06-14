import 'dart:math' show cos, sin;
import 'dart:ui' show Canvas, Paint, Color;
import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';
import 'package:taply_theme_widgets/taply_theme_widgets.dart';

void main() => runApp(const AdvancedExampleApp());

class AdvancedExampleApp extends StatelessWidget {
  const AdvancedExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Advanced Theme Example',
      home: const AdvancedExampleScreen(),
    );
  }
}

class StarPainter extends BasePainter {
  @override
  String get type => 'star';

  @override
  PaintCapabilities get capabilities => PaintCapabilities.basic;

  @override
  bool canPaint(RenderPaintNode node) => node.type == type;

  @override
  void initialize() {}

  @override
  void prepare(PaintContext context) {}

  @override
  PaintResult paint(PaintContext context) {
    final canvas = context.canvas;
    final paint = Paint()..color = const Color(0xFFFFD700);
    final path = _createStarPath(0, 0, 50, 5);
    canvas.drawPath(path, paint);
    return PaintResult(success: true, duration: Duration.zero);
  }

  Path _createStarPath(double cx, double cy, double radius, int points) {
    final path = Path();
    final angle = (-3.14159 / 2);
    final step = 3.14159 / points;
    for (var i = 0; i < points * 2; i++) {
      final r = i.isEven ? radius : radius * 0.4;
      final x = cx + r * cos(angle + i * step);
      final y = cy + r * sin(angle + i * step);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    return path;
  }

  @override
  void dispose() {}
}

class AdvancedExampleScreen extends StatefulWidget {
  const AdvancedExampleScreen({super.key});

  @override
  State<AdvancedExampleScreen> createState() => _AdvancedExampleScreenState();
}

class _AdvancedExampleScreenState extends State<AdvancedExampleScreen> {
  late final ThemeEngine _engine;
  late final PaintMetrics _metrics;
  late final ThemeDocument _theme;

  @override
  void initState() {
    super.initState();
    _engine = ThemeEngine();
    _engine.registerPainter(StarPainter());
    _metrics = _engine.createMetrics();
    _theme = _engine.loadThemeFromMap({
      'id': 'advanced_theme',
      'name': 'Advanced Theme',
      'width': 600,
      'height': 400,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Theme Example')),
      body: Center(
        child: CardEngineWidget(
          engine: _engine,
          document: _theme,
          metrics: _metrics,
          width: 600,
          height: 400,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}
