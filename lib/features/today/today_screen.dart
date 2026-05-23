import 'package:flutter/material.dart';

import '../../models/habit.dart';
import 'widgets/add_habit_dialog.dart';
import 'widgets/habit_tile.dart';

class TodayScreen extends StatefulWidget {
  const TodayScreen({super.key});
  @override
  State<TodayScreen> createState() => _TodayScreenState();
}

class _TodayScreenState extends State<TodayScreen> {
  List<Habit> habits = [
    Habit(
      id: 'read',
      name: 'Read 20 pages',
      icon: Icons.menu_book,
      streak: 3,
      isCompletedToday: false,
    ),
    Habit(
      id: 'water',
      name: 'Drink water',
      icon: Icons.water_drop,
      streak: 5,
      isCompletedToday: true,
    ),
    Habit(
      id: 'walk',
      name: 'Morning walk',
      icon: Icons.directions_walk,
      streak: 2,
      isCompletedToday: false,
    ),
  ];

  int get completedCount => habits.where((h) => h.isCompletedToday).length;

  double get completionProgress {
    if (habits.isEmpty) return 0;
    return completedCount / habits.length;
  }

  void toggleHabitCompletion(String habitId) {
    setState(() {
      habits = habits.map((habit) {
        if (habit.id == habitId) {
          return habit.copyWith(
            isCompletedToday: !habit.isCompletedToday,
          );
        }
        return habit;
      }).toList();
    });
  }

  Future<void> addHabit() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const AddHabitDialog(),
    );

    if (!mounted) return;

    final habitName = result?['name'] as String?;
    final habitIcon = result?['icon'] as IconData?;

    if (habitName == null || habitName.trim().isEmpty) {
      return;
    }

    setState(() {
      habits = [
        ...habits,
        Habit(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: habitName.trim(),
          icon: habitIcon ?? Icons.star,
          streak: 0,
          isCompletedToday: false,
        ),
      ];
    });
  }

  void deleteHabit(String habitId) {
    setState(() {
      habits = habits.where((h) => h.id != habitId).toList();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Today')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            '$completedCount of ${habits.length} habits completed',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: completionProgress),
          const SizedBox(height: 16),
          ...habits.map((habit) {
            return HabitTile(
              habit: habit,
              onTap: () => toggleHabitCompletion(habit.id),
              onDelete: () => deleteHabit(habit.id),
            );
          })
        ]
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
