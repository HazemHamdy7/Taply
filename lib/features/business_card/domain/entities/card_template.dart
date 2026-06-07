import 'package:flutter/material.dart';
import 'package:business_card/shared/template_engine/template_loader.dart';

class CardTemplate {
  final String id;
  final String name;
  final List<Color> gradientColors;
  final Color accentColor;
  final Color textColor;

  const CardTemplate({
    required this.id,
    required this.name,
    required this.gradientColors,
    required this.accentColor,
    required this.textColor,
  });

  static List<CardTemplate> get all {
    final jsonTemplates = TemplateLoader.all;
    if (jsonTemplates.isNotEmpty) {
      return jsonTemplates.map((t) {
        return CardTemplate(
          id: t.id,
          name: t.name,
          gradientColors: _gradientFor(t.id),
          accentColor: _accentFor(t.id),
          textColor: Colors.white,
        );
      }).toList();
    }
    return _fallback;
  }

  static const List<CardTemplate> _fallback = [
    CardTemplate(
      id: 'blue_gold_luxury',
      name: 'Blue Gold Luxury',
      gradientColors: [Color(0xFF08172F), Color(0xFF10284B)],
      accentColor: Color(0xFFD4A33B),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'dark_green_fold',
      name: 'Dark Green Fold',
      gradientColors: [Color(0xFF002B2E), Color(0xFF003F44)],
      accentColor: Color(0xFFE8DFC8),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'real_estate_gold',
      name: 'Real Estate Gold',
      gradientColors: [Color(0xFF0B1D36), Color(0xFF142E4A)],
      accentColor: Color(0xFFC99552),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'black_orange_premium',
      name: 'Black Orange Premium',
      gradientColors: [Color(0xFF000000), Color(0xFF1A1A1A)],
      accentColor: Color(0xFFF7931E),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'rose_gold_elegance',
      name: 'Rose Gold Elegance',
      gradientColors: [Color(0xFFFCF6F0), Color(0xFFF7EDE4)],
      accentColor: Color(0xFFC98787),
      textColor: Color(0xFF3D1C1C),
    ),
    CardTemplate(
      id: 'navy_silver_professional',
      name: 'Navy Silver Professional',
      gradientColors: [Color(0xFF0D1B2A), Color(0xFF1B2D45)],
      accentColor: Color(0xFFC8CFD8),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'champagne_gold_prestige',
      name: 'Champagne Gold Prestige',
      gradientColors: [Color(0xFF2D1B0E), Color(0xFF3D2616)],
      accentColor: Color(0xFFD4A55B),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'forest_emerald',
      name: 'Forest Emerald',
      gradientColors: [Color(0xFF0A1F14), Color(0xFF0D2818)],
      accentColor: Color(0xFFD4A840),
      textColor: Color(0xFFFFFFFF),
    ),
  ];

  static List<Color> _gradientFor(String id) {
    switch (id) {
      case 'blue_gold_luxury': return const [Color(0xFF08172F), Color(0xFF10284B)];
      case 'dark_green_fold': return const [Color(0xFF002B2E), Color(0xFF003F44)];
      case 'real_estate_gold': return const [Color(0xFF0B1D36), Color(0xFF142E4A)];
      case 'black_orange_premium': return const [Color(0xFF000000), Color(0xFF1A1A1A)];
      case 'rose_gold_elegance': return const [Color(0xFFFCF6F0), Color(0xFFF7EDE4)];
      case 'navy_silver_professional': return const [Color(0xFF0D1B2A), Color(0xFF1B2D45)];
      case 'champagne_gold_prestige': return const [Color(0xFF2D1B0E), Color(0xFF3D2616)];
      case 'forest_emerald': return const [Color(0xFF0A1F14), Color(0xFF0D2818)];
      default: return const [Color(0xFF1565C0), Color(0xFF1976D2)];
    }
  }

  static Color _accentFor(String id) {
    switch (id) {
      case 'blue_gold_luxury': return const Color(0xFFD4A33B);
      case 'dark_green_fold': return const Color(0xFFE8DFC8);
      case 'real_estate_gold': return const Color(0xFFC99552);
      case 'black_orange_premium': return const Color(0xFFF7931E);
      case 'rose_gold_elegance': return const Color(0xFFC98787);
      case 'navy_silver_professional': return const Color(0xFFC8CFD8);
      case 'champagne_gold_prestige': return const Color(0xFFD4A55B);
      case 'forest_emerald': return const Color(0xFFD4A840);
      default: return const Color(0xFFBBDEFB);
    }
  }

  static CardTemplate getById(String? id) {
    return all.firstWhere((t) => t.id == id, orElse: () => all.isNotEmpty ? all.first : _fallback.first);
  }
}
