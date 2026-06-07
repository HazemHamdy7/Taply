import 'dart:math';
import 'package:flutter/material.dart';

const double _cw = 1000;
const double _ch = 600;

abstract class BaseCardPainter extends CustomPainter {
  const BaseCardPainter();

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ───────────────────────────────────────
// 1. BLUE GOLD LUXURY
// ───────────────────────────────────────
class BlueGoldLuxuryPainter extends BaseCardPainter {
  const BlueGoldLuxuryPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / _cw;
    canvas.clipRRect(RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(32 * s),
    ));

    // Base gradient
    final bg = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF060F26), Color(0xFF0D1F4A), Color(0xFF162D5E)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, bg);

    // Radial vignette
    final vignette = Paint()
      ..shader = RadialGradient(
        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
        focal: const Alignment(0.3, 0.2),
        focalRadius: 0.3,
        radius: 1.2,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, vignette);

    final gold = Paint()
      ..color = const Color(0xFFD4A33B)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 * s;
    final goldThin = Paint()
      ..color = const Color(0xFFD4A33B).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5 * s;
    // Outer border frame
    final frame = RRect.fromRectAndRadius(
      Rect.fromLTWH(16 * s, 16 * s, _cw * s - 32 * s, _ch * s - 32 * s),
      Radius.circular(20 * s),
    );
    canvas.drawRRect(frame, gold);

    // Inner thin frame
    final innerFrame = RRect.fromRectAndRadius(
      Rect.fromLTWH(24 * s, 24 * s, _cw * s - 48 * s, _ch * s - 48 * s),
      Radius.circular(14 * s),
    );
    canvas.drawRRect(innerFrame, goldThin);

    // Corner ornaments
    _drawCornerOrnament(canvas, 16 * s, 16 * s, 80 * s, gold, true, true, s);
    _drawCornerOrnament(canvas, _cw * s - 16 * s, 16 * s, 80 * s, gold, false, true, s);
    _drawCornerOrnament(canvas, 16 * s, _ch * s - 16 * s, 80 * s, gold, true, false, s);
    _drawCornerOrnament(canvas, _cw * s - 16 * s, _ch * s - 16 * s, 80 * s, gold, false, false, s);

    // Left chevron ornament
    final chevPath = Path();
    final cy = _ch * s / 2;
    chevPath.moveTo(120 * s, cy - 80 * s);
    chevPath.lineTo(220 * s, cy);
    chevPath.lineTo(120 * s, cy + 80 * s);
    canvas.drawPath(chevPath, gold);
    final chevPath2 = Path();
    chevPath2.moveTo(140 * s, cy - 60 * s);
    chevPath2.lineTo(210 * s, cy);
    chevPath2.lineTo(140 * s, cy + 60 * s);
    canvas.drawPath(chevPath2, goldThin);

    // Right decorative lines
    final rightLine = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFD4A33B).withValues(alpha: 0),
          const Color(0xFFD4A33B).withValues(alpha: 0.6),
          const Color(0xFFD4A33B).withValues(alpha: 0),
        ],
        stops: const [0, 0.5, 1],
      ).createShader(Rect.fromLTWH(0, 0, _cw * s, _ch * s));
    rightLine.style = PaintingStyle.stroke;
    rightLine.strokeWidth = 1.5 * s;
    for (int i = 0; i < 5; i++) {
      final yy = 100 * s + i * 90 * s;
      canvas.drawLine(Offset(700 * s, yy), Offset(_cw * s - 30 * s, yy), rightLine);
    }

    // Bottom gold accent line
    final bottomLine = Paint()
      ..color = const Color(0xFFD4A33B).withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawLine(
      Offset(40 * s, _ch * s - 50 * s),
      Offset(_cw * s - 40 * s, _ch * s - 50 * s),
      bottomLine,
    );
  }

  void _drawCornerOrnament(Canvas c, double x, double y, double size, Paint p,
      bool left, bool top, double s) {
    final path = Path();
    final signX = left ? 1.0 : -1.0;
    final signY = top ? 1.0 : -1.0;
    final cx = x + (left ? 0 : -size);
    final cy = y + (top ? 0 : -size);

    path.moveTo(cx, cy + signY * size * 0.25);
    path.lineTo(cx + signX * size * 0.25, cy);
    path.moveTo(cx, cy + signY * size * 0.4);
    path.lineTo(cx + signX * size * 0.4, cy);
    c.drawPath(path, p);
  }
}

// ───────────────────────────────────────
// 2. DARK GREEN FOLD
// ───────────────────────────────────────
class DarkGreenFoldPainter extends BaseCardPainter {
  const DarkGreenFoldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / _cw;
    canvas.clipRRect(RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(30 * s),
    ));

    // Base dark green
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF002B2E));

    // Subtle vertical stripe texture
    final stripe = Paint()
      ..color = Colors.white.withValues(alpha: 0.02);
    for (int i = 0; i < 60; i++) {
      canvas.drawLine(
        Offset(i * 17 * s, 0),
        Offset(i * 17 * s, _ch * s),
        stripe,
      );
    }

    // Paper fold — cream panel on the right
    final foldPath = Path();
    foldPath.moveTo(650 * s, 0);
    foldPath.quadraticBezierTo(780 * s, 100 * s, 750 * s, 220 * s);
    foldPath.quadraticBezierTo(710 * s, 320 * s, 740 * s, 400 * s);
    foldPath.quadraticBezierTo(770 * s, 480 * s, 720 * s, _ch * s);
    foldPath.lineTo(_cw * s, _ch * s);
    foldPath.lineTo(_cw * s, 0);
    foldPath.close();

    final foldPaint = Paint()..color = const Color(0xFFE8DFC8);
    canvas.drawPath(foldPath, foldPaint);

    // Fold edge shadow
    final shadowPath = Path();
    shadowPath.moveTo(650 * s, 0);
    shadowPath.quadraticBezierTo(770 * s, 100 * s, 740 * s, 220 * s);
    shadowPath.quadraticBezierTo(700 * s, 320 * s, 730 * s, 400 * s);
    shadowPath.quadraticBezierTo(760 * s, 480 * s, 710 * s, _ch * s);
    shadowPath.lineTo(700 * s, _ch * s);
    shadowPath.quadraticBezierTo(750 * s, 480 * s, 720 * s, 400 * s);
    shadowPath.quadraticBezierTo(690 * s, 320 * s, 730 * s, 220 * s);
    shadowPath.quadraticBezierTo(760 * s, 100 * s, 640 * s, 0);
    shadowPath.close();

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 12);
    canvas.drawPath(shadowPath, shadowPaint);

    // Curl highlight
    final curlPath = Path();
    curlPath.moveTo(652 * s, 0);
    curlPath.quadraticBezierTo(775 * s, 100 * s, 745 * s, 220 * s);
    curlPath.quadraticBezierTo(705 * s, 320 * s, 735 * s, 400 * s);
    curlPath.quadraticBezierTo(765 * s, 480 * s, 715 * s, _ch * s);
    final curlPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3 * s;
    canvas.drawPath(curlPath, curlPaint);

    // Bottom decorative line (cream)
    final decoPaint = Paint()
      ..color = const Color(0xFFE8DFC8).withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawLine(
      Offset(30 * s, _ch * s - 50 * s),
      Offset(600 * s, _ch * s - 50 * s),
      decoPaint,
    );

    // Small diamond ornaments on the bottom line
    final diamondPaint = Paint()
      ..color = const Color(0xFFE8DFC8)
      ..style = PaintingStyle.fill;
    for (int i = 0; i < 3; i++) {
      final dx = 100 * s + i * 200 * s;
      final dy = _ch * s - 50 * s;
      final dPath = Path()
        ..moveTo(dx, dy - 4 * s)
        ..lineTo(dx + 4 * s, dy)
        ..lineTo(dx, dy + 4 * s)
        ..lineTo(dx - 4 * s, dy)
        ..close();
      canvas.drawPath(dPath, diamondPaint);
    }
  }
}

// ───────────────────────────────────────
// 3. REAL ESTATE GOLD
// ───────────────────────────────────────
class RealEstateGoldPainter extends BaseCardPainter {
  const RealEstateGoldPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / _cw;
    canvas.clipRRect(RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(30 * s),
    ));

    // Dark navy base
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF09162E));

    // Subtle grid pattern
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5 * s;
    for (int x = 0; x < _cw; x += 40) {
      canvas.drawLine(Offset(x * s, 0), Offset(x * s, _ch * s), gridPaint);
    }
    for (int y = 0; y < _ch; y += 40) {
      canvas.drawLine(Offset(0, y * s), Offset(_cw * s, y * s), gridPaint);
    }

    // Gold column on the left
    final colGradient = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFC99552),
          const Color(0xFFE8C97A),
          const Color(0xFFB88632),
          const Color(0xFFD4A85C),
        ],
        stops: const [0, 0.3, 0.6, 1],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, 80 * s, _ch * s));
    canvas.drawRect(Rect.fromLTWH(30 * s, 80 * s, 45 * s, _ch * s - 160 * s), colGradient);

    // Column capital (top)
    final capitalPath = Path()
      ..moveTo(20 * s, 80 * s)
      ..lineTo(85 * s, 80 * s)
      ..lineTo(95 * s, 60 * s)
      ..lineTo(10 * s, 60 * s)
      ..close();
    canvas.drawPath(capitalPath, colGradient);

    // Column base (bottom)
    final basePath = Path()
      ..moveTo(20 * s, _ch * s - 80 * s)
      ..lineTo(85 * s, _ch * s - 80 * s)
      ..lineTo(95 * s, _ch * s - 60 * s)
      ..lineTo(10 * s, _ch * s - 60 * s)
      ..close();
    canvas.drawPath(basePath, colGradient);

    // Column vertical fluting lines
    final flutePaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * s;
    for (int i = 0; i < 3; i++) {
      final fx = 37 * s + i * 11 * s;
      canvas.drawLine(
        Offset(fx, 82 * s),
        Offset(fx, _ch * s - 82 * s),
        flutePaint,
      );
    }

    // Top gold header line
    final headerLine = Paint()
      ..color = const Color(0xFFC99552).withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawLine(
      Offset(130 * s, 55 * s),
      Offset(_cw * s - 30 * s, 55 * s),
      headerLine,
    );

    // Bottom gold header line
    canvas.drawLine(
      Offset(130 * s, 70 * s),
      Offset(_cw * s - 30 * s, 70 * s),
      Paint()
        ..color = const Color(0xFFC99552).withValues(alpha: 0.3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1 * s,
    );

    // Right side gold pattern — vertical thin lines
    final rightDeco = Paint()
      ..color = const Color(0xFFC99552).withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1 * s;
    for (int i = 0; i < 8; i++) {
      final rx = _cw * s - 50 * s + i * 4 * s;
      canvas.drawLine(
        Offset(rx, 100 * s),
        Offset(rx, _ch * s - 100 * s),
        rightDeco,
      );
    }

    // Bottom gold accent
    final bottomAccent = Paint()
      ..color = const Color(0xFFC99552).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawLine(
      Offset(130 * s, _ch * s - 50 * s),
      Offset(_cw * s - 30 * s, _ch * s - 50 * s),
      bottomAccent,
    );
  }
}

// ───────────────────────────────────────
// 4. BLACK ORANGE PREMIUM
// ───────────────────────────────────────
class BlackOrangePremiumPainter extends BaseCardPainter {
  const BlackOrangePremiumPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / _cw;
    canvas.clipRRect(RRect.fromRectAndRadius(
      Offset.zero & size,
      Radius.circular(30 * s),
    ));

    // Black base
    canvas.drawRect(Offset.zero & size, Paint()..color = const Color(0xFF0A0A0A));

    // Diagonal gradient overlay
    final overlay = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFF7B547).withValues(alpha: 0.06),
          Colors.transparent,
          const Color(0xFFF7B547).withValues(alpha: 0.03),
        ],
        stops: const [0, 0.5, 1],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Offset.zero & size);
    canvas.drawRect(Offset.zero & size, overlay);

    // Particles with glow
    final rng = Random(42);
    for (int i = 0; i < 300; i++) {
      final px = rng.nextDouble() * _cw * s;
      final py = rng.nextDouble() * _ch * s;
      final sizeFactor = rng.nextDouble();
      final radius = (sizeFactor * 3.5 + 0.3) * s;
      final alphaF = (sizeFactor * 0.55 + 0.15).clamp(0.0, 1.0);

      // Glow
      if (radius > 1.5 * s) {
        final glow = Paint()
          ..color = const Color(0xFFF7B547).withValues(alpha: alphaF * 0.2)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * 3);
        canvas.drawCircle(Offset(px, py), radius * 2, glow);
      }

      // Core
      final paint = Paint()
        ..color = const Color(0xFFF7B547).withValues(alpha: alphaF);
      canvas.drawCircle(Offset(px, py), radius, paint);
    }

    // Bottom glow bar
    final glowBar = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFFF7B547).withValues(alpha: 0),
          const Color(0xFFF7B547).withValues(alpha: 0.12),
          const Color(0xFFF7B547).withValues(alpha: 0),
        ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ).createShader(Rect.fromLTWH(0, _ch * s - 80 * s, _cw * s, 80 * s));
    canvas.drawRect(
      Rect.fromLTWH(0, _ch * s - 80 * s, _cw * s, 80 * s),
      glowBar,
    );

    // Top accent line
    final topLine = Paint()
      ..color = const Color(0xFFF7B547).withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s;
    canvas.drawLine(
      Offset(30 * s, 55 * s),
      Offset(_cw * s - 30 * s, 55 * s),
      topLine,
    );

    // Bottom accent line
    canvas.drawLine(
      Offset(30 * s, _ch * s - 55 * s),
      Offset(_cw * s - 30 * s, _ch * s - 55 * s),
      topLine,
    );
  }
}
