import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/categories/domain/entities/category.dart';
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
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Category'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Category name',
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
                context.read<CategoryCubit>().create(name);
                Navigator.of(ctx).pop();
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }

  void _showRenameDialog(Category category) {
    final controller = TextEditingController(text: category.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename Category'),
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
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(Category category) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Category'),
        content: Text('Delete "${category.name}" category?'),
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
        title: const Text('Manage Categories'),
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
                'No categories yet',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.disabledColor,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.categories.length,
            itemBuilder: (context, index) {
              final cat = state.categories[index];
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: theme.colorScheme.primaryContainer,
                    child: Icon(
                      Icons.label_outline,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                  title: Text(cat.name),
                  subtitle: cat.isDefault
                      ? Text(
                          'Default',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.disabledColor,
                          ),
                        )
                      : null,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'rename') {
                        _showRenameDialog(cat);
                      } else if (value == 'delete') {
                        _confirmDelete(cat);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'rename',
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('Rename'),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete_outline, color: Colors.red),
                          title: Text('Delete', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                        ),
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
