import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:gal/gal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';

String _cardToQrData(BusinessCard c) {
  final lines = <String>[
    'BEGIN:VCARD',
    'VERSION:3.0',
    if (c.fullName.isNotEmpty) 'FN:${c.fullName}',
    if (c.jobTitle.isNotEmpty) 'TITLE:${c.jobTitle}',
    if (c.companyName.isNotEmpty) 'ORG:${c.companyName}',
    if (c.mobileNumber.isNotEmpty) 'TEL;TYPE=CELL:${c.mobileNumber}',
    if (c.whatsappNumber.isNotEmpty) 'TEL;TYPE=OTHER:${c.whatsappNumber}',
    if (c.email.isNotEmpty) 'EMAIL:${c.email}',
    if (c.website.isNotEmpty) 'URL:${c.website}',
    if (c.address.isNotEmpty) 'ADR;TYPE=WORK:;;${c.address}',
    if (c.linkedin.isNotEmpty ||
        c.facebook.isNotEmpty ||
        c.instagram.isNotEmpty ||
        c.telegram.isNotEmpty ||
        c.aboutMe.isNotEmpty)
      'NOTE:${[
        if (c.linkedin.isNotEmpty) 'LinkedIn: ${c.linkedin}',
        if (c.facebook.isNotEmpty) 'Facebook: ${c.facebook}',
        if (c.instagram.isNotEmpty) 'Instagram: ${c.instagram}',
        if (c.telegram.isNotEmpty) 'Telegram: ${c.telegram}',
        if (c.aboutMe.isNotEmpty) c.aboutMe,
      ].join('\\n')}',
    'END:VCARD',
  ];
  return lines.join('\n');
}

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final _qrKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveQrImage() async {
    final boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;

    setState(() => _isSaving = true);

    try {
      await Gal.putImageBytes(
        byteData.buffer.asUint8List(),
        name: 'business_card_qr_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR Code saved to gallery')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Scan QR',
            onPressed: () => context.push('/qr-scanner'),
          ),
        ],
      ),
      body: BlocBuilder<BusinessCardCubit, BusinessCardState>(
        builder: (context, state) {
          final card = state.card;

          if (card == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_2, size: 80, color: theme.disabledColor),
                  const SizedBox(height: 16),
                  const Text('No card data available'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/create-card'),
                    child: const Text('Create Card'),
                  ),
                ],
              ),
            );
          }

          final qrData = _cardToQrData(card);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: RepaintBoundary(
                      key: _qrKey,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(16),
                        child: QrImageView(
                          data: qrData,
                          version: QrVersions.auto,
                          size: 300,
                          eyeStyle: const QrEyeStyle(
                            eyeShape: QrEyeShape.square,
                            color: Colors.black,
                          ),
                          dataModuleStyle: const QrDataModuleStyle(
                            dataModuleShape: QrDataModuleShape.square,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(card.fullName, style: theme.textTheme.titleLarge),
                if (card.companyName.isNotEmpty)
                  Text(card.companyName, style: theme.textTheme.bodyMedium),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveQrImage,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_alt),
                  label: const Text('Save QR'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
