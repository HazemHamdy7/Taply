import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/analytics/domain/repositories/analytics_repository.dart';
import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';
import 'package:business_card/features/scanned_cards/domain/repositories/scanned_card_repository.dart';

enum SortMode { date, name, category, favorites }

class ScannedCardState {
  final List<ScannedCard> cards;
  final bool isLoading;
  final String searchQuery;
  final String? selectedCategoryId;
  final SortMode sortMode;
  final bool showFavoritesOnly;

  const ScannedCardState({
    this.cards = const [],
    this.isLoading = false,
    this.searchQuery = '',
    this.selectedCategoryId,
    this.sortMode = SortMode.date,
    this.showFavoritesOnly = false,
  });

  List<ScannedCard> get filtered {
    var result = cards.toList();

    if (selectedCategoryId != null) {
      result = result
          .where((c) => c.categoryIds.contains(selectedCategoryId))
          .toList();
    }

    if (showFavoritesOnly) {
      result = result.where((c) => c.isFavorite).toList();
    }

    if (searchQuery.isNotEmpty) {
      final q = searchQuery.toLowerCase();
      result = result.where((c) =>
        c.fullName.toLowerCase().contains(q) ||
        c.companyName.toLowerCase().contains(q) ||
        c.jobTitle.toLowerCase().contains(q) ||
        c.email.toLowerCase().contains(q) ||
        c.mobileNumber.contains(q),
      ).toList();
    }

    switch (sortMode) {
      case SortMode.date:
        result.sort((a, b) => b.scanDate.compareTo(a.scanDate));
      case SortMode.name:
        result.sort((a, b) => a.fullName.compareTo(b.fullName));
      case SortMode.category:
        result.sort((a, b) {
          final aCat = a.categoryIds.isNotEmpty ? a.categoryIds.first : '';
          final bCat = b.categoryIds.isNotEmpty ? b.categoryIds.first : '';
          return aCat.compareTo(bCat);
        });
      case SortMode.favorites:
        result.sort((a, b) {
          if (a.isFavorite && !b.isFavorite) return -1;
          if (!a.isFavorite && b.isFavorite) return 1;
          return b.scanDate.compareTo(a.scanDate);
        });
    }

    return result;
  }

  ScannedCardState copyWith({
    List<ScannedCard>? cards,
    bool? isLoading,
    String? searchQuery,
    String? selectedCategoryId,
    SortMode? sortMode,
    bool? showFavoritesOnly,
    bool clearCategory = false,
  }) {
    return ScannedCardState(
      cards: cards ?? this.cards,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      sortMode: sortMode ?? this.sortMode,
      showFavoritesOnly: showFavoritesOnly ?? this.showFavoritesOnly,
    );
  }
}

class ScannedCardCubit extends Cubit<ScannedCardState> {
  final ScannedCardRepository _repository;
  final AnalyticsRepository _analyticsRepository;

  ScannedCardCubit(this._repository, this._analyticsRepository) : super(const ScannedCardState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final cards = await _repository.getAll();
    emit(ScannedCardState(
      cards: cards,
      selectedCategoryId: state.selectedCategoryId,
      sortMode: state.sortMode,
      showFavoritesOnly: state.showFavoritesOnly,
    ));
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
    final card = state.cards.where((c) => c.id == id).firstOrNull;
    await _repository.delete(id);
    if (card != null && card.cardId.isNotEmpty) {
      await _analyticsRepository.deleteEventsByCardId(card.cardId);
    }
    await load();
  }

  Future<void> toggleFavorite(String id) async {
    await _repository.toggleFavorite(id);
    await load();
  }

  Future<void> updateCategories(String id, List<String> categoryIds) async {
    await _repository.updateCategories(id, categoryIds);
    await load();
  }

  void search(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void filterByCategory(String? categoryId) {
    emit(state.copyWith(
      selectedCategoryId: categoryId,
      clearCategory: categoryId == null,
    ));
  }

  void sortBy(SortMode mode) {
    emit(state.copyWith(sortMode: mode));
  }

  void toggleShowFavoritesOnly() {
    emit(state.copyWith(showFavoritesOnly: !state.showFavoritesOnly));
  }
}
