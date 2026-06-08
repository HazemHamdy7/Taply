import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';
import 'package:business_card/features/scanned_cards/presentation/screens/card_view_screen.dart';
import 'package:business_card/features/business_card/presentation/widgets/business_card_widget.dart';

class ScannedCardsScreen extends StatefulWidget {
  const ScannedCardsScreen({super.key});

  @override
  State<ScannedCardsScreen> createState() => _ScannedCardsScreenState();
}

class _ScannedCardsScreenState extends State<ScannedCardsScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ScannedCardCubit>().load();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 30, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.searchScannedCards,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context.read<ScannedCardCubit>().search('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
              ),
              onChanged: (q) => context.read<ScannedCardCubit>().search(q),
            ),
          ),
          Expanded(
            child: BlocBuilder<ScannedCardCubit, ScannedCardState>(
              builder: (context, state) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final cards = state.filtered;

                if (cards.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.contact_page_outlined,
                            size: 80,
                            color: theme.colorScheme.primary.withValues(
                              alpha: 0.4,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.searchQuery.isNotEmpty
                                ? AppLocalizations.of(context)!.noMatchSearch
                                : AppLocalizations.of(context)!.noScannedCards,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.6,
                              ),
                            ),
                          ),
                          if (state.searchQuery.isEmpty) ...[
                            const SizedBox(height: 8),
                            Text(
                              AppLocalizations.of(context)!.scanToSave,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.disabledColor,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => context.read<ScannedCardCubit>().load(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    itemCount: cards.length,
                    itemBuilder: (context, index) {
                      final card = cards[index];
                      return _ScannedCardTile(card: card);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScannedCardTile extends StatelessWidget {
  final ScannedCard card;
  const _ScannedCardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final availableWidth = MediaQuery.of(context).size.width - 32;
    final cardWidgetWidth = availableWidth;
    final cardWidgetHeight = cardWidgetWidth * 0.6;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showDetail(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: cardWidgetWidth,
              height: cardWidgetHeight,
              child: BusinessCardWidget(
                card: card.toBusinessCard(),
                width: cardWidgetWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          card.fullName.isNotEmpty ? card.fullName : AppLocalizations.of(context)!.unknown,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        if (card.companyName.isNotEmpty)
                          Text(
                            card.companyName,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.textTheme.bodySmall?.color
                                  ?.withValues(alpha: 0.6),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Text(
                    _formatDate(card.scanDate),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.disabledColor,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      card.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: card.isFavorite ? Colors.red : null,
                      size: 20,
                    ),
                    onPressed: () => context
                        .read<ScannedCardCubit>()
                        .toggleFavorite(card.id),
                    visualDensity: VisualDensity.compact,
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: () => _confirmDelete(context),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  void _showDetail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CardViewScreen(card: card.toBusinessCard(), showSave: false),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.deleteCard),
        content: Text(
          AppLocalizations.of(ctx)!.deleteCardConfirm(
            card.fullName.isNotEmpty ? card.fullName : AppLocalizations.of(ctx)!.card,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<ScannedCardCubit>().delete(card.id);
              Navigator.of(ctx).pop();
            },
            child: Text(AppLocalizations.of(ctx)!.delete, style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
