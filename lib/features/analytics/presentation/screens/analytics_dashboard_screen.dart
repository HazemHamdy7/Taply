import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:business_card/features/analytics/presentation/widgets/activity_chart.dart';
import 'package:business_card/features/analytics/presentation/widgets/overview_cards.dart';
import 'package:business_card/features/analytics/presentation/widgets/top_cards_section.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Analytics'),
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
                      'No analytics data yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Analytics will appear here as you use the app',
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
                  title: 'Daily Activity (7 days)',
                  labels: summary.dailyActivity
                      .map((d) => '${d.date.month}/${d.date.day}')
                      .toList(),
                  values: summary.dailyActivity.map((d) => d.count).toList(),
                  barColor: theme.colorScheme.primary,
                ),
                ActivityChart(
                  title: 'Weekly Activity (4 weeks)',
                  labels:
                      summary.weeklyActivity.map((w) => w.label).toList(),
                  values: summary.weeklyActivity.map((w) => w.count).toList(),
                  barColor: theme.colorScheme.tertiary,
                ),
                ActivityChart(
                  title: 'Monthly Activity (6 months)',
                  labels:
                      summary.monthlyActivity.map((m) => m.label).toList(),
                  values: summary.monthlyActivity.map((m) => m.count).toList(),
                  barColor: theme.colorScheme.secondary,
                ),
                const SizedBox(height: 8),
                TopCardsSection(
                  topViewed: summary.topViewed,
                  topShared: summary.topShared,
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
                'Event Breakdown',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _eventRow(theme, Icons.qr_code, 'QR Scans',
                  summary.totalQrScans, Colors.indigo),
              _eventRow(theme, Icons.nfc, 'NFC Opens', summary.totalNfcOpens,
                  Colors.teal),
              _eventRow(theme, Icons.visibility, 'Card Views',
                  summary.totalCardViews, Colors.blue),
              _eventRow(theme, Icons.share, 'Shares', summary.totalShares,
                  Colors.green),
              _eventRow(theme, Icons.download, 'VCF Downloads',
                  summary.totalVcfDownloads, Colors.orange),
              _eventRow(theme, Icons.person_add, 'Contact Saves',
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
                'Total Events',
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
