import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/habit_controller.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class WeeklyCompletionChart extends StatelessWidget {
  const WeeklyCompletionChart({super.key});

  static const labels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(values.length, (index) {
                  return Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: FractionallySizedBox(
                              heightFactor: values[index],
                              child: Container(
                                width: AppSizes.weeklyChartBarWidth,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(
                                    AppRadius.sm,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          labels[index],
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ],
    );
  }
}
