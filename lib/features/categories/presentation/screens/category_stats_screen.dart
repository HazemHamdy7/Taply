import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/categories/helpers/icon_helper.dart';
import 'package:business_card/features/categories/helpers/localized_category_name.dart';
import 'package:business_card/features/categories/presentation/cubit/category_cubit.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';

class CategoryStatsScreen extends StatelessWidget {
  const CategoryStatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(loc.categoryStats),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, catState) {
          return BlocBuilder<ScannedCardCubit, ScannedCardState>(
            builder: (context, cardState) {
              if (catState.isLoading || cardState.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              final categories = catState.categories;
              final allCards = cardState.cards;

              if (categories.isEmpty || allCards.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.bar_chart_outlined,
                          size: 80,
                          color: theme.colorScheme.primary.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          loc.noCategoryStats,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              final cardCountByCategory = <String, int>{};
              final latestCardDateByCategory = <String, DateTime>{};
              for (final cat in categories) {
                final count =
                    allCards.where((c) => c.categoryIds.contains(cat.id)).length;
                cardCountByCategory[cat.id] = count;

                final cardsWithCat =
                    allCards.where((c) => c.categoryIds.contains(cat.id)).toList();
                if (cardsWithCat.isNotEmpty) {
                  cardsWithCat.sort((a, b) => b.scanDate.compareTo(a.scanDate));
                  latestCardDateByCategory[cat.id] = cardsWithCat.first.scanDate;
                }
              }

              final mostActive = categories.isNotEmpty
                  ? categories.reduce((a, b) =>
                      (cardCountByCategory[a.id] ?? 0) >=
                              (cardCountByCategory[b.id] ?? 0)
                          ? a
                          : b)
                  : null;

              final totalWithCategory =
                  allCards.where((c) => c.categoryIds.isNotEmpty).length;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            loc.overview,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _StatRow(
                            icon: Icons.contact_page_outlined,
                            label: loc.totalContacts,
                            value: '${allCards.length}',
                          ),
                          _StatRow(
                            icon: Icons.label_outline,
                            label: loc.categorized,
                            value: '$totalWithCategory',
                          ),
                          if (mostActive != null) ...[
                            const Divider(),
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Color(mostActive.color),
                                  child: Icon(
                                    getIconData(mostActive.icon),
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    loc.mostActiveCategory,
                                    style: theme.textTheme.bodySmall?.copyWith(
                                      color: theme.disabledColor,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${cardCountByCategory[mostActive.id] ?? 0}',
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    loc.perCategory,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...categories.map((cat) {
                    final count = cardCountByCategory[cat.id] ?? 0;
                    final latestDate = latestCardDateByCategory[cat.id];
                    return Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(cat.color),
                          child: Icon(
                            getIconData(cat.icon),
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(localizedCategoryName(context, cat)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              '$count',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (latestDate != null)
                              Text(
                                _formatDate(latestDate),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.disabledColor,
                                  fontSize: 11,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }
}

class _StatRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(label, style: theme.textTheme.bodyMedium),
          ),
          Text(
            value,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
