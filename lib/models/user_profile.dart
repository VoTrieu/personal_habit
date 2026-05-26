class UserProfile {
  static const defaultId = 'main';

  final String id;
  final String name;
  final String email;
  final String bio;
  final String? avatarPath;

  const UserProfile({
    this.id = defaultId,
    required this.name,
    required this.email,
    required this.bio,
    this.avatarPath,
  });

  const UserProfile.empty()
    : id = defaultId,
      name = 'Habit Builder',
      email = '',
      bio = 'Building better habits every day.',
      avatarPath = null;

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? bio,
    String? avatarPath,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      avatarPath: avatarPath ?? this.avatarPath,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'bio': bio,
      'avatarPath': avatarPath,
    };
  }

  factory UserProfile.fromMap(Map<String, Object?> map) {
    return UserProfile(
      id: map['id'] as String,
      name: map['name'] as String,
      email: map['email'] as String,
      bio: map['bio'] as String,
      avatarPath: map['avatarPath'] as String?,
    );
  }
}
