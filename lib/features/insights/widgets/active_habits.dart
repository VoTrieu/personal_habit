import 'package:flutter/material.dart';

import '../../../data/sample_habits.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class ActiveHabits extends StatelessWidget {
  const ActiveHabits({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Active habits', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        ...sampleHabits.map((habit) {
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: CircleAvatar(
              backgroundColor: habit.color,
              foregroundColor: AppColors.white,
              child: Icon(habit.icon),
            ),
            title: Text(habit.name),
            subtitle: Text('${habit.streak} day streak'),
            trailing: const Icon(Icons.chevron_right),
          );
        }),
      ],
    );
  }
}
