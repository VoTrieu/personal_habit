import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../controllers/habit_controller.dart';
import '../../../models/habit.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';
import '../../../utils/time_formatters.dart';
import '../../../widgets/habit_colors.dart';

class ProfilePreferences extends StatelessWidget {
  const ProfilePreferences({super.key});

  @override
  Widget build(BuildContext context) {
    final reminders = context
        .watch<HabitController>()
        .habits
        .where((habit) => habit.reminderEnabled)
        .toList();

    return SettingsGroup(
      children: [
        SettingsRow(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage habit reminders',
          onTap: () => showRemindersSheet(context, reminders),
        ),
        SettingsRow(
          icon: Icons.palette_outlined,
          title: 'Appearance',
          subtitle: 'App theme and visual style',
          onTap: () => showAppearanceSheet(context),
        ),
        SettingsRow(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'Personal Habit app',
          onTap: () => showAboutDialog(context),
        ),
      ],
    );
  }

  void showRemindersSheet(BuildContext context, List<Habit> reminders) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.screen,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Notifications',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                if (reminders.isEmpty)
                  Text(
                    'No habit reminders are enabled.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                else
                  ...reminders.map((habit) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: habit.color,
                        foregroundColor: AppColors.white,
                        child: Icon(habit.icon),
                      ),
                      title: Text(habit.name),
                      subtitle: Text(formatTimeOfDay(habit.reminderTime)),
                      trailing: const Icon(Icons.notifications_active_outlined),
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAppearanceSheet(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screen,
              0,
              AppSpacing.screen,
              AppSpacing.screen,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.md),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(
                    Icons.light_mode_outlined,
                    color: AppColors.primary,
                  ),
                  title: const Text('Light'),
                  subtitle: const Text('Current app theme'),
                  trailing: const Icon(Icons.check, color: AppColors.primary),
                ),
                const SizedBox(height: AppSpacing.md),
                const HabitColors(selectedColor: null, onSelected: null),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAboutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Personal Habit'),
          content: const Text(
            'A simple habit tracker for daily progress, streaks, reminders, and weekly insights.\n\nVersion 1.0.0',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

class SettingsGroup extends StatelessWidget {
  const SettingsGroup({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(children: children),
    );
  }
}

class SettingsRow extends StatelessWidget {
  const SettingsRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
