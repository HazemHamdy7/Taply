import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/domain/repositories/business_card_repository.dart';

class BusinessCardState {
  final List<BusinessCard> cards;
  final int selectedIndex;
  final bool isLoading;

  const BusinessCardState({
    this.cards = const [],
    this.selectedIndex = 0,
    this.isLoading = false,
  });

  BusinessCard? get selectedCard =>
      cards.isEmpty ? null : cards[selectedIndex.clamp(0, cards.length - 1)];

  BusinessCardState copyWith({
    List<BusinessCard>? cards,
    int? selectedIndex,
    bool? isLoading,
  }) {
    return BusinessCardState(
      cards: cards ?? this.cards,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BusinessCardCubit extends Cubit<BusinessCardState> {
  final BusinessCardRepository _repository;

  BusinessCardCubit(this._repository) : super(const BusinessCardState());

  Future<void> loadCards() async {
    emit(state.copyWith(isLoading: true));
    final cards = await _repository.getAllCards();
    emit(BusinessCardState(cards: cards));
  }

  Future<void> saveCard(BusinessCard card) async {
    emit(state.copyWith(isLoading: true));
    final id = card.id ?? DateTime.now().millisecondsSinceEpoch.toString();
    final toSave = card.copyWith(id: id);
    await _repository.saveCard(toSave);
    final cards = await _repository.getAllCards();
    final newIndex = cards.indexWhere((c) => c.id == id);
    emit(BusinessCardState(cards: cards, selectedIndex: newIndex >= 0 ? newIndex : 0));
  }

  Future<void> deleteCard(String id) async {
    final currentIndex = state.selectedIndex;
    final currentLen = state.cards.length;
    emit(state.copyWith(isLoading: true));
    try {
      await _repository.deleteCard(id);
    } catch (_) {}
    try {
      final cards = await _repository.getAllCards();
      final newIndex = currentIndex.clamp(0, cards.length - 1);
      emit(BusinessCardState(
        cards: cards,
        selectedIndex: currentLen != cards.length ? newIndex : currentIndex,
      ));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void selectCard(int index) {
    if (index >= 0 && index < state.cards.length) {
      emit(state.copyWith(selectedIndex: index));
    }
  }
}
