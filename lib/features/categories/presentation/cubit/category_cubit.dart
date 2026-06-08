import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';
import 'package:business_card/features/categories/domain/repositories/category_repository.dart';

class CategoryState {
  final List<Category> categories;
  final bool isLoading;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
  });

  CategoryState copyWith({
    List<Category>? categories,
    bool? isLoading,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepository _repository;

  CategoryCubit(this._repository) : super(const CategoryState());

  Future<void> load() async {
    emit(state.copyWith(isLoading: true));
    final categories = await _repository.getAll();
    emit(CategoryState(categories: categories));
  }

  Future<void> create(String name, {String icon = 'label_outline', int color = 0xFF9E9E9E}) async {
    final categories = await _repository.getAll();
    final id = 'cat_${DateTime.now().millisecondsSinceEpoch}';
    final category = Category(
      id: id,
      name: name,
      icon: icon,
      color: color,
      sortOrder: categories.length,
    );
    await _repository.save(category);
    await load();
  }

  Future<void> rename(String id, String newName) async {
    await _repository.rename(id, newName);
    await load();
  }

  Future<void> update(Category category) async {
    await _repository.update(category);
    await load();
  }

  Future<void> delete(String id) async {
    await _repository.delete(id);
    await load();
  }

  Future<void> reorder(int oldIndex, int newIndex) async {
    final categories = await _repository.getAll();
    if (oldIndex < 0 || oldIndex >= categories.length) return;
    if (newIndex < 0 || newIndex >= categories.length) return;

    final updated = List<Category>.from(categories);
    final item = updated.removeAt(oldIndex);
    updated.insert(newIndex, item);

    for (int i = 0; i < updated.length; i++) {
      if (updated[i].sortOrder != i) {
        await _repository.reorder(updated[i].id, i);
      }
    }
    await load();
  }
}
