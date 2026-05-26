import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../theme/app_colors.dart';
import '../../models/habit.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';
import '../../widgets/action_button.dart';
import '../../widgets/completion_week_strip.dart';
import '../../widgets/delete_habit_confirmation_dialog.dart';
import 'habit_detail_result.dart';
import 'widgets/habit_detail_stat.dart';
import 'widgets/habit_info_card.dart';

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
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.screen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.detailTop),
                    Center(
                      child: Container(
                        width: AppSizes.detailIconBackgroundSize,
                        height: AppSizes.detailIconBackgroundSize,
                        decoration: BoxDecoration(
                          color: habit.color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: habit.color.withValues(alpha: 0.28),
                              blurRadius: AppSpacing.xl,
                              offset: const Offset(0, AppSpacing.sm),
                            ),
                          ],
                        ),
                        child: Icon(
                          habit.icon,
                          color: AppColors.white,
                          size: AppSizes.detailIconSize,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Row(
                      children: [
                        Expanded(
                          child: HabitDetailStat(
                            value: '${habit.streak}',
                            label: 'Current Streak',
                          ),
                        ),
                        Expanded(
                          child: HabitDetailStat(
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
                    Row(
                      children: [
                        Expanded(
                          child: HabitInfoCard(
                            icon: Icons.repeat,
                            label: 'Frequency',
                            value: habit.frequency,
                            backgroundColor: AppColors.insightAmberBackground,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: HabitInfoCard(
                            icon: Icons.notifications_outlined,
                            label: 'Reminder',
                            value: habit.reminderEnabled
                                ? formatTimeOfDay(habit.reminderTime)
                                : 'Off',
                            backgroundColor: AppColors.insightCoralBackground,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    HabitInfoCard(
                      icon: habit.isCompletedToday
                          ? Icons.check_circle_outline
                          : Icons.radio_button_unchecked,
                      label: 'Status',
                      value: habit.isCompletedToday
                          ? 'Completed'
                          : 'Not Completed',
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                AppSpacing.screen,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: ActionButton(
                      icon: habit.isCompletedToday
                          ? Icons.check_circle
                          : Icons.check_circle_outline,
                      label: habit.isCompletedToday ? 'Undo' : 'Complete',
                      backgroundColor: habit.color,
                      foregroundColor: AppColors.white,
                      onPressed: () => Navigator.pop(
                        context,
                        HabitDetailResult(
                          habitId: habit.id,
                          action: HabitDetailAction.toggleCompletion,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ActionButton(
                      icon: Icons.edit,
                      label: 'Edit',
                      backgroundColor: AppColors.insightTealBackground,
                      foregroundColor: AppColors.primary,
                      onPressed: () => Navigator.pop(
                        context,
                        HabitDetailResult(
                          habitId: habit.id,
                          action: HabitDetailAction.edit,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: ActionButton(
                      icon: Icons.delete_outline,
                      label: 'Delete',
                      backgroundColor: AppColors.dangerBackground,
                      foregroundColor: AppColors.danger,
                      onPressed: () => deleteHabit(context, habit.id),
                    ),
                  ),
                ],
              ),
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

  Future<void> deleteHabit(BuildContext context, String habitId) async {
    final shouldDelete = await showDeleteHabitConfirmationDialog(context);

    if (!context.mounted || !shouldDelete) {
      return;
    }

    Navigator.pop(
      context,
      HabitDetailResult(habitId: habitId, action: HabitDetailAction.delete),
    );
  }
}






