import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';

class CardPreviewScreen extends StatefulWidget {
  const CardPreviewScreen({super.key});

  @override
  State<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends State<CardPreviewScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BusinessCardCubit>().loadCard();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _deleteCard() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this card?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('No')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<BusinessCardCubit>().deleteCard();
            },
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Card'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () => context.push('/qr'),
            tooltip: 'QR Code',
          ),
          IconButton(
            icon: const Icon(Icons.nfc),
            onPressed: () => context.push('/nfc'),
            tooltip: 'NFC',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: BlocConsumer<BusinessCardCubit, BusinessCardState>(
        listener: (context, state) {
          if (state.card == null && !state.isLoading) {
            context.go('/create-card');
          }
        },
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final card = state.card;
          if (card == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.credit_card_outlined, size: 80, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  Text('No business card found. Create one now.',
                      style: theme.textTheme.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.push('/create-card'),
                    icon: const Icon(Icons.add),
                    label: const Text('Create Card'),
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildCard(theme, card),
                const SizedBox(height: 20),
                _buildActions(theme, card),
                const SizedBox(height: 20),
                if (card.aboutMe.isNotEmpty) _buildAboutSection(theme, card),
                const SizedBox(height: 12),
                _buildDeleteButton(theme),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/create-card',
            extra: context.read<BusinessCardCubit>().state.card),
        icon: const Icon(Icons.edit),
        label: const Text('Edit'),
      ),
    );
  }

  Widget _buildCard(ThemeData theme, dynamic card) {
    return Card(
      elevation: 4,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: card.profileImagePath != null
                  ? FileImage(File(card.profileImagePath))
                  : null,
              child: card.profileImagePath == null
                  ? Icon(Icons.person, size: 50, color: theme.colorScheme.primary)
                  : null,
            ),
            const SizedBox(height: 16),
            Text(
              card.fullName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              card.jobTitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.9),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              card.companyName,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 16),
            if (card.email.isNotEmpty)
              _buildInfoRow(Icons.email, card.email, Colors.white70),
            if (card.mobileNumber.isNotEmpty)
              _buildInfoRow(Icons.phone, card.mobileNumber, Colors.white70),
            if (card.address.isNotEmpty)
              _buildInfoRow(Icons.location_on, card.address, Colors.white70),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Flexible(child: Text(text, style: TextStyle(color: color, fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildActions(ThemeData theme, dynamic card) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: [
        if (card.mobileNumber.isNotEmpty)
          _ActionButton(
            icon: Icons.phone,
            label: 'Call',
            color: Colors.green,
            onTap: () => _launchUrl('tel:${card.mobileNumber}'),
          ),
        if (card.whatsappNumber.isNotEmpty)
          _ActionButton(
            icon: Icons.chat,
            label: 'WhatsApp',
            color: const Color(0xFF25D366),
            onTap: () => _launchUrl('https://wa.me/${card.whatsappNumber}'),
          ),
        if (card.email.isNotEmpty)
          _ActionButton(
            icon: Icons.email,
            label: 'Email',
            color: Colors.red,
            onTap: () => _launchUrl('mailto:${card.email}'),
          ),
        if (card.website.isNotEmpty)
          _ActionButton(
            icon: Icons.language,
            label: 'Website',
            color: theme.colorScheme.primary,
            onTap: () => _launchUrl(card.website),
          ),
      ],
    );
  }

  Widget _buildAboutSection(ThemeData theme, dynamic card) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('About Me', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(card.aboutMe, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(ThemeData theme) {
    return TextButton.icon(
      onPressed: _deleteCard,
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text('Delete Card', style: TextStyle(color: Colors.red)),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: color.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 6),
            Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}
