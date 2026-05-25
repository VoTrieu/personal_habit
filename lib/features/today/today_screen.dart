import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';
import '../../models/new_habit_result.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/completion_week_strip.dart';
import '../habit_detail/habit_detail_result.dart';
import '../habit_detail/habit_detail_screen.dart';
import '../new_habit/new_habit_screen.dart';
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
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Habit'),
        content: const Text('Are you sure you want to delete this habit?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

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
        final updatedHabit = context.read<HabitController>().findHabitById(
          result.habitId,
        );
        if (updatedHabit != null) {
          await openHabitDetail(updatedHabit);
        }
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
                  const TodayHeader(),
                  const SizedBox(height: AppSpacing.headerToWeek),
                  const CompletionWeekStrip(
                    showBorder: true,
                    days: [
                      CompletionDay(
                        label: 'Mon',
                        date: '18',
                        isCompleted: true,
                      ),
                      CompletionDay(
                        label: 'Tue',
                        date: '19',
                        isCompleted: true,
                      ),
                      CompletionDay(
                        label: 'Wed',
                        date: '20',
                        isCompleted: false,
                      ),
                      CompletionDay(label: 'Thu', date: '21'),
                      CompletionDay(label: 'Fri', date: '22', isToday: true),
                      CompletionDay(label: 'Sat', date: '23'),
                      CompletionDay(label: 'Sun', date: '24'),
                    ],
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
}
