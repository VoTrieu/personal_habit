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
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(
              habit.isCompletedToday ? Icons.check_circle : Icons.circle_outlined,
              color: habit.isCompletedToday ? Colors.green : Colors.grey,
            ),
            onPressed: onTap,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ) 
        ],
      ),
      onTap: onTap,
    );
  }
}