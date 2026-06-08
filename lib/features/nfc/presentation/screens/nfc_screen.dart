import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/analytics/presentation/cubit/analytics_cubit.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/nfc/presentation/cubit/nfc_cubit.dart';
import 'package:business_card/features/scanned_cards/presentation/screens/card_view_screen.dart';

class NfcScreen extends StatelessWidget {
  const NfcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.nfc)),
      body: BlocConsumer<NfcCubit, NfcState>(
        listener: (context, state) {
          if (state.message != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message!),
                backgroundColor: state.readCard != null ? Colors.green : null,
              ),
            );
            context.read<NfcCubit>().clearState();
          }
        },
        builder: (context, state) {
          if (state.availability == NFCAvailability.not_supported) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.nfc, size: 80, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.nfcNotSupported),
                ],
              ),
            );
          }

          if (state.availability == NFCAvailability.disabled) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.nfc, size: 80, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text(AppLocalizations.of(context)!.nfcDisabled),
                ],
              ),
            );
          }

          if (state.readCard != null) {
            final card = state.readCard!;
            context.read<AnalyticsCubit>().trackNfcOpen(
              card.id ?? '',
              card.fullName,
            );
            final allCards = context.read<BusinessCardCubit>().state.cards;
            final matchedCard = allCards.where((c) => c.id != null && c.id == card.id).firstOrNull
                ?? allCards.where((c) =>
                    c.fullName == card.fullName &&
                    c.mobileNumber == card.mobileNumber &&
                    c.email == card.email
                ).firstOrNull;
            final isOwnCard = matchedCard != null;
            final displayCard = matchedCard ?? card;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CardViewScreen(card: displayCard, showSave: !isOwnCard),
                ),
              ).then((_) => context.read<NfcCubit>().clearState());
            });
            return const SizedBox.shrink();
          }

          return _buildActions(context, theme, state);
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme, NfcState state) {
    final hasCard = context.read<BusinessCardCubit>().state.cards.isNotEmpty;
    final isBusy = state.isPolling;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.nfc, size: 80, color: theme.colorScheme.primary),
            const SizedBox(height: 24),
            Text(
              isBusy ? AppLocalizations.of(context)!.placePhoneNearTag : AppLocalizations.of(context)!.nfcActions,
              style: theme.textTheme.titleLarge,
            ),
            if (isBusy) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
            const SizedBox(height: 32),
            if (hasCard)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isBusy
                      ? null
                      : () {
                          final card = context.read<BusinessCardCubit>().state.selectedCard;
                          if (card != null) {
                            context.read<NfcCubit>().writeCard(card);
                          }
                        },
                  icon: const Icon(Icons.nfc),
                  label: Text(AppLocalizations.of(context)!.writeNFC),
                ),
              ),
            if (hasCard) const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: isBusy
                    ? null
                    : () => context.read<NfcCubit>().readCard(),
                icon: const Icon(Icons.nfc),
                label: Text(AppLocalizations.of(context)!.readNFC),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
