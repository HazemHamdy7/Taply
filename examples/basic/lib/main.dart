import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';
import 'package:taply_theme_widgets/taply_theme_widgets.dart';

void main() => runApp(const BasicExampleApp());

class BasicExampleApp extends StatelessWidget {
  const BasicExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basic Theme Example',
      home: const BasicExampleScreen(),
    );
  }
}

class BasicExampleScreen extends StatefulWidget {
  const BasicExampleScreen({super.key});

  @override
  State<BasicExampleScreen> createState() => _BasicExampleScreenState();
}

class _BasicExampleScreenState extends State<BasicExampleScreen> {
  late final ThemeEngine _engine;
  late final PaintMetrics _metrics;
  late final ThemeDocument _theme;

  @override
  void initState() {
    super.initState();
    _engine = ThemeEngine();
    _metrics = _engine.createMetrics();
    _theme = _engine.loadThemeFromMap({
      'id': 'basic_theme',
      'name': 'Basic Theme',
      'width': 600,
      'height': 400,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Basic Theme Example')),
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
