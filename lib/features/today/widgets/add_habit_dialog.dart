import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class AddHabitDialog extends StatefulWidget {
  const AddHabitDialog({
    super.key,
    this.initialName,
    this.initialIcon,
  });

  final String? initialName;
  final IconData? initialIcon;

  @override
  State<AddHabitDialog> createState() => _AddHabitDialogState();
}

class _AddHabitDialogState extends State<AddHabitDialog> {
  final _controller = TextEditingController();
  IconData? _selectedIcon;

  bool get canSubmit => _controller.text.trim().isNotEmpty && _selectedIcon != null;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.initialName ?? '';
    _selectedIcon = widget.initialIcon;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.initialName != null;

    return AlertDialog(
      title: Text(isEditing ? 'Edit Habit' : 'Add New Habit'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Habit Name'),
            onChanged: (_) => setState(() {}),
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
          onPressed: canSubmit ? () {
              Navigator.of(context).pop({
                'name': _controller.text.trim(),
                'icon': _selectedIcon,
              });
            } : null,
          child: Text(isEditing ? 'Save' : 'Add'),
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
        child: Icon(icon, color: isSelected ? Colors.white : AppColors.textMuted),
      ),
    );
  }
  
}