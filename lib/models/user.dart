class User {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String? company;
  final bool emailNotifications;
  final bool pushNotifications;
  final DateTime createdAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    this.company,
    required this.emailNotifications,
    required this.pushNotifications,
    required this.createdAt,
  });

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? company,
    bool? emailNotifications,
    bool? pushNotifications,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      company: company ?? this.company,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}