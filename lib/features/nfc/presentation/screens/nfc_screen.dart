import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/nfc/presentation/cubit/nfc_cubit.dart';

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
            return _buildReadCard(context, theme, state.readCard!);
          }

          return _buildActions(context, theme, state);
        },
      ),
    );
  }

  Widget _buildActions(BuildContext context, ThemeData theme, NfcState state) {
    final hasCard = context.read<BusinessCardCubit>().hasCard;
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
                          final card = context.read<BusinessCardCubit>().state.card;
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

  Widget _buildReadCard(BuildContext context, ThemeData theme, dynamic card) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Icon(Icons.person, size: 60, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(card.fullName, style: theme.textTheme.headlineSmall),
          if (card.jobTitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(card.jobTitle, style: theme.textTheme.titleMedium),
          ],
          if (card.companyName.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(card.companyName, style: theme.textTheme.bodyLarge),
          ],
          const SizedBox(height: 24),
          if (card.mobileNumber.isNotEmpty)
            _readInfoTile(Icons.phone, card.mobileNumber),
          if (card.whatsappNumber.isNotEmpty)
            _readInfoTile(Icons.chat, card.whatsappNumber),
          if (card.email.isNotEmpty)
            _readInfoTile(Icons.email, card.email),
          if (card.website.isNotEmpty)
            _readInfoTile(Icons.language, card.website),
          if (card.address.isNotEmpty)
            _readInfoTile(Icons.location_on, card.address),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.read<NfcCubit>().clearState(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Widget _readInfoTile(IconData icon, String text) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(text),
      ),
    );
  }
}
