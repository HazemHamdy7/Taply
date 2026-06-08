import 'package:business_card/features/analytics/domain/entities/card_analytics.dart';

class DayActivity {
  final DateTime date;
  final int count;

  const DayActivity({required this.date, required this.count});
}

class WeekActivity {
  final String label;
  final int count;

  const WeekActivity({required this.label, required this.count});
}

class MonthActivity {
  final String label;
  final int count;

  const MonthActivity({required this.label, required this.count});
}

class AnalyticsSummary {
  final int totalQrScans;
  final int totalNfcOpens;
  final int totalCardViews;
  final int totalShares;
  final int totalVcfDownloads;
  final int totalContactSaves;
  final int totalEvents;
  final List<CardAnalytics> topViewed;
  final List<CardAnalytics> topShared;
  final List<CardAnalytics> topOpened;
  final List<DayActivity> dailyActivity;
  final List<WeekActivity> weeklyActivity;
  final List<MonthActivity> monthlyActivity;

  const AnalyticsSummary({
    this.totalQrScans = 0,
    this.totalNfcOpens = 0,
    this.totalCardViews = 0,
    this.totalShares = 0,
    this.totalVcfDownloads = 0,
    this.totalContactSaves = 0,
    this.totalEvents = 0,
    this.topViewed = const [],
    this.topShared = const [],
    this.topOpened = const [],
    this.dailyActivity = const [],
    this.weeklyActivity = const [],
    this.monthlyActivity = const [],
  });
}
