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
      children: days.map((day) {
        return Expanded(child: _CompletionDayItem(day: day));
      }).toList(),
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
    final circleSize = AppSizes.weekDayRadius * 2;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(day.label, style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(height: AppSpacing.xxs),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(day.date, style: Theme.of(context).textTheme.bodySmall),
        ),
        const SizedBox(height: AppSpacing.sm),
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isFilled ? AppColors.primary : AppColors.transparent,
            border: Border.all(
              color: isFilled ? AppColors.primary : AppColors.borderLight,
            ),
          ),
          child: Center(child: _CompletionDayCircleContent(day: day)),
        ),
      ],
    );
  }
}

class _CompletionDayCircleContent extends StatelessWidget {
  const _CompletionDayCircleContent({required this.day});

  final CompletionDay day;

  @override
  Widget build(BuildContext context) {
    if (day.isToday) {
      return Text(
        day.date,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: AppSizes.weekDateFontSize,
          fontWeight: FontWeight.w600,
        ),
      );
    }

    if (day.isCompleted) {
      return const Icon(
        Icons.check,
        color: AppColors.white,
        size: AppSizes.weekCheckIconSize,
      );
    }

    return const SizedBox.shrink();
  }
}
