import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';
import 'package:business_card/features/scanned_cards/domain/repositories/scanned_card_repository.dart';

class ScannedCardState {
  final List<ScannedCard> cards;
  final bool isLoading;
  final String searchQuery;

  const ScannedCardState({
    this.cards = const [],
    this.isLoading = false,
    this.searchQuery = '',
  });

  List<ScannedCard> get filtered {
    if (searchQuery.isEmpty) return cards;
    final q = searchQuery.toLowerCase();
    return cards.where((c) =>
      c.fullName.toLowerCase().contains(q) ||
      c.companyName.toLowerCase().contains(q) ||
      c.jobTitle.toLowerCase().contains(q) ||
      c.email.toLowerCase().contains(q) ||
      c.mobileNumber.contains(q),
    ).toList();
  }

  ScannedCardState copyWith({
    List<ScannedCard>? cards,
    bool? isLoading,
    String? searchQuery,
  }) {
    return ScannedCardState(
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ScannedCardCubit extends Cubit<ScannedCardState> {
  final ScannedCardRepository _repository;

  ScannedCardCubit(this._repository) : super(const ScannedCardState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final cards = await _repository.getAll();
    emit(ScannedCardState(cards: cards));
  }

  Future<void> save(ScannedCard card) async {
    await _repository.save(card);
    await load();
  }

  Future<bool> saveIfNotExists(ScannedCard card) async {
    final exists = await _repository.existsByData(card);
    if (exists) return false;
    await _repository.save(card);
    await load();
    return true;
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    await load();
  }

  Future<void> toggleFavorite(String id) async {
    await _repository.toggleFavorite(id);
    await load();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }
}
