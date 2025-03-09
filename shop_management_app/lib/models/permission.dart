class Permission {
  final String id;
  final String name;
  final String description;
  final String resource;
  final PermissionAction action;
  final DateTime createdAt;
  final DateTime updatedAt;

  Permission({
    required this.id,
    required this.name,
    required this.description,
    required this.resource,
    required this.action,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Permission.fromJson(Map<String, dynamic> json) {
    return Permission(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      resource: json['resource'],
      action: PermissionAction.values.firstWhere(
        (action) => action.toString().split('.').last == json['action'],
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'resource': resource,
      'action': action.toString().split('.').last,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  // Factory methods for common permissions
  static Permission read(String resource) {
    return Permission(
      id: '${resource}_read',
      name: '${resource.capitalize} Read',
      description: 'Can read ${resource.toLowerCase()}',
      resource: resource.toLowerCase(),
      action: PermissionAction.read,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Permission write(String resource) {
    return Permission(
      id: '${resource}_write',
      name: '${resource.capitalize} Write',
      description: 'Can create and update ${resource.toLowerCase()}',
      resource: resource.toLowerCase(),
      action: PermissionAction.write,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Permission delete(String resource) {
    return Permission(
      id: '${resource}_delete',
      name: '${resource.capitalize} Delete',
      description: 'Can delete ${resource.toLowerCase()}',
      resource: resource.toLowerCase(),
      action: PermissionAction.delete,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Permission manage(String resource) {
    return Permission(
      id: '${resource}_manage',
      name: '${resource.capitalize} Manage',
      description: 'Can manage all aspects of ${resource.toLowerCase()}',
      resource: resource.toLowerCase(),
      action: PermissionAction.manage,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  // Get all permissions for the system
  static List<Permission> allPermissions() {
    final resources = [
      'shop',
      'product',
      'inventory',
      'user',
      'role',
      'permission',
      'module'
    ];

    final List<Permission> permissions = [];
    
    for (final resource in resources) {
      permissions.addAll([
        read(resource),
        write(resource),
        delete(resource),
        manage(resource),
      ]);
    }

    return permissions;
  }

  // Helper method to check if this permission includes another permission
  bool includes(Permission other) {
    if (resource != other.resource) return false;
    
    // Manage action includes all other actions
    if (action == PermissionAction.manage) return true;
    
    // Write action includes read action
    if (action == PermissionAction.write && other.action == PermissionAction.read) {
      return true;
    }

    return action == other.action;
  }
}

enum PermissionAction {
  read,
  write,
  delete,
  manage
}

extension PermissionActionExtension on PermissionAction {
  String get label {
    switch (this) {
      case PermissionAction.read:
        return 'Read';
      case PermissionAction.write:
        return 'Write';
      case PermissionAction.delete:
        return 'Delete';
      case PermissionAction.manage:
        return 'Manage';
    }
  }

  String get description {
    switch (this) {
      case PermissionAction.read:
        return 'Can view and list resources';
      case PermissionAction.write:
        return 'Can create and update resources';
      case PermissionAction.delete:
        return 'Can delete resources';
      case PermissionAction.manage:
        return 'Has full control over resources';
    }
  }
}

extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}
