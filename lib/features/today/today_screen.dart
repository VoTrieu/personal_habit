import 'package:flutter/material.dart';

import '../../data/sample_habits.dart';
import '../../models/habit.dart';
import '../../models/new_habit_result.dart';
import '../../theme/app_dimensions.dart';
import '../habit_detail/habit_detail_result.dart';
import '../habit_detail/habit_detail_screen.dart';
import '../new_habit/new_habit_screen.dart';
import 'widgets/add_habit_dialog.dart';
import 'widgets/habit_summary.dart';
import 'widgets/habit_tile.dart';
import 'widgets/today_header.dart';
class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  List<Habit> habits = [...sampleHabits];

  int get completedCount => habits.where((h) => h.isCompletedToday).length;

  bool get hasHabits => habits.isNotEmpty;

  double get completionProgress {
    if (habits.isEmpty) return 0;
    return completedCount / habits.length;
  }

  Habit? findHabitById(String id) {
    for (final habit in habits) {
      if (habit.id == id) {
        return habit;
      }
    }
    return null;
  }

  int get bestStreak {
    if (habits.isEmpty) return 0;
    var highestStreak = habits
        .map((h) => h.streak)
        .reduce((a, b) => a > b ? a : b);
    return highestStreak;
  }

  void toggleHabitCompletion(String habitId) {
    setState(() {
      habits = habits.map((habit) {
        if (habit.id == habitId) {
          return habit.copyWith(isCompletedToday: !habit.isCompletedToday);
        }
        return habit;
      }).toList();
    });
  }

  Future<void> addHabit() async {
    final result = await Navigator.of(context).push<NewHabitResult>(
      MaterialPageRoute(builder: (context) => const NewHabitScreen()),
    );

    if (!mounted || result == null) return;

    setState(() {
      habits = [
        ...habits,
        Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: result.name,
          icon: result.icon,
          streak: 0,
          isCompletedToday: false,
          color: result.color,
          frequency: result.frequency,
          reminderEnabled: result.reminderEnabled,
          reminderTime: result.reminderTime,
        ),
      ];
    });
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

    setState(() {
      habits = habits.where((h) => h.id != habitId).toList();
    });
  }

  Future<void> openHabitDetail(Habit habit) async {
    final result = await Navigator.of(context).push<HabitDetailResult>(
      MaterialPageRoute(builder: (context) => HabitDetailScreen(habit: habit)),
    );

    if (!mounted || result == null) return;

    switch (result.action) {
      case HabitDetailAction.toggleCompletion:
        toggleHabitCompletion(result.habitId);
        break;
      case HabitDetailAction.edit:
        await editHabit(result.habitId);
        final updatedHabit = findHabitById(result.habitId);
        if (updatedHabit != null) {
          await openHabitDetail(updatedHabit);
        }
        break;
    }
  }

  Future<void> editHabit(String habitId) async {
    final habit = findHabitById(habitId);

    if (habit == null) return;

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) =>
          AddHabitDialog(initialName: habit.name, initialIcon: habit.icon),
    );

    if (!mounted) return;

    final updatedName = result?['name'] as String?;
    final updatedIcon = result?['icon'] as IconData?;

    if (updatedName == null || updatedName.trim().isEmpty) {
      return;
    }

    setState(() {
      habits = habits.map((habit) {
        if (habit.id == habitId) {
          return habit.copyWith(
            name: updatedName.trim(),
            icon: updatedIcon ?? habit.icon,
          );
        }
        return habit;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: hasHabits
            ? ListView(
                padding: const EdgeInsets.all(AppSpacing.screen),
                children: [
                  const TodayHeader(),
                  const SizedBox(height: AppSpacing.headerToWeek),
                  const CompletionWeekStrip(
                    showBorder: true,
                    days: [
                      CompletionDay(label: 'Mon', date: '18', isCompleted: true),
                      CompletionDay(label: 'Tue', date: '19', isCompleted: true),
                      CompletionDay(label: 'Wed', date: '20', isCompleted: false),
                      CompletionDay(label: 'Thu', date: '21'),
                      CompletionDay(label: 'Fri', date: '22', isToday: true),
                      CompletionDay(label: 'Sat', date: '23'),
                      CompletionDay(label: 'Sun', date: '24'),
                    ]
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HabitSummary(
                    bestStreak: bestStreak,
                    completedCount: completedCount,
                    totalCount: habits.length,
                    completionProgress: completionProgress,
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
