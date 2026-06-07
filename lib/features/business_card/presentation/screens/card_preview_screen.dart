import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/business_card/presentation/widgets/business_card_widget.dart';

class CardPreviewScreen extends StatefulWidget {
  const CardPreviewScreen({super.key});

  @override
  State<CardPreviewScreen> createState() => _CardPreviewScreenState();
}

class _CardPreviewScreenState extends State<CardPreviewScreen> {
  final _pageController = PageController();
  BusinessCard? _singleCard;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final extra = GoRouterState.of(context).extra;
      if (extra is BusinessCard) {
        setState(() => _singleCard = extra);
      }
    });
    context.read<BusinessCardCubit>().loadCards();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.tryParse(url);
    if (uri != null) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _deleteCard(BusinessCard card) async {
    final cubit = context.read<BusinessCardCubit>();
    final scaffold = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Delete "${card.fullName}" card?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('No')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    await cubit.deleteCard(card.id!);
    if (!mounted) return;
    if (cubit.state.cards.isEmpty) {
      if (_singleCard != null) context.pop();
      return;
    }
    scaffold.showSnackBar(
      const SnackBar(content: Text('Card deleted'), duration: Duration(seconds: 2)),
    );
    if (_singleCard != null) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('My Cards'),
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
          if (_singleCard != null) return;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_pageController.hasClients &&
                state.selectedIndex < state.cards.length) {
              _pageController.jumpToPage(state.selectedIndex);
            }
          });
        },
        builder: (context, state) {
          if (_singleCard != null) {
            final fresh = state.cards.where((c) => c.id == _singleCard!.id).firstOrNull;
            return _buildSingleCard(theme, fresh ?? _singleCard!);
          }

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
                      'Add Your Card',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Create a digital business card\nto share with anyone',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.textTheme.bodyMedium?.color?.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    FilledButton.icon(
                      onPressed: () => context.push('/create-card'),
                      icon: const Icon(Icons.add),
                      label: const Text('Create Your Card'),
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
              Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: state.cards.length,
                      onPageChanged: (i) =>
                          context.read<BusinessCardCubit>().selectCard(i),
                      itemBuilder: (context, index) {
                        final card = state.cards[index];
                        return SingleChildScrollView(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
                          child: Column(
                            children: [
                              _buildCard(theme, card),
                              const SizedBox(height: 20),
                              _buildActions(theme, card),
                              const SizedBox(height: 20),
                              if (card.aboutMe.isNotEmpty)
                                _buildAboutSection(theme, card),
                              const SizedBox(height: 12),
                              _buildDeleteButton(theme, card),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  if (state.cards.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 80),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(state.cards.length, (i) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: i == state.selectedIndex ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: i == state.selectedIndex
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.primary.withValues(alpha: 0.3),
                            ),
                          );
                        }),
                      ),
                    ),
                ],
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
                        heroTag: 'edit',
                        onPressed: () => context.push('/create-card',
                            extra: state.selectedCard),
                        child: const Icon(Icons.edit),
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

  Widget _buildCard(ThemeData theme, BusinessCard card) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BusinessCardWidget(
            card: card,
            width: MediaQuery.of(context).size.width - 32,
          ),
        ),
      ],
    );
  }

  Widget _buildActions(ThemeData theme, BusinessCard card) {
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

  Widget _buildAboutSection(ThemeData theme, BusinessCard card) {
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

  Widget _buildDeleteButton(ThemeData theme, BusinessCard card) {
    return TextButton.icon(
      onPressed: () => _deleteCard(card),
      icon: const Icon(Icons.delete, color: Colors.red),
      label: const Text('Delete Card', style: TextStyle(color: Colors.red)),
    );
  }

  Widget _buildSingleCard(ThemeData theme, BusinessCard card) {
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            children: [
              _buildCard(theme, card),
              const SizedBox(height: 20),
              _buildActions(theme, card),
              const SizedBox(height: 20),
              if (card.aboutMe.isNotEmpty) _buildAboutSection(theme, card),
              const SizedBox(height: 12),
              _buildDeleteButton(theme, card),
              const SizedBox(height: 80),
            ],
          ),
        ),
        Positioned(
          right: 16,
          bottom: 16,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton.small(
                heroTag: 'editSingle',
                onPressed: () => context.push('/create-card', extra: card),
                child: const Icon(Icons.edit),
              ),
              const SizedBox(height: 8),
              FloatingActionButton(
                heroTag: 'addSingle',
                onPressed: () => context.push('/create-card'),
                child: const Icon(Icons.add),
              ),
            ],
          ),
        ),
      ],
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
