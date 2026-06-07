import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';

BusinessCard? _qrDataToCard(String raw) {
  final map = <String, String>{};
  for (final line in raw.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty ||
        trimmed == 'BEGIN:VCARD' ||
        trimmed == 'END:VCARD' ||
        trimmed.startsWith('VERSION:')) continue;

    final idx = trimmed.indexOf(':');
    if (idx == -1) continue;

    final key = trimmed.substring(0, idx);
    final value = trimmed.substring(idx + 1).trim();

    final prop = key.split(';').first;
    map[prop] = value;
  }

  final fullName = map['FN'];
  if (fullName == null || fullName.isEmpty) return null;

  final note = map['NOTE'] ?? '';

  return BusinessCard(
    fullName: fullName,
    jobTitle: map['TITLE'] ?? '',
    companyName: map['ORG'] ?? '',
    mobileNumber: map['TEL'] != null ? map['TEL']!.split('\\n').first : '',
    email: map['EMAIL'] ?? '',
    website: map['URL'] ?? '',
    address: map['ADR']?.replaceAll(RegExp(r'^;+'), '').replaceAll(';', ', ') ?? '',
    aboutMe: note,
  );
}

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  MobileScannerController? _controller;
  bool _hasResult = false;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _copyText(String label, String text) {
    Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label copied'), duration: const Duration(seconds: 1)),
    );
  }

  void _onDetect(BarcodeCapture capture) {
    if (_hasResult) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) continue;
      final card = _qrDataToCard(raw);
      if (card == null) continue;

      _hasResult = true;
      _controller?.stop();
      _showCardDialog(card);
      return;
    }
  }

  void _showCardDialog(BusinessCard scanned) {
    final localCard = context.read<BusinessCardCubit>().state.card;
    final isOwnCard = localCard != null && localCard.fullName == scanned.fullName;
    final imagePath = isOwnCard ? localCard.profileImagePath : null;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final theme = Theme.of(ctx);
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildHeader(ctx, theme, scanned, imagePath),
                if (scanned.mobileNumber.isNotEmpty || scanned.email.isNotEmpty ||
                    scanned.website.isNotEmpty || scanned.address.isNotEmpty)
                  _buildContactSection(ctx, theme, scanned),
                if (scanned.jobTitle.isNotEmpty || scanned.companyName.isNotEmpty)
                  _buildInfoSection(theme, scanned),
                if (scanned.aboutMe.isNotEmpty) _buildNoteSection(ctx, theme, scanned),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext ctx, ThemeData theme, BusinessCard card, String? imagePath) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.85),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 42,
              backgroundImage: imagePath != null ? FileImage(File(imagePath)) : null,
              child: imagePath == null
                  ? Icon(Icons.person, size: 42, color: theme.colorScheme.primary)
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            card.fullName,
            style: const TextStyle(
              fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white,
            ),
          ),
          if (card.jobTitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(card.jobTitle,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14)),
          ],
          if (card.companyName.isNotEmpty)
            Text(card.companyName,
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildContactSection(BuildContext ctx, ThemeData theme, BusinessCard card) {
    final items = <_ScannedField>[
      if (card.mobileNumber.isNotEmpty)
        _ScannedField(Icons.phone_outlined, 'Phone', card.mobileNumber),
      if (card.email.isNotEmpty)
        _ScannedField(Icons.email_outlined, 'Email', card.email),
      if (card.website.isNotEmpty)
        _ScannedField(Icons.language_outlined, 'Website', card.website),
      if (card.address.isNotEmpty)
        _ScannedField(Icons.location_on_outlined, 'Address', card.address),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: items.map((item) => _buildFieldTile(ctx, theme, item)).toList(),
      ),
    );
  }

  Widget _buildInfoSection(ThemeData theme, BusinessCard card) {
    final details = <String>[
      if (card.jobTitle.isNotEmpty) 'Title: ${card.jobTitle}',
      if (card.companyName.isNotEmpty) 'Company: ${card.companyName}',
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        color: theme.colorScheme.surfaceContainerHighest,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: details.map((d) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Text(d, style: const TextStyle(fontSize: 13)),
            )).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldTile(BuildContext ctx, ThemeData theme, _ScannedField field) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(field.icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(field.label,
                    style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                Text(field.value, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            tooltip: 'Copy',
            onPressed: () => _copyText(field.label, field.value),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSection(BuildContext ctx, ThemeData theme, BusinessCard card) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About',
                    style: TextStyle(
                        fontSize: 11,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                const SizedBox(height: 4),
                Text(card.aboutMe, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, size: 18),
            tooltip: 'Copy',
            onPressed: () => _copyText('About', card.aboutMe),
            visualDensity: VisualDensity.compact,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR Code')),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}

class _ScannedField {
  final IconData icon;
  final String label;
  final String value;
  const _ScannedField(this.icon, this.label, this.value);
}
