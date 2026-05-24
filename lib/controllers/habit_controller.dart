import 'package:flutter/material.dart';

import '../data/habit_database.dart';
import '../models/habit.dart';

class HabitController extends ChangeNotifier {
  HabitController({HabitDatabase? database})
    : _database = database ?? HabitDatabase();

  final HabitDatabase _database;

  List<Habit> _habits = [];
  bool _isLoading = false;

  List<Habit> get habits => _habits;
  bool get isLoading => _isLoading;

  int get completedCount {
    return _habits.where((habit) => habit.isCompletedToday).length;
  }

  double get completionProgress {
    if (_habits.isEmpty) return 0;
    return completedCount / _habits.length;
  }

  int get bestStreak {
    if (_habits.isEmpty) return 0;
    return _habits.map((habit) => habit.streak).reduce((a, b) => a > b ? a : b);
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();
    _habits = await _database.getHabits();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addHabit(Habit habit) async {
    await _database.insertHabit(habit);
    _habits = [...habits, habit];
    notifyListeners();
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    await _database.updateHabit(updatedHabit);

    _habits = _habits.map((habit) {
      if (habit.id == updatedHabit.id) {
        return updatedHabit;
      }

      return habit;
    }).toList();

    notifyListeners();
  }

  Future<void> deleteHabit(String habitId) async {
    await _database.deleteHabit(habitId);
    _habits = [...habits.where((h) => h.id != habitId)];
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final habit = habits.firstWhere((h) => h.id == habitId);
    final updatedHabit = habit.copyWith(
      isCompletedToday: !habit.isCompletedToday,
    );
    await updateHabit(updatedHabit);
  }

  Habit? findHabitById(String habitId) {
    for (final habit in _habits) {
      if (habit.id == habitId) {
        return habit;
      }
    }

    return null;
  }
}
