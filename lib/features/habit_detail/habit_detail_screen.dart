import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../models/habit.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';
import '../../widgets/completion_week_strip.dart';
import 'habit_detail_result.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key, required this.habit});

  final Habit habit;

  int get totalCompletions {
    return habit.streak * 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(habit.name)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screen),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: AppSizes.detailIconSize / 2,
                backgroundColor: habit.color,
                foregroundColor: AppColors.white,
                child: Icon(habit.icon, size: AppSizes.detailIconSize),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: _DetailStat(
                    value: '${habit.streak}',
                    label: 'Current Streak',
                  ),
                ),
                Expanded(
                  child: _DetailStat(
                    value: '$totalCompletions',
                    label: 'Total completions',
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xxl),
            const CompletionWeekStrip(
              title: 'Last 7 days',
              days: [
                CompletionDay(label: 'Sat', date: '16', isCompleted: true),
                CompletionDay(label: 'Sun', date: '17', isCompleted: true),
                CompletionDay(label: 'Mon', date: '18', isCompleted: true),
                CompletionDay(label: 'Tue', date: '19', isCompleted: true),
                CompletionDay(label: 'Wed', date: '20', isCompleted: true),
                CompletionDay(label: 'Thu', date: '21'),
                CompletionDay(label: 'Fri', date: '22', isToday: true),
              ],
            ),
            const SizedBox(height: AppSpacing.xl),
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

class _DetailStat extends StatelessWidget {
  const _DetailStat({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}