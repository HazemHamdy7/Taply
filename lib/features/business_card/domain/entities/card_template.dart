import 'package:flutter/material.dart';

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

  static const List<CardTemplate> all = [
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
      id: 'template_05',
      name: 'White Minimal',
      gradientColors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
      accentColor: Color(0xFF333333),
      textColor: Color(0xFF000000),
    ),
    CardTemplate(
      id: 'template_06',
      name: 'Teal Modern',
      gradientColors: [Color(0xFF004D40), Color(0xFF00695C)],
      accentColor: Color(0xFF80CBC4),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'template_07',
      name: 'Purple Royal',
      gradientColors: [Color(0xFF2A004D), Color(0xFF4A148C)],
      accentColor: Color(0xFFE1BEE7),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'template_08',
      name: 'Red Dynamic',
      gradientColors: [Color(0xFF1A0000), Color(0xFFB71C1C)],
      accentColor: Color(0xFFFFCDD2),
      textColor: Color(0xFFFFFFFF),
    ),
    CardTemplate(
      id: 'default',
      name: 'Default',
      gradientColors: [Color(0xFF1565C0), Color(0xFF1976D2)],
      accentColor: Color(0xFFBBDEFB),
      textColor: Color(0xFFFFFFFF),
    ),
  ];

  static CardTemplate getById(String? id) {
    return all.firstWhere((t) => t.id == id, orElse: () => all.last);
  }
}
