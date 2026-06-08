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
      insights.add('insightAddContacts');
    }
    if (score.qrScans < 3) {
      insights.add('insightShareQR');
    }
    if (score.nfcOpens < 2) {
      insights.add('insightUseNfc');
    }
    if (score.sharedCards < 3) {
      insights.add('insightShareMore');
    }
    if (score.savedContacts < score.totalContacts) {
      insights.add('insightSaveContacts');
    }
    if (score.followUpsCompleted < 3) {
      insights.add('insightFollowUp');
    }

    if (insights.isEmpty) {
      insights.add('insightGreatJob');
    }

    return insights.take(3).toList();
  }
}
