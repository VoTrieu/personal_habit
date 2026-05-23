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
  ),
  Habit(
    id: 'water',
    name: 'Drink water',
    icon: Icons.water_drop,
    streak: 5,
    isCompletedToday: true,
    color: Color(0xFFFF5A4E),
  ),
  Habit(
    id: 'walk',
    name: 'Morning walk',
    icon: Icons.directions_walk,
    streak: 2,
    isCompletedToday: false,
    color: Color(0xFFFFB020),
  ),
];