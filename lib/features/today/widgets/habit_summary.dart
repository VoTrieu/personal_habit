import 'package:flutter/material.dart';

import '../../../theme/app_dimensions.dart';

class HabitSummary extends StatelessWidget {
  final int bestStreak;
  final int completedCount;
  final int totalCount;
  final double completionProgress;

  const HabitSummary({
    super.key,
    required this.bestStreak,
    required this.completedCount,
    required this.totalCount,
    required this.completionProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$completedCount of $totalCount habits completed',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.sm),
        LinearProgressIndicator(value: completionProgress),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Best Streak: $bestStreak days',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}
