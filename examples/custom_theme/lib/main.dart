import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';
import 'package:taply_theme_widgets/taply_theme_widgets.dart';

void main() => runApp(const CustomThemeExampleApp());

class CustomThemeExampleApp extends StatelessWidget {
  const CustomThemeExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom Theme Example',
      home: const CustomThemeExampleScreen(),
    );
  }
}

class _ThemeOption {
  final String name;
  final Map<String, dynamic> json;

  const _ThemeOption({required this.name, required this.json});
}

class CustomThemeExampleScreen extends StatefulWidget {
  const CustomThemeExampleScreen({super.key});

  @override
  State<CustomThemeExampleScreen> createState() =>
      _CustomThemeExampleScreenState();
}

class _CustomThemeExampleScreenState extends State<CustomThemeExampleScreen> {
  late final ThemeEngine _engine;
  late final PaintMetrics _metrics;
  late ThemeDocument _currentTheme;

  final List<_ThemeOption> _themes = [
    _ThemeOption(
      name: 'Dark Theme',
      json: {
        'id': 'dark',
        'name': 'Dark Theme',
        'width': 600,
        'height': 400,
      },
    ),
    _ThemeOption(
      name: 'Light Theme',
      json: {
        'id': 'light',
        'name': 'Light Theme',
        'width': 600,
        'height': 400,
      },
    ),
    _ThemeOption(
      name: 'Colorful Theme',
      json: {
        'id': 'colorful',
        'name': 'Colorful Theme',
        'width': 600,
        'height': 400,
      },
    ),
  ];

  @override
  void initState() {
    super.initState();
    _engine = ThemeEngine();
    _metrics = _engine.createMetrics();
    _currentTheme = _engine.loadThemeFromMap(_themes.first.json);
  }

  void _selectTheme(_ThemeOption option) {
    setState(() {
      _currentTheme = _engine.loadThemeFromMap(option.json);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom Theme Example')),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CardEngineWidget(
                engine: _engine,
                document: _currentTheme,
                metrics: _metrics,
              ),
            ),
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _themes.length,
              itemBuilder: (context, index) {
                final theme = _themes[index];
                final isSelected =
                    _currentTheme.metadata.id == theme.json['id'];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: ChoiceChip(
                    label: Text(theme.name),
                    selected: isSelected,
                    onSelected: (_) => _selectTheme(theme),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _engine.dispose();
    super.dispose();
  }
}
