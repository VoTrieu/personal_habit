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

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'iconCodePoint': icon.codePoint,
      'isCompletedToday': isCompletedToday ? 1 : 0,
      'streak': streak,
      'colorValue': color.toARGB32(),
      'frequency': frequency,
      'reminderEnabled': reminderEnabled ? 1 : 0,
      'reminderTimeMinutes': reminderTime.hour * 60 + reminderTime.minute,
    };
  }

  factory Habit.fromMap(Map<String, Object?> map) {
    final reminderTimeMinutes = map['reminderTimeMinutes'] as int;
    return Habit(
      id: map['id'] as String,
      name: map['name'] as String,
      icon: _iconFromCodePoint(map['iconCodePoint'] as int),
      isCompletedToday: (map['isCompletedToday'] as int) == 1,
      streak: map['streak'] as int,
      color: Color(map['colorValue'] as int),
      frequency: map['frequency'] as String,
      reminderEnabled: (map['reminderEnabled'] as int) == 1,
      reminderTime: TimeOfDay(
        hour: reminderTimeMinutes ~/ 60,
        minute: reminderTimeMinutes % 60,
      ),
    );
  }
}

IconData _iconFromCodePoint(int codePoint) {
  if (codePoint == Icons.menu_book.codePoint) return Icons.menu_book;
  if (codePoint == Icons.water_drop.codePoint) return Icons.water_drop;
  if (codePoint == Icons.directions_walk.codePoint) {
    return Icons.directions_walk;
  }
  if (codePoint == Icons.fitness_center.codePoint) {
    return Icons.fitness_center;
  }
  if (codePoint == Icons.self_improvement.codePoint) {
    return Icons.self_improvement;
  }
  if (codePoint == Icons.language.codePoint) return Icons.language;

  return Icons.menu_book;
}
