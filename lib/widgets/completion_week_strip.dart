import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_dimensions.dart';

class CompletionWeekStrip extends StatelessWidget {
  final List<CompletionDay> days;
  final String? title;
  final bool showBorder;

  const CompletionWeekStrip({
    super.key,
    required this.days,
    this.title,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days.map((day) => _CompletionDayItem(day: day)).toList(),
    );

    final child = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.md),
        ],
        content,
      ],
    );

    if (!showBorder) {
      return child;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.fieldVertical,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: child,
    );
  }
}

class CompletionDay {
  final String label;
  final String date;
  final bool isCompleted;
  final bool isToday;

  const CompletionDay({
    required this.label,
    required this.date,
    this.isToday = false,
    this.isCompleted = false,
  });
}

class _CompletionDayItem extends StatelessWidget {
  const _CompletionDayItem({required this.day});

  final CompletionDay day;

  @override
  Widget build(BuildContext context) {
    final isFilled = day.isCompleted || day.isToday;

    return Column(
      children: [
        Text(day.label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xxs),
        Text(day.date, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: AppSpacing.sm),
        CircleAvatar(
          radius: AppSizes.weekDayRadius,
          backgroundColor: isFilled ? AppColors.primary : AppColors.transparent,
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
