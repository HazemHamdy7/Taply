import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/shared/export/card_screenshot.dart';
import 'package:business_card/shared/export/card_vcf_generator.dart';

class CardExportService {
  CardExportService._();

  /// Export card PNG — saves to gallery
  static Future<String?> exportPng({
    required BuildContext context,
    required BusinessCard card,
  }) async {
    final bytes = await CardScreenshotService.renderHiRes(
      context: context,
      card: card,
      targetWidth: 1080,
    );
    if (bytes == null) return 'Failed to render card';
    final ok = await CardScreenshotService.saveToGallery(bytes);
    return ok ? null : 'Failed to save to gallery';
  }

  /// Share card as image — renders hi-res, saves to temp, shares
  static Future<String?> shareAsImage({
    required BuildContext context,
    required BusinessCard card,
  }) async {
    final bytes = await CardScreenshotService.renderHiRes(
      context: context,
      card: card,
      targetWidth: 1080,
    );
    if (bytes == null) return 'Failed to render card';
    final file = await CardScreenshotService.saveToFile(
      bytes,
      '${card.fullName.replaceAll(' ', '_')}_card.png',
    );
    if (file == null) return 'Failed to create file';
    try {
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: '${card.fullName} — Digital Business Card',
        ),
      );
    } catch (_) {
      return 'Failed to share';
    }
    return null;
  }

  /// Save contact (VCF) — saves .vcf file, shares it
  static Future<String?> saveContact({
  required BuildContext context,
    required BusinessCard card,
  }) async {
    return _shareVcf(card);
  }

  /// Add to phone contacts — saves .vcf, shares so user can import
  static Future<String?> addToPhoneContacts({
    required BuildContext context,
    required BusinessCard card,
  }) async {
    return _shareVcf(card);
  }

  /// High resolution export (1080×648 at 300 DPI equivalent)
  static Future<String?> hiResExport({
    required BuildContext context,
    required BusinessCard card,
  }) async {
    // Render at 1920px wide for maximum quality
    final bytes = await CardScreenshotService.renderHiRes(
      context: context,
      card: card,
      targetWidth: 1920,
    );
    if (bytes == null) return 'Failed to render card';

    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${card.fullName.replaceAll(' ', '_')}_hi_res.png');
      await file.writeAsBytes(bytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: '${card.fullName} — High Resolution Card (1920px)',
        ),
      );

      dir.listSync().forEach((f) {
        if (f.path.endsWith('_hi_res.png')) f.delete();
      });
    } catch (_) {
      return 'Failed to export';
    }
    return null;
  }

  static Future<String?> _shareVcf(BusinessCard card) async {
    try {
      final vcf = CardVcfGenerator.generate(card);
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/${card.fullName.replaceAll(' ', '_')}.vcf');
      await file.writeAsString(vcf);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path, mimeType: 'text/vcard')],
          text: '${card.fullName} — Contact Card',
        ),
      );
    } catch (_) {
      return 'Failed to share contact';
    }
    return null;
  }
}
