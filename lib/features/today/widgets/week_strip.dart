import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class WeekStrip extends StatelessWidget {
  const WeekStrip({super.key});

  static const days = [
    _WeekDay(label: 'Mon', date: '18', isCompleted: true),
    _WeekDay(label: 'Tue', date: '19', isCompleted: true),
    _WeekDay(label: 'Wed', date: '20', isCompleted: true),
    _WeekDay(label: 'Thu', date: '21', isCompleted: false),
    _WeekDay(label: 'Fri', date: '22', isToday: true),
    _WeekDay(label: 'Sat', date: '23', isCompleted: false),
    _WeekDay(label: 'Sun', date: '24', isCompleted: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.fieldVertical,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) => _WeekDayItem(day: day)).toList(),
      ),
    );
  }
}

class _WeekDayItem extends StatelessWidget {
  final _WeekDay day;

  const _WeekDayItem({required this.day});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isFilled = day.isToday || day.isCompleted;

    return Column(
      children: [
        Text(day.label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xxs),
        Text(day.date, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        CircleAvatar(
          radius: AppSizes.weekDayRadius,
          backgroundColor: isFilled
              ? colorScheme.primary
              : AppColors.transparent,
          foregroundColor: isFilled ? AppColors.white : AppColors.iconSubtle,
          child: day.isCompleted
              ? const Icon(Icons.check, size: AppSizes.weekCheckIconSize)
              : Text(
                  day.date,
                  style: const TextStyle(fontSize: AppSizes.weekDateFontSize),
                ),
        ),
      ],
    );
  }
}

class _WeekDay {
  final String label;
  final String date;
  final bool isToday;
  final bool isCompleted;

  const _WeekDay({
    required this.label,
    required this.date,
    this.isToday = false,
    this.isCompleted = false,
  });
}
