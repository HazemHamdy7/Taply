import 'package:business_card/features/analytics/domain/entities/analytics_event.dart';
import 'package:business_card/features/analytics/domain/entities/analytics_summary.dart';

abstract class AnalyticsRepository {
  Future<void> trackEvent(AnalyticsEvent event);
  Future<List<AnalyticsEvent>> getAllEvents();
  Future<AnalyticsSummary> getSummary();
  Future<void> deleteEventsByCardId(String cardId);
  Future<void> clearAll();
}
