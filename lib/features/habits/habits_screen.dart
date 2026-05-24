import 'package:flutter/material.dart';

import '../../data/sample_habits.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

class HabitsScreen extends StatelessWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Text('Habits', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xl),
            ...sampleHabits.map((habit) {
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
