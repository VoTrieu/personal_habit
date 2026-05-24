import 'package:flutter/material.dart';

class NewHabitResult {
  final String name;
  final IconData icon;
  final Color color;
  final String frequency;
  final bool reminderEnabled;
  final TimeOfDay reminderTime;

  const NewHabitResult({
    required this.name,
    required this.icon,
    required this.color,
    required this.frequency,
    required this.reminderEnabled,
    required this.reminderTime,
  }); 
}