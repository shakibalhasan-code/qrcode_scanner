import '../api_endpoints.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final bool verified;
  final String? image;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.verified,
    this.image,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'USER',
      verified: json['verified'] ?? false,
      image: json['image'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toString()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'role': role,
      'verified': verified,
      'image': image,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  // Helper methods
  String get displayName => name.isNotEmpty ? name : 'User';

  String get initials {
    if (name.isEmpty) return 'U';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  bool get isVerified => verified;
  bool get isAdmin => role.toUpperCase() == 'ADMIN';
  bool get isUser => role.toUpperCase() == 'USER';

  String get formattedJoinDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[createdAt.month - 1]} ${createdAt.year}';
  }

  // Helper method to get complete image URL
  String? getFullImageUrl() {
    if (image == null || image!.isEmpty) return null;
    if (image!.startsWith('http')) {
      return image;
    }
    return '${ApiEndpoints.imageUrl}$image';
  }

  // CopyWith method for creating modified copies
  User copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    bool? verified,
    String? image,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      verified: verified ?? this.verified,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, role: $role, verified: $verified}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// User Profile Response model
class UserProfileResponse {
  final bool success;
  final String message;
  final User data;

  UserProfileResponse({
    required this.success,
    required this.message,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: User.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
