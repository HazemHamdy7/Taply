import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';
import 'package:taply_theme_runtime/taply_theme_runtime.dart';
import 'package:taply_theme_widgets/taply_theme_widgets.dart';

void main() => runApp(const RuntimeExampleApp());

class RuntimeExampleApp extends StatelessWidget {
  const RuntimeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Runtime Example',
      home: const RuntimeExampleScreen(),
    );
  }
}

class RuntimeExampleScreen extends StatefulWidget {
  const RuntimeExampleScreen({super.key});

  @override
  State<RuntimeExampleScreen> createState() => _RuntimeExampleScreenState();
}

class _RuntimeExampleScreenState extends State<RuntimeExampleScreen> {
  late final ThemeEngine _engine;
  late final CardRuntime _runtime;
  late final ThemeDocument _theme;

  @override
  void initState() {
    super.initState();
    _engine = ThemeEngine();
    _runtime = CardRuntime(
      data: BusinessCardData(
        name: 'Jane Doe',
        title: 'Software Engineer',
        company: 'Taply',
        email: 'jane@example.com',
        phone: '+1-555-0123',
      ),
    );
    _theme = _engine.loadThemeFromMap({
      'id': 'runtime_theme',
      'name': 'Runtime Theme',
      'width': 600,
      'height': 400,
    });
  }

  void _updateData() {
    setState(() {
      _runtime.updateData(
        _runtime.data.copyWith(
          name: 'John Smith',
          title: 'Product Manager',
          company: 'Taply Inc.',
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Runtime Example')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: BusinessCardWidget(
                engine: _engine,
                document: _theme,
                runtime: _runtime,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _updateData,
              child: const Text('Update Card Data'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _runtime.dispose();
    _engine.dispose();
    super.dispose();
  }
}
