import 'dart:io';
import 'package:flutter/material.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/domain/entities/card_template.dart';
import 'package:business_card/features/business_card/presentation/widgets/template_painters.dart';

class BusinessCardWidget extends StatelessWidget {
  final BusinessCard card;
  final double width;

  const BusinessCardWidget({super.key, required this.card, required this.width});

  static const double designWidth = 1000;
  static const double designHeight = 600;

  double get _s => width / designWidth;
  double get height => designHeight * _s;

  @override
  Widget build(BuildContext context) {
    final t = CardTemplate.getById(card.templateId);
    final painter = _getPainter(t.id);

    return SizedBox(
      width: width,
      height: height,
      child: painter != null
          ? Stack(
              children: [
                CustomPaint(size: Size(width, height), painter: painter),
                ..._buildOverlays(t, context),
              ],
            )
          : Stack(
              children: [
                _buildFallback(t),
                ..._buildOverlays(t, context),
              ],
            ),
    );
  }

  BaseCardPainter? _getPainter(String id) {
    switch (id) {
      case 'blue_gold_luxury':
        return const BlueGoldLuxuryPainter();
      case 'dark_green_fold':
        return const DarkGreenFoldPainter();
      case 'real_estate_gold':
        return const RealEstateGoldPainter();
      case 'black_orange_premium':
        return const BlackOrangePremiumPainter();
      default:
        return null;
    }
  }

  Widget _buildFallback(CardTemplate t) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20 * _s),
        gradient: LinearGradient(colors: t.gradientColors),
      ),
    );
  }

  TextDirection _detectDirection(String text) {
    if (text.runes.any((r) => r >= 0x0600 && r <= 0x06FF || r >= 0xFB50 && r <= 0xFDFF || r >= 0xFE70 && r <= 0xFEFF)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  List<Widget> _buildOverlays(CardTemplate t, BuildContext context) {
    switch (t.id) {
      case 'blue_gold_luxury':
        return _blueGoldOverlays();
      case 'dark_green_fold':
        return _darkGreenOverlays();
      case 'real_estate_gold':
        return _realEstateOverlays();
      case 'black_orange_premium':
        return _blackOrangeOverlays();
      default:
        return _defaultOverlays(t);
    }
  }

  // ── Blue Gold Luxury ──────────────────────────────────
  List<Widget> _blueGoldOverlays() {
    final dir = _detectDirection(card.fullName);
    final cx = dir == TextDirection.ltr ? 340.0 : 660.0;
    return [
      _logo(220.0, 220.0, 110.0),
      _text('fullName', cx, 280.0, 32.0, const Color(0xFFD4A33B), FontWeight.w700, dir),
      _text('companyName', cx, 318.0, 15.0, Colors.white70, FontWeight.w500, dir),
      _text('tagline', cx, 340.0, 14.0, const Color(0xFFD4A33B), FontWeight.w400, dir),
      _text('jobTitle', cx, 362.0, 16.0, Colors.white, FontWeight.w500, dir),
      if (dir == TextDirection.ltr) ...[
        _text('mobileNumber', 40.0, 455.0, 13.0, Colors.white60, FontWeight.w300, dir),
        _text('mobileNumber2', 40.0, 475.0, 13.0, Colors.white60, FontWeight.w300, dir),
        _text('email', 230.0, 455.0, 13.0, Colors.white60, FontWeight.w300, dir),
        _text('website', 230.0, 475.0, 13.0, Colors.white60, FontWeight.w300, dir),
      ] else ...[
        _text('mobileNumber', 520.0, 455.0, 13.0, Colors.white60, FontWeight.w300, dir),
        _text('mobileNumber2', 520.0, 475.0, 13.0, Colors.white60, FontWeight.w300, dir),
        _text('email', 250.0, 455.0, 13.0, Colors.white60, FontWeight.w300, dir),
        _text('website', 250.0, 475.0, 13.0, Colors.white60, FontWeight.w300, dir),
      ],
    ];
  }

  // ── Dark Green Fold ───────────────────────────────────
  List<Widget> _darkGreenOverlays() {
    final dir = _detectDirection(card.fullName);
    final cx = dir == TextDirection.ltr ? 160.0 : 100.0;
    return [
      if (card.profileImagePath != null || card.fullName.isNotEmpty)
        _logo(dir == TextDirection.ltr ? 160.0 : 600.0, 130.0, 100.0),
      if (dir == TextDirection.ltr) ...[
        _text('fullName', cx, 310.0, 30.0, Colors.white, FontWeight.w700, dir),
        _text('companyName', cx, 346.0, 14.0, Colors.white60, FontWeight.w500, dir),
        _text('tagline', cx, 366.0, 13.0, const Color(0xFFE8DFC8), FontWeight.w400, dir),
        _text('jobTitle', cx, 386.0, 16.0, Colors.white70, FontWeight.w400, dir),
      ] else ...[
        _text('fullName', cx, 310.0, 30.0, Colors.white, FontWeight.w700, dir),
        _text('companyName', cx, 346.0, 14.0, Colors.white60, FontWeight.w500, dir),
        _text('tagline', cx, 366.0, 13.0, const Color(0xFFE8DFC8), FontWeight.w400, dir),
        _text('jobTitle', cx, 386.0, 16.0, Colors.white70, FontWeight.w400, dir),
      ],
      // Contact info on the cream fold
      if (card.mobileNumber.isNotEmpty)
        Positioned(
          right: (dir == TextDirection.ltr ? 40.0 : 600.0) * _s,
          top: 60.0 * _s,
          child: _styledText(card.mobileNumber, 13.0, const Color(0xFF002B2E), FontWeight.w500, dir),
        ),
      if (card.mobileNumber2.isNotEmpty)
        Positioned(
          right: (dir == TextDirection.ltr ? 40.0 : 600.0) * _s,
          top: 82.0 * _s,
          child: _styledText(card.mobileNumber2, 12.0, const Color(0xFF002B2E).withValues(alpha: 0.7), FontWeight.w400, dir),
        ),
      if (card.email.isNotEmpty)
        Positioned(
          right: (dir == TextDirection.ltr ? 40.0 : 600.0) * _s,
          top: 104.0 * _s,
          child: _styledText(card.email, 12.0, const Color(0xFF002B2E).withValues(alpha: 0.7), FontWeight.w400, dir),
        ),
      if (card.website.isNotEmpty)
        Positioned(
          right: (dir == TextDirection.ltr ? 40.0 : 600.0) * _s,
          top: 126.0 * _s,
          child: _styledText(card.website, 12.0, const Color(0xFF002B2E).withValues(alpha: 0.7), FontWeight.w400, dir),
        ),
      // Social dots on the fold
      Positioned(
        right: (dir == TextDirection.ltr ? 55.0 : 665.0) * _s,
        top: 270.0 * _s,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (card.linkedin.isNotEmpty) _socialDot(const Color(0xFF0A66C2)),
            if (card.instagram.isNotEmpty) _socialDot(const Color(0xFFE4405F)),
            if (card.facebook.isNotEmpty) _socialDot(const Color(0xFF1877F2)),
            if (card.x.isNotEmpty) _socialDot(const Color(0xFF000000)),
          ].map((d) => Padding(padding: EdgeInsets.only(bottom: 14.0 * _s), child: d)).toList(),
        ),
      ),
    ];
  }

  Widget _socialDot(Color c) {
    return Container(
      width: 12 * _s,
      height: 12 * _s,
      decoration: BoxDecoration(
        color: c,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5 * _s),
      ),
    );
  }

  // ── Real Estate Gold ──────────────────────────────────
  List<Widget> _realEstateOverlays() {
    final dir = _detectDirection(card.fullName);
    final leftContent = dir == TextDirection.ltr;
    final cx = leftContent ? 130.0 : 500.0;
    return [
      _logo(leftContent ? 650.0 : 350.0, 280.0, 240.0),
      _text('fullName', cx, 140.0, 34.0, Colors.white, FontWeight.w700, dir),
      _text('companyName', cx, 180.0, 16.0, const Color(0xFFC99552), FontWeight.w600, dir),
      _text('tagline', cx, 205.0, 14.0, const Color(0xFFC99552), FontWeight.w400, dir),
      _text('jobTitle', cx, 228.0, 15.0, Colors.white70, FontWeight.w500, dir),
      _contactRow(Icons.phone_outlined, card.mobileNumber, cx, 270.0, dir),
      _contactRow(Icons.phone_outlined, card.mobileNumber2, cx, 300.0, dir),
      _contactRow(Icons.email_outlined, card.email, cx, 330.0, dir),
      _contactRow(Icons.language_outlined, card.website, cx, 360.0, dir),
      if (card.address.isNotEmpty)
        _contactRow(Icons.location_on_outlined, card.address, cx, 390.0, dir),
    ];
  }

  Widget _contactRow(IconData icon, String text, double x, double y, TextDirection dir) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Positioned(
      left: x * _s,
      top: y * _s,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: dir,
        children: [
          Icon(icon, size: 15 * _s, color: const Color(0xFFC99552)),
          SizedBox(width: 8 * _s),
          _styledText(text, 14, Colors.white70, FontWeight.w400, dir),
        ],
      ),
    );
  }

  // ── Black Orange Premium ──────────────────────────────
  List<Widget> _blackOrangeOverlays() {
    final dir = _detectDirection(card.fullName);
    final cx = dir == TextDirection.ltr ? 300.0 : 60.0;
    return [
      _logo(dir == TextDirection.ltr ? 160.0 : 840.0, 200.0, 150.0),
      _text('fullName', cx, 120.0, 30.0, Colors.white, FontWeight.w700, dir),
      _text('companyName', cx, 156.0, 14.0, Colors.white60, FontWeight.w500, dir),
      _text('tagline', cx, 176.0, 14.0, const Color(0xFFF7931E), FontWeight.w400, dir),
      _text('jobTitle', cx, 198.0, 16.0, const Color(0xFFF7931E), FontWeight.w600, dir),
      Positioned(
        left: cx * _s,
        top: 240.0 * _s,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (card.mobileNumber.isNotEmpty) _orangeInfoRow(Icons.phone_outlined, card.mobileNumber, dir),
            if (card.mobileNumber2.isNotEmpty) _orangeInfoRow(Icons.phone_outlined, card.mobileNumber2, dir),
            if (card.email.isNotEmpty) _orangeInfoRow(Icons.email_outlined, card.email, dir),
            if (card.website.isNotEmpty) _orangeInfoRow(Icons.language_outlined, card.website, dir),
            if (card.address.isNotEmpty) _orangeInfoRow(Icons.location_on_outlined, card.address, dir),
          ],
        ),
      ),
    ];
  }

  Widget _orangeInfoRow(IconData icon, String text, TextDirection dir) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10 * _s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: dir,
        children: [
          Icon(icon, size: 15 * _s, color: const Color(0xFFF7931E)),
          SizedBox(width: 8 * _s),
          _styledText(text, 14, Colors.white70, FontWeight.w400, dir),
        ],
      ),
    );
  }

  // ── Default fallback overlays ─────────────────────────
  List<Widget> _defaultOverlays(CardTemplate t) {
    final dir = _detectDirection(card.fullName);
    return [
      _defaultHeader(t, dir),
    ];
  }

  Widget _defaultHeader(CardTemplate t, TextDirection dir) {
    return Positioned(
      left: (dir == TextDirection.ltr ? 40 : 160) * _s,
      top: 80 * _s,
      child: Directionality(
        textDirection: dir,
        child: Column(
          crossAxisAlignment: dir == TextDirection.ltr ? CrossAxisAlignment.start : CrossAxisAlignment.end,
          children: [
            if (card.profileImagePath != null)
              CircleAvatar(
                radius: 60 * _s,
                backgroundImage: FileImage(File(card.profileImagePath!)),
              ),
            if (card.profileImagePath == null && card.fullName.isNotEmpty)
              CircleAvatar(
                radius: 60 * _s,
                backgroundColor: t.accentColor.withValues(alpha: 0.2),
                child: Icon(Icons.person, size: 46 * _s, color: t.accentColor),
              ),
            SizedBox(height: 12 * _s),
            _styledText(card.fullName, 26, t.textColor, FontWeight.w700, dir),
            if (card.companyName.isNotEmpty) ...[
              SizedBox(height: 2 * _s),
              _styledText(card.companyName, 13, t.textColor.withValues(alpha: 0.6), FontWeight.w500, dir),
            ],
            if (card.tagline.isNotEmpty) ...[
              SizedBox(height: 2 * _s),
              _styledText(card.tagline, 13, t.accentColor, FontWeight.w400, dir),
            ],
            if (card.jobTitle.isNotEmpty) ...[
              SizedBox(height: 4 * _s),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12 * _s, vertical: 2 * _s),
                decoration: BoxDecoration(
                  color: t.textColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14 * _s),
                ),
                child: _styledText(card.jobTitle, 13, t.textColor.withValues(alpha: 0.9), FontWeight.w500, dir),
              ),
            ],
            SizedBox(height: 10 * _s),
            if (card.mobileNumber.isNotEmpty) _infoRow(Icons.phone, card.mobileNumber, t.textColor.withValues(alpha: 0.7), dir),
            if (card.mobileNumber2.isNotEmpty) _infoRow(Icons.phone, card.mobileNumber2, t.textColor.withValues(alpha: 0.7), dir),
            if (card.email.isNotEmpty) _infoRow(Icons.email, card.email, t.textColor.withValues(alpha: 0.7), dir),
            if (card.website.isNotEmpty) _infoRow(Icons.language, card.website, t.textColor.withValues(alpha: 0.7), dir),
            if (card.address.isNotEmpty) _infoRow(Icons.location_on, card.address, t.textColor.withValues(alpha: 0.7), dir),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text, Color color, TextDirection dir) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2 * _s),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: dir,
        children: [
          Icon(icon, size: 14 * _s, color: color),
          SizedBox(width: 6 * _s),
          _styledText(text, 12, color, FontWeight.w400, dir),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────
  Widget _text(String field, double x, double y, double fontSize, Color color, FontWeight fw, TextDirection dir) {
    final v = _fieldValue(field);
    if (v.isEmpty) return const SizedBox.shrink();
    return Positioned(
      left: x * _s,
      top: y * _s,
      child: _styledText(v, fontSize, color, fw, dir),
    );
  }

  String _fieldValue(String field) {
    switch (field) {
      case 'fullName': return card.fullName;
      case 'jobTitle': return card.jobTitle;
      case 'companyName': return card.companyName;
      case 'tagline': return card.tagline;
      case 'mobileNumber': return card.mobileNumber;
      case 'mobileNumber2': return card.mobileNumber2;
      case 'email': return card.email;
      case 'website': return card.website;
      default: return '';
    }
  }

  Widget _styledText(String text, double fontSize, Color color, FontWeight fw, TextDirection dir) {
    return Directionality(
      textDirection: dir,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize * _s,
          color: color,
          fontWeight: fw,
          letterSpacing: 0.3 * _s,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _logo(double x, double y, double size) {
    return Positioned(
      left: (x - size / 2) * _s,
      top: (y - size / 2) * _s,
      child: CircleAvatar(
        radius: size / 2 * _s,
        backgroundColor: Colors.white,
        backgroundImage: card.profileImagePath != null
            ? FileImage(File(card.profileImagePath!))
            : null,
        child: card.profileImagePath == null
            ? Icon(Icons.person, size: size * 0.45 * _s, color: Colors.grey.shade400)
            : null,
      ),
    );
  }
}
