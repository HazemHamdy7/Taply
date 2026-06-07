import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/nfc/presentation/cubit/nfc_cubit.dart';
import 'package:business_card/features/scanned_cards/presentation/screens/card_view_screen.dart';

class NfcScreen extends StatelessWidget {
  const NfcScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('NFC')),
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
                  const Text('NFC is not supported on this device'),
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
                  const Text('NFC is disabled. Please enable it in settings.'),
                ],
              ),
            );
          }

          if (state.readCard != null) {
            final card = state.readCard!;
            final localCard = context.read<BusinessCardCubit>().state.selectedCard;
            final isOwnCard = localCard != null && localCard.fullName == card.fullName;
            final displayCard = isOwnCard ? localCard : card;
            WidgetsBinding.instance.addPostFrameCallback((_) {
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
              isBusy ? 'Place your phone near the tag...' : 'NFC Actions',
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
                  label: const Text('Write to NFC Tag'),
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
                label: const Text('Read NFC Tag'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
