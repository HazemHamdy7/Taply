import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'template_model.dart';

class TemplatePainter extends CustomPainter {
  final TemplateModel template;
  final double scale;

  const TemplatePainter({required this.template, this.scale = 1.0});

  @override
  void paint(Canvas canvas, Size size) {
    final s = scale;
    final rect = Offset.zero & size;

    if (template.clipRadius > 0) {
      canvas.clipRRect(RRect.fromRectAndRadius(
        rect,
        Radius.circular(template.clipRadius * s),
      ));
    }

    Color parse(String? hex) {
      if (hex == null || hex == 'transparent') return Colors.transparent;
      if (hex == 'white') return Colors.white;
      if (hex == 'black') return Colors.black;
      String h = hex.replaceFirst('#', '');
      double alpha = 1.0;
      if (h.contains('@')) {
        final parts = h.split('@');
        h = parts[0];
        alpha = double.tryParse(parts[1]) ?? 1.0;
      }
      final value = int.tryParse(h, radix: 16) ?? 0;
      if (h.length <= 6) {
        return Color(value | 0xFF000000).withValues(alpha: alpha);
      }
      return Color(value).withValues(alpha: alpha);
    }

    Paint makeFill(Map<String, dynamic>? fill, Rect r) {
      final p = Paint()..style = PaintingStyle.fill;
      if (fill == null) return p;
      final kind = fill['kind'] as String?;
      if (kind == null) return p..color = parse(fill.toString());
      final colors = (fill['colors'] as List<dynamic>)
          .map((c) => parse(c as String))
          .toList();
      if (kind == 'linear') {
        final angle = (fill['angle'] as num?)?.toDouble() ?? 0;
        final a = angle * math.pi / 180;
        final dx = math.sin(a);
        final dy = math.cos(a);
        final scale = math.max(dx.abs(), dy.abs()).clamp(0.001, double.infinity);
        final stops = fill['stops'] as List<dynamic>?;
        p.shader = LinearGradient(
          colors: colors,
          stops: stops?.map((s) => (s as num).toDouble()).toList(),
          begin: Alignment(-dx / scale, dy / scale),
          end: Alignment(dx / scale, -dy / scale),
        ).createShader(r);
      } else if (kind == 'radial') {
        final focalX = (fill['focalX'] as num?)?.toDouble() ?? 0;
        final focalY = (fill['focalY'] as num?)?.toDouble() ?? 0;
        final radius = (fill['radius'] as num?)?.toDouble() ?? 1.0;
        p.shader = RadialGradient(
          colors: colors,
          focal: Alignment(focalX, focalY),
          radius: radius,
        ).createShader(r);
      }
      return p;
    }

    Paint makeStroke(String? strokeColor, double? strokeWidth) {
      final p = Paint()
        ..style = PaintingStyle.stroke
        ..color = parse(strokeColor)
        ..strokeWidth = (strokeWidth ?? 1) * s;
      return p;
    }

    for (final layer in template.paintLayers) {
      final extra = layer.extra;
      switch (layer.type) {
        case 'rect':
          canvas.drawRect(rect, makeFill(layer.fill, rect));
          break;

        case 'rrect': {
          final lx = (layer.x ?? 0) * s;
          final ly = (layer.y ?? 0) * s;
          final lw = (layer.w ?? 1000) * s;
          final lh = (layer.h ?? 600) * s;
          final r = (layer.br ?? 0) * s;
          final rrect = RRect.fromRectAndRadius(
            Rect.fromLTWH(lx, ly, lw, lh),
            Radius.circular(r),
          );
          if (layer.stroke != null) {
            canvas.drawRRect(rrect, makeStroke(layer.stroke, layer.strokeWidth));
          } else if (layer.fill != null) {
            canvas.drawRRect(rrect, makeFill(layer.fill, Rect.fromLTWH(lx, ly, lw, lh)));
          }
          break;
        }

        case 'line': {
          final x1 = (extra['x1'] as num?)?.toDouble() ?? 0;
          final y1 = (extra['y1'] as num?)?.toDouble() ?? 0;
          final x2 = (extra['x2'] as num?)?.toDouble() ?? 0;
          final y2 = (extra['y2'] as num?)?.toDouble() ?? 0;
          canvas.drawLine(
            Offset(x1 * s, y1 * s),
            Offset(x2 * s, y2 * s),
            makeStroke(layer.stroke, layer.strokeWidth),
          );
          break;
        }

        case 'grid': {
          final stepX = (extra['stepX'] as num?)?.toDouble() ?? 40;
          final stepY = (extra['stepY'] as num?)?.toDouble() ?? 40;
          final gridStroke = Paint()
            ..style = PaintingStyle.stroke
            ..color = parse(extra['color'] as String? ?? '#FFFFFF08')
            ..strokeWidth = (extra['strokeWidth'] as num?)?.toDouble() ?? 0.5 * s;
          for (double gx = 0; gx < template.width; gx += stepX) {
            canvas.drawLine(
              Offset(gx * s, 0),
              Offset(gx * s, template.height * s),
              gridStroke,
            );
          }
          for (double gy = 0; gy < template.height; gy += stepY) {
            canvas.drawLine(
              Offset(0, gy * s),
              Offset(template.width * s, gy * s),
              gridStroke,
            );
          }
          break;
        }

        case 'stripes': {
          final count = (extra['count'] as num?)?.toInt() ?? 0;
          final step = (extra['step'] as num?)?.toDouble() ?? 17;
          final stripePaint = Paint()
            ..color = parse(extra['color'] as String? ?? '#FFFFFF05')
            ..strokeWidth = (extra['strokeWidth'] as num?)?.toDouble() ?? 1 * s;
          for (int i = 0; i < count; i++) {
            final ix = i * step * s;
            canvas.drawLine(Offset(ix, 0), Offset(ix, template.height * s), stripePaint);
          }
          break;
        }

        case 'path': {
          final d = extra['d'] as String? ?? '';
          final path = _parseSvgPath(d, s);
          if (extra.containsKey('stroke')) {
            canvas.drawPath(path, makeStroke(extra['stroke'] as String?, (extra['strokeWidth'] as num?)?.toDouble()));
          } else if (layer.fill != null) {
            canvas.drawPath(path, makeFill(layer.fill, rect));
          }
          break;
        }

        case 'corner_ornament': {
          final cx = (layer.x ?? 0) * s;
          final cy = (layer.y ?? 0) * s;
          final sz = (extra['size'] as num?)?.toDouble() ?? 80 * s;
          final left = extra['left'] as bool? ?? true;
          final top = extra['top'] as bool? ?? true;
          final signX = left ? 1.0 : -1.0;
          final signY = top ? 1.0 : -1.0;
          final ox = cx + (left ? 0 : -sz);
          final oy = cy + (top ? 0 : -sz);
          final path = Path()
            ..moveTo(ox, oy + signY * sz * 0.25)
            ..lineTo(ox + signX * sz * 0.25, oy)
            ..moveTo(ox, oy + signY * sz * 0.4)
            ..lineTo(ox + signX * sz * 0.4, oy);
          canvas.drawPath(path, makeStroke(layer.stroke, layer.strokeWidth));
          break;
        }

        case 'circle': {
          final ccx = (extra['cx'] as num?)?.toDouble() ?? 0;
          final ccy = (extra['cy'] as num?)?.toDouble() ?? 0;
          final cr = (extra['r'] as num?)?.toDouble() ?? 10;
          final center = Offset(ccx * s, ccy * s);
          final radius = cr * s;
          final fillColor = extra['color'] as String?;
          if (fillColor != null && fillColor != 'transparent') {
            canvas.drawCircle(center, radius, Paint()..color = parse(fillColor));
          } else if (layer.fill != null) {
            canvas.drawCircle(center, radius, makeFill(layer.fill, Rect.fromCircle(center: center, radius: radius)));
          }
          if (layer.stroke != null) {
            canvas.drawCircle(center, radius, makeStroke(layer.stroke, layer.strokeWidth));
          }
          break;
        }

        case 'chevron': {
          final ccx = (extra['cx'] as num?)?.toDouble() ?? 0;
          final ccy = (extra['cy'] as num?)?.toDouble() ?? 0;
          final ch = (extra['height'] as num?)?.toDouble() ?? 80;
          final path = Path()
            ..moveTo(ccx * s, (ccy - ch / 2) * s)
            ..lineTo((ccx + ch) * s, ccy * s)
            ..lineTo(ccx * s, (ccy + ch / 2) * s);
          canvas.drawPath(path, makeStroke(layer.stroke, layer.strokeWidth));
          break;
        }

        case 'deco_lines': {
          final x1 = (extra['x1'] as num?)?.toDouble() ?? 0;
          final x2 = (extra['x2'] as num?)?.toDouble() ?? 0;
          final x1e = (extra['endY'] as num?)?.toDouble();
          final count = (extra['count'] as num?)?.toInt() ?? 0;
          final spacing = (extra['spacing'] as num?)?.toDouble() ?? 90;
          final startY = (extra['startY'] as num?)?.toDouble() ?? 100;
          final fade = extra['fade'] as bool? ?? false;
          for (int i = 0; i < count; i++) {
            final yy = (startY + i * spacing) * s;
            final dStroke = Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = (layer.strokeWidth ?? 1) * s;
            if (fade) {
              dStroke.shader = LinearGradient(
                colors: [
                  parse(layer.stroke).withValues(alpha: 0),
                  parse(layer.stroke).withValues(alpha: 0.6),
                  parse(layer.stroke).withValues(alpha: 0),
                ],
                stops: const [0, 0.5, 1],
              ).createShader(Rect.fromLTWH(0, 0, template.width * s, template.height * s));
            } else {
              dStroke.color = parse(layer.stroke);
            }
            canvas.drawLine(
              Offset(x1 * s, yy),
              Offset((x1e ?? x2) * s, yy),
              dStroke,
            );
          }
          break;
        }

        case 'fold': {
          final foldX = (extra['foldX'] as num?)?.toDouble() ?? 650 * s;
          final foldPath = Path()
            ..moveTo(foldX * s, 0)
            ..quadraticBezierTo(780 * s, 100 * s, 750 * s, 220 * s)
            ..quadraticBezierTo(710 * s, 320 * s, 740 * s, 400 * s)
            ..quadraticBezierTo(770 * s, 480 * s, 720 * s, template.height * s)
            ..lineTo(template.width * s, template.height * s)
            ..lineTo(template.width * s, 0)
            ..close();
          canvas.drawPath(foldPath, Paint()..color = parse(extra['foldColor'] as String? ?? '#E8DFC8'));
          break;
        }

        case 'fold_shadow': {
          final foldX = (extra['foldX'] as num?)?.toDouble() ?? 650 * s;
          final blur = (extra['blurSigma'] as num?)?.toDouble() ?? 12 * s;
          final shadowPath = Path()
            ..moveTo(foldX * s, 0)
            ..quadraticBezierTo(770 * s, 100 * s, 740 * s, 220 * s)
            ..quadraticBezierTo(700 * s, 320 * s, 730 * s, 400 * s)
            ..quadraticBezierTo(760 * s, 480 * s, 710 * s, template.height * s)
            ..lineTo(700 * s, template.height * s)
            ..quadraticBezierTo(750 * s, 480 * s, 720 * s, 400 * s)
            ..quadraticBezierTo(690 * s, 320 * s, 730 * s, 220 * s)
            ..quadraticBezierTo(760 * s, 100 * s, 640 * s, 0)
            ..close();
          final shadowPaint = Paint()
            ..color = parse(extra['color'] as String? ?? '#00000033')
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);
          canvas.drawPath(shadowPath, shadowPaint);
          break;
        }

        case 'fold_highlight': {
          final foldX = (extra['foldX'] as num?)?.toDouble() ?? 652 * s;
          final curlPath = Path()
            ..moveTo(foldX * s, 0)
            ..quadraticBezierTo(775 * s, 100 * s, 745 * s, 220 * s)
            ..quadraticBezierTo(705 * s, 320 * s, 735 * s, 400 * s)
            ..quadraticBezierTo(765 * s, 480 * s, 715 * s, template.height * s);
          final curlPaint = Paint()
            ..color = parse(extra['color'] as String? ?? '#FFFFFF14')
            ..style = PaintingStyle.stroke
            ..strokeWidth = (extra['strokeWidth'] as num?)?.toDouble() ?? 3 * s;
          canvas.drawPath(curlPath, curlPaint);
          break;
        }

        case 'diamonds': {
          final count = (extra['count'] as num?)?.toInt() ?? 0;
          final startX = (extra['startX'] as num?)?.toDouble() ?? 100;
          final spacing = (extra['spacing'] as num?)?.toDouble() ?? 200;
          final dy = (extra['y'] as num?)?.toDouble() ?? 550;
          final dSize = (extra['size'] as num?)?.toDouble() ?? 4;
          final diamondPaint = Paint()..color = parse(extra['color'] as String? ?? '#E8DFC8');
          for (int i = 0; i < count; i++) {
            final dx = (startX + i * spacing) * s;
            final dPath = Path()
              ..moveTo(dx, (dy - dSize) * s)
              ..lineTo((dx + dSize) * s, dy * s)
              ..lineTo(dx, (dy + dSize) * s)
              ..lineTo((dx - dSize) * s, dy * s)
              ..close();
            canvas.drawPath(dPath, diamondPaint);
          }
          break;
        }

        case 'gradient_rect': {
          final lx = (layer.x ?? 0) * s;
          final ly = (layer.y ?? 0) * s;
          final lw = (layer.w ?? 80) * s;
          final lh = (layer.h ?? 440) * s;
          canvas.drawRect(
            Rect.fromLTWH(lx, ly, lw, lh),
            makeFill(layer.fill, Rect.fromLTWH(lx, ly, lw, lh)),
          );
          break;
        }

        case 'fluting': {
          final startX = (extra['startX'] as num?)?.toDouble() ?? 37;
          final fluteCount = (extra['count'] as num?)?.toInt() ?? 3;
          final step = (extra['step'] as num?)?.toDouble() ?? 11;
          final y1 = (extra['y1'] as num?)?.toDouble() ?? 82;
          final y2 = (extra['y2'] as num?)?.toDouble() ?? 518;
          final flutePaint = Paint()
            ..style = PaintingStyle.stroke
            ..color = parse(layer.stroke)
            ..strokeWidth = (layer.strokeWidth ?? 1) * s;
          for (int i = 0; i < fluteCount; i++) {
            final fx = (startX + i * step) * s;
            canvas.drawLine(Offset(fx, y1 * s), Offset(fx, y2 * s), flutePaint);
          }
          break;
        }

        case 'particles': {
          final count = (extra['count'] as num?)?.toInt() ?? 300;
          final seed = (extra['seed'] as num?)?.toInt() ?? 42;
          final rng = math.Random(seed);
          final minR = (extra['minRadius'] as num?)?.toDouble() ?? 0.3;
          final maxR = (extra['maxRadius'] as num?)?.toDouble() ?? 3.8;
          final minA = (extra['minAlpha'] as num?)?.toDouble() ?? 0.15;
          final maxA = (extra['maxAlpha'] as num?)?.toDouble() ?? 0.7;
          final particleColor = parse(extra['color'] as String? ?? '#F7B547');
          for (int i = 0; i < count; i++) {
            final px = rng.nextDouble() * template.width * s;
            final py = rng.nextDouble() * template.height * s;
            final sizeFactor = rng.nextDouble();
            final radius = (minR + sizeFactor * (maxR - minR)) * s;
            final alphaF = (minA + sizeFactor * (maxA - minA)).clamp(0.0, 1.0);
            if (radius > 1.5 * s) {
              final glow = Paint()
                ..color = particleColor.withValues(alpha: alphaF * 0.2)
                ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 3);
              canvas.drawCircle(Offset(px, py), radius * 2, glow);
            }
            canvas.drawCircle(
              Offset(px, py),
              radius,
              Paint()..color = particleColor.withValues(alpha: alphaF),
            );
          }
          break;
        }

        case 'glow_bar': {
          final gy = (extra['y'] as num?)?.toDouble() ?? 520 * s;
          final gh = (extra['height'] as num?)?.toDouble() ?? 80 * s;
          final glowAlpha = (extra['alpha'] as num?)?.toDouble() ?? 0.12;
          final glowColor = parse(extra['color'] as String? ?? '#F7B547');
          final glowBarPaint = Paint()
            ..shader = LinearGradient(
              colors: [
                glowColor.withValues(alpha: 0),
                glowColor.withValues(alpha: glowAlpha),
                glowColor.withValues(alpha: 0),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ).createShader(Rect.fromLTWH(0, gy * s, template.width * s, gh * s));
          canvas.drawRect(Rect.fromLTWH(0, gy * s, template.width * s, gh * s), glowBarPaint);
          break;
        }
      }
    }
  }

  Path _parseSvgPath(String d, double s) {
    final path = Path();
    final re = RegExp(r'([MLQCZ])\s*([-\d.e]+)?\s*,?\s*([-\d.e]+)?'
        r'(?:\s+([-\d.e]+)\s*,?\s*([-\d.e]+))?'
        r'(?:\s+([-\d.e]+)\s*,?\s*([-\d.e]+))?',
        caseSensitive: false);
    final matches = re.allMatches(d);
    for (final m in matches) {
      final cmd = m.group(1)?.toUpperCase() ?? '';
      final nums = <double>[];
      for (int i = 2; i <= m.groupCount; i++) {
        final v = double.tryParse(m.group(i)?.replaceAll(',', '') ?? '');
        if (v != null) nums.add(v * s);
      }
      switch (cmd) {
        case 'M':
          if (nums.length >= 2) path.moveTo(nums[0], nums[1]);
          break;
        case 'L':
          if (nums.length >= 2) path.lineTo(nums[0], nums[1]);
          break;
        case 'Q':
          if (nums.length >= 4) path.quadraticBezierTo(nums[0], nums[1], nums[2], nums[3]);
          break;
        case 'C':
          if (nums.length >= 6) path.cubicTo(nums[0], nums[1], nums[2], nums[3], nums[4], nums[5]);
          break;
        case 'Z':
          path.close();
          break;
      }
    }
    return path;
  }

  @override
  bool shouldRepaint(covariant TemplatePainter oldDelegate) {
    return oldDelegate.template.id != template.id || oldDelegate.scale != scale;
  }
}
