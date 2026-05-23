import 'package:flutter/material.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({super.key});

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _controller = TextEditingController();
  IconData? _selectedIcon;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Habit Name'),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              _iconOption(Icons.menu_book),
              _iconOption(Icons.water_drop),
              _iconOption(Icons.directions_walk),
              _iconOption(Icons.fitness_center),
              _iconOption(Icons.self_improvement),
            ],
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty && _selectedIcon != null) {
              Navigator.of(context).pop({
                'name': _controller.text,
                'icon': _selectedIcon,
              });
            }
          },
          child: const Text('Add'),
        )
      ],
    );
  }

  Widget _iconOption(IconData icon) {
    final isSelected = _selectedIcon == icon;
    return GestureDetector(
      onTap: () => setState(() => _selectedIcon = icon),
      child: CircleAvatar(
        backgroundColor: isSelected ? Colors.blue : Colors.grey[300],
        child: Icon(icon, color: isSelected ? Colors.white : Colors.black54),
      ),
    );
  }
  
}