class CardAnalytics {
  final String cardId;
  final String cardName;
  final int viewCount;
  final int shareCount;
  final int openCount;
  final int totalCount;

  const CardAnalytics({
    required this.cardId,
    required this.cardName,
    this.viewCount = 0,
    this.shareCount = 0,
    this.openCount = 0,
    this.totalCount = 0,
  });
}
