import 'package:flutter/material.dart';

import '../../models/new_habit_result.dart';
import '../../theme/app_dimensions.dart';
import '../../utils/time_formatters.dart';
import 'widgets/habit_colors.dart';
import 'widgets/habit_frequencies.dart';
import 'widgets/habit_icons.dart';
import 'widgets/habit_reminder_time.dart';
import 'widgets/habit_reminder.dart';

class NewHabitScreen extends StatefulWidget {
  final String? initialName;
  final IconData? initialIcon;
  final Color? initialColor;
  final String? initialFrequency;
  final bool? initialReminderEnabled;
  final TimeOfDay? initialReminderTime;

  const NewHabitScreen({
    super.key,
    this.initialName,
    this.initialIcon,
    this.initialColor,
    this.initialFrequency,
    this.initialReminderEnabled,
    this.initialReminderTime,
  });

  @override
  State<NewHabitScreen> createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends State<NewHabitScreen> {
  final controller = TextEditingController();

  late IconData selectedIcon;
  late Color selectedColor;
  late String selectedFrequency;
  late bool reminderEnabled;
  late TimeOfDay reminderTime;

  bool get canSave => controller.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    controller.text = widget.initialName ?? '';
    selectedColor = widget.initialColor ?? habitColors[0];
    selectedIcon = widget.initialIcon ?? habitIcons[0];
    selectedFrequency = widget.initialFrequency ?? habitFrequencies[0];
    reminderEnabled = widget.initialReminderEnabled ?? false;
    reminderTime =
        widget.initialReminderTime ?? const TimeOfDay(hour: 19, minute: 30);
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
    final isEditing = widget.initialName != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Habit' : 'New Habit')),
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
