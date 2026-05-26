import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/habit_controller.dart';
import '../../controllers/profile_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';
import '../../widgets/app_stat_card.dart';
import 'edit_profile_screen.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_preferences.dart';
import 'widgets/profile_progress_card.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HabitController>();
    final profileController = context.watch<ProfileController>();
    final habits = controller.habits;
    final profile = profileController.profile;
    final totalCompletions = habits.fold<int>(
      0,
      (total, habit) => total + habit.streak,
    );
    final reminderCount = habits.where((habit) => habit.reminderEnabled).length;
    final completionPercent = (controller.completionProgress * 100).round();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xl),
            ProfileHeader(
              profile: profile,
              habitCount: habits.length,
              completionPercent: completionPercent,
              onEditPressed: () => openEditProfile(context),
              onAvatarPressed: () => pickAvatar(context),
            ),
            const SizedBox(height: AppSpacing.xl),
            ProfileProgressCard(
              completedCount: controller.completedCount,
              totalCount: habits.length,
              progress: controller.completionProgress,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: AppStatCard(
                    title: 'Best streak',
                    value: '${controller.bestStreak}',
                    icon: Icons.local_fire_department,
                    iconColor: AppColors.habitAmber,
                    backgroundColor: AppColors.insightAmberBackground,
                    iconPosition: AppStatCardIconPosition.start,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: AppStatCard(
                    title: 'Completions',
                    value: '$totalCompletions',
                    icon: Icons.check_circle_outline,
                    iconColor: AppColors.habitCoral,
                    backgroundColor: AppColors.insightCoralBackground,
                    iconPosition: AppStatCardIconPosition.start,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppStatCard(
              title: 'Reminder${reminderCount == 1 ? '' : 's'} enabled',
              value: '$reminderCount',
              icon: Icons.notifications_active_outlined,
              iconColor: AppColors.primary,
              backgroundColor: AppColors.insightTealBackground,
              iconPosition: AppStatCardIconPosition.start,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Preferences', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: AppSpacing.md),
            const ProfilePreferences(),
          ],
        ),
      ),
    );
  }

  Future<void> openEditProfile(BuildContext context) async {
    final profile = context.read<ProfileController>().profile;

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditProfileScreen(profile: profile),
      ),
    );
  }

  Future<void> pickAvatar(BuildContext context) async {
    await context.read<ProfileController>().pickAvatar();
  }
}
