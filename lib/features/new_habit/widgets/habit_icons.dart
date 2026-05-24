import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

const habitIcons = [
  Icons.menu_book,
  Icons.water_drop,
  Icons.directions_walk,
  Icons.fitness_center,
  Icons.self_improvement,
  Icons.language,
];

class HabitIcons extends StatelessWidget {
  const HabitIcons({
    super.key,
    required this.selectedIcon,
    required this.onSelected,
  });

  final IconData selectedIcon;
  final ValueChanged<IconData> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Icon', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          alignment: WrapAlignment.spaceAround,
          children: habitIcons.map((icon) {
            final isSelected = selectedIcon == icon;
            return InkWell(
              onTap: () => onSelected(icon),
              borderRadius: BorderRadius.circular(AppRadius.round),
              child: CircleAvatar(
                radius: AppSizes.habitIconRadius,
                backgroundColor: isSelected
                    ? AppColors.primary
                    : AppColors.optionBackground,
                foregroundColor: isSelected
                    ? AppColors.white
                    : AppColors.textMuted,
                child: Icon(icon),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
