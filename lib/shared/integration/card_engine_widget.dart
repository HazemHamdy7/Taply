import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/theme_engine/renderer/render_node.dart';
import 'package:business_card/theme_engine/renderer/render_tree.dart';
import 'package:business_card/theme_engine/runtime/card_runtime.dart';
import 'business_card_data_adapter.dart';
import 'template_theme_loader.dart';

class CardEngineWidget extends StatefulWidget {
  final BusinessCard card;
  final double width;

  const CardEngineWidget({super.key, required this.card, required this.width});

  static const double designWidth = 1000;
  static const double designHeight = 600;

  @override
  State<CardEngineWidget> createState() => _CardEngineWidgetState();
}

class _CardEngineWidgetState extends State<CardEngineWidget> {
  CardRuntimeResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _render();
  }

  @override
  void didUpdateWidget(CardEngineWidget old) {
    super.didUpdateWidget(old);
    if (widget.card.templateId != old.card.templateId ||
        widget.card.fullName != old.card.fullName) {
      _render();
    }
  }

  void _render() {
    final doc = TemplateThemeLoader.get(widget.card.templateId);
    if (doc == null) {
      setState(() => _error = 'Template "${widget.card.templateId}" not found');
      return;
    }

    final runtime = CardRuntime();
    runtime.setDocument(doc);
    runtime.setCardData(BusinessCardDataAdapter.toEngineData(widget.card));

    try {
      final result = runtime.render(
        viewportWidth: CardEngineWidget.designWidth,
        viewportHeight: CardEngineWidget.designHeight,
      );
      setState(() {
        _result = result;
        _error = null;
      });
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  double get _scale => widget.width / CardEngineWidget.designWidth;
  double get _height => CardEngineWidget.designHeight * _scale;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return SizedBox(
        width: widget.width,
        height: _height,
        child: Center(
          child: Text(_error!, style: const TextStyle(color: Colors.red, fontSize: 12)),
        ),
      );
    }

    if (_result == null) {
      return SizedBox(
        width: widget.width,
        height: _height,
        child: const Center(child: SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2))),
      );
    }

    return SizedBox(
      width: widget.width,
      height: _height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            CustomPaint(
              size: Size(widget.width, _height),
              painter: _PicturePainter(_result!.picture),
            ),
            ..._buildWidgetNodes(_result!.renderTree),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildWidgetNodes(RenderTree tree) {
    final card = widget.card;
    final scale = _scale;
    final dir = _detectDirection(card.fullName);
    final nodes = tree.flatten().whereType<RenderWidgetNode>().toList();
    nodes.sort((a, b) => a.zIndex.compareTo(b.zIndex));

    final widgets = <Widget>[];
    for (final node in nodes) {
      final w = _buildWidgetNode(node, card, scale, dir);
      if (w != null) widgets.add(w);
    }
    return widgets;
  }

  Widget? _buildWidgetNode(RenderWidgetNode node, BusinessCard card, double scale, TextDirection dir) {
    switch (node.type) {
      case 'image':
        return _buildImage(node, card, scale, dir);
      case 'text':
        return _buildText(node, card, scale, dir);
      case 'contact_row':
        return _buildContactRow(node, card, scale, dir);
      case 'info_column':
        return _buildInfoColumn(node, card, scale, dir);
      case 'contact_on_fold':
        return _buildContactOnFold(node, card, scale, dir);
      case 'social_dots':
        return _buildSocialDots(node, card, scale, dir);
    }
    return null;
  }

  Widget? _buildImage(RenderWidgetNode node, BusinessCard card, double scale, TextDirection dir) {
    final size = (node.size ?? 100) * scale / 2;
    final x = (dir == TextDirection.ltr ? node.x : (node.properties['rtlX'] as num? ?? node.x).toDouble()) * scale;
    final y = node.y * scale;
    final path = card.profileImagePath;

    return Positioned(
      left: x - size,
      top: y - size,
      child: CircleAvatar(
        radius: size,
        backgroundColor: Colors.white,
        backgroundImage: path != null ? FileImage(File(path)) : null,
        child: path == null
            ? Icon(Icons.person, size: size * 0.9, color: Colors.grey.shade400)
            : null,
      ),
    );
  }

  Widget? _buildText(RenderWidgetNode node, BusinessCard card, double scale, TextDirection dir) {
    final v = _val(card, node.field);
    if (v.isEmpty) return null;
    return Positioned(
      left: (dir == TextDirection.ltr ? node.x : (node.properties['rtlX'] as num? ?? node.x).toDouble()) * scale,
      top: node.y * scale,
      child: _styledText(v, (node.fontSize ?? 14) * scale, _parse(node.color), _fw(node.fontWeight), dir, maxLines: node.maxLines?.toInt()),
    );
  }

  Widget? _buildContactRow(RenderWidgetNode node, BusinessCard card, double scale, TextDirection dir) {
    final v = _val(card, node.field);
    final hideEmpty = node.properties['hideIfEmpty'] as bool? ?? false;
    if (v.isEmpty) {
      if (hideEmpty) return null;
      return null;
    }
    if (v.isEmpty) return null;

    return Positioned(
      left: (dir == TextDirection.ltr ? node.x : (node.properties['rtlX'] as num? ?? node.x).toDouble()) * scale,
      top: node.y * scale,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: dir,
        children: [
          Icon(_icon(node.properties['icon'] as String? ?? 'phone_outlined'),
              size: 15 * scale, color: _parse(node.properties['iconColor'] as String?)),
          SizedBox(width: 8 * scale),
          _styledText(v, (node.fontSize ?? 14) * scale, _parse(node.color), _fw(node.fontWeight), dir),
        ],
      ),
    );
  }

  Widget? _buildInfoColumn(RenderWidgetNode node, BusinessCard card, double scale, TextDirection dir) {
    final fields = (node.properties['fields'] as List<dynamic>?)?.cast<String>() ?? [];
    final icons = (node.properties['icons'] as List<dynamic>?)?.cast<String>() ?? [];
    final spacing = (node.properties['spacing'] as num?)?.toDouble() ?? 10;
    final children = <Widget>[];
    for (int i = 0; i < fields.length; i++) {
      final fv = _val(card, fields[i]);
      if (fv.isEmpty && fields[i] == 'address') continue;
      if (fv.isEmpty) continue;
      children.add(Padding(
        padding: EdgeInsets.only(bottom: spacing * scale),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: dir,
          children: [
            Icon(_icon(i < icons.length ? icons[i] : 'phone_outlined'),
                size: 15 * scale, color: _parse(node.properties['iconColor'] as String?)),
            SizedBox(width: 8 * scale),
            _styledText(fv, (node.fontSize ?? 14) * scale, _parse(node.color), _fw(node.fontWeight), dir),
          ],
        ),
      ));
    }
    if (children.isEmpty) return null;
    return Positioned(
      left: (dir == TextDirection.ltr ? node.x : (node.properties['rtlX'] as num? ?? node.x).toDouble()) * scale,
      top: node.y * scale,
      child: Column(
        crossAxisAlignment: dir == TextDirection.ltr ? CrossAxisAlignment.start : CrossAxisAlignment.end,
        textDirection: dir,
        children: children,
      ),
    );
  }

  Widget? _buildContactOnFold(RenderWidgetNode node, BusinessCard card, double scale, TextDirection dir) {
    final fields = (node.properties['fields'] as List<dynamic>?)?.cast<String>() ?? [];
    final colors = (node.properties['colors'] as List<dynamic>?)?.map((c) => _parse(c as String)).toList() ?? [];
    final fontSizes = (node.properties['fontSizes'] as List<dynamic>?)?.map((s) => (s as num).toDouble()).toList() ?? [];
    final fontWeights = (node.properties['fontWeights'] as List<dynamic>?)?.map((s) => _fw(s as String)).toList() ?? [];
    final children = <Widget>[];
    for (int i = 0; i < fields.length; i++) {
      final fv = _val(card, fields[i]);
      if (fv.isEmpty) continue;
      children.add(_styledText(
        fv,
        (i < fontSizes.length ? fontSizes[i] : 12) * scale,
        i < colors.length ? colors[i] : Colors.black,
        i < fontWeights.length ? fontWeights[i] : FontWeight.w400,
        dir,
      ));
    }
    if (children.isEmpty) return null;
    final contactX = dir == TextDirection.ltr
        ? (node.x - 960 + 40) * scale
        : (node.properties['rtlX'] as num? ?? node.x).toDouble() * scale;
    return Positioned(
      left: contactX,
      top: node.y * scale,
      child: Column(
        crossAxisAlignment: dir == TextDirection.ltr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        textDirection: dir,
        children: children,
      ),
    );
  }

  Widget? _buildSocialDots(RenderWidgetNode node, BusinessCard card, double scale, TextDirection dir) {
    final fields = (node.properties['fields'] as List<dynamic>?)?.cast<String>() ?? [];
    final dotColors = (node.properties['colors'] as List<dynamic>?)?.map((c) => _parse(c as String)).toList() ?? [];
    final spacing = (node.properties['spacing'] as num?)?.toDouble() ?? 14;
    final dotSize = (node.properties['dotSize'] as num?)?.toDouble() ?? 12;
    final children = <Widget>[];
    for (int i = 0; i < fields.length; i++) {
      final fv = _val(card, fields[i]);
      if (fv.isEmpty) continue;
      children.add(Container(
        width: dotSize * scale,
        height: dotSize * scale,
        margin: EdgeInsets.only(bottom: spacing * scale),
        decoration: BoxDecoration(
          color: i < dotColors.length ? dotColors[i] : Colors.grey,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5 * scale),
        ),
      ));
    }
    if (children.isEmpty) return null;
    return Positioned(
      left: (dir == TextDirection.ltr ? node.x : (node.properties['rtlX'] as num? ?? node.x).toDouble()) * scale,
      top: node.y * scale,
      child: Column(
        crossAxisAlignment: dir == TextDirection.ltr ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        textDirection: dir,
        children: children,
      ),
    );
  }

  static TextDirection _detectDirection(String text) {
    if (text.runes.any((r) =>
        r >= 0x0600 && r <= 0x06FF ||
        r >= 0xFB50 && r <= 0xFDFF ||
        r >= 0xFE70 && r <= 0xFEFF)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  static String _val(BusinessCard card, String? field) {
    if (field == null) return '';
    switch (field) {
      case 'fullName': return card.fullName;
      case 'jobTitle': return card.jobTitle;
      case 'companyName': return card.companyName;
      case 'tagline': return card.tagline;
      case 'mobileNumber': return card.mobileNumber;
      case 'mobileNumber2': return card.mobileNumber2;
      case 'whatsappNumber': return card.whatsappNumber;
      case 'email': return card.email;
      case 'website': return card.website;
      case 'linkedin': return card.linkedin;
      case 'facebook': return card.facebook;
      case 'instagram': return card.instagram;
      case 'telegram': return card.telegram;
      case 'youtube': return card.youtube;
      case 'x': return card.x;
      case 'address': return card.address;
      case 'aboutMe': return card.aboutMe;
      default: return '';
    }
  }

  static Color _parse(String? hex) {
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

  static FontWeight _fw(String? w) {
    switch (w) {
      case '300': return FontWeight.w300;
      case '400': return FontWeight.w400;
      case '500': return FontWeight.w500;
      case '600': return FontWeight.w600;
      case '700': return FontWeight.w700;
      default: return FontWeight.w400;
    }
  }

  static IconData _icon(String name) {
    switch (name) {
      case 'phone': case 'phone_outlined': return Icons.phone_outlined;
      case 'email': case 'email_outlined': return Icons.email_outlined;
      case 'language': case 'language_outlined': return Icons.language_outlined;
      case 'location_on': case 'location_on_outlined': return Icons.location_on_outlined;
      default: return Icons.circle;
    }
  }

  static Widget _styledText(String text, double fontSize, Color color, FontWeight fw, TextDirection dir, {int? maxLines}) {
    if (text.isEmpty) return const SizedBox.shrink();
    return Directionality(
      textDirection: dir,
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          color: color,
          fontWeight: fw,
          letterSpacing: 0.3,
        ),
        maxLines: maxLines ?? 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _PicturePainter extends CustomPainter {
  final ui.Picture picture;
  const _PicturePainter(this.picture);

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPicture(picture);
  }

  @override
  bool shouldRepaint(_PicturePainter old) => old.picture != picture;
}
