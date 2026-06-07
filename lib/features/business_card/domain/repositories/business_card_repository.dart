import 'package:business_card/features/business_card/domain/entities/business_card.dart';

abstract interface class BusinessCardRepository {
  Future<BusinessCard?> getCard();
  Future<void> saveCard(BusinessCard card);
  Future<void> deleteCard();
}
