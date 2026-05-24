import 'package:flutter/material.dart';

const habitColors = [
  Color(0xFF00897B),
  Color(0xFFFF5A4E),
  Color(0xFFFFB020),
  Color(0xFF3F6FE5),
  Color(0xFF6B46C1),
  Color(0xFF16A34A),
];

class HabitColors extends StatelessWidget {
  const HabitColors({
    super.key,
    required this.selectedColor,
    required this.onSelected,
  });

  final Color selectedColor;
  final ValueChanged<Color> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Color', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          alignment: WrapAlignment.spaceAround,
          children: habitColors.map((color) {
            final isSelected = selectedColor == color;
            return InkWell(
              onTap: () => onSelected(color),
              borderRadius: BorderRadius.circular(24),
              child: CircleAvatar(
                radius: 22,
                backgroundColor: color,
                child: isSelected
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
