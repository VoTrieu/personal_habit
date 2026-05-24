import 'package:flutter/material.dart';

import '../../../models/habit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
    required this.onOpen,
  });
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onOpen,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.tile),
        child: Row(
          children: [
            CircleAvatar(
              radius: AppSizes.habitIconRadius,
              backgroundColor: habit.color,
              foregroundColor: AppColors.white,
              child: Icon(habit.icon),
            ),
            const SizedBox(width: AppSpacing.fieldVertical),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    habit.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    habit.reminderEnabled
                        ? '${habit.frequency} • ${habit.streak} day streak • Reminder on'
                        : '${habit.frequency} • ${habit.streak} day streak',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: onToggle,
              icon: Icon(
                habit.isCompletedToday
                    ? Icons.check_circle
                    : Icons.circle_outlined,
                size: AppSizes.checkIconSize,
                color: habit.isCompletedToday
                    ? habit.color
                    : AppColors.iconMuted,
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
      ),
    );
  }
}
