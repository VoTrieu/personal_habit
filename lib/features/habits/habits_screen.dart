import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

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
                    );
                  }),
                ],
              ),
      ),
    );
  }
}
