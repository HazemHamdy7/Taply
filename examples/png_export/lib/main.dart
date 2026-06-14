import 'dart:io';
import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';
import 'package:taply_theme_widgets/taply_theme_widgets.dart';

void main() => runApp(const PngExportExampleApp());

class PngExportExampleApp extends StatelessWidget {
  const PngExportExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PNG Export Example',
      home: const PngExportExampleScreen(),
    );
  }
}

class PngExportExampleScreen extends StatefulWidget {
  const PngExportExampleScreen({super.key});

  @override
  State<PngExportExampleScreen> createState() => _PngExportExampleScreenState();
}

class _PngExportExampleScreenState extends State<PngExportExampleScreen> {
  late final ThemeEngine _engine;
  final CardScreenshotService _screenshotService =
      CardScreenshotService(engine: ThemeEngine());
  late final PaintMetrics _metrics;
  late final ThemeDocument _theme;
  String? _exportPath;

  @override
  void initState() {
    super.initState();
    _theme = _engine.loadThemeFromMap({
      'id': 'export_theme',
      'name': 'Export Theme',
      'width': 600,
      'height': 400,
    });
    _metrics = _engine.createMetrics();
  }

  Future<void> _exportPng() async {
    final bytes = await _screenshotService.renderToImage(
      _theme,
      width: 600,
      height: 400,
      pixelRatio: 2.0,
    );

    final dir = Directory('exports');
    if (!await dir.exists()) {
      await dir.create();
    }

    final file = File('${dir.path}/card_export.png');
    await file.writeAsBytes(bytes);
    setState(() => _exportPath = file.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('PNG Export Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CardEngineWidget(
              engine: _engine,
              document: _theme,
              metrics: _metrics,
              width: 300,
              height: 200,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _exportPng,
              child: const Text('Export as PNG'),
            ),
            if (_exportPath != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Saved to: $_exportPath'),
              ),
          ],
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
