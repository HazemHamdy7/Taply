import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/analytics/domain/entities/analytics_event.dart';
import 'package:business_card/features/analytics/domain/entities/analytics_summary.dart';
import 'package:business_card/features/analytics/domain/repositories/analytics_repository.dart';

class AnalyticsState {
  final AnalyticsSummary summary;
  final bool isLoading;

  const AnalyticsState({
    this.summary = const AnalyticsSummary(),
    this.isLoading = false,
  });

  AnalyticsState copyWith({
    AnalyticsSummary? summary,
    bool? isLoading,
  }) {
    return AnalyticsState(
      summary: summary ?? this.summary,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AnalyticsCubit extends Cubit<AnalyticsState> {
  final AnalyticsRepository _repository;

  AnalyticsCubit(this._repository) : super(const AnalyticsState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final summary = await _repository.getSummary();
    emit(AnalyticsState(summary: summary));
  }

  Future<void> trackQrScan(String cardId, String cardName) async {
    await _repository.trackEvent(AnalyticsEvent(
      id: _newId(),
      cardId: cardId,
      cardName: cardName,
      eventType: EventType.qrScan,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> trackNfcOpen(String cardId, String cardName) async {
    await _repository.trackEvent(AnalyticsEvent(
      id: _newId(),
      cardId: cardId,
      cardName: cardName,
      eventType: EventType.nfcOpen,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> trackCardView(String cardId, String cardName) async {
    await _repository.trackEvent(AnalyticsEvent(
      id: _newId(),
      cardId: cardId,
      cardName: cardName,
      eventType: EventType.cardView,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> trackShare(String cardId, String cardName) async {
    await _repository.trackEvent(AnalyticsEvent(
      id: _newId(),
      cardId: cardId,
      cardName: cardName,
      eventType: EventType.share,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> trackVcfDownload(String cardId, String cardName) async {
    await _repository.trackEvent(AnalyticsEvent(
      id: _newId(),
      cardId: cardId,
      cardName: cardName,
      eventType: EventType.vcfDownload,
      timestamp: DateTime.now(),
    ));
  }

  Future<void> trackContactSave(String cardId, String cardName) async {
    await _repository.trackEvent(AnalyticsEvent(
      id: _newId(),
      cardId: cardId,
      cardName: cardName,
      eventType: EventType.contactSave,
      timestamp: DateTime.now(),
    ));
  }

  String _newId() => 'ae_${DateTime.now().millisecondsSinceEpoch}_${_random()}';

  int _random() => DateTime.now().microsecondsSinceEpoch % 10000;
}
