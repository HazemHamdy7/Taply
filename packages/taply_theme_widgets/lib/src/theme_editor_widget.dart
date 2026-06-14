import 'package:flutter/material.dart';
import 'package:taply_theme_engine/taply_theme_engine.dart';

/// A widget for selecting and previewing themes.
class ThemeEditorWidget extends StatelessWidget {
  final List<ThemeDocument> themes;
  final ThemeDocument? selectedTheme;
  final ValueChanged<ThemeDocument>? onThemeSelected;

  const ThemeEditorWidget({
    super.key,
    required this.themes,
    this.selectedTheme,
    this.onThemeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: themes.length,
      itemBuilder: (context, index) {
        final theme = themes[index];
        final isSelected = theme.metadata.id == selectedTheme?.metadata.id;
        return ListTile(
          title: Text(theme.metadata.name),
          subtitle: Text(theme.metadata.id),
          selected: isSelected,
          onTap: () => onThemeSelected?.call(theme),
        );
      },
    );
  }
}
