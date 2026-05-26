import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';

class WeeklyStatusScreen extends StatefulWidget {
  const WeeklyStatusScreen({super.key});

  @override
  State<WeeklyStatusScreen> createState() => _WeeklyStatusScreenState();
}

class _WeeklyStatusScreenState extends State<WeeklyStatusScreen> {
  late final List<DateTime> dates;
  late Future<Map<String, Map<String, bool>>> statusesFuture;

  @override
  void initState() {
    super.initState();
    dates = lastSevenDays();
    statusesFuture = loadStatuses();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HabitController>();
    final habits = controller.habits;

    return Scaffold(
      appBar: AppBar(title: const Text('Weekly Status')),
      body: SafeArea(
        child: habits.isEmpty
            ? const Center(child: Text('No habits to review.'))
            : FutureBuilder<Map<String, Map<String, bool>>>(
                future: statusesFuture,
                builder: (context, snapshot) {
                  final statuses = snapshot.data ?? {};

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final width = math.max(constraints.maxWidth, 560.0);

                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: width,
                          child: ListView(
                            padding: const EdgeInsets.all(AppSpacing.screen),
                            children: [
                              _WeekHeader(dates: dates),
                              const SizedBox(height: AppSpacing.md),
                              ...habits.map((habit) {
                                return _HabitStatusRow(
                                  habit: habit,
                                  dates: dates,
                                  statuses: statuses[habit.id] ?? {},
                                  onToggle: (date, isCompleted) {
                                    toggleStatus(
                                      habitId: habit.id,
                                      date: date,
                                      isCompleted: isCompleted,
                                    );
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  List<DateTime> lastSevenDays() {
    final today = DateTime.now();

    return List.generate(7, (index) {
      return today.subtract(Duration(days: 6 - index));
    });
  }

  Future<Map<String, Map<String, bool>>> loadStatuses() {
    final dateKeys = dates.map(getDateKey).toList();
    return context.read<HabitController>().getDailyStatusesForDates(dateKeys);
  }

  Future<void> toggleStatus({
    required String habitId,
    required DateTime date,
    required bool isCompleted,
  }) async {
    await context.read<HabitController>().setHabitCompletionForDate(
      habitId: habitId,
      date: getDateKey(date),
      isCompleted: isCompleted,
    );

    if (!mounted) return;

    setState(() {
      statusesFuture = loadStatuses();
    });
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader({required this.dates});

  static const habitColumnWidth = 156.0;

  final List<DateTime> dates;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    return Row(
      children: [
        const SizedBox(width: habitColumnWidth),
        ...dates.map((date) {
          final isToday = isSameDate(date, today);

          return Expanded(
            child: Column(
              children: [
                Text(
                  getWeekdayLabel(date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isToday ? AppColors.primary : AppColors.textMuted,
                    fontWeight: isToday ? FontWeight.w700 : null,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  date.day.toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isToday ? AppColors.primary : null,
                    fontWeight: isToday ? FontWeight.w700 : null,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

class _HabitStatusRow extends StatelessWidget {
  const _HabitStatusRow({
    required this.habit,
    required this.dates,
    required this.statuses,
    required this.onToggle,
  });

  final Habit habit;
  final List<DateTime> dates;
  final Map<String, bool> statuses;
  final void Function(DateTime date, bool isCompleted) onToggle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: _WeekHeader.habitColumnWidth,
            child: Row(
              children: [
                CircleAvatar(
                  radius: AppSizes.habitIconRadius,
                  backgroundColor: habit.color,
                  foregroundColor: AppColors.white,
                  child: Icon(habit.icon),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    habit.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
          ),
          ...dates.map((date) {
            final dateKey = getDateKey(date);
            final isCompleted = statuses[dateKey] ?? false;

            return Expanded(
              child: Center(
                child: _StatusToggle(
                  color: habit.color,
                  isCompleted: isCompleted,
                  onTap: () => onToggle(date, !isCompleted),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _StatusToggle extends StatelessWidget {
  const _StatusToggle({
    required this.color,
    required this.isCompleted,
    required this.onTap,
  });

  final Color color;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.round),
      child: Container(
        width: AppSizes.weekDayRadius * 2,
        height: AppSizes.weekDayRadius * 2,
        decoration: BoxDecoration(
          color: isCompleted ? color : AppColors.transparent,
          shape: BoxShape.circle,
          border: Border.all(
            color: isCompleted ? color : AppColors.borderLight,
          ),
        ),
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: AppColors.white,
                size: AppSizes.weekCheckIconSize,
              )
            : null,
      ),
    );
  }
}
