import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:ndef/ndef.dart' as ndef;
import 'package:business_card/features/business_card/domain/entities/business_card.dart';

class NfcState {
  final NFCAvailability availability;
  final bool isPolling;
  final bool isWriting;
  final String? message;
  final BusinessCard? readCard;

  const NfcState({
    this.availability = NFCAvailability.not_supported,
    this.isPolling = false,
    this.isWriting = false,
    this.message,
    this.readCard,
  });

  NfcState copyWith({
    NFCAvailability? availability,
    bool? isPolling,
    bool? isWriting,
    String? message,
    BusinessCard? readCard,
    bool clearMessage = false,
    bool clearCard = false,
  }) {
    return NfcState(
      availability: availability ?? this.availability,
      isPolling: isPolling ?? this.isPolling,
      isWriting: isWriting ?? this.isWriting,
      message: clearMessage ? null : (message ?? this.message),
      readCard: clearCard ? null : (readCard ?? this.readCard),
    );
  }
}

class NfcCubit extends Cubit<NfcState> {
  NfcCubit() : super(const NfcState()) {
    _checkAvailability();
  }

  Future<void> _checkAvailability() async {
    final availability = await FlutterNfcKit.nfcAvailability;
    emit(state.copyWith(availability: availability));
  }

  Future<void> writeCard(BusinessCard card) async {
    emit(state.copyWith(isPolling: true, isWriting: true, clearMessage: true, clearCard: true));

    try {
      await FlutterNfcKit.poll(
        iosAlertMessage: 'Hold your phone near the NFC tag to write data',
      );

      final data = _cardToNdefPayload(card);
      final record = ndef.TextRecord(text: data, language: 'en');
      await FlutterNfcKit.writeNDEFRecords([record]);
      await FlutterNfcKit.finish(iosAlertMessage: 'Written successfully');

      emit(state.copyWith(
        isPolling: false,
        isWriting: false,
        message: 'Data written successfully',
      ));
    } catch (e) {
      await FlutterNfcKit.finish(iosErrorMessage: 'Write failed');
      emit(state.copyWith(
        isPolling: false,
        isWriting: false,
        message: 'Error writing: $e',
      ));
    }
  }

  Future<void> readCard() async {
    emit(state.copyWith(isPolling: true, clearMessage: true, clearCard: true));

    try {
      await FlutterNfcKit.poll(
        iosAlertMessage: 'Hold your phone near the NFC tag to read data',
      );

      final records = await FlutterNfcKit.readNDEFRecords();
      await FlutterNfcKit.finish(iosAlertMessage: 'Read successfully');

      if (records.isEmpty) {
        emit(state.copyWith(isPolling: false, message: 'No NDEF records found'));
        return;
      }

      final record = records.first;
      String data;
      if (record is ndef.TextRecord) {
        data = record.text ?? '';
      } else {
        final payload = record.payload;
        data = payload != null ? String.fromCharCodes(payload) : '';
      }
      final card = _parseCardData(data);

      emit(state.copyWith(
        isPolling: false,
        readCard: card,
        message: 'Data read successfully',
      ));
    } catch (e) {
      await FlutterNfcKit.finish(iosErrorMessage: 'Read failed');
      emit(state.copyWith(
        isPolling: false,
        message: 'Error reading: $e',
      ));
    }
  }

  String _cardToNdefPayload(BusinessCard card) {
    final lines = <String>[
      'BEGIN:VCARD',
      'VERSION:3.0',
      if (card.fullName.isNotEmpty) 'FN:${card.fullName}',
      if (card.jobTitle.isNotEmpty) 'TITLE:${card.jobTitle}',
      if (card.companyName.isNotEmpty) 'ORG:${card.companyName}',
      if (card.mobileNumber.isNotEmpty) 'TEL;TYPE=CELL:${card.mobileNumber}',
      if (card.whatsappNumber.isNotEmpty) 'TEL;TYPE=OTHER:${card.whatsappNumber}',
      if (card.email.isNotEmpty) 'EMAIL:${card.email}',
      if (card.website.isNotEmpty) 'URL:${card.website}',
      if (card.address.isNotEmpty) 'ADR;TYPE=WORK:;;${card.address}',
      if (card.linkedin.isNotEmpty ||
          card.facebook.isNotEmpty ||
          card.instagram.isNotEmpty ||
          card.telegram.isNotEmpty ||
          card.aboutMe.isNotEmpty)
        'NOTE:${[
          if (card.linkedin.isNotEmpty) 'LinkedIn: ${card.linkedin}',
          if (card.facebook.isNotEmpty) 'Facebook: ${card.facebook}',
          if (card.instagram.isNotEmpty) 'Instagram: ${card.instagram}',
          if (card.telegram.isNotEmpty) 'Telegram: ${card.telegram}',
          if (card.aboutMe.isNotEmpty) card.aboutMe,
        ].join('\\n')}',
      'END:VCARD',
    ];
    return lines.join('\n');
  }

  BusinessCard _parseCardData(String data) {
    final map = <String, String>{};
    for (final line in data.split('\n')) {
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

    final fullName = map['FN'] ?? '';
    final note = map['NOTE'] ?? '';

    return BusinessCard(
      fullName: fullName,
      jobTitle: map['TITLE'] ?? '',
      companyName: map['ORG'] ?? '',
      mobileNumber:
          map['TEL'] != null ? map['TEL']!.split('\\n').first : '',
      email: map['EMAIL'] ?? '',
      website: map['URL'] ?? '',
      address: map['ADR']
              ?.replaceAll(RegExp(r'^;+'), '')
              .replaceAll(';', ', ') ??
          '',
      aboutMe: note,
    );
  }

  void clearState() {
    emit(NfcState(availability: state.availability));
  }
}
