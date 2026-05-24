import 'package:flutter/material.dart';

import '../../models/new_habit_result.dart';

class NewHabitScreen extends StatefulWidget {
  const NewHabitScreen({super.key});

  @override
  State<NewHabitScreen> createState() => _NewHabitScreenState();
}

class _NewHabitScreenState extends State<NewHabitScreen> {
  final controller = TextEditingController();
  IconData? selectedIcon;

  bool get canSave => controller.text.trim().isNotEmpty && selectedIcon != null;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void saveHabit() {
    if (!canSave) return;
    final name = controller.text.trim();
    Navigator.of(context).pop(NewHabitResult(name: name, icon: selectedIcon!));
  }

  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.menu_book,
      Icons.water_drop,
      Icons.directions_walk,
      Icons.fitness_center,
      Icons.self_improvement,
    ];

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
            Text('Icon', style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              children: icons.map((icon) {
                final isSelected = selectedIcon == icon;
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedIcon = icon;
                    });
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: isSelected
                        ? const Color(0xFF00897B)
                        : Colors.black12,
                    foregroundColor: isSelected ? Colors.white : Colors.black54,
                    child: Icon(icon, size: 32),
                  ),
                );
              }).toList(),
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
