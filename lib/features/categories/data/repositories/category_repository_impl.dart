import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/categories/data/models/category_model.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';
import 'package:business_card/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  Box<CategoryModel> get _box =>
      Hive.box<CategoryModel>(AppConstants.categoriesBoxName);

  static const _defaultsKey = 'categories_defaults_initialized';

  static const List<Category> defaultCategories = [
    Category(
      id: 'default_clients',
      name: 'Clients',
      isDefault: true,
      icon: 'work',
      color: 0xFF4CAF50,
      sortOrder: 0,
    ),
    Category(
      id: 'default_investors',
      name: 'Investors',
      isDefault: true,
      icon: 'trending_up',
      color: 0xFF2196F3,
      sortOrder: 1,
    ),
    Category(
      id: 'default_developers',
      name: 'Developers',
      isDefault: true,
      icon: 'code',
      color: 0xFF9C27B0,
      sortOrder: 2,
    ),
    Category(
      id: 'default_designers',
      name: 'Designers',
      isDefault: true,
      icon: 'palette',
      color: 0xFFFF5722,
      sortOrder: 3,
    ),
    Category(
      id: 'default_partners',
      name: 'Partners',
      isDefault: true,
      icon: 'handshake',
      color: 0xFFFF9800,
      sortOrder: 4,
    ),
    Category(
      id: 'default_friends',
      name: 'Friends',
      isDefault: true,
      icon: 'people',
      color: 0xFFE91E63,
      sortOrder: 5,
    ),
  ];

  Future<void> ensureDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_defaultsKey) == true) {
      for (final cat in defaultCategories) {
        final existing = _box.get(cat.id);
        if (existing != null && (existing.icon == 'label_outline' || existing.color == 0xFF9E9E9E)) {
          await _box.put(cat.id, CategoryModel.fromEntity(cat));
        }
      }
      return;
    }

    for (final cat in defaultCategories) {
      if (_box.get(cat.id) == null) {
        await _box.put(cat.id, CategoryModel.fromEntity(cat));
      }
    }
    await prefs.setBool(_defaultsKey, true);
  }

  @override
  Future<List<Category>> getAll() async {
    final models = _box.values.toList();
    models.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> save(Category category) async {
    await _box.put(category.id, CategoryModel.fromEntity(category));
  }

  @override
  Future<void> rename(String id, String newName) async {
    final model = _box.get(id);
    if (model != null) {
      await _box.put(
        id,
        CategoryModel(
          id: model.id,
          name: newName,
          isDefault: model.isDefault,
          icon: model.icon,
          color: model.color,
          sortOrder: model.sortOrder,
        ),
      );
    }
  }

  @override
  Future<void> update(Category category) async {
    await _box.put(category.id, CategoryModel.fromEntity(category));
  }

  @override
  Future<void> reorder(String id, int newSortOrder) async {
    final model = _box.get(id);
    if (model != null) {
      await _box.put(
        id,
        CategoryModel(
          id: model.id,
          name: model.name,
          isDefault: model.isDefault,
          icon: model.icon,
          color: model.color,
          sortOrder: newSortOrder,
        ),
      );
    }
  }

  @override
  Future<void> delete(String id) async {
    await _box.delete(id);
  }

  @override
  Category? getById(String id) {
    final model = _box.get(id);
    return model?.toEntity();
  }
}
