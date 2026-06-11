import 'package:meta/meta.dart';

@immutable
class PaintCapabilities {
  final bool supportsOpacity;
  final bool supportsTransform;
  final bool supportsGradient;
  final bool supportsStroke;
  final bool supportsShadow;
  final bool supportsClipping;
  final bool supportsBlendMode;

  const PaintCapabilities({
    this.supportsOpacity = true,
    this.supportsTransform = true,
    this.supportsGradient = false,
    this.supportsStroke = false,
    this.supportsShadow = false,
    this.supportsClipping = false,
    this.supportsBlendMode = false,
  });

  static const PaintCapabilities basic = PaintCapabilities();

  static const PaintCapabilities advanced = PaintCapabilities(
    supportsGradient: true,
    supportsStroke: true,
    supportsShadow: true,
    supportsClipping: true,
    supportsBlendMode: true,
  );

  static const PaintCapabilities none = PaintCapabilities(
    supportsOpacity: false,
    supportsTransform: false,
  );

  PaintCapabilities copyWith({
    bool? supportsOpacity,
    bool? supportsTransform,
    bool? supportsGradient,
    bool? supportsStroke,
    bool? supportsShadow,
    bool? supportsClipping,
    bool? supportsBlendMode,
  }) {
    return PaintCapabilities(
      supportsOpacity: supportsOpacity ?? this.supportsOpacity,
      supportsTransform: supportsTransform ?? this.supportsTransform,
      supportsGradient: supportsGradient ?? this.supportsGradient,
      supportsStroke: supportsStroke ?? this.supportsStroke,
      supportsShadow: supportsShadow ?? this.supportsShadow,
      supportsClipping: supportsClipping ?? this.supportsClipping,
      supportsBlendMode: supportsBlendMode ?? this.supportsBlendMode,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is PaintCapabilities &&
      supportsOpacity == other.supportsOpacity &&
      supportsTransform == other.supportsTransform &&
      supportsGradient == other.supportsGradient &&
      supportsStroke == other.supportsStroke &&
      supportsShadow == other.supportsShadow &&
      supportsClipping == other.supportsClipping &&
      supportsBlendMode == other.supportsBlendMode;

  @override
  int get hashCode => Object.hash(
        supportsOpacity,
        supportsTransform,
        supportsGradient,
        supportsStroke,
        supportsShadow,
        supportsClipping,
        supportsBlendMode,
      );

  @override
  String toString() {
    final flags = <String>[];
    if (supportsOpacity) flags.add('opacity');
    if (supportsTransform) flags.add('transform');
    if (supportsGradient) flags.add('gradient');
    if (supportsStroke) flags.add('stroke');
    if (supportsShadow) flags.add('shadow');
    if (supportsClipping) flags.add('clipping');
    if (supportsBlendMode) flags.add('blendMode');
    return 'PaintCapabilities(${flags.join(', ')})';
  }
}
