import 'package:flutter/material.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/analytics/domain/entities/card_analytics.dart';

class TopCardsSection extends StatelessWidget {
  final List<CardAnalytics> topViewed;
  final List<CardAnalytics> topShared;

  const TopCardsSection({
    super.key,
    required this.topViewed,
    required this.topShared,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasViewed = topViewed.isNotEmpty && topViewed.any((c) => c.viewCount > 0);
    final hasShared = topShared.isNotEmpty && topShared.any((c) => c.shareCount > 0);

    if (!hasViewed && !hasShared) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: Text(
                AppLocalizations.of(context)!.noAnalyticsData,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (hasViewed) ...[
            Text(
              AppLocalizations.of(context)!.mostViewed,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...topViewed
                .where((c) => c.viewCount > 0)
                .take(3)
                .map((c) => _CardRankTile(
                      rank: topViewed.indexOf(c) + 1,
                      name: c.cardName,
                      count: c.viewCount,
                      label: AppLocalizations.of(context)!.viewsLabel,
                      icon: Icons.visibility,
                    )),
          ],
          if (hasShared && hasViewed) const SizedBox(height: 16),
          if (hasShared) ...[
            Text(
              AppLocalizations.of(context)!.mostShared,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            ...topShared
                .where((c) => c.shareCount > 0)
                .take(3)
                .map((c) => _CardRankTile(
                      rank: topShared.indexOf(c) + 1,
                      name: c.cardName,
                      count: c.shareCount,
                      label: AppLocalizations.of(context)!.sharesLabel,
                      icon: Icons.share,
                    )),
          ],
        ],
      ),
    );
  }
}

class _CardRankTile extends StatelessWidget {
  final int rank;
  final String name;
  final int count;
  final String label;
  final IconData icon;

  const _CardRankTile({
    required this.rank,
    required this.name,
    required this.count,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          radius: 14,
          backgroundColor: rank <= 3
              ? [Colors.amber, Colors.grey.shade400, Colors.brown.shade300][rank - 1]
              : theme.colorScheme.surfaceContainerHighest,
          child: Text(
            '$rank',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: rank <= 3 ? Colors.white : null,
            ),
          ),
        ),
        title: Text(
          name.isNotEmpty ? name : AppLocalizations.of(context)!.unknownCard,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: theme.colorScheme.primary),
            const SizedBox(width: 4),
            Text(
              '$count',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
