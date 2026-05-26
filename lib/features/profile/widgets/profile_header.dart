import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.habitCount,
    required this.completionPercent,
  });

  final int habitCount;
  final int completionPercent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const CircleAvatar(
          radius: AppSizes.profileAvatarRadius,
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
          child: Icon(Icons.person, size: AppSizes.profileAvatarIconSize),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Habit Builder',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$habitCount active habit${habitCount == 1 ? '' : 's'}',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$completionPercent% complete today',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
