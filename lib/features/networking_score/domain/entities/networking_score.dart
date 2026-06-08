class NetworkingScore {
  final int score;
  final int totalContacts;
  final int newContactsThisMonth;
  final int qrScans;
  final int nfcOpens;
  final int followUpsCompleted;
  final int sharedCards;
  final int savedContacts;

  const NetworkingScore({
    this.score = 0,
    this.totalContacts = 0,
    this.newContactsThisMonth = 0,
    this.qrScans = 0,
    this.nfcOpens = 0,
    this.followUpsCompleted = 0,
    this.sharedCards = 0,
    this.savedContacts = 0,
  });

  String get level {
    if (score <= 30) return 'Beginner Networker';
    if (score <= 60) return 'Active Networker';
    if (score <= 80) return 'Professional Networker';
    return 'Networking Expert';
  }

  double get progressFraction => score / 100.0;
}
