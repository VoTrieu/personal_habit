import 'package:flutter/material.dart';
import 'package:personal_habit/features/insights/widgets/insight_stat_cards.dart';

import '../../theme/app_dimensions.dart';
import 'widgets/completion_rate.dart';
import 'widgets/weekly_completion_chart.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Text('Insights', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xl),
            const CompletionRate(),
            const SizedBox(height: AppSpacing.xl),
            const WeeklyCompletionChart(),
            const SizedBox(height: AppSpacing.xl),
            const InsightStatCards()
          ],
        ),
      ),
    );
  }
}
