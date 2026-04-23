import 'package:flutter/material.dart';

class CategoryTabBar extends StatelessWidget {
  final List<String> categories;
  final int selectedIndex;
  final ValueChanged<int> onCategoryChanged;

  const CategoryTabBar({
    super.key,
    required this.categories,
    required this.selectedIndex,
    required this.onCategoryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      color: Theme.of(context).colorScheme.surface,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = index == selectedIndex;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: Material(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                onTap: () => onCategoryChanged(index),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      categories[index],
                      style: TextStyle(
                        color: isSelected
                            ? Theme.of(context).colorScheme.onPrimary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
