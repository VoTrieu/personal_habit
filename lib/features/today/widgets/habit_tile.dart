import 'package:flutter/material.dart';

import '../../../models/habit.dart';

class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
    required this.onOpen,
  });
  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final VoidCallback onOpen;

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
            onPressed: onToggle,
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ) 
        ],
      ),
      onTap: onOpen,
    );
  }
}