import 'package:hive/hive.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/business_card/data/models/business_card_model.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/domain/repositories/business_card_repository.dart';

class BusinessCardRepositoryImpl implements BusinessCardRepository {
  Box<BusinessCardModel> get _box => Hive.box<BusinessCardModel>(AppConstants.hiveBoxName);

  @override
  Future<BusinessCard?> getCard() async {
    final model = _box.get(AppConstants.cardKey);
    return model?.toEntity();
  }

  @override
  Future<void> saveCard(BusinessCard card) async {
    final model = BusinessCardModel.fromEntity(card);
    await _box.put(AppConstants.cardKey, model);
  }

  @override
  Future<void> deleteCard() async {
    await _box.delete(AppConstants.cardKey);
  }
}
