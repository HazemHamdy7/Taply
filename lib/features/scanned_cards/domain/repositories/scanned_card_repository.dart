import 'package:business_card/features/scanned_cards/domain/entities/scanned_card.dart';

abstract class ScannedCardRepository {
  Future<List<ScannedCard>> getAll();
  Future<void> save(ScannedCard card);
  Future<void> delete(String id);
  Future<void> toggleFavorite(String id);
  Future<void> updateCategories(String id, List<String> categoryIds);
  Future<List<ScannedCard>> search(String query);
  Future<bool> existsByData(ScannedCard card);
}
