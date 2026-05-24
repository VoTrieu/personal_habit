import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';
import 'habit_detail_result.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habit});

  final Habit habit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit.name)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(habit.icon, size: AppSizes.detailIconSize),
            const SizedBox(height: AppSpacing.lg),
            Text(habit.name, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text('Current streak: ${habit.streak} days'),
            const SizedBox(height: AppSpacing.sm),
            Text('Frequency: ${habit.frequency}'),
            const SizedBox(height: AppSpacing.sm),
            Text(
              habit.reminderEnabled
                  ? 'Reminder ${formatTimeOfDay(habit.reminderTime)}'
                  : 'Reminder Off',
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              habit.isCompletedToday
                  ? 'Completed today'
                  : 'Not completed today',
            ),
            const SizedBox(height: AppSpacing.xl),
            FilledButton.icon(
              onPressed: () => Navigator.pop(
                context,
                HabitDetailResult(
                  habitId: habit.id,
                  action: HabitDetailAction.toggleCompletion,
                ),
              ),
              icon: Icon(
                habit.isCompletedToday
                    ? Icons.check_circle
                    : Icons.check_circle_outline,
              ),
              label: Text(
                habit.isCompletedToday
                    ? 'Mark as Incomplete'
                    : 'Mark as Completed',
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            OutlinedButton.icon(
              onPressed: () => Navigator.pop(
                context,
                HabitDetailResult(
                  habitId: habit.id,
                  action: HabitDetailAction.edit,
                ),
              ),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
