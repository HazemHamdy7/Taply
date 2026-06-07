import 'dart:convert';
import 'package:flutter/services.dart';
import 'template_model.dart';

class TemplateLoader {
  static final Map<String, TemplateModel> _cache = {};

  static TemplateModel? get(String id) => _cache[id];

  static List<TemplateModel> get all => _cache.values.toList();

  static TemplateModel? getById(String? id) {
    final t = _cache[id];
    if (t != null) return t;
    return _cache.values.isNotEmpty ? _cache.values.first : null;
  }

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
        _cache[id] = TemplateModel.fromJson(json);
      } catch (_) {}
    }
  }

  static List<TemplateModel> loadFallback() {
    return [
      TemplateModel(
        id: 'default',
        name: 'Default',
        width: 1000,
        height: 600,
        paintLayers: [
          PaintLayer(
            type: 'rect',
            fill: {'kind': 'linear', 'colors': ['#1565C0', '#1976D2'], 'angle': 135},
          ),
        ],
        widgetLayers: [
          WidgetLayer(type: 'text', field: 'fullName', x: 40, y: 80, fontSize: 26, color: '#FFFFFF', fontWeight: '700'),
          WidgetLayer(type: 'text', field: 'companyName', x: 40, y: 112, fontSize: 13, color: '#FFFFFF99', fontWeight: '500'),
          WidgetLayer(type: 'text', field: 'tagline', x: 40, y: 130, fontSize: 13, color: '#BBDEFB', fontWeight: '400'),
          WidgetLayer(type: 'text', field: 'jobTitle', x: 40, y: 150, fontSize: 13, color: '#FFFFFFE6', fontWeight: '500'),
          WidgetLayer(type: 'contact_row', field: 'mobileNumber', x: 40, y: 170, fontSize: 12, color: '#FFFFFFB3', fontWeight: '400', extra: {'icon': 'phone', 'iconColor': '#FFFFFFB3'}),
          WidgetLayer(type: 'contact_row', field: 'mobileNumber2', x: 40, y: 186, fontSize: 12, color: '#FFFFFFB3', fontWeight: '400', extra: {'icon': 'phone', 'iconColor': '#FFFFFFB3'}),
          WidgetLayer(type: 'contact_row', field: 'email', x: 40, y: 202, fontSize: 12, color: '#FFFFFFB3', fontWeight: '400', extra: {'icon': 'email', 'iconColor': '#FFFFFFB3'}),
          WidgetLayer(type: 'contact_row', field: 'website', x: 40, y: 218, fontSize: 12, color: '#FFFFFFB3', fontWeight: '400', extra: {'icon': 'language', 'iconColor': '#FFFFFFB3'}),
          WidgetLayer(type: 'contact_row', field: 'address', x: 40, y: 234, fontSize: 12, color: '#FFFFFFB3', fontWeight: '400', extra: {'icon': 'location_on', 'iconColor': '#FFFFFFB3', 'hideIfEmpty': true}),
        ],
      ),
    ];
  }
}
