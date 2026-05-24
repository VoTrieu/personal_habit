import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class HabitReminder extends StatelessWidget {
  const HabitReminder({
    super.key,
    required this.isEnabled,
    required this.onChanged,
  });

  final bool isEnabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Reminder', style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 4),
              Text(
                'Get reminded to stay on track',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.textMuted),
              ),
            ],
          ),
        ),
        Switch(value: isEnabled, onChanged: onChanged),
      ],
    );
  }
}
