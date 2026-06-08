import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/networking_score/presentation/cubit/networking_score_cubit.dart';

class NetworkingInsights extends StatelessWidget {
  const NetworkingInsights({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<NetworkingScoreCubit, NetworkingScoreState>(
      builder: (ctx, state) {
        final insights = state.insights;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_outline,
                          size: 18, color: theme.colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.insights,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  for (final insight in insights)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.arrow_forward_ios,
                              size: 12,
                              color: theme.colorScheme.primary
                                  .withValues(alpha: 0.6)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _localizedInsight(context, insight),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _localizedInsight(BuildContext context, String key) {
    final loc = AppLocalizations.of(context)!;
    switch (key) {
      case 'insightAddContacts':
        return loc.insightAddContacts;
      case 'insightShareQR':
        return loc.insightShareQR;
      case 'insightUseNfc':
        return loc.insightUseNfc;
      case 'insightShareMore':
        return loc.insightShareMore;
      case 'insightSaveContacts':
        return loc.insightSaveContacts;
      case 'insightFollowUp':
        return loc.insightFollowUp;
      case 'insightGreatJob':
        return loc.insightGreatJob;
      default:
        return key;
    }
  }
}
