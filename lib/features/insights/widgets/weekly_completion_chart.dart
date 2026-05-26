import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/habit_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class WeeklyCompletionChart extends StatelessWidget {
  const WeeklyCompletionChart({super.key});

  static const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  static const percentages = ['100%', '75%', '50%', '25%', '0%'];

  @override
  Widget build(BuildContext context) {
    final controller = context.read<HabitController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completions this week',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        FutureBuilder<List<double>>(
          future: controller.weeklyCompletionRates(),
          builder: (context, snapshot) {
            final values = snapshot.data ?? List.filled(7, 0.0);

            return Container(
              height: AppSizes.weeklyChartHeight,
              padding: const EdgeInsets.all(AppSpacing.lg),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.borderLight),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(
                    width: AppSizes.weeklyChartAxisWidth,
                    child: _PercentageAxis(labels: percentages),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(child: _ChartBars(values: values)),
                        const SizedBox(height: AppSpacing.sm),
                        const _WeekdayLabels(labels: labels),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _PercentageAxis extends StatelessWidget {
  const _PercentageAxis({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: labels.map((label) {
              return Text(label, style: Theme.of(context).textTheme.bodySmall);
            }).toList(),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        const SizedBox(height: AppSizes.weeklyChartWeekdayLabelHeight),
      ],
    );
  }
}

class _ChartBars extends StatelessWidget {
  const _ChartBars({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const _ChartGridLines(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(values.length, (index) {
            return Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: FractionallySizedBox(
                  heightFactor: values[index],
                  child: Container(
                    width: AppSizes.weeklyChartBarWidth,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _ChartGridLines extends StatelessWidget {
  const _ChartGridLines();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(5, (index) {
        return Container(
          height: AppSizes.weeklyChartGridLineHeight,
          color: AppColors.borderLight,
        );
      }),
    );
  }
}

class _WeekdayLabels extends StatelessWidget {
  const _WeekdayLabels({required this.labels});

  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSizes.weeklyChartWeekdayLabelHeight,
      child: Row(
        children: labels.map((label) {
          return Expanded(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          );
        }).toList(),
      ),
    );
  }
}
