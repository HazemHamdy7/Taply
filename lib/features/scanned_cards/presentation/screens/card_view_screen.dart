import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/widgets/business_card_widget.dart';
import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';
import 'package:business_card/shared/export/widgets/export_bottom_sheet.dart';

class CardViewScreen extends StatelessWidget {
  final BusinessCard card;
  final bool showSave;

  const CardViewScreen({super.key, required this.card, this.showSave = true});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardWidth = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(card.fullName.isNotEmpty ? card.fullName : 'Card'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Export',
            onPressed: () => ExportBottomSheet.show(context, card),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: BusinessCardWidget(card: card, width: cardWidth),
            ),
            if (card.tagline.isNotEmpty || card.aboutMe.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (card.tagline.isNotEmpty)
                        Text(card.tagline,
                            style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w600)),
                      if (card.aboutMe.isNotEmpty) ...[
                        if (card.tagline.isNotEmpty) const SizedBox(height: 8),
                        Text(card.aboutMe,
                            style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
                      ],
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            _actionsSection(context, theme),
            const SizedBox(height: 24),
            if (showSave)
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () async { await _saveCard(context); },
                  icon: const Icon(Icons.save),
                  label: const Text('Save Card'),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveCard(BuildContext context) async {
    final scanned = ScannedCard(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      cardId: card.id ?? '',
      fullName: card.fullName,
      jobTitle: card.jobTitle,
      companyName: card.companyName,
      tagline: card.tagline,
      mobileNumber: card.mobileNumber,
      mobileNumber2: card.mobileNumber2,
      whatsappNumber: card.whatsappNumber,
      email: card.email,
      website: card.website,
      linkedin: card.linkedin,
      facebook: card.facebook,
      instagram: card.instagram,
      telegram: card.telegram,
      youtube: card.youtube,
      x: card.x,
      address: card.address,
      aboutMe: card.aboutMe,
      templateId: card.templateId,
      scanDate: DateTime.now(),
    );
    final saved = await context.read<ScannedCardCubit>().saveIfNotExists(scanned);
    if (!context.mounted) return;
    if (saved) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card saved'), duration: Duration(seconds: 2)),
      );
      context.goNamed('home', extra: 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This card is already saved'), duration: Duration(seconds: 2)),
      );
    }
  }

  Widget _actionsSection(BuildContext context, ThemeData theme) {
    final tiles = <Widget>[];
    _addTile(tiles, Icons.phone_outlined, 'Call', card.mobileNumber, () => _launch('tel:${card.mobileNumber}'));
    _addTile(tiles, Icons.phone_outlined, 'Call 2', card.mobileNumber2, () => _launch('tel:${card.mobileNumber2}'));
    _addTile(tiles, Icons.chat_outlined, 'WhatsApp', card.whatsappNumber, () => _launch('https://wa.me/${card.whatsappNumber.replaceAll('+', '').replaceAll(' ', '')}'));
    _addTile(tiles, Icons.email_outlined, 'Email', card.email, () => _launch('mailto:${card.email}'));
    _addTile(tiles, Icons.language_outlined, 'Website', card.website, () => _launch(_normalizeUrl(card.website)));
    _addTile(tiles, Icons.location_on_outlined, 'Address', card.address, () => _launch('https://maps.google.com/?q=${Uri.encodeComponent(card.address)}'));
    _addTile(tiles, Icons.person_outlined, 'LinkedIn', card.linkedin, () => _launch(_normalizeUrl(card.linkedin)));
    _addTile(tiles, Icons.facebook_outlined, 'Facebook', card.facebook, () => _launch(_normalizeUrl(card.facebook)));
    _addTile(tiles, Icons.camera_alt_outlined, 'Instagram', card.instagram, () => _launch(_normalizeUrl(card.instagram)));
    _addTile(tiles, Icons.send_outlined, 'Telegram', card.telegram, () => _launch(_normalizeUrl(card.telegram)));
    _addTile(tiles, Icons.play_circle_outlined, 'YouTube', card.youtube, () => _launch(_normalizeUrl(card.youtube)));
    _addTile(tiles, Icons.alternate_email_outlined, 'X', card.x, () => _launch(_normalizeUrl(card.x)));

    if (tiles.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Column(children: tiles),
    );
  }

  void _addTile(List<Widget> list, IconData icon, String label, String value, VoidCallback onTap) {
    if (value.isEmpty) return;
    list.add(ListTile(
      leading: Icon(icon, color: Colors.grey.shade600),
      title: Text(value, style: const TextStyle(fontSize: 14)),
      subtitle: Text(label, style: const TextStyle(fontSize: 11)),
      trailing: const Icon(Icons.open_in_new, size: 16),
      dense: true,
      onTap: onTap,
    ));
  }

  Future<void> _launch(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.tryParse(url);
    if (uri == null) return;
    if (uri.hasScheme && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  String _normalizeUrl(String url) {
    if (url.isEmpty) return url;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'https://$url';
  }
}
