import 'package:shop_management_app/models/role.dart';

class User {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? avatarUrl;
  final List<Role> roles;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, dynamic>? metadata;

  User({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.avatarUrl,
    required this.roles,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.metadata,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      avatarUrl: json['avatar_url'],
      roles: (json['roles'] as List).map((role) => Role.fromJson(role)).toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] ?? true,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone_number': phoneNumber,
      'avatar_url': avatarUrl,
      'roles': roles.map((role) => role.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'metadata': metadata,
    };
  }

  User copyWith({
    String? name,
    String? phoneNumber,
    String? avatarUrl,
    List<Role>? roles,
    bool? isActive,
    Map<String, dynamic>? metadata,
  }) {
    return User(
      id: id,
      email: email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      roles: roles ?? this.roles,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
      metadata: metadata ?? this.metadata,
    );
  }

  // Helper methods for permissions
  bool hasRole(String roleName) {
    return roles.any((role) => role.name.toLowerCase() == roleName.toLowerCase());
  }

  bool hasPermission(String permission) {
    return roles.any((role) => role.hasPermission(permission));
  }

  bool hasAnyPermission(List<String> permissions) {
    return roles.any((role) => role.hasAnyPermission(permissions));
  }

  bool hasAllPermissions(List<String> permissions) {
    return roles.any((role) => role.hasAllPermissions(permissions));
  }

  // Helper method to get user initials
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length > 1) {
      return '${nameParts.first[0]}${nameParts.last[0]}'.toUpperCase();
    }
    return name.substring(0, min(2, name.length)).toUpperCase();
  }

  // Helper method to get user status
  UserStatus get status {
    if (!isActive) return UserStatus.inactive;
    if (roles.isEmpty) return UserStatus.pending;
    return UserStatus.active;
  }
}

enum UserStatus {
  active,
  inactive,
  pending
}

extension UserStatusExtension on UserStatus {
  String get label {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
      case UserStatus.pending:
        return 'Pending';
    }
  }

  String get color {
    switch (this) {
      case UserStatus.active:
        return '#4CAF50'; // Green
      case UserStatus.inactive:
        return '#F44336'; // Red
      case UserStatus.pending:
        return '#FFC107'; // Yellow
    }
  }
}

// Helper function to get minimum of two integers
int min(int a, int b) => a < b ? a : b;
