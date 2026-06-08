import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/analytics/domain/entities/analytics_event.dart';
import 'package:business_card/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:business_card/features/networking_score/domain/entities/networking_score.dart';
import 'package:business_card/features/networking_score/domain/services/networking_score_service.dart';
import 'package:business_card/features/scanned_cards/domain/repositories/scanned_card_repository.dart';

class NetworkingScoreState {
  final NetworkingScore score;
  final List<String> insights;
  final bool isLoading;

  const NetworkingScoreState({
    this.score = const NetworkingScore(),
    this.insights = const [],
    this.isLoading = false,
  });
}

class NetworkingScoreCubit extends Cubit<NetworkingScoreState> {
  final ScannedCardRepository _scannedCardRepository;
  final AnalyticsRepository _analyticsRepository;
  final NetworkingScoreService _service;

  NetworkingScoreCubit(
    this._scannedCardRepository,
    this._analyticsRepository,
    this._service,
  ) : super(const NetworkingScoreState());

  Future<void> load() async {
    emit(NetworkingScoreState(isLoading: true));

    final scannedCards = await _scannedCardRepository.getAll();
    final events = await _analyticsRepository.getAllEvents();

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);

    final newContactsThisMonth =
        scannedCards.where((c) => c.scanDate.isAfter(startOfMonth)).length;

    final qrScans = events
        .where((e) => e.eventType == EventType.qrScan)
        .length;
    final nfcOpens = events
        .where((e) => e.eventType == EventType.nfcOpen)
        .length;
    final followUpsCompleted = events
        .where((e) => e.eventType == EventType.followUp)
        .length;
    final sharedCards = events
        .where((e) => e.eventType == EventType.share)
        .length;
    final savedContacts = events
        .where((e) => e.eventType == EventType.contactSave)
        .length;

    final score = _service.calculate(
      totalContacts: scannedCards.length,
      newContactsThisMonth: newContactsThisMonth,
      qrScans: qrScans,
      nfcOpens: nfcOpens,
      followUpsCompleted: followUpsCompleted,
      sharedCards: sharedCards,
      savedContacts: savedContacts,
    );

    final insights = _service.generateInsights(score,
        scannedCardsCount: scannedCards.length);

    emit(NetworkingScoreState(score: score, insights: insights));
  }
}
