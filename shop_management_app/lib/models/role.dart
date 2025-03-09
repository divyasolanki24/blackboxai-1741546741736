import 'package:shop_management_app/models/permission.dart';

class Role {
  final String id;
  final String name;
  final String description;
  final List<Permission> permissions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final bool isSystem;

  Role({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.isSystem = false,
  });

  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      permissions: (json['permissions'] as List)
          .map((permission) => Permission.fromJson(permission))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      isActive: json['is_active'] ?? true,
      isSystem: json['is_system'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'permissions': permissions.map((permission) => permission.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'is_active': isActive,
      'is_system': isSystem,
    };
  }

  Role copyWith({
    String? name,
    String? description,
    List<Permission>? permissions,
    bool? isActive,
  }) {
    return Role(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      permissions: permissions ?? this.permissions,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      isActive: isActive ?? this.isActive,
      isSystem: isSystem,
    );
  }

  // Permission check methods
  bool hasPermission(String permissionName) {
    return permissions.any(
      (permission) => permission.name.toLowerCase() == permissionName.toLowerCase(),
    );
  }

  bool hasAnyPermission(List<String> permissionNames) {
    return permissionNames.any((name) => hasPermission(name));
  }

  bool hasAllPermissions(List<String> permissionNames) {
    return permissionNames.every((name) => hasPermission(name));
  }

  // Predefined system roles
  static Role admin() {
    return Role(
      id: 'admin',
      name: 'Administrator',
      description: 'Full system access',
      permissions: Permission.allPermissions(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSystem: true,
    );
  }

  static Role manager() {
    return Role(
      id: 'manager',
      name: 'Manager',
      description: 'Shop management access',
      permissions: [
        Permission.read('shop'),
        Permission.write('shop'),
        Permission.read('product'),
        Permission.write('product'),
        Permission.read('inventory'),
        Permission.write('inventory'),
        Permission.read('user'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSystem: true,
    );
  }

  static Role staff() {
    return Role(
      id: 'staff',
      name: 'Staff',
      description: 'Basic shop operations',
      permissions: [
        Permission.read('shop'),
        Permission.read('product'),
        Permission.read('inventory'),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSystem: true,
    );
  }
}

// Role types for quick reference
enum RoleType {
  admin,
  manager,
  staff,
  custom
}

extension RoleTypeExtension on RoleType {
  String get label {
    switch (this) {
      case RoleType.admin:
        return 'Administrator';
      case RoleType.manager:
        return 'Manager';
      case RoleType.staff:
        return 'Staff';
      case RoleType.custom:
        return 'Custom';
    }
  }

  Role createRole() {
    switch (this) {
      case RoleType.admin:
        return Role.admin();
      case RoleType.manager:
        return Role.manager();
      case RoleType.staff:
        return Role.staff();
      case RoleType.custom:
        return Role(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: 'Custom Role',
          description: 'Custom role with specific permissions',
          permissions: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
    }
  }
}
