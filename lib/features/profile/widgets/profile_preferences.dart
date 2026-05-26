import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_dimensions.dart';

class ProfilePreferences extends StatelessWidget {
  const ProfilePreferences({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsGroup(
      children: [
        SettingsRow(
          icon: Icons.notifications_outlined,
          title: 'Notifications',
          subtitle: 'Manage habit reminders',
        ),
        SettingsRow(
          icon: Icons.palette_outlined,
          title: 'Appearance',
          subtitle: 'App theme and visual style',
        ),
        SettingsRow(
          icon: Icons.info_outline,
          title: 'About',
          subtitle: 'Personal Habit app',
        ),
      ],
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
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
