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
    return [
      'FN:${card.fullName}',
      'JT:${card.jobTitle}',
      'CO:${card.companyName}',
      'MB:${card.mobileNumber}',
      'WA:${card.whatsappNumber}',
      'EM:${card.email}',
      'WE:${card.website}',
      'LI:${card.linkedin}',
      'FB:${card.facebook}',
      'IG:${card.instagram}',
      'TG:${card.telegram}',
      'AD:${card.address}',
      'AB:${card.aboutMe}',
    ].join('|');
  }

  BusinessCard _parseCardData(String data) {
    final fields = data.split('|');
    String get(String prefix) {
      for (final f in fields) {
        if (f.startsWith(prefix)) return f.substring(3);
      }
      return '';
    }

    return BusinessCard(
      fullName: get('FN:'),
      jobTitle: get('JT:'),
      companyName: get('CO:'),
      mobileNumber: get('MB:'),
      whatsappNumber: get('WA:'),
      email: get('EM:'),
      website: get('WE:'),
      linkedin: get('LI:'),
      facebook: get('FB:'),
      instagram: get('IG:'),
      telegram: get('TG:'),
      address: get('AD:'),
      aboutMe: get('AB:'),
    );
  }

  void clearState() {
    emit(NfcState(availability: state.availability));
  }
}
