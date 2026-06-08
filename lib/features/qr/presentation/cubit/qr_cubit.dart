import 'dart:typed_data';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';

class QrState {
  final BusinessCard? card;
  final bool isSaving;

  const QrState({this.card, this.isSaving = false});

  QrState copyWith({BusinessCard? card, bool? isSaving}) {
    return QrState(
      card: card ?? this.card,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class QrCubit extends Cubit<QrState> {
  QrCubit() : super(const QrState());

  void loadCard(BusinessCard card) {
    emit(QrState(card: card));
  }

  String get qrData {
    final c = state.card;
    if (c == null) return '';
    return [
      if (c.fullName.isNotEmpty) 'FN:${c.fullName}',
      if (c.jobTitle.isNotEmpty) 'JT:${c.jobTitle}',
      if (c.companyName.isNotEmpty) 'CO:${c.companyName}',
      if (c.mobileNumber.isNotEmpty) 'MB:${c.mobileNumber}',
      if (c.whatsappNumber.isNotEmpty) 'WA:${c.whatsappNumber}',
      if (c.email.isNotEmpty) 'EM:${c.email}',
      if (c.website.isNotEmpty) 'WE:${c.website}',
      if (c.linkedin.isNotEmpty) 'LI:${c.linkedin}',
      if (c.facebook.isNotEmpty) 'FB:${c.facebook}',
      if (c.instagram.isNotEmpty) 'IG:${c.instagram}',
      if (c.telegram.isNotEmpty) 'TG:${c.telegram}',
      if (c.address.isNotEmpty) 'AD:${c.address}',
      if (c.aboutMe.isNotEmpty) 'AB:${c.aboutMe}',
      if (c.profileImagePath != null && c.profileImagePath!.isNotEmpty)
        'PH:${c.profileImagePath}',
    ].join('\n');
  }

  Future<void> saveQrImage(GlobalKey key, {Rect? sharePositionOrigin}) async {
    emit(state.copyWith(isSaving: true));
    try {
      final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) return;
      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) return;

      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/business_card_qr.png');
      await file.writeAsBytes(byteData.buffer.asUint8List());

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'My Business Card QR Code', sharePositionOrigin: sharePositionOrigin),
      );
    } catch (_) {}
    emit(state.copyWith(isSaving: false));
  }

  Future<void> shareQrImage(Uint8List bytes, {Rect? sharePositionOrigin}) async {
    try {
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/business_card_qr.png');
      await file.writeAsBytes(bytes);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(file.path)], text: 'My Business Card QR Code', sharePositionOrigin: sharePositionOrigin),
      );
    } catch (_) {}
  }
}
