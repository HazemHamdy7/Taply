import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:business_card/features/analytics/domain/entities/card_analytics.dart';
import 'package:business_card/features/analytics/presentation/widgets/activity_chart.dart';
import 'package:business_card/features/analytics/presentation/widgets/overview_cards.dart';
import 'package:business_card/features/analytics/presentation/widgets/top_cards_section.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/networking_score/presentation/cubit/networking_score_cubit.dart';
import 'package:business_card/features/networking_score/presentation/widgets/networking_insights.dart';
import 'package:business_card/features/networking_score/presentation/widgets/networking_score_card.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';

class AnalyticsDashboardScreen extends StatefulWidget {
  const AnalyticsDashboardScreen({super.key});

  @override
  State<AnalyticsDashboardScreen> createState() =>
      _AnalyticsDashboardScreenState();
}

class _AnalyticsDashboardScreenState extends State<AnalyticsDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AnalyticsCubit>().load();
      context.read<NetworkingScoreCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.analytics),
        centerTitle: true,
      ),
      body: BlocBuilder<AnalyticsCubit, AnalyticsState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = state.summary;
          final totalEvents = summary.totalEvents;

          if (totalEvents == 0) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.analytics_outlined,
                      size: 80,
                      color: theme.colorScheme.primary.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppLocalizations.of(context)!.noAnalyticsData,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.analyticsEmptyHint,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.disabledColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final totalCards =
              context.watch<BusinessCardCubit>().state.cards.length;
          final totalContacts =
              context.watch<ScannedCardCubit>().state.cards.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.only(top: 16, bottom: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                const NetworkingScoreCard(),
                const SizedBox(height: 8),
                const NetworkingInsights(),
                const SizedBox(height: 16),
                OverviewCards(
                  summary: summary,
                  totalCards: totalCards,
                  totalContacts: totalContacts,
                ),
                const SizedBox(height: 16),
                _buildEventBreaksDown(theme, summary),
                const SizedBox(height: 8),
                _buildTotalEvents(theme, summary),
                const SizedBox(height: 8),
                ActivityChart(
                  title: AppLocalizations.of(context)!.dailyActivity,
                  labels: summary.dailyActivity
                      .map((d) => '${d.date.month}/${d.date.day}')
                      .toList(),
                  values: summary.dailyActivity.map((d) => d.count).toList(),
                  barColor: theme.colorScheme.primary,
                ),
                ActivityChart(
                  title: AppLocalizations.of(context)!.weeklyActivity,
                  labels:
                      summary.weeklyActivity.map((w) => w.label).toList(),
                  values: summary.weeklyActivity.map((w) => w.count).toList(),
                  barColor: theme.colorScheme.tertiary,
                ),
                ActivityChart(
                  title: AppLocalizations.of(context)!.monthlyActivity,
                  labels:
                      summary.monthlyActivity.map((m) => m.label).toList(),
                  values: summary.monthlyActivity.map((m) => m.count).toList(),
                  barColor: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                TopCardsSection(
                  topViewed: _filterDeletedCards(summary.topViewed),
                  topShared: _filterDeletedCards(summary.topShared),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEventBreaksDown(ThemeData theme, summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.eventBreakdown,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _eventRow(theme, Icons.qr_code, AppLocalizations.of(context)!.qrScans,
                  summary.totalQrScans, Colors.indigo),
              _eventRow(theme, Icons.nfc, AppLocalizations.of(context)!.nfcOpens, summary.totalNfcOpens,
                  Colors.teal),
              _eventRow(theme, Icons.visibility, AppLocalizations.of(context)!.cardViews,
                  summary.totalCardViews, Colors.blue),
              _eventRow(theme, Icons.share, AppLocalizations.of(context)!.shares, summary.totalShares,
                  Colors.green),
              _eventRow(theme, Icons.download, AppLocalizations.of(context)!.vcfDownloads,
                  summary.totalVcfDownloads, Colors.orange),
              _eventRow(theme, Icons.person_add, AppLocalizations.of(context)!.contactSaves,
                  summary.totalContactSaves, Colors.purple),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventRow(
      ThemeData theme, IconData icon, String label, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text(
            '$count',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  List<CardAnalytics> _filterDeletedCards(List<CardAnalytics> cards) {
    if (cards.isEmpty) return cards;
    final scannedIds = context
        .read<ScannedCardCubit>()
        .state
        .cards
        .map((c) => c.cardId)
        .where((id) => id.isNotEmpty)
        .toSet();
    final businessIds = context
        .read<BusinessCardCubit>()
        .state
        .cards
        .where((c) => c.id != null)
        .map((c) => c.id!)
        .toSet();
    final validIds = {...scannedIds, ...businessIds};
    if (validIds.isEmpty) return cards;
    return cards.where((c) => validIds.contains(c.cardId)).toList();
  }

  Widget _buildTotalEvents(ThemeData theme, summary) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Card(
        color: theme.colorScheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.trending_up,
                  color: theme.colorScheme.onPrimaryContainer),
              const SizedBox(width: 8),
              Text(
                '${summary.totalEvents}',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                AppLocalizations.of(context)!.totalEvents,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
