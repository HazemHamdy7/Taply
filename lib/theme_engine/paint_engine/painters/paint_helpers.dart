import 'dart:ui' show Color, BlendMode, StrokeCap, StrokeJoin, TileMode;

Color? parseColor(String? hex) {
  if (hex == null || hex.isEmpty) return null;
  var h = hex;
  if (h.startsWith('#')) h = h.substring(1);
  if (h.length == 6) return Color(int.parse('FF$h', radix: 16));
  return Color(int.parse(h, radix: 16));
}

BlendMode parseBlendMode(String? mode) {
  if (mode == null) return BlendMode.srcOver;
  switch (mode) {
    case 'srcOver':    return BlendMode.srcOver;
    case 'srcIn':      return BlendMode.srcIn;
    case 'srcOut':     return BlendMode.srcOut;
    case 'srcATop':    return BlendMode.srcATop;
    case 'dstOver':    return BlendMode.dstOver;
    case 'dstIn':      return BlendMode.dstIn;
    case 'dstOut':     return BlendMode.dstOut;
    case 'dstATop':    return BlendMode.dstATop;
    case 'multiply':   return BlendMode.multiply;
    case 'screen':     return BlendMode.screen;
    case 'overlay':    return BlendMode.overlay;
    case 'darken':     return BlendMode.darken;
    case 'lighten':    return BlendMode.lighten;
    case 'colorDodge': return BlendMode.colorDodge;
    case 'colorBurn':  return BlendMode.colorBurn;
    case 'hardLight':  return BlendMode.hardLight;
    case 'softLight':  return BlendMode.softLight;
    case 'difference': return BlendMode.difference;
    case 'exclusion':  return BlendMode.exclusion;
    case 'hue':        return BlendMode.hue;
    case 'saturation': return BlendMode.saturation;
    case 'color':      return BlendMode.color;
    case 'luminosity': return BlendMode.luminosity;
    default:           return BlendMode.srcOver;
  }
}

StrokeCap parseStrokeCap(String? cap) {
  switch (cap) {
    case 'round':  return StrokeCap.round;
    case 'square': return StrokeCap.square;
    default:       return StrokeCap.butt;
  }
}

StrokeJoin parseStrokeJoin(String? join) {
  switch (join) {
    case 'round': return StrokeJoin.round;
    case 'bevel': return StrokeJoin.bevel;
    default:      return StrokeJoin.miter;
  }
}

double? parseDouble(dynamic value) => (value as num?)?.toDouble();
int? parseInt(dynamic value) => (value as num?)?.toInt();

TileMode parseTileMode(String? mode) {
  switch (mode) {
    case 'repeated': return TileMode.repeated;
    case 'mirrored': return TileMode.mirror;
    default:         return TileMode.clamp;
  }
}
