import 'package:flutter/material.dart';

IconData getIconData(String iconName) {
  switch (iconName) {
    case 'work':
      return Icons.work;
    case 'code':
      return Icons.code;
    case 'trending_up':
      return Icons.trending_up;
    case 'palette':
      return Icons.palette;
    case 'handshake':
      return Icons.handshake;
    case 'people':
      return Icons.people;
    case 'star':
      return Icons.star;
    case 'favorite':
      return Icons.favorite;
    case 'business':
      return Icons.business;
    case 'school':
      return Icons.school;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'sports_esports':
      return Icons.sports_esports;
    case 'music_note':
      return Icons.music_note;
    case 'restaurant':
      return Icons.restaurant;
    case 'flight':
      return Icons.flight;
    case 'shopping_cart':
      return Icons.shopping_cart;
    case 'home':
      return Icons.home;
    case 'pets':
      return Icons.pets;
    default:
      return Icons.label_outline;
  }
}

const List<String> availableIconNames = [
  'label_outline',
  'work',
  'code',
  'trending_up',
  'palette',
  'handshake',
  'people',
  'star',
  'favorite',
  'business',
  'school',
  'health_and_safety',
  'sports_esports',
  'music_note',
  'restaurant',
  'flight',
  'shopping_cart',
  'home',
  'pets',
];

const List<int> availableColors = [
  0xFF4CAF50,
  0xFF2196F3,
  0xFF9C27B0,
  0xFFFF5722,
  0xFFFF9800,
  0xFFE91E63,
  0xFFF44336,
  0xFF00BCD4,
  0xFF795548,
  0xFF607D8B,
  0xFF3F51B5,
  0xFF009688,
];
