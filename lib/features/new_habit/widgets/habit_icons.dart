import 'package:flutter/material.dart';

const habitIcons = [
  Icons.menu_book,
  Icons.water_drop,
  Icons.directions_walk,
  Icons.fitness_center,
  Icons.self_improvement,
  Icons.language,
];

class HabitIcons extends StatelessWidget {
  const HabitIcons({
    super.key,
    required this.selectedIcon,
    required this.onSelected,
  });

  final IconData selectedIcon;
  final ValueChanged<IconData> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Icon', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          alignment: WrapAlignment.spaceAround,
          children: habitIcons.map((icon) {
            final isSelected = selectedIcon == icon;
            return InkWell(
              onTap: () => onSelected(icon),
              borderRadius: BorderRadius.circular(28),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: isSelected
                    ? const Color(0xFF00897B)
                    : Colors.black12,
                foregroundColor: isSelected ? Colors.white : Colors.black54,
                child: Icon(icon),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
