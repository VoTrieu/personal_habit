import 'package:flutter/material.dart';

import '../theme/app_dimensions.dart';

enum AppStatCardIconPosition { start, end }

class AppStatCard extends StatelessWidget {
  const AppStatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    this.subtitle,
    this.iconPosition = AppStatCardIconPosition.end,
  });

  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final AppStatCardIconPosition iconPosition;

  @override
  Widget build(BuildContext context) {
    final iconWidget = Icon(icon, color: iconColor);
    final textContent = Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
          ],
        ],
      ),
    );

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: iconPosition == AppStatCardIconPosition.start
            ? [iconWidget, const SizedBox(width: AppSpacing.md), textContent]
            : [textContent, iconWidget],
      ),
    );
  }
}
