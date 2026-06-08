import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/scanned_cards/presentation/screens/card_view_screen.dart';
import 'package:business_card/shared/utils/card_url.dart';

BusinessCard? _qrDataToCard(String raw) {
  final result = CardUrl.decode(raw);
  if (result != null) return result.card;

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

  void _onDetect(BarcodeCapture capture) {
    if (_hasResult) return;
    for (final barcode in capture.barcodes) {
      final raw = barcode.rawValue;
      if (raw == null || raw.isEmpty) continue;
      final card = _qrDataToCard(raw);
      if (card == null) continue;

      _hasResult = true;
      _controller?.stop();

      final localCard = context.read<BusinessCardCubit>().state.selectedCard;
      final isOwnCard = localCard != null && localCard.fullName == card.fullName;
      final displayCard = isOwnCard ? localCard : card;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CardViewScreen(card: displayCard, showSave: !isOwnCard),
        ),
      );
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.scanQRCode)),
      body: MobileScanner(
        controller: _controller,
        onDetect: _onDetect,
      ),
    );
  }
}
