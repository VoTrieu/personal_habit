import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/habit_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

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
          child: _InsightStatCard(
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
          child: _InsightStatCard(
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

class _InsightStatCard extends StatelessWidget {
  const _InsightStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                )),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(icon, color: iconColor),
        ],
      ),
    );
  }
}
