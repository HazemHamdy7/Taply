import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/widgets/business_card_widget.dart';
import 'package:business_card/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:business_card/features/categories/presentation/cubit/category_cubit.dart';
import 'package:business_card/features/categories/presentation/widgets/category_picker_sheet.dart';
import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';
import 'package:business_card/shared/export/widgets/export_bottom_sheet.dart';

class CardViewScreen extends StatelessWidget {
  final BusinessCard card;
  final bool showSave;
  final String? scannedCardId;
  final List<String> categoryIds;

  const CardViewScreen({
    super.key,
    required this.card,
    this.showSave = true,
    this.scannedCardId,
    this.categoryIds = const [],
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardWidth = MediaQuery.of(context).size.width - 32;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(card.fullName.isNotEmpty
            ? card.fullName
            : AppLocalizations.of(context)!.card),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          if (scannedCardId != null)
            BlocBuilder<ScannedCardCubit, ScannedCardState>(
              builder: (context, state) {
                final scannedCard = state.cards
                    .where((c) => c.id == scannedCardId)
                    .firstOrNull;
                final isFav = scannedCard?.isFavorite ?? false;
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  tooltip: isFav
                      ? AppLocalizations.of(context)!.removeFromFavorites
                      : AppLocalizations.of(context)!.addToFavorites,
                  onPressed: () => context
                      .read<ScannedCardCubit>()
                      .toggleFavorite(scannedCardId!),
                );
              },
            ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: AppLocalizations.of(context)!.export,
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
            if (scannedCardId != null) ...[
              const SizedBox(height: 12),
              _CategoriesSection(
                scannedCardId: scannedCardId!,
                categoryIds: categoryIds,
              ),
            ],
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
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7))),
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
                  onPressed: () async {
                    await _saveCard(context);
                  },
                  icon: const Icon(Icons.save),
                  label: Text(AppLocalizations.of(context)!.saveCard),
                ),
              ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(AppLocalizations.of(context)!.close),
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
    final saved =
        await context.read<ScannedCardCubit>().saveIfNotExists(scanned);
    if (!context.mounted) return;
    if (saved) {
      context.read<AnalyticsCubit>().trackContactSave(
        card.id ?? '',
        card.fullName,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.cardSaved),
            duration: const Duration(seconds: 2)),
      );
      context.goNamed('home', extra: 1);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(AppLocalizations.of(context)!.cardAlreadySaved),
            duration: const Duration(seconds: 2)),
      );
    }
  }

  Widget _actionsSection(BuildContext context, ThemeData theme) {
    final tiles = <Widget>[];
    final loc = AppLocalizations.of(context)!;
    _addTile(tiles, Icons.phone_outlined, loc.call, card.mobileNumber,
        () => _launch('tel:${card.mobileNumber}'));
    _addTile(tiles, Icons.phone_outlined, loc.call2, card.mobileNumber2,
        () => _launch('tel:${card.mobileNumber2}'));
    _addTile(
        tiles,
        Icons.chat_outlined,
        loc.whatsapp,
        card.whatsappNumber,
        () => _launch(
            'https://wa.me/${card.whatsappNumber.replaceAll('+', '').replaceAll(' ', '')}'));
    _addTile(tiles, Icons.email_outlined, loc.emailLabel, card.email,
        () => _launch('mailto:${card.email}'));
    _addTile(tiles, Icons.language_outlined, loc.websiteLabel, card.website,
        () => _launch(_normalizeUrl(card.website)));
    _addTile(
        tiles,
        Icons.location_on_outlined,
        loc.address,
        card.address,
        () => _launch(
            'https://maps.google.com/?q=${Uri.encodeComponent(card.address)}'));
    _addTile(tiles, Icons.person_outlined, loc.linkedin, card.linkedin,
        () => _launch(_normalizeUrl(card.linkedin)));
    _addTile(tiles, Icons.facebook_outlined, loc.facebook, card.facebook,
        () => _launch(_normalizeUrl(card.facebook)));
    _addTile(tiles, Icons.camera_alt_outlined, loc.instagram, card.instagram,
        () => _launch(_normalizeUrl(card.instagram)));
    _addTile(tiles, Icons.send_outlined, loc.telegram, card.telegram,
        () => _launch(_normalizeUrl(card.telegram)));
    _addTile(tiles, Icons.play_circle_outlined, loc.youtube, card.youtube,
        () => _launch(_normalizeUrl(card.youtube)));
    _addTile(tiles, Icons.alternate_email_outlined, loc.xTwitter, card.x,
        () => _launch(_normalizeUrl(card.x)));

    if (tiles.isEmpty) return const SizedBox.shrink();

    return Card(
      child: Column(children: tiles),
    );
  }

  void _addTile(List<Widget> list, IconData icon, String label, String value,
      VoidCallback onTap) {
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

class _CategoriesSection extends StatelessWidget {
  final String scannedCardId;

  const _CategoriesSection({
    required this.scannedCardId,
    required List<String> categoryIds,
  }) : _initialCategoryIds = categoryIds;

  final List<String> _initialCategoryIds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.label_outline,
                    size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Categories',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _editCategories(context),
                  icon: const Icon(Icons.edit, size: 16),
                  label: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            BlocBuilder<ScannedCardCubit, ScannedCardState>(
              builder: (context, cardState) {
                final card = cardState.cards
                    .where((c) => c.id == scannedCardId)
                    .firstOrNull;
                final ids = card?.categoryIds ?? _initialCategoryIds;

                return BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, catState) {
                    if (ids.isEmpty) {
                      return Text(
                        'No categories assigned',
                        style: TextStyle(
                          color: theme.disabledColor,
                          fontSize: 13,
                        ),
                      );
                    }

                    final names = ids
                        .map((id) => catState.categories
                            .where((c) => c.id == id)
                            .map((c) => c.name)
                            .firstOrNull)
                        .where((n) => n != null)
                        .toList();

                    return Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: names.map((name) {
                        return Chip(
                          label:
                              Text(name!, style: const TextStyle(fontSize: 12)),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          backgroundColor: theme.colorScheme.primaryContainer
                              .withValues(alpha: 0.6),
                          labelStyle: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        );
                      }).toList(),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _editCategories(BuildContext context) {
    final cardState = context.read<ScannedCardCubit>().state;
    final card =
        cardState.cards.where((c) => c.id == scannedCardId).firstOrNull;
    final currentIds = card?.categoryIds ?? _initialCategoryIds;

    CategoryPickerSheet.show(
      context,
      selectedIds: currentIds,
      onChanged: (selected) {
        context
            .read<ScannedCardCubit>()
            .updateCategories(scannedCardId, selected);
      },
    );
  }
}
