import 'package:hive/hive.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/business_card/data/models/business_card_model.dart';
import 'package:business_card/features/business_card/domain/entities/business_card.dart';
import 'package:business_card/features/business_card/domain/repositories/business_card_repository.dart';

class BusinessCardRepositoryImpl implements BusinessCardRepository {
  Box<BusinessCardModel> get _box => Hive.box<BusinessCardModel>(AppConstants.hiveBoxName);

  @override
  Future<List<BusinessCard>> getAllCards() async {
    final models = _box.values.toList();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveCard(BusinessCard card) async {
    final model = BusinessCardModel.fromEntity(card);
    await _box.put(card.id ?? model.id, model);
  }

  @override
  Future<void> deleteCard(String id) async {
    if (_box.containsKey(id)) {
      await _box.delete(id);
      return;
    }
    // Fallback: search by matching stored id field
    final keys = _box.keys.toList();
    for (final key in keys) {
      final model = _box.get(key);
      if (model?.id == id) {
        await _box.delete(key);
        return;
      }
    }
  }
}
