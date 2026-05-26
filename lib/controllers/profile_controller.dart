import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../data/habit_database.dart';
import '../models/user_profile.dart';

class ProfileController extends ChangeNotifier {
  ProfileController({HabitDatabase? database, ImagePicker? imagePicker})
    : _database = database ?? HabitDatabase(),
      _imagePicker = imagePicker ?? ImagePicker();

  final HabitDatabase _database;
  final ImagePicker _imagePicker;

  UserProfile _profile = const UserProfile.empty();
  bool _isLoading = false;

  UserProfile get profile => _profile;
  bool get isLoading => _isLoading;

  Future<void> loadProfile() async {
    _isLoading = true;
    notifyListeners();

    try {
      _profile = await _database.getUserProfile();
    } catch (error) {
      debugPrint('Failed to load profile: $error');
      _profile = const UserProfile.empty();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> saveProfile({
    required String name,
    required String email,
    required String bio,
  }) async {
    final updatedProfile = _profile.copyWith(
      name: name.trim().isEmpty ? 'Habit Builder' : name.trim(),
      email: email.trim(),
      bio: bio.trim(),
    );

    await _saveProfile(updatedProfile);
  }

  Future<void> pickAvatar() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 900,
      );

      if (image == null) return;

      final copiedPath = await _copyAvatarToAppDirectory(image.path);
      await _saveProfile(_profile.copyWith(avatarPath: copiedPath));
    } catch (error) {
      debugPrint('Failed to pick avatar: $error');
    }
  }

  Future<void> _saveProfile(UserProfile profile) async {
    await _database.saveUserProfile(profile);
    _profile = profile;
    notifyListeners();
  }

  Future<String> _copyAvatarToAppDirectory(String sourcePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final extension = path.extension(sourcePath);
    final avatarPath = path.join(directory.path, 'profile_avatar$extension');

    await File(sourcePath).copy(avatarPath);
    return avatarPath;
  }
}
