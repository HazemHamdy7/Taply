import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';
import 'package:business_card/features/categories/helpers/icon_helper.dart';
import 'package:business_card/features/categories/helpers/localized_category_name.dart';
import 'package:business_card/features/categories/presentation/cubit/category_cubit.dart';

class CategoryManagerScreen extends StatefulWidget {
  const CategoryManagerScreen({super.key});

  @override
  State<CategoryManagerScreen> createState() => _CategoryManagerScreenState();
}

class _CategoryManagerScreenState extends State<CategoryManagerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().load();
  }

  void _showCreateDialog() {
    _showCategoryFormDialog(null);
  }

  void _showEditDialog(Category category) {
    _showCategoryFormDialog(category);
  }

  void _showCategoryFormDialog(Category? existing) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    String selectedIcon = existing?.icon ?? 'label_outline';
    int selectedColor = existing?.color ?? 0xFF4CAF50;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(ctx).disabledColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                existing == null
                    ? AppLocalizations.of(ctx)!.newCategory
                    : AppLocalizations.of(ctx)!.renameCategory,
                style: Theme.of(ctx).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nameController,
                autofocus: existing == null,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(ctx)!.categoryName,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(ctx)!.categoryIcon,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).disabledColor,
                    ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: GridView.builder(
                  scrollDirection: Axis.horizontal,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                  ),
                  itemCount: availableIconNames.length,
                  itemBuilder: (_, i) {
                    final name = availableIconNames[i];
                    final isSelected = selectedIcon == name;
                    return GestureDetector(
                      onTap: () => setSheetState(() => selectedIcon = name),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(ctx).colorScheme.primaryContainer
                              : Theme.of(ctx).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(8),
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(ctx).colorScheme.primary,
                                  width: 2,
                                )
                              : null,
                        ),
                        child: Icon(
                          getIconData(name),
                          color: isSelected
                              ? Theme.of(ctx).colorScheme.onPrimaryContainer
                              : null,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(ctx)!.categoryColor,
                style: Theme.of(ctx).textTheme.bodySmall?.copyWith(
                      color: Theme.of(ctx).disabledColor,
                    ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: availableColors.map((c) {
                  final isSelected = selectedColor == c;
                  return GestureDetector(
                    onTap: () => setSheetState(() => selectedColor = c),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Color(c),
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: Theme.of(ctx).colorScheme.onSurface,
                                width: 3,
                              )
                            : null,
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check,
                              color: Theme.of(ctx).colorScheme.onSurface,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    if (existing != null) {
                      context.read<CategoryCubit>().update(existing.copyWith(
                            name: name,
                            icon: selectedIcon,
                            color: selectedColor,
                          ));
                    } else {
                      context
                          .read<CategoryCubit>()
                          .create(name, icon: selectedIcon, color: selectedColor);
                    }
                    Navigator.of(ctx).pop();
                  },
                  child: Text(existing == null
                      ? AppLocalizations.of(ctx)!.create
                      : AppLocalizations.of(ctx)!.save),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRenameDialog(Category category) {
    final controller = TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.renameCategory),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          FilledButton(
            onPressed: () {
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<CategoryCubit>().rename(category.id, name);
                Navigator.of(ctx).pop();
              }
            },
            child: Text(AppLocalizations.of(ctx)!.rename),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Category category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.deleteCategory),
        content: Text(AppLocalizations.of(ctx)!.deleteCategoryConfirm(category.name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx)!.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<CategoryCubit>().delete(category.id);
              Navigator.of(ctx).pop();
            },
            child: Text(
              AppLocalizations.of(ctx)!.delete,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.manageCategories),
        centerTitle: true,
      ),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.categories.isEmpty) {
            return Center(
              child: Text(
                AppLocalizations.of(context)!.noCategoriesYet,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.categories.length,
            onReorder: (oldIndex, newIndex) {
              context.read<CategoryCubit>().reorder(oldIndex, newIndex);
            },
            itemBuilder: (context, index) {
              final cat = state.categories[index];
              return Card(
                key: ValueKey(cat.id),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(cat.color),
                    child: Icon(
                      getIconData(cat.icon),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  title: Text(localizedCategoryName(context, cat)),
                  subtitle: cat.isDefault
                      ? Text(
                          AppLocalizations.of(context)!.categoryDefault,
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.disabledColor,
                          ),
                        )
                      : null,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.drag_handle, color: theme.disabledColor),
                      PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            _showEditDialog(cat);
                          } else if (value == 'rename') {
                            _showRenameDialog(cat);
                          } else if (value == 'delete') {
                            _confirmDelete(cat);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: ListTile(
                              leading: const Icon(Icons.edit_outlined),
                              title: Text(AppLocalizations.of(context)!.edit),
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'rename',
                            child: ListTile(
                              leading: const Icon(Icons.drive_file_rename_outline),
                              title: Text(AppLocalizations.of(context)!.rename),
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          PopupMenuItem(
                            value: 'delete',
                            child: ListTile(
                              leading: const Icon(Icons.delete_outline, color: Colors.red),
                              title: Text(AppLocalizations.of(context)!.delete, style: const TextStyle(color: Colors.red)),
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showCreateDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
