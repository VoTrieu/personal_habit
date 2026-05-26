import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/habit_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../widgets/app_stat_card.dart';

class InsightStatCards extends StatelessWidget {
  const InsightStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HabitController>();
    final totalCompletions = controller.habits.fold<int>(
      0,
      (total, habit) => total + habit.streak,
    );
    return Row(
      children: [
        Expanded(
          child: AppStatCard(
            title: 'Best streak',
            value: '${controller.bestStreak} days',
            subtitle: 'Best current streak',
            icon: Icons.local_fire_department,
            iconColor: AppColors.habitAmber,
            backgroundColor: AppColors.insightAmberBackground,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: AppStatCard(
            title: 'Total completions',
            value: '$totalCompletions',
            subtitle: 'All habits',
            icon: Icons.check_circle_outline,
            iconColor: AppColors.habitCoral,
            backgroundColor: AppColors.insightCoralBackground,
          ),
        ),
      ],
    );
  }
}
