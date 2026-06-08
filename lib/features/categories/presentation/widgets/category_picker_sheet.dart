import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/categories/presentation/cubit/category_cubit.dart';

class CategoryPickerSheet extends StatefulWidget {
  final List<String> selectedIds;
  final ValueChanged<List<String>> onChanged;

  const CategoryPickerSheet({
    super.key,
    required this.selectedIds,
    required this.onChanged,
  });

  static Future<void> show(
    BuildContext context, {
    required List<String> selectedIds,
    required ValueChanged<List<String>> onChanged,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CategoryPickerSheet(
        selectedIds: selectedIds,
        onChanged: onChanged,
      ),
    );
  }

  @override
  State<CategoryPickerSheet> createState() => _CategoryPickerSheetState();
}

class _CategoryPickerSheetState extends State<CategoryPickerSheet> {
  late List<String> _selected;

  @override
  void initState() {
    super.initState();
    _selected = List.from(widget.selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      maxChildSize: 0.7,
      minChildSize: 0.3,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.disabledColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)!.assignCategories,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<CategoryCubit, CategoryState>(
                  builder: (context, state) {
                    if (state.categories.isEmpty) {
                      return Center(
                        child: Text(
                          AppLocalizations.of(context)!.noCategoriesAvailable,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.disabledColor,
                          ),
                        ),
                      );
                    }

                    return ListView(
                      controller: scrollController,
                      children: state.categories.map((cat) {
                        final isSelected = _selected.contains(cat.id);
                        return CheckboxListTile(
                          title: Text(cat.name),
                          subtitle: cat.isDefault
                              ? Text(
                                  AppLocalizations.of(context)!.categoryDefault,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: theme.disabledColor,
                                  ),
                                )
                              : null,
                          value: isSelected,
                          onChanged: (checked) {
                            setState(() {
                              if (checked == true) {
                                _selected.add(cat.id);
                              } else {
                                _selected.remove(cat.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    widget.onChanged(_selected);
                    Navigator.of(context).pop();
                  },
                  child: Text(AppLocalizations.of(context)!.done),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
