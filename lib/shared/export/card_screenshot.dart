import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/shared/export/card_engine_renderer.dart';

class CardScreenshotService {
  CardScreenshotService._();

  /// Renders the card directly to a PNG image at the target width.
  /// Uses the Theme Engine render pipeline for paint layers and canvas
  /// rendering for widget layers.
  static Future<Uint8List?> renderHiRes({
    required BuildContext context,
    required BusinessCard card,
    double targetWidth = 1080,
  }) {
    return CardEngineHiResRenderer.render(card: card, targetWidth: targetWidth);
  }

  /// Saves PNG bytes to a temp file and returns the File
  static Future<File?> saveToFile(
    Uint8List bytes,
    String fileName,
  ) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
      return file;
    } catch (_) {
      return null;
    }
  }

  /// Saves PNG bytes to the device gallery (Android/iOS)
  static Future<bool> saveToGallery(Uint8List bytes) async {
    try {
      await Gal.putImageBytes(
        bytes,
        name: 'bizcard_${DateTime.now().millisecondsSinceEpoch}',
      );
      return true;
    } catch (_) {
      return false;
    }
  }
}
