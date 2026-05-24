import 'package:flutter/material.dart';

import '../models/habit.dart';

const sampleHabits = [
  Habit(
    id: 'read',
    name: 'Read 20 pages',
    icon: Icons.menu_book,
    streak: 3,
    isCompletedToday: false,
    color: Color(0xFF00897B),
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
    color: Color(0xFFFF5A4E),
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
    color: Color(0xFFFFB020),
    frequency: 'Weekday',
    reminderEnabled: true,
    reminderTime: TimeOfDay(hour: 8, minute: 30),
  ),
];
