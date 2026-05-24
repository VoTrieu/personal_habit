import 'package:flutter/material.dart';

import '../models/habit.dart';
import '../theme/app_colors.dart';

const sampleHabits = [
  Habit(
    id: 'read',
    name: 'Read 20 pages',
    icon: Icons.menu_book,
    streak: 3,
    isCompletedToday: false,
    color: AppColors.habitTeal,
    frequency: 'Daily',
    reminderEnabled: true,
    reminderTime: TimeOfDay(hour: 10, minute: 30),
  ),
  Habit(
    id: 'water',
    name: 'Drink water',
    icon: Icons.water_drop,
    streak: 5,
    isCompletedToday: true,
    color: AppColors.habitCoral,
    frequency: 'Daily',
    reminderEnabled: true,
    reminderTime: TimeOfDay(hour: 19, minute: 30),
  ),
  Habit(
    id: 'walk',
    name: 'Morning walk',
    icon: Icons.directions_walk,
    streak: 2,
    isCompletedToday: false,
    color: AppColors.habitAmber,
    frequency: 'Weekday',
    reminderEnabled: true,
    reminderTime: TimeOfDay(hour: 8, minute: 30),
  ),
];
