import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/profile_controller.dart';
import '../../models/user_profile.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_dimensions.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final UserProfile profile;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameController;
  late final TextEditingController emailController;
  late final TextEditingController bioController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
    bioController = TextEditingController(text: widget.profile.bio);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<ProfileController>().profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppSpacing.screen),
          children: [
            Center(
              child: InkWell(
                onTap: pickAvatar,
                borderRadius: BorderRadius.circular(AppRadius.round),
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    _ProfileAvatar(avatarPath: profile.avatarPath),
                    const CircleAvatar(
                      radius: 18,
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      child: Icon(Icons.camera_alt_outlined, size: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            TextField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Bio',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FilledButton(
              onPressed: saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> pickAvatar() async {
    await context.read<ProfileController>().pickAvatar();
  }

  Future<void> saveProfile() async {
    await context.read<ProfileController>().saveProfile(
      name: nameController.text,
      email: emailController.text,
      bio: bioController.text,
    );

    if (!mounted) return;

    Navigator.pop(context);
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
