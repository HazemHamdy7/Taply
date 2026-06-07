import 'dart:io';
import 'package:flutter/material.dart';
import 'template_model.dart';
import 'template_loader.dart';
import 'template_painter.dart';

class TemplateRenderer extends StatelessWidget {
  final String templateId;
  final Map<String, String> fieldValues;
  final double width;
  final String? profileImagePath;

  const TemplateRenderer({
    super.key,
    required this.templateId,
    required this.fieldValues,
    required this.width,
    this.profileImagePath,
  });

  static const double designWidth = 1000;
  static const double designHeight = 600;

  double get _s => width / designWidth;
  double get height => designHeight * _s;

  @override
  Widget build(BuildContext context) {
    final template = TemplateLoader.getById(templateId);
    if (template == null) return const SizedBox.shrink();

    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(
            size: Size(width, height),
            painter: TemplatePainter(template: template, scale: _s),
          ),
          ..._buildWidgetLayers(template),
        ],
      ),
    );
  }

  TextDirection _detectDirection(String text) {
    if (text.runes.any((r) =>
        r >= 0x0600 && r <= 0x06FF ||
        r >= 0xFB50 && r <= 0xFDFF ||
        r >= 0xFE70 && r <= 0xFEFF)) {
      return TextDirection.rtl;
    }
    return TextDirection.ltr;
  }

  String _val(String field) => fieldValues[field] ?? '';

  Color _parse(String? hex) {
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

  FontWeight _fw(String? w) {
    switch (w) {
      case '300': return FontWeight.w300;
      case '400': return FontWeight.w400;
      case '500': return FontWeight.w500;
      case '600': return FontWeight.w600;
      case '700': return FontWeight.w700;
      default: return FontWeight.w400;
    }
  }

  IconData _icon(String name) {
    switch (name) {
      case 'phone': case 'phone_outlined': return Icons.phone_outlined;
      case 'email': case 'email_outlined': return Icons.email_outlined;
      case 'language': case 'language_outlined': return Icons.language_outlined;
      case 'location_on': case 'location_on_outlined': return Icons.location_on_outlined;
      default: return Icons.circle;
    }
  }

  Widget _styledText(String text, double fontSize, Color color, FontWeight fw, TextDirection dir, {int? maxLines}) {
    if (text.isEmpty) return const SizedBox.shrink();
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
        maxLines: maxLines ?? 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  List<Widget> _buildWidgetLayers(TemplateModel template) {
    final dir = _detectDirection(_val('fullName'));
    final widgets = <Widget>[];

    for (final layer in template.widgetLayers) {
      Widget? w;
      final extra = layer.extra;

      switch (layer.type) {
        case 'image': {
          final size = (layer.size ?? 100) * _s / 2;
          w = Positioned(
            left: (dir == TextDirection.ltr ? layer.x - (layer.size ?? 100) / 2 : (layer.rtlX ?? 0) - (layer.size ?? 100) / 2) * _s,
            top: (layer.y - (layer.size ?? 100) / 2) * _s,
            child: CircleAvatar(
              radius: size,
              backgroundColor: Colors.white,
              backgroundImage: profileImagePath != null
                  ? FileImage(File(profileImagePath!))
                  : null,
              child: profileImagePath == null
                  ? Icon(Icons.person, size: size * 0.9, color: Colors.grey.shade400)
                  : null,
            ),
          );
          break;
        }

        case 'text': {
          final v = _val(layer.field ?? '');
          if (v.isEmpty) continue;
          w = Positioned(
            left: (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * _s,
            top: layer.y * _s,
            child: _styledText(
              v,
              layer.fontSize ?? 14,
              _parse(layer.color),
              _fw(layer.fontWeight),
              dir,
              maxLines: layer.maxLines?.toInt(),
            ),
          );
          break;
        }

        case 'contact_row': {
          final v = _val(layer.field ?? '');
          final hideEmpty = extra['hideIfEmpty'] as bool? ?? false;
          if (v.isEmpty) {
            if (hideEmpty) continue;
            break;
          }
          w = Positioned(
            left: (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * _s,
            top: layer.y * _s,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: dir,
              children: [
                Icon(_icon(extra['icon'] as String? ?? 'phone_outlined'),
                    size: 15 * _s, color: _parse(extra['iconColor'] as String?)),
                SizedBox(width: 8 * _s),
                _styledText(v, layer.fontSize ?? 14, _parse(layer.color),
                    _fw(layer.fontWeight), dir),
              ],
            ),
          );
          break;
        }

        case 'info_column': {
          final fields = (extra['fields'] as List<dynamic>?)?.cast<String>() ?? [];
          final icons = (extra['icons'] as List<dynamic>?)?.cast<String>() ?? [];
          final spacing = (extra['spacing'] as num?)?.toDouble() ?? 10;
          final children = <Widget>[];
          for (int i = 0; i < fields.length; i++) {
            final fv = _val(fields[i]);
            if (fv.isEmpty && fields[i] == 'address') continue;
            if (fv.isEmpty) continue;
            children.add(
              Padding(
                padding: EdgeInsets.only(bottom: spacing * _s),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  textDirection: dir,
                  children: [
                    Icon(_icon(i < icons.length ? icons[i] : 'phone_outlined'),
                        size: 15 * _s, color: _parse(extra['iconColor'] as String?)),
                    SizedBox(width: 8 * _s),
                    _styledText(fv, layer.fontSize ?? 14, _parse(layer.color),
                        _fw(layer.fontWeight), dir),
                  ],
                ),
              ),
            );
          }
          if (children.isEmpty) continue;
          w = Positioned(
            left: (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * _s,
            top: layer.y * _s,
            child: Column(
              crossAxisAlignment: dir == TextDirection.ltr
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.end,
              textDirection: dir,
              children: children,
            ),
          );
          break;
        }

        case 'contact_on_fold': {
          final fields = (extra['fields'] as List<dynamic>?)?.cast<String>() ?? [];
          final colors = (extra['colors'] as List<dynamic>?)?.map((c) => _parse(c as String)).toList() ?? [];
          final fontSizes = (extra['fontSizes'] as List<dynamic>?)?.map((s) => (s as num).toDouble()).toList() ?? [];
          final fontWeights = (extra['fontWeights'] as List<dynamic>?)?.map((s) => _fw(s as String)).toList() ?? [];
          final children = <Widget>[];
          for (int i = 0; i < fields.length; i++) {
            final fv = _val(fields[i]);
            if (fv.isEmpty) continue;
            children.add(
              _styledText(
                fv,
                i < fontSizes.length ? fontSizes[i] : 12,
                i < colors.length ? colors[i] : Colors.black,
                i < fontWeights.length ? fontWeights[i] : FontWeight.w400,
                dir,
              ),
            );
          }
          if (children.isEmpty) continue;
          final contactX = dir == TextDirection.ltr ? (layer.x - 960 + 40) : layer.effectiveX;
          final contactY = layer.y;
          w = Positioned(
            left: contactX * _s,
            top: contactY * _s,
            child: Column(
              crossAxisAlignment: dir == TextDirection.ltr
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              textDirection: dir,
              children: children,
            ),
          );
          break;
        }

        case 'social_dots': {
          final fields = (extra['fields'] as List<dynamic>?)?.cast<String>() ?? [];
          final dotColors = (extra['colors'] as List<dynamic>?)?.map((c) => _parse(c as String)).toList() ?? [];
          final spacing = (extra['spacing'] as num?)?.toDouble() ?? 14;
          final dotSize = (extra['dotSize'] as num?)?.toDouble() ?? 12;
          final children = <Widget>[];
          for (int i = 0; i < fields.length; i++) {
            final fv = _val(fields[i]);
            if (fv.isEmpty) continue;
            children.add(
              Container(
                width: dotSize * _s,
                height: dotSize * _s,
                margin: EdgeInsets.only(bottom: spacing * _s),
                decoration: BoxDecoration(
                  color: i < dotColors.length ? dotColors[i] : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                    width: 1.5 * _s,
                  ),
                ),
              ),
            );
          }
          if (children.isEmpty) continue;
          w = Positioned(
            left: (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * _s,
            top: layer.y * _s,
            child: Column(
              crossAxisAlignment: dir == TextDirection.ltr
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              textDirection: dir,
              children: children,
            ),
          );
          break;
        }
      }

      if (w != null) widgets.add(w);
    }

    return widgets;
  }
}
