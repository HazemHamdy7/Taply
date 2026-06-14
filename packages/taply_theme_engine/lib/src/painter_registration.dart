import '../taply_theme_engine.dart';

/// Configuration for registering a custom painter with the engine.
class PainterRegistration {
  final String type;
  final BasePainter Function() factory;

  const PainterRegistration({
    required this.type,
    required this.factory,
  });
}
