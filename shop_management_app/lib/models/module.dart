class Module {
  final String id;
  final String name;
  final String description;
  final ModuleType type;
  final bool isEnabled;
  final List<String> requiredPermissions;
  final Map<String, dynamic> settings;
  final List<ModuleFeature> features;
  final DateTime createdAt;
  final DateTime updatedAt;

  Module({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    this.isEnabled = true,
    required this.requiredPermissions,
    required this.settings,
    required this.features,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      type: ModuleType.values.firstWhere(
        (type) => type.toString().split('.').last == json['type'],
      ),
      isEnabled: json['is_enabled'] ?? true,
      requiredPermissions: List<String>.from(json['required_permissions']),
      settings: Map<String, dynamic>.from(json['settings']),
      features: (json['features'] as List)
          .map((feature) => ModuleFeature.fromJson(feature))
          .toList(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type.toString().split('.').last,
      'is_enabled': isEnabled,
      'required_permissions': requiredPermissions,
      'settings': settings,
      'features': features.map((feature) => feature.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  Module copyWith({
    String? name,
    String? description,
    ModuleType? type,
    bool? isEnabled,
    List<String>? requiredPermissions,
    Map<String, dynamic>? settings,
    List<ModuleFeature>? features,
  }) {
    return Module(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      type: type ?? this.type,
      isEnabled: isEnabled ?? this.isEnabled,
      requiredPermissions: requiredPermissions ?? this.requiredPermissions,
      settings: settings ?? this.settings,
      features: features ?? this.features,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  // Predefined modules
  static Module shopManagement() {
    return Module(
      id: 'shop_management',
      name: 'Shop Management',
      description: 'Manage shops and their settings',
      type: ModuleType.core,
      requiredPermissions: ['shop.manage'],
      settings: {},
      features: [
        ModuleFeature(
          id: 'shop_creation',
          name: 'Shop Creation',
          isEnabled: true,
          requiredPermissions: ['shop.write'],
        ),
        ModuleFeature(
          id: 'shop_analytics',
          name: 'Shop Analytics',
          isEnabled: true,
          requiredPermissions: ['shop.read'],
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Module inventoryManagement() {
    return Module(
      id: 'inventory_management',
      name: 'Inventory Management',
      description: 'Manage product inventory across shops',
      type: ModuleType.core,
      requiredPermissions: ['inventory.manage'],
      settings: {
        'enable_low_stock_alerts': true,
        'default_minimum_stock': 10,
      },
      features: [
        ModuleFeature(
          id: 'stock_tracking',
          name: 'Stock Tracking',
          isEnabled: true,
          requiredPermissions: ['inventory.read', 'inventory.write'],
        ),
        ModuleFeature(
          id: 'inventory_reports',
          name: 'Inventory Reports',
          isEnabled: true,
          requiredPermissions: ['inventory.read'],
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  static Module userManagement() {
    return Module(
      id: 'user_management',
      name: 'User Management',
      description: 'Manage users, roles, and permissions',
      type: ModuleType.core,
      requiredPermissions: ['user.manage', 'role.manage'],
      settings: {},
      features: [
        ModuleFeature(
          id: 'user_roles',
          name: 'User Roles',
          isEnabled: true,
          requiredPermissions: ['role.read', 'role.write'],
        ),
        ModuleFeature(
          id: 'permission_management',
          name: 'Permission Management',
          isEnabled: true,
          requiredPermissions: ['permission.manage'],
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}

class ModuleFeature {
  final String id;
  final String name;
  final bool isEnabled;
  final List<String> requiredPermissions;

  ModuleFeature({
    required this.id,
    required this.name,
    this.isEnabled = true,
    required this.requiredPermissions,
  });

  factory ModuleFeature.fromJson(Map<String, dynamic> json) {
    return ModuleFeature(
      id: json['id'],
      name: json['name'],
      isEnabled: json['is_enabled'] ?? true,
      requiredPermissions: List<String>.from(json['required_permissions']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'is_enabled': isEnabled,
      'required_permissions': requiredPermissions,
    };
  }
}

enum ModuleType {
  core,
  addon,
  integration,
  custom
}

extension ModuleTypeExtension on ModuleType {
  String get label {
    switch (this) {
      case ModuleType.core:
        return 'Core Module';
      case ModuleType.addon:
        return 'Add-on Module';
      case ModuleType.integration:
        return 'Integration Module';
      case ModuleType.custom:
        return 'Custom Module';
    }
  }

  String get description {
    switch (this) {
      case ModuleType.core:
        return 'Essential system functionality';
      case ModuleType.addon:
        return 'Additional features and functionality';
      case ModuleType.integration:
        return 'Third-party service integration';
      case ModuleType.custom:
        return 'Custom-built module';
    }
  }
}
