import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xl),
            CircleAvatar(
              radius: AppSizes.profileAvatarRadius,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              child: const Icon(
                Icons.person,
                size: AppSizes.profileAvatarIconSize,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Text(
                'Habit Builder',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.notifications_outlined),
              title: Text('Notifications'),
              trailing: Icon(Icons.chevron_right),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.palette_outlined),
              title: Text('Appearance'),
              trailing: Icon(Icons.chevron_right),
            ),
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline),
              title: Text('About'),
              trailing: Icon(Icons.chevron_right),
            ),
          ],
        ),
      ),
    );
  }
}
