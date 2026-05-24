import 'package:flutter/material.dart';

import '../../../theme/app_dimensions.dart';

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
        Text('Frequency', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: AppSpacing.md),
        SegmentedButton<String>(
          showSelectedIcon: false,
          style: SegmentedButton.styleFrom(
            minimumSize: const Size(0, AppSizes.frequencyHeight),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.sm),
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
