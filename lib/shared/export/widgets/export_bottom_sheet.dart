import 'package:flutter/material.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/shared/export/card_export_service.dart';

class ExportBottomSheet extends StatelessWidget {
  final BusinessCard card;

  const ExportBottomSheet({super.key, required this.card});

  static Future<void> show(BuildContext context, BusinessCard card) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ExportBottomSheet(card: card),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final tiles = [
      _TileData(Icons.image, loc.saveToGallery, Colors.green, () => _export(context, 'saveGallery')),
      _TileData(Icons.share, loc.shareAsImage, Colors.blue, () => _export(context, 'shareImage')),
      _TileData(Icons.contact_page, loc.saveContactVcf, Colors.indigo, () => _export(context, 'saveVcf')),
      _TileData(Icons.person_add, loc.addToPhoneContacts, Colors.orange, () => _export(context, 'addContacts')),
      _TileData(Icons.high_quality, loc.hiResExport, Colors.purple, () => _export(context, 'hiRes')),
    ];

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(AppLocalizations.of(context)!.exportCard, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            ...tiles.map((t) => ListTile(
              leading: CircleAvatar(
                backgroundColor: t.color.withValues(alpha: 0.15),
                child: Icon(t.icon, color: t.color, size: 22),
              ),
              title: Text(t.label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: t.onTap,
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _export(BuildContext context, String action) async {
    Navigator.pop(context);
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.processing), duration: const Duration(seconds: 1)),
    );

    String? error;
    switch (action) {
      case 'saveGallery':
        error = await CardExportService.exportPng(context: context, card: card);
        break;
      case 'shareImage':
        error = await CardExportService.shareAsImage(context: context, card: card);
        break;
      case 'saveVcf':
        error = await CardExportService.saveContact(context: context, card: card);
        break;
      case 'addContacts':
        error = await CardExportService.addToPhoneContacts(context: context, card: card);
        break;
      case 'hiRes':
        error = await CardExportService.hiResExport(context: context, card: card);
        break;
    }

    if (!context.mounted) return;

    if (error != null) {
      scaffold.showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red.shade300),
      );
    }
  }
}

class _TileData {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  _TileData(this.icon, this.label, this.color, this.onTap);
}
