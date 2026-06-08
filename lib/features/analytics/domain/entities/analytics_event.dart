class AnalyticsEvent {
  final String id;
  final String cardId;
  final String cardName;
  final String eventType;
  final DateTime timestamp;

  const AnalyticsEvent({
    required this.id,
    required this.cardId,
    required this.cardName,
    required this.eventType,
    required this.timestamp,
  });
}

class EventType {
  static const String qrScan = 'qr_scan';
  static const String nfcOpen = 'nfc_open';
  static const String cardView = 'card_view';
  static const String share = 'share';
  static const String vcfDownload = 'vcf_download';
  static const String contactSave = 'contact_save';

  static const List<String> all = [
    qrScan,
    nfcOpen,
    cardView,
    share,
    vcfDownload,
    contactSave,
  ];
}
