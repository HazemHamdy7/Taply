import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:business_card/features/business_card/presentation/cubit/business_card_cubit.dart';
import 'package:business_card/features/qr/presentation/cubit/qr_cubit.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key});

  @override
  State<QRScreen> createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  final _qrKey = GlobalKey();
  Uint8List? _qrBytes;

  @override
  void initState() {
    super.initState();
    final cardCubit = context.read<BusinessCardCubit>();
    final card = cardCubit.state.card;
    if (card != null) {
      context.read<QrCubit>().loadCard(card);
    }
  }

  Future<void> _captureQr() async {
    final boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return;
    final image = await boundary.toImage(pixelRatio: 3.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return;
    _qrBytes = byteData.buffer.asUint8List();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('QR Code')),
      body: BlocBuilder<QrCubit, QrState>(
        builder: (context, state) {
          if (state.card == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.qr_code_2, size: 80),
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

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: RepaintBoundary(
                      key: _qrKey,
                      child: QrImageView(
                        data: context.read<QrCubit>().qrData,
                        version: QrVersions.auto,
                        size: 250,
                        eyeStyle: QrEyeStyle(
                          eyeShape: QrEyeShape.square,
                          color: theme.colorScheme.primary,
                        ),
                        dataModuleStyle: QrDataModuleStyle(
                          dataModuleShape: QrDataModuleShape.square,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  state.card!.fullName,
                  style: theme.textTheme.titleLarge,
                ),
                if (state.card!.companyName.isNotEmpty)
                  Text(
                    state.card!.companyName,
                    style: theme.textTheme.bodyMedium,
                  ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _QrActionButton(
                      icon: Icons.save_alt,
                      label: 'Save',
                      onTap: () async {
                        await _captureQr();
                        if (_qrBytes != null && context.mounted) {
                          context.read<QrCubit>().saveQrImage(_qrKey);
                        }
                      },
                    ),
                    _QrActionButton(
                      icon: Icons.share,
                      label: 'Share',
                      onTap: () async {
                        await _captureQr();
                        if (_qrBytes != null && context.mounted) {
                          context.read<QrCubit>().shareQrImage(_qrBytes!);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _QrActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QrActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(130, 48),
      ),
    );
  }
}
