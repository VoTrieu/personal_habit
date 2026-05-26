import 'dart:io';

import 'package:flutter/material.dart';

import '../../../models/user_profile.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.profile,
    required this.habitCount,
    required this.completionPercent,
    required this.onEditPressed,
    required this.onAvatarPressed,
  });

  final UserProfile profile;
  final int habitCount;
  final int completionPercent;
  final VoidCallback onEditPressed;
  final VoidCallback onAvatarPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onAvatarPressed,
          borderRadius: BorderRadius.circular(AppRadius.round),
          child: Stack(
            alignment: Alignment.bottomRight,
            children: [
              _ProfileAvatar(avatarPath: profile.avatarPath),
              const CircleAvatar(
                radius: 15,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                child: Icon(Icons.camera_alt_outlined, size: 15),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.lg),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.name,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.xs),
              if (profile.email.isNotEmpty) ...[
                Text(
                  profile.email,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: AppSpacing.xs),
              ],
              Text(profile.bio, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: AppSpacing.sm),
              Text(
                '$habitCount active habit${habitCount == 1 ? '' : 's'} • $completionPercent% complete today',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.primary),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: onEditPressed,
          icon: const Icon(Icons.edit_outlined),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.avatarPath});

  final String? avatarPath;

  @override
  Widget build(BuildContext context) {
    final path = avatarPath;

    if (path != null && File(path).existsSync()) {
      return CircleAvatar(
        radius: AppSizes.profileAvatarRadius,
        backgroundImage: FileImage(File(path)),
      );
    }

    return const CircleAvatar(
      radius: AppSizes.profileAvatarRadius,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.white,
      child: Icon(Icons.person, size: AppSizes.profileAvatarIconSize),
    );
  }
}
