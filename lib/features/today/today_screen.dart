import 'package:flutter/material.dart';

import '../../models/habit.dart';
import '../habit_detail/habit_detail_result.dart';
import '../habit_detail/habit_detail_screen.dart';
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

  bool get hasHabits => habits.isNotEmpty;

  double get completionProgress {
    if (habits.isEmpty) return 0;
    return completedCount / habits.length;
  }

  Habit? findHabitById(String id) {
    try {
      return habits.firstWhere((h) => h.id == id);
    } catch (e) {
      return null;
    }
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
          )
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
      MaterialPageRoute(
        builder: (context) => HabitDetailScreen(habit: habit),
      ),
    );

    if(!mounted || result == null) return;

    
    switch(result.action) {
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
      builder: (context) => AddHabitDialog(
        initialName: habit.name,
        initialIcon: habit.icon,
      ),
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
      appBar: AppBar(title: const Text('Today')),
      body: hasHabits
      ? ListView(
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
              onToggle: () => toggleHabitCompletion(habit.id),
              onDelete: () => deleteHabit(habit.id),
              onOpen: () => openHabitDetail(habit),
            );
          })
        ]
      )
      : const Center(
        child: Text('No habits added yet. Tap the + button to add your first habit!'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addHabit,
        child: const Icon(Icons.add),
      ),
    );
  }
}
