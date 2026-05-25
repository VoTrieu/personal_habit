import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../models/habit.dart';
import '../../models/new_habit_result.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../habit_detail/habit_detail_result.dart';
import '../habit_detail/habit_detail_screen.dart';
import '../new_habit/new_habit_screen.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  Future<void> openHabitDetail(BuildContext context, Habit habit) async {
    final result = await Navigator.of(context).push<HabitDetailResult>(
      MaterialPageRoute(builder: (context) => HabitDetailScreen(habit: habit)),
    );

    if (!context.mounted || result == null) return;

    final controller = context.read<HabitController>();

    switch (result.action) {
      case HabitDetailAction.toggleCompletion:
        await controller.toggleHabitCompletion(result.habitId);
        break;
      case HabitDetailAction.edit:
        await editHabit(context, result.habitId);
        break;
    }
  }

  Future<void> editHabit(BuildContext context, String habitId) async {
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

    if (!context.mounted || result == null) return;

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
            : habits.isEmpty
            ? const Center(child: Text('No habits yet.'))
            : ListView(
                padding: const EdgeInsets.all(AppSpacing.screen),
                children: [
                  Text(
                    'Habits',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  ...habits.map((habit) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: habit.color,
                        foregroundColor: AppColors.white,
                        child: Icon(habit.icon),
                      ),
                      title: Text(habit.name),
                      subtitle: Text(
                        '${habit.frequency} • ${habit.streak} day streak',
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => openHabitDetail(context, habit),
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
