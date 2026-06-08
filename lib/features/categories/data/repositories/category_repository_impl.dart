import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:business_card/core/constants/app_constants.dart';
import 'package:business_card/features/categories/data/models/category_model.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';
import 'package:business_card/features/categories/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  Box<CategoryModel> get _box => Hive.box<CategoryModel>(AppConstants.categoriesBoxName);

  static const _defaultsKey = 'categories_defaults_initialized';

  static const List<Category> defaultCategories = [
    Category(id: 'default_clients', name: 'Clients', isDefault: true),
    Category(id: 'default_investors', name: 'Investors', isDefault: true),
    Category(id: 'default_developers', name: 'Developers', isDefault: true),
    Category(id: 'default_designers', name: 'Designers', isDefault: true),
    Category(id: 'default_partners', name: 'Partners', isDefault: true),
    Category(id: 'default_friends', name: 'Friends', isDefault: true),
  ];

  Future<void> ensureDefaults() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getBool(_defaultsKey) == true) return;

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
        CategoryModel(id: model.id, name: newName, isDefault: model.isDefault),
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
