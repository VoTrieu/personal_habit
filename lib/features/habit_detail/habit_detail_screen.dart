import 'package:flutter/material.dart';

import '../../models/habit.dart';

class HabitDetailScreen extends StatelessWidget {
  const HabitDetailScreen({super.key,
  required this.habit});

  final Habit habit;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              habit.icon,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              habit.name,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Current streak: ${habit.streak} days',
            ),
            const SizedBox(height: 8),
            Text(
              habit.isCompletedToday ? 'Completed today' : 'Not completed today',
            ),
            SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context, habit.id),
              icon: Icon(
                habit.isCompletedToday ? Icons.check_circle : Icons.check_circle_outline,
              ),
              label: Text(
                habit.isCompletedToday ? 'Mark as Incomplete' : 'Mark as Completed',
              ),
            )
          ],
        ),
      ),
    );
  }
}