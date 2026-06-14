import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:business_card/theme_engine/models/theme_document.dart';
import 'template_to_theme_converter.dart';

class TemplateThemeLoader {
  TemplateThemeLoader._();

  static final Map<String, ThemeDocument> _cache = {};

  static ThemeDocument? get(String id) => _cache[id];

  static List<ThemeDocument> get all => _cache.values.toList();

  static bool get isLoaded => _cache.isNotEmpty;

  static Future<void> loadAll() async {
    if (_cache.isNotEmpty) return;

    final ids = [
      'blue_gold_luxury',
      'dark_green_fold',
      'real_estate_gold',
      'black_orange_premium',
      'rose_gold_elegance',
      'navy_silver_professional',
      'champagne_gold_prestige',
      'forest_emerald',
    ];

    for (final id in ids) {
      try {
        final jsonStr = await rootBundle.loadString('assets/templates/$id.json');
        final json = jsonDecode(jsonStr) as Map<String, dynamic>;
        _cache[id] = TemplateToThemeConverter.convert(json);
      } catch (_) {}
    }
  }
}
