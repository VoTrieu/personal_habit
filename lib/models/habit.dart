import 'package:flutter/material.dart';

class Habit {
  final String id;
  final String name;
  final IconData icon;
  final bool isCompletedToday;
  final int streak;
  final Color color;
  final String frequency;
  final bool reminderEnabled;
  final TimeOfDay reminderTime;

  const Habit({
    required this.id,
    required this.name,
    required this.icon,
    required this.isCompletedToday,
    required this.streak,
    required this.color,
    required this.frequency,
    required this.reminderEnabled,
    required this.reminderTime,
  });

  Habit copyWith({
    String? id,
    String? name,
    IconData? icon,
    bool? isCompletedToday,
    int? streak,
    Color? color,
    String? frequency,
    bool? reminderEnabled,
    TimeOfDay? reminderTime,
  }) {
    return Habit(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      isCompletedToday: isCompletedToday ?? this.isCompletedToday,
      streak: streak ?? this.streak,
      color: color ?? this.color,
      frequency: frequency ?? this.frequency,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
    );
  }
}
