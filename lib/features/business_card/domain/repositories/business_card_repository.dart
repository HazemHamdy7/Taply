import 'package:business_card/features/business_card/domain/entities/business_card.dart';

abstract interface class BusinessCardRepository {
  Future<List<BusinessCard>> getAllCards();
  Future<void> saveCard(BusinessCard card);
  Future<void> deleteCard(String id);
}
