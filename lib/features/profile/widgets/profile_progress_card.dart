import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class ProfileProgressCard extends StatelessWidget {
  const ProfileProgressCard({
    super.key,
    required this.completedCount,
    required this.totalCount,
    required this.progress,
  });

  final int completedCount;
  final int totalCount;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.insightTealBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Today progress',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Text(
                '$completedCount/$totalCount',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.round),
            child: LinearProgressIndicator(
              minHeight: AppSpacing.sm,
              value: progress,
              backgroundColor: AppColors.white,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            totalCount == 0
                ? 'Add your first habit to start tracking.'
                : 'Complete today\'s habits to keep your streak moving.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
