import 'package:flutter/material.dart';

import '../data/habit_database.dart';
import '../models/habit.dart';
import '../services/notification_service.dart';
import '../utils/time_formatters.dart';

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

  String todayKey() {
    final now = DateTime.now();
    final month = now.month.toString().padLeft(2, '0');
    final day = now.day.toString().padLeft(2, '0');

    return '${now.year}-$month-$day';
  }

  Future<void> loadHabits() async {
    _isLoading = true;
    notifyListeners();

    try {
      final loadedHabits = await _database.getHabits();
      final today = todayKey();

      _habits = [];
      for (final habit in loadedHabits) {
        final isCompletedToday = await _database.isHabitCompletedOnDate(
          habit.id,
          today,
        );
        _habits.add(habit.copyWith(isCompletedToday: isCompletedToday));
      }
    } catch (error) {
      debugPrint('Failed to load habits: $error');
      _habits = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addHabit(Habit habit) async {
    await _database.insertHabit(habit);
    await _syncHabitReminder(habit);

    _habits = [...habits, habit];
    notifyListeners();
  }

  Future<void> updateHabit(Habit updatedHabit) async {
    await _database.updateHabit(updatedHabit);
    await _syncHabitReminder(updatedHabit);

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
    await NotificationService.instance.cancelHabitReminder(habitId);

    _habits = [...habits.where((h) => h.id != habitId)];
    notifyListeners();
  }

  Future<void> toggleHabitCompletion(String habitId) async {
    final habit = habits.firstWhere((h) => h.id == habitId);
    final date = todayKey();
    final isNowCompleted = !habit.isCompletedToday;

    if (isNowCompleted) {
      await _database.insertCompletion(habitId, date);
    } else {
      await _database.deleteCompletion(habitId, date);
    }

    final updatedHabit = habit.copyWith(
      isCompletedToday: isNowCompleted,
      streak: isNowCompleted
          ? habit.streak + 1
          : (habit.streak > 0 ? habit.streak - 1 : 0),
    );

    await updateHabit(updatedHabit);
  }

  Future<List<String>> getCompletedDates(String habitId) {
    return _database.getCompletedDates(habitId);
  }

  Future<List<double>> weeklyCompletionRates() async {
    if (_habits.isEmpty) {
      return List.filled(7, 0);
    }

    final today = DateTime.now();
    final completedDateSets = <String, Set<String>>{};

    for (final habit in _habits) {
      final completedDates = await getCompletedDates(habit.id);
      completedDateSets[habit.id] = completedDates.toSet();
    }

    return List.generate(7, (index) {
      final date = today.subtract(Duration(days: 6 - index));
      final dateKey = getDateKey(date);

      final completedCount = _habits.where((habit) {
        return completedDateSets[habit.id]?.contains(dateKey) ?? false;
      }).length;

      return completedCount / _habits.length;
    });
  }

  Habit? findHabitById(String habitId) {
    for (final habit in _habits) {
      if (habit.id == habitId) {
        return habit;
      }
    }

    return null;
  }

  Future<void> _syncHabitReminder(Habit habit) async {
    if (!habit.reminderEnabled) {
      await NotificationService.instance.cancelHabitReminder(habit.id);
      return;
    }

    await NotificationService.instance.scheduleDailyHabitReminder(
      habitId: habit.id,
      habitName: habit.name,
      time: habit.reminderTime,
    );
  }
}
