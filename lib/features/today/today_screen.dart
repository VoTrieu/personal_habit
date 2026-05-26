import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';
import '../../models/new_habit_result.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';
import '../../widgets/completion_week_strip.dart';
import '../../widgets/delete_habit_confirmation_dialog.dart';
import '../habit_detail/habit_detail_result.dart';
import '../habit_detail/habit_detail_screen.dart';
import '../new_habit/new_habit_screen.dart';
import '../weekly_status/weekly_status_screen.dart';
import 'widgets/habit_summary.dart';
import 'widgets/habit_tile.dart';
import 'widgets/today_header.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  Future<void> toggleHabitCompletion(String habitId) async {
    await context.read<HabitController>().toggleHabitCompletion(habitId);
  }

  Future<void> addHabit() async {
    final result = await Navigator.of(context).push<NewHabitResult>(
      MaterialPageRoute(builder: (context) => const NewHabitScreen()),
    );

    if (!mounted || result == null) return;

    final habit = Habit(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: result.name,
      icon: result.icon,
      streak: 0,
      isCompletedToday: false,
      color: result.color,
      frequency: result.frequency,
      reminderEnabled: result.reminderEnabled,
      reminderTime: result.reminderTime,
    );

    await context.read<HabitController>().addHabit(habit);
  }

  Future<void> deleteHabit(String habitId) async {
    final shouldDelete = await showDeleteHabitConfirmationDialog(context);

    if (!mounted || shouldDelete != true) {
      return;
    }

    await context.read<HabitController>().deleteHabit(habitId);
  }

  Future<void> openHabitDetail(Habit habit) async {
    final result = await Navigator.of(context).push<HabitDetailResult>(
      MaterialPageRoute(builder: (context) => HabitDetailScreen(habit: habit)),
    );

    if (!mounted || result == null) return;

    switch (result.action) {
      case HabitDetailAction.toggleCompletion:
        await toggleHabitCompletion(result.habitId);
        break;
      case HabitDetailAction.edit:
        await editHabit(result.habitId);
        if (!mounted) return;

        final updatedHabit = context.read<HabitController>().findHabitById(
          result.habitId,
        );
        if (updatedHabit != null) {
          await openHabitDetail(updatedHabit);
        }
        break;
      case HabitDetailAction.delete:
        await context.read<HabitController>().deleteHabit(result.habitId);
        break;
    }
  }

  Future<void> editHabit(String habitId) async {
    final controller = context.read<HabitController>();
    final habit = controller.findHabitById(habitId);

    if (habit == null) return;

    final result = await Navigator.of(context).push<NewHabitResult>(
      MaterialPageRoute(
        builder: (context) => NewHabitScreen(
          initialName: habit.name,
          initialIcon: habit.icon,
          initialColor: habit.color,
          initialFrequency: habit.frequency,
          initialReminderEnabled: habit.reminderEnabled,
          initialReminderTime: habit.reminderTime,
        ),
      ),
    );

    if (!mounted || result == null) return;

    await controller.updateHabit(
      habit.copyWith(
        name: result.name,
        icon: result.icon,
        color: result.color,
        frequency: result.frequency,
        reminderEnabled: result.reminderEnabled,
        reminderTime: result.reminderTime,
      ),
    );
  }

  Future<void> openWeeklyStatus() async {
    await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const WeeklyStatusScreen()));

    if (!mounted) return;

    await context.read<HabitController>().loadHabits();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HabitController>();
    final habits = controller.habits;

    return Scaffold(
      body: SafeArea(
        child: controller.isLoading
            ? const Center(child: CircularProgressIndicator())
            : habits.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(AppSpacing.screen),
                children: [
                  TodayHeader(onWeeklyStatusPressed: openWeeklyStatus),
                  const SizedBox(height: AppSpacing.headerToWeek),
                  FutureBuilder<List<CompletionDay>>(
                    future: completionWeekDays(controller),
                    builder: (context, snapshot) {
                      return CompletionWeekStrip(
                        showBorder: true,
                        days: snapshot.data ?? emptyCompletionWeekDays(),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HabitSummary(
                    bestStreak: controller.bestStreak,
                    completedCount: controller.completedCount,
                    totalCount: habits.length,
                    completionProgress: controller.completionProgress,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  ...habits.map((habit) {
                    return HabitTile(
                      habit: habit,
                      onToggle: () => toggleHabitCompletion(habit.id),
                      onDelete: () => deleteHabit(habit.id),
                      onOpen: () => openHabitDetail(habit),
                    );
                  }),
                ],
              )
            : const Center(
                child: Text(
                  'No habits added yet. Tap the + button to add your first habit!',
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addHabit,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: AppSizes.floatingActionIconSize),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Future<List<CompletionDay>> completionWeekDays(
    HabitController controller,
  ) async {
    final today = DateTime.now();
    final completedDateSets = <String, Set<String>>{};

    for (final habit in controller.habits) {
      final completedDates = await controller.getCompletedDates(habit.id);
      completedDateSets[habit.id] = completedDates.toSet();
    }

    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      final dateKey = getDateKey(date);
      final isCompleted = controller.habits.every((habit) {
        return completedDateSets[habit.id]?.contains(dateKey) ?? false;
      });

      return CompletionDay(
        label: getWeekdayLabel(date),
        date: date.day.toString(),
        isToday: isSameDate(date, today),
        isCompleted: isCompleted,
      );
    });
  }

  List<CompletionDay> emptyCompletionWeekDays() {
    final today = DateTime.now();

    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));

      return CompletionDay(
        label: getWeekdayLabel(date),
        date: date.day.toString(),
        isToday: isSameDate(date, today),
      );
    });
  }
}
