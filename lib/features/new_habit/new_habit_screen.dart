import 'package:flutter/material.dart';
import 'package:personal_habit/features/new_habit/widgets/habit_reminder.dart';

import '../../models/new_habit_result.dart';
import 'widgets/habit_colors.dart';
import 'widgets/habit_frequencies.dart';
import 'widgets/habit_icons.dart';
import 'widgets/habit_reminder_time.dart';

class NewHabitScreen extends StatefulWidget {
  const NewHabitScreen({super.key});

  @override
  State<NewHabitScreen> createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends State<NewHabitScreen> {
  final controller = TextEditingController();
  Color selectedColor = habitColors[0];
  IconData selectedIcon = habitIcons[0];
  String selectedFrequency = habitFrequencies[0];
  bool reminderEnabled = false;
  TimeOfDay reminderTime = const TimeOfDay(hour: 19, minute: 30);

  bool get canSave => controller.text.trim().isNotEmpty;

  String get reminderTimeLabel {
    final hour = reminderTime.hourOfPeriod == 0
        ? 12
        : reminderTime.hourOfPeriod;
    final minute = reminderTime.minute.toString().padLeft(2, '0');
    final period = reminderTime.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveHabit() {
    if (!canSave) return;
    final name = controller.text.trim();
    Navigator.of(context).pop(
      NewHabitResult(
        name: name,
        icon: selectedIcon,
        color: selectedColor,
        frequency: selectedFrequency,
        reminderEnabled: reminderEnabled,
        reminderTime: reminderTime,
      ),
    );
  }

  Future<void> pickReminderTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: reminderTime,
    );

    if (!mounted || pickedTime == null) {
      return;
    }

    setState(() {
      reminderTime = pickedTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    "Habit Name",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "e.g. Read 20 pages",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  HabitFrequencies(
                    selectedFrequency: selectedFrequency,
                    onSelected: (frequency) =>
                        setState(() => selectedFrequency = frequency),
                  ),
                  const SizedBox(height: 24),
                  HabitIcons(
                    selectedIcon: selectedIcon,
                    onSelected: (icon) => setState(() => selectedIcon = icon),
                  ),
                  const SizedBox(height: 24),
                  HabitColors(
                    selectedColor: selectedColor,
                    onSelected: (color) =>
                        setState(() => selectedColor = color),
                  ),
                  const SizedBox(height: 24),
                  HabitReminder(
                    isEnabled: reminderEnabled,
                    onChanged: (value) =>
                        setState(() => reminderEnabled = value),
                  ),
                  if (reminderEnabled) ...[
                    const SizedBox(height: 16),
                    HabitReminderTime(
                      timeLabel: reminderTimeLabel,
                      onTap: pickReminderTime,
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: canSave ? saveHabit : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF00897B),
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.black12,
                    disabledForegroundColor: Colors.black38,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    textStyle: Theme.of(context).textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  child: const Text('Save Habit'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
