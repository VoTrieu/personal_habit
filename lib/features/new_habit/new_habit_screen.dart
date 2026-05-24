import 'package:flutter/material.dart';
import 'package:personal_habit/features/new_habit/widgets/habit_reminder.dart';

import '../../models/new_habit_result.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';
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
                padding: const EdgeInsets.all(AppSpacing.screen),
                children: [
                  Text(
                    "Habit Name",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "e.g. Read 20 pages",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HabitFrequencies(
                    selectedFrequency: selectedFrequency,
                    onSelected: (frequency) =>
                        setState(() => selectedFrequency = frequency),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HabitIcons(
                    selectedIcon: selectedIcon,
                    onSelected: (icon) => setState(() => selectedIcon = icon),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HabitColors(
                    selectedColor: selectedColor,
                    onSelected: (color) =>
                        setState(() => selectedColor = color),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HabitReminder(
                    isEnabled: reminderEnabled,
                    onChanged: (value) =>
                        setState(() => reminderEnabled = value),
                  ),
                  if (reminderEnabled) ...[
                    const SizedBox(height: AppSpacing.lg),
                    HabitReminderTime(
                      timeLabel: formatTimeOfDay(reminderTime),
                      onTap: pickReminderTime,
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.screen,
                AppSpacing.md,
                AppSpacing.screen,
                AppSpacing.screen,
              ),
              child: SizedBox(
                width: double.infinity,
                height: AppSizes.buttonHeight,
                child: FilledButton(
                  onPressed: canSave ? saveHabit : null,
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
