import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../theme/app_colors.dart';
import '../../models/habit.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';
import '../../widgets/completion_week_strip.dart';
import 'habit_detail_result.dart';

class HabitDetailScreen extends StatefulWidget {
  const HabitDetailScreen({super.key, required this.habit});

  final Habit habit;

  @override
  State<HabitDetailScreen> createState() => _HabitDetailScreenState();
}

class _HabitDetailScreenState extends State<HabitDetailScreen> {
  late Future<List<String>> completedDatesFuture;

  int get totalCompletions {
    return widget.habit.streak;
  }

  @override
  void initState() {
    super.initState();
    completedDatesFuture = context.read<HabitController>().getCompletedDates(
      widget.habit.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final habit = widget.habit;

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
            FutureBuilder<List<String>>(
              future: completedDatesFuture,
              builder: (context, snapshot) {
                final completedDates = snapshot.data ?? [];

                return CompletionWeekStrip(
                  title: 'Last 7 days',
                  days: _lastSevenDays(completedDates),
                );
              },
            ),
            const SizedBox(height: AppSpacing.xl),
            _HabitInfoRow(
              icon: Icons.repeat,
              label: 'Frequency',
              value: habit.frequency,
            ),
            const SizedBox(height: AppSpacing.md),
            _HabitInfoRow(
              icon: Icons.notifications_outlined,
              label: 'Reminder',
              value: habit.reminderEnabled
                  ? formatTimeOfDay(habit.reminderTime)
                  : 'Off',
            ),
            const SizedBox(height: AppSpacing.md),
            _HabitInfoRow(
              icon: habit.isCompletedToday
                  ? Icons.check_circle_outline
                  : Icons.radio_button_unchecked,
              label: 'Status',
              value: habit.isCompletedToday ? 'Completed' : 'Not Completed',
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

  List<CompletionDay> _lastSevenDays(List<String> completedDates) {
    final today = DateTime.now();
    final completedDateSet = completedDates.toSet();

    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      final dateKey = getDateKey(date);

      return CompletionDay(
        label: getWeekdayLabel(date),
        date: date.day.toString(),
        isToday: isSameDate(date, today),
        isCompleted: completedDateSet.contains(dateKey),
      );
    });
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

class _HabitInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HabitInfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: AppSizes.habitIconRadius,
          backgroundColor: AppColors.optionBackground,
          foregroundColor: AppColors.textMuted,
          child: Icon(icon),
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: AppSpacing.xs),
            Text(value, style: Theme.of(context).textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}
