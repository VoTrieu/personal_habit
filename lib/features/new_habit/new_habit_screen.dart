import 'package:flutter/material.dart';

import '../../models/new_habit_result.dart';
import 'widgets/habit_colors.dart';
import 'widgets/habit_frequencies.dart';
import 'widgets/habit_icons.dart';

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
      NewHabitResult(name: name, icon: selectedIcon, color: selectedColor),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('New Habit')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text("Habit Name", style: Theme.of(context).textTheme.titleSmall),
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
              onSelected: (frequency) => setState(() => selectedFrequency = frequency),
            ),
            const SizedBox(height: 24),
            HabitIcons(
              selectedIcon: selectedIcon,
              onSelected: (icon) => setState(() => selectedIcon = icon),
            ),
            const SizedBox(height: 24),
            HabitColors(
              selectedColor: selectedColor,
              onSelected: (color) => setState(() => selectedColor = color),
            ),
            const SizedBox(height: 32),
            FilledButton(
              onPressed: canSave ? saveHabit : null,
              child: const Text('Save Habit'),
            ),
          ],
        ),
      ),
    );
  }
}
