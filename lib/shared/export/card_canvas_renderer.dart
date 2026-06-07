import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/shared/template_engine/template_loader.dart';
import 'package:business_card/shared/template_engine/template_model.dart';
import 'package:business_card/shared/template_engine/template_painter.dart';
import 'package:business_card/shared/template_engine/template_renderer.dart';

class CardCanvasRenderer {
  CardCanvasRenderer._();

  static const double _designW = TemplateRenderer.designWidth;
  static const double _designH = TemplateRenderer.designHeight;

  static Future<Uint8List?> render({
    required BusinessCard card,
    double targetWidth = 1080,
  }) async {
    final template = TemplateLoader.getById(card.templateId);
    if (template == null) return null;

    final scale = targetWidth / _designW;
    final height = _designH * scale;

    ui.Image? profileImage;
    if (card.profileImagePath != null && File(card.profileImagePath!).existsSync()) {
      final bytes = File(card.profileImagePath!).readAsBytesSync();
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      profileImage = frame.image;
      codec.dispose();
    }

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder, Rect.fromLTWH(0, 0, targetWidth, height));

    final painter = TemplatePainter(template: template, scale: scale);
    painter.paint(canvas, Size(targetWidth, height));

    final dir = _detectDirection(card.fullName);

    for (final layer in template.widgetLayers) {
      _paintLayer(canvas, layer, card, profileImage, scale, dir);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(targetWidth.round(), height.round());
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    return data?.buffer.asUint8List();
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

  static double _iconSize(double scale) => 15 * scale;

  static IconData _iconData(String name) {
    switch (name) {
      case 'phone': case 'phone_outlined': return Icons.phone_outlined;
      case 'email': case 'email_outlined': return Icons.email_outlined;
      case 'language': case 'language_outlined': return Icons.language_outlined;
      case 'location_on': case 'location_on_outlined': return Icons.location_on_outlined;
      default: return Icons.circle;
    }
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

  static void _paintLayer(
    Canvas canvas,
    WidgetLayer layer,
    BusinessCard card,
    ui.Image? profileImage,
    double scale,
    TextDirection dir,
  ) {
    final extra = layer.extra;

    switch (layer.type) {
      case 'image':
        _paintImage(canvas, layer, profileImage, scale, dir);
        break;

      case 'text': {
        final v = _val(card, layer.field);
        if (v.isEmpty) return;
        final x = (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * scale;
        final y = layer.y * scale;
        _drawText(canvas, v, x, y,
          fontSize: (layer.fontSize ?? 14) * scale,
          color: _parse(layer.color),
          fontWeight: _fw(layer.fontWeight),
          dir: dir,
          maxLines: layer.maxLines?.toInt(),
        );
        break;
      }

      case 'contact_row': {
        final v = _val(card, layer.field);
        final hideEmpty = extra['hideIfEmpty'] as bool? ?? false;
        if (v.isEmpty) {
          if (hideEmpty) return;
          break;
        }
        final x = (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * scale;
        final y = layer.y * scale;
        final iSize = _iconSize(scale);
        final iconColor = _parse(extra['iconColor'] as String?);
        final icon = _iconData(extra['icon'] as String? ?? 'phone_outlined');
        _drawIcon(canvas, icon, x, y + (14 * scale - iSize) / 2, iSize, iconColor);
        _drawText(canvas, v, x + iSize + 8 * scale, y,
          fontSize: (layer.fontSize ?? 14) * scale,
          color: _parse(layer.color),
          fontWeight: _fw(layer.fontWeight),
          dir: dir,
        );
        break;
      }

      case 'info_column': {
        final fieldsList = (extra['fields'] as List<dynamic>?)?.cast<String>() ?? [];
        final icons = (extra['icons'] as List<dynamic>?)?.cast<String>() ?? [];
        final spacing = (extra['spacing'] as num?)?.toDouble() ?? 10;
        final iconColor = _parse(extra['iconColor'] as String?);
        final iSize = _iconSize(scale);
        var currentY = layer.y * scale;
        for (int i = 0; i < fieldsList.length; i++) {
          final fv = _val(card, fieldsList[i]);
          if (fv.isEmpty && fieldsList[i] == 'address') continue;
          if (fv.isEmpty) continue;
          final ix = (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * scale;
          final icon = _iconData(i < icons.length ? icons[i] : 'phone_outlined');
          _drawIcon(canvas, icon, ix, currentY + (14 * scale - iSize) / 2, iSize, iconColor);
          _drawText(canvas, fv, ix + iSize + 8 * scale, currentY,
            fontSize: (layer.fontSize ?? 14) * scale,
            color: _parse(layer.color),
            fontWeight: _fw(layer.fontWeight),
            dir: dir,
          );
          currentY += (layer.fontSize ?? 14) * scale + spacing * scale;
        }
        break;
      }

      case 'contact_on_fold': {
        final flist = (extra['fields'] as List<dynamic>?)?.cast<String>() ?? [];
        final colors = (extra['colors'] as List<dynamic>?)?.map((c) => _parse(c as String)).toList() ?? [];
        final fontSizes = (extra['fontSizes'] as List<dynamic>?)?.map((s) => (s as num).toDouble()).toList() ?? [];
        final fontWeights = (extra['fontWeights'] as List<dynamic>?)?.map((s) => _fw(s as String)).toList() ?? [];
        final contactX = (dir == TextDirection.ltr ? (layer.x - 960 + 40) : layer.effectiveX) * scale;
        var currentY = layer.y * scale;
        for (int i = 0; i < flist.length; i++) {
          final fv = _val(card, flist[i]);
          if (fv.isEmpty) continue;
          _drawText(canvas, fv, contactX, currentY,
            fontSize: (i < fontSizes.length ? fontSizes[i] : 12) * scale,
            color: i < colors.length ? colors[i] : Colors.black,
            fontWeight: i < fontWeights.length ? fontWeights[i] : FontWeight.w400,
            dir: dir,
          );
          currentY += (i < fontSizes.length ? fontSizes[i] : 12) * scale + 2 * scale;
        }
        break;
      }

      case 'social_dots': {
        final sfields = (extra['fields'] as List<dynamic>?)?.cast<String>() ?? [];
        final dotColors = (extra['colors'] as List<dynamic>?)?.map((c) => _parse(c as String)).toList() ?? [];
        final spacing = (extra['spacing'] as num?)?.toDouble() ?? 14;
        final dotSize = (extra['dotSize'] as num?)?.toDouble() ?? 12;
        final sx = (dir == TextDirection.ltr ? layer.x : layer.effectiveX) * scale;
        final sy = layer.y * scale;
        final ds = dotSize * scale;
        var currentY = sy;
        for (int i = 0; i < sfields.length; i++) {
          final fv = _val(card, sfields[i]);
          if (fv.isEmpty) continue;
          final paint = Paint()
            ..color = i < dotColors.length ? dotColors[i] : Colors.grey;
          canvas.drawCircle(Offset(sx + ds / 2, currentY + ds / 2), ds / 2, paint);
          final borderPaint = Paint()
            ..color = Colors.white.withValues(alpha: 0.3)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.5 * scale;
          canvas.drawCircle(Offset(sx + ds / 2, currentY + ds / 2), ds / 2, borderPaint);
          currentY += ds + spacing * scale;
        }
        break;
      }
    }
  }

  static void _drawText(
    Canvas canvas,
    String text,
    double x, double y, {
    required double fontSize,
    required Color color,
    required FontWeight fontWeight,
    required TextDirection dir,
    int? maxLines,
  }) {
    if (text.isEmpty) return;
    final style = ui.ParagraphStyle(
      textDirection: dir,
      fontSize: fontSize,
      fontWeight: fontWeight,
      maxLines: maxLines ?? 1,
      ellipsis: maxLines != null ? '...' : null,
    );
    final builder = ui.ParagraphBuilder(style)
      ..pushStyle(ui.TextStyle(color: color))
      ..addText(text);
    final paragraph = builder.build();
    paragraph.layout(const ui.ParagraphConstraints(width: double.infinity));
    canvas.drawParagraph(paragraph, Offset(x, y));
  }

  static void _drawIcon(
    Canvas canvas,
    IconData icon,
    double x, double y,
    double size,
    Color color,
  ) {
    if (color == Colors.transparent) return;
    final style = ui.ParagraphStyle(
      fontFamily: 'MaterialIcons',
      fontSize: size,
      textDirection: TextDirection.ltr,
    );
    final builder = ui.ParagraphBuilder(style)
      ..pushStyle(ui.TextStyle(color: color))
      ..addText(String.fromCharCode(icon.codePoint));
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: size * 2));
    canvas.drawParagraph(paragraph, Offset(x, y));
  }

  static void _paintImage(
    Canvas canvas,
    WidgetLayer layer,
    ui.Image? profileImage,
    double scale,
    TextDirection dir,
  ) {
    final size = (layer.size ?? 100) * scale / 2;
    final cx = (dir == TextDirection.ltr ? layer.x : (layer.rtlX ?? layer.x)) * scale;
    final cy = layer.y * scale;
    final center = Offset(cx, cy);
    final rect = Rect.fromCircle(center: center, radius: size);

    if (profileImage != null) {
      canvas.save();
      canvas.clipPath(Path()..addOval(rect));
      canvas.drawImageRect(
        profileImage,
        Rect.fromLTWH(0, 0, profileImage.width.toDouble(), profileImage.height.toDouble()),
        rect,
        Paint(),
      );
      canvas.restore();
    } else {
      canvas.drawCircle(center, size, Paint()..color = Colors.grey.shade300);
      final personStyle = ui.ParagraphStyle(
        fontFamily: 'MaterialIcons',
        fontSize: size * 0.8,
        textDirection: TextDirection.ltr,
      );
      final builder = ui.ParagraphBuilder(personStyle)
        ..pushStyle(ui.TextStyle(color: Colors.grey.shade500))
        ..addText(String.fromCharCode(Icons.person.codePoint));
      final paragraph = builder.build();
      paragraph.layout(ui.ParagraphConstraints(width: size * 2));
      canvas.drawParagraph(paragraph, Offset(cx - paragraph.width / 2, cy - size * 0.7));
    }
  }
}
