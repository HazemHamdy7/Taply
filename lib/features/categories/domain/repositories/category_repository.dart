import 'package:business_card/features/categories/domain/entities/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getAll();
  Future<void> save(Category category);
  Future<void> rename(String id, String newName);
  Future<void> update(Category category);
  Future<void> reorder(String id, int newSortOrder);
  Future<void> delete(String id);
  Category? getById(String id);
}
