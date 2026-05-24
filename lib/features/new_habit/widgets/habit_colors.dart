import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

const habitColors = [
  AppColors.habitTeal,
  AppColors.habitCoral,
  AppColors.habitAmber,
  AppColors.habitBlue,
  AppColors.habitPurple,
  AppColors.habitGreen,
];

class HabitColors extends StatelessWidget {
  const HabitColors({
    super.key,
    required this.selectedColor,
    required this.onSelected,
  });

  final Color selectedColor;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Color', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.md,
          alignment: WrapAlignment.spaceAround,
          children: habitColors.map((color) {
            final isSelected = selectedColor == color;
            return InkWell(
              onTap: () => onSelected(color),
              borderRadius: BorderRadius.circular(AppRadius.round),
              child: CircleAvatar(
                radius: AppSizes.colorSwatchRadius,
                backgroundColor: color,
                child: isSelected
                    ? const Icon(Icons.check, color: AppColors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
