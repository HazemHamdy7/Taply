import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/business_card/presentation/widgets/business_card_widget.dart';
import 'package:business_card/features/scanned_cards/presentation/screens/scanned_cards_screen.dart';
import 'package:business_card/features/settings/presentation/screens/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialTab;
  const HomeScreen({super.key, this.initialTab = 0});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _currentTab = widget.initialTab;

  @override
  void initState() {
    super.initState();
    context.read<BusinessCardCubit>().loadCards();
  }

  final _pages = <Widget>[
    const _MyCardsTab(),
    const ScannedCardsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: IndexedStack(
        index: _currentTab,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentTab,
        onDestinationSelected: (i) => setState(() => _currentTab = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.credit_card_outlined),
            label: AppLocalizations.of(context)!.myCards,
          ),
          NavigationDestination(
            icon: const Icon(Icons.contact_page_outlined),
            label: AppLocalizations.of(context)!.scanned,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}

class _MyCardsTab extends StatelessWidget {
  const _MyCardsTab();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.myCards),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => context.push('/qr'),
            tooltip: AppLocalizations.of(context)!.qrCode,
          ),
          IconButton(
            icon: const Icon(Icons.nfc),
            onPressed: () => context.push('/nfc'),
            tooltip: AppLocalizations.of(context)!.nfc,
          ),
        ],
      ),
      body: BlocBuilder<BusinessCardCubit, BusinessCardState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.cards.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.credit_card_outlined,
                        size: 100, color: theme.colorScheme.primary.withValues(alpha: 0.4)),
                    const SizedBox(height: 24),
                    Text(
                      AppLocalizations.of(context)!.addYourCard,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.createDigitalCard,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => context.push('/create-card'),
                      icon: const Icon(Icons.add),
                      label: Text(AppLocalizations.of(context)!.createYourCard),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.67 / 1,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: state.cards.length,
                  itemBuilder: (context, index) {
                    final card = state.cards[index];
                    return _buildCardGridItem(context, theme, card);
                  },
                ),
              ),
              Positioned(
                right: 16,
                bottom: 16,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (state.cards.isNotEmpty)
                      FloatingActionButton.small(
                        heroTag: 'manage',
                        onPressed: () => context.push('/card-preview'),
                        child: const Icon(Icons.swap_horiz),
                      ),
                    if (state.cards.isNotEmpty) const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'add',
                      onPressed: () => context.push('/create-card'),
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCardGridItem(BuildContext context, ThemeData theme, BusinessCard card) {
    final availableWidth = (MediaQuery.of(context).size.width - 16 * 2 - 12) / 2;
    return GestureDetector(
      onTap: () => context.push('/card-preview', extra: card),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BusinessCardWidget(card: card, width: availableWidth),
      ),
    );
  }
}


