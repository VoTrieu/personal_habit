import 'package:flutter/material.dart';

const habitFrequencies = ['Daily', 'Weekday', 'Weekly', 'Custom'];

class HabitFrequencies extends StatelessWidget {
  const HabitFrequencies({
    super.key,
    required this.selectedFrequency,
    required this.onSelected,
  });

  final String selectedFrequency;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Frequency', style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 12),
        SegmentedButton<String>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            minimumSize: const Size(0, 52),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          segments: habitFrequencies.map((frequency) {
            return ButtonSegment<String>(
              value: frequency,
              label: Text(
                frequency,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          selected: {selectedFrequency},
          onSelectionChanged: (selection) {
            onSelected(selection.first);
          },
        ),
      ],
    );
  }
}
