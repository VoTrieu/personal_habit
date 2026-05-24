import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class InsightStatCards extends StatelessWidget {
  const InsightStatCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: _InsightStatCard(
            title: 'Best streak',
            value: '12 days',
            subtitle: 'Read 20 pages',
            icon: Icons.local_fire_department,
            iconColor: AppColors.habitAmber,
          ),
        ),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: _InsightStatCard(
            title: 'Total completions',
            value: '126',
            subtitle: 'All habits',
            icon: Icons.check_circle_outline,
            iconColor: AppColors.habitCoral,
          ),
        ),
      ],
    );
  }
}

class _InsightStatCard extends StatelessWidget {
  const _InsightStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.optionBackground,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: AppSpacing.sm),
                Text(value, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: AppSpacing.xs),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(icon, color: iconColor),
        ],
      ),
    );
  }
}