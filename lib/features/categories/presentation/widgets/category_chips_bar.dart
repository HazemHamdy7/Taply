import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:business_card/core/l10n/app_localizations.dart';
import 'package:business_card/features/categories/presentation/cubit/category_cubit.dart';
import 'package:business_card/features/scanned_cards/presentation/cubit/scanned_card_cubit.dart';

class CategoryChipsBar extends StatelessWidget {
  const CategoryChipsBar({super.key});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return BlocBuilder<CategoryCubit, CategoryState>(
      builder: (context, catState) {
        return BlocBuilder<ScannedCardCubit, ScannedCardState>(
          builder: (context, cardState) {
            final categories = catState.categories;
            if (categories.isEmpty) return const SizedBox.shrink();

            return SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: loc.allCategories,
                    selected: cardState.selectedCategoryId == null,
                    onSelected: () => context
                        .read<ScannedCardCubit>()
                        .filterByCategory(null),
                  ),
                  const SizedBox(width: 8),
                  ...categories.map((cat) => _FilterChip(
                        label: cat.name,
                        selected: cardState.selectedCategoryId == cat.id,
                        onSelected: () => context
                            .read<ScannedCardCubit>()
                            .filterByCategory(cat.id),
                      )),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: FilterChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onSelected(),
        visualDensity: VisualDensity.compact,
        selectedColor: theme.colorScheme.primaryContainer,
        checkmarkColor: theme.colorScheme.onPrimaryContainer,
        labelStyle: TextStyle(
          fontSize: 13,
          color: selected
              ? theme.colorScheme.onPrimaryContainer
              : theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
