import 'package:flutter/material.dart';

import '../../../models/habit.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.onTap,
    required this.onDelete,
  });
  final Habit habit;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(habit.icon),
      title: Text(habit.name),
      subtitle: Text('Streak: ${habit.streak}'),
      trailing: Icon(
        habit.isCompletedToday ? Icons.check_circle : Icons.circle_outlined,
        color: habit.isCompletedToday ? Colors.green : Colors.grey,
      ),
      onTap: onTap,
      onLongPress: onDelete,
    );
  }
}