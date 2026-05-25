import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/habit_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class CompletionRate extends StatelessWidget {
  const CompletionRate({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HabitController>();
    final progress = controller.completionProgress;
    final percentage = (progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.insightTealBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Completion rate',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '$percentage%',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${controller.completedCount} of ${controller.habits.length} habits completed',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: AppSizes.completionRateChartSize,
            height: AppSizes.completionRateChartSize,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: AppSizes.completionRateStrokeWidth,
              backgroundColor: AppColors.borderLight,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
