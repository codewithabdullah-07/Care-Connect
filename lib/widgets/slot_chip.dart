import 'package:flutter/material.dart';

import '../utils/colors.dart';

class SlotChip extends StatelessWidget {
  const SlotChip({
    super.key,
    required this.slot,
    required this.selected,
    required this.onTap,
  });

  final String slot;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final selectedTextColor = Theme.of(context).brightness == Brightness.dark
        ? AppColors.plum
        : AppColors.ivory;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected
              ? AppColors.gold
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.gold : Theme.of(context).dividerColor,
            width: 1.2,
          ),
        ),
        child: Text(
          slot,
          style: TextStyle(
            color: selected ? selectedTextColor : AppColors.gold,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
