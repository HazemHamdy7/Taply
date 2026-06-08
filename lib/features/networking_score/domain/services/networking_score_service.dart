import 'package:business_card/features/networking_score/domain/entities/networking_score.dart';

class NetworkingScoreService {
  NetworkingScore calculate({
    required int totalContacts,
    required int newContactsThisMonth,
    required int qrScans,
    required int nfcOpens,
    required int followUpsCompleted,
    required int sharedCards,
    required int savedContacts,
  }) {
    int points = 0;

    points += _cap(totalContacts, 20);
    points += _cap(newContactsThisMonth * 2, 15);
    points += _cap(qrScans, 15);
    points += _cap(nfcOpens * 2, 10);
    points += _cap(followUpsCompleted * 3, 15);
    points += _cap(sharedCards * 2, 15);
    points += _cap(savedContacts, 10);

    return NetworkingScore(
      score: points.clamp(0, 100),
      totalContacts: totalContacts,
      newContactsThisMonth: newContactsThisMonth,
      qrScans: qrScans,
      nfcOpens: nfcOpens,
      followUpsCompleted: followUpsCompleted,
      sharedCards: sharedCards,
      savedContacts: savedContacts,
    );
  }

  int _cap(int value, int max) => value > max ? max : value;

  List<String> generateInsights(NetworkingScore score,
      {required int scannedCardsCount}) {
    final insights = <String>[];

    if (score.totalContacts < 10) {
      insights.add('Add more contacts to improve your score');
    }
    if (score.qrScans < 3) {
      insights.add('Print your QR code or share it digitally');
    }
    if (score.nfcOpens < 2) {
      insights.add('Use NFC to quickly exchange cards');
    }
    if (score.sharedCards < 3) {
      insights.add('Share your card more often');
    }
    if (score.savedContacts < score.totalContacts) {
      insights.add('Save more contacts from your scans');
    }
    if (score.followUpsCompleted < 3) {
      insights.add('Follow up with saved contacts');
    }

    if (insights.isEmpty) {
      insights.add('Great job! Keep networking to maintain your score');
    }

    return insights.take(3).toList();
  }
}
