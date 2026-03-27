/// User data model representing user information
class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profilePictureUrl;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profilePictureUrl,
    required this.createdAt,
  });

  /// Convert UserModel to JSON
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      profilePictureUrl: json['profilePictureUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// Create a copy of UserModel with updated fields
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profilePictureUrl,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
