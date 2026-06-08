import 'package:hive/hive.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/analytics/data/models/analytics_event_model.dart';
import 'package:business_card/features/analytics/domain/entities/analytics_event.dart';
import 'package:business_card/features/analytics/domain/entities/analytics_summary.dart';
import 'package:business_card/features/analytics/domain/entities/card_analytics.dart';
import 'package:business_card/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  Box<AnalyticsEventModel> get _box =>
      Hive.box<AnalyticsEventModel>(AppConstants.analyticsBoxName);

  @override
  Future<void> trackEvent(AnalyticsEvent event) async {
    final model = AnalyticsEventModel.fromEntity(event);
    await _box.put(event.id, model);
  }

  @override
  Future<List<AnalyticsEvent>> getAllEvents() async {
    final models = _box.values.toList();
    models.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<AnalyticsSummary> getSummary() async {
    final events = _box.values.toList();

    int totalQrScans = 0;
    int totalNfcOpens = 0;
    int totalCardViews = 0;
    int totalShares = 0;
    int totalVcfDownloads = 0;
    int totalContactSaves = 0;

    final cardCounts = <String, _CardCounts>{};

    final dailyMap = <int, int>{};
    final weeklyMap = <int, int>{};
    final monthlyMap = <String, int>{};

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    for (final event in events) {
      switch (event.eventType) {
        case EventType.qrScan:
          totalQrScans++;
          break;
        case EventType.nfcOpen:
          totalNfcOpens++;
          break;
        case EventType.cardView:
          totalCardViews++;
          break;
        case EventType.share:
          totalShares++;
          break;
        case EventType.vcfDownload:
          totalVcfDownloads++;
          break;
        case EventType.contactSave:
          totalContactSaves++;
          break;
      }

      cardCounts.putIfAbsent(event.cardId, () => _CardCounts(name: event.cardName));
      final cc = cardCounts[event.cardId]!;
      switch (event.eventType) {
        case EventType.cardView:
          cc.views++;
          break;
        case EventType.share:
        case EventType.vcfDownload:
          cc.shares++;
          break;
        case EventType.qrScan:
        case EventType.nfcOpen:
          cc.opens++;
          break;
      }
      cc.total++;

      final dayKey = _dayKey(event.timestamp);
      dailyMap[dayKey] = (dailyMap[dayKey] ?? 0) + 1;

      final weekKey = _weekKey(event.timestamp);
      weeklyMap[weekKey] = (weeklyMap[weekKey] ?? 0) + 1;

      final monthKey = _monthKey(event.timestamp);
      monthlyMap[monthKey] = (monthlyMap[monthKey] ?? 0) + 1;
    }

    final sortedCards = cardCounts.entries
        .map((e) => CardAnalytics(
              cardId: e.key,
              cardName: e.value.name,
              viewCount: e.value.views,
              shareCount: e.value.shares,
              openCount: e.value.opens,
              totalCount: e.value.total,
            ))
        .toList();

    final topViewed = List<CardAnalytics>.from(sortedCards)
      ..sort((a, b) => b.viewCount.compareTo(a.viewCount));
    final topShared = List<CardAnalytics>.from(sortedCards)
      ..sort((a, b) => b.shareCount.compareTo(a.shareCount));
    final topOpened = List<CardAnalytics>.from(sortedCards)
      ..sort((a, b) => b.openCount.compareTo(a.openCount));

    final dailyActivity = <DayActivity>[];
    for (int i = 6; i >= 0; i--) {
      final d = DateTime(today.year, today.month, today.day - i);
      final key = _dayKey(d);
      dailyActivity.add(DayActivity(date: d, count: dailyMap[key] ?? 0));
    }

    final weeklyActivity = <WeekActivity>[];
    for (int i = 3; i >= 0; i--) {
      final monday = _startOfWeek(today.subtract(Duration(days: 7 * i)));
      final wKey = _weekKey(monday);
      final label = '${monday.month}/${monday.day}';
      weeklyActivity.add(WeekActivity(label: label, count: weeklyMap[wKey] ?? 0));
    }

    final monthlyActivity = <MonthActivity>[];
    for (int i = 5; i >= 0; i--) {
      final m = DateTime(today.year, today.month - i, 1);
      final key = _monthKey(m);
      final label = '${m.year}-${m.month.toString().padLeft(2, '0')}';
      monthlyActivity.add(MonthActivity(label: label, count: monthlyMap[key] ?? 0));
    }

    return AnalyticsSummary(
      totalQrScans: totalQrScans,
      totalNfcOpens: totalNfcOpens,
      totalCardViews: totalCardViews,
      totalShares: totalShares,
      totalVcfDownloads: totalVcfDownloads,
      totalContactSaves: totalContactSaves,
      totalEvents: events.length,
      topViewed: topViewed.take(5).toList(),
      topShared: topShared.take(5).toList(),
      topOpened: topOpened.take(5).toList(),
      dailyActivity: dailyActivity,
      weeklyActivity: weeklyActivity,
      monthlyActivity: monthlyActivity,
    );
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }

  int _dayKey(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day).millisecondsSinceEpoch;
  }

  int _weekKey(DateTime dt) {
    final monday = _startOfWeek(dt);
    return DateTime(monday.year, monday.month, monday.day).millisecondsSinceEpoch;
  }

  DateTime _startOfWeek(DateTime dt) {
    final weekday = dt.weekday;
    final daysFromMonday = weekday - DateTime.monday;
    return DateTime(dt.year, dt.month, dt.day - daysFromMonday);
  }

  String _monthKey(DateTime dt) {
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}';
  }
}

class _CardCounts {
  final String name;
  int views = 0;
  int shares = 0;
  int opens = 0;
  int total = 0;

  _CardCounts({required this.name});
}
