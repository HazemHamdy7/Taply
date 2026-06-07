import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/domain/repositories/business_card_repository.dart';

class BusinessCardState {
  final BusinessCard? card;
  final bool isLoading;

  const BusinessCardState({this.card, this.isLoading = false});

  BusinessCardState copyWith({BusinessCard? card, bool? isLoading}) {
    return BusinessCardState(
      card: card ?? this.card,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class BusinessCardCubit extends Cubit<BusinessCardState> {
  final BusinessCardRepository _repository;

  BusinessCardCubit(this._repository) : super(const BusinessCardState());

  Future<void> loadCard() async {
    emit(state.copyWith(isLoading: true));
    final card = await _repository.getCard();
    emit(BusinessCardState(card: card, isLoading: false));
  }

  Future<void> saveCard(BusinessCard card) async {
    emit(state.copyWith(isLoading: true));
    await _repository.saveCard(card);
    emit(BusinessCardState(card: card, isLoading: false));
  }

  Future<void> deleteCard() async {
    await _repository.deleteCard();
    emit(const BusinessCardState());
  }

  bool get hasCard => state.card != null;
}
