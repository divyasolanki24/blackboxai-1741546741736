import 'package:get/get.dart';
import 'package:shop_management_app/models/role.dart';
import 'package:shop_management_app/models/permission.dart';
import 'package:shop_management_app/repositories/base_repository.dart';

class RoleRepository extends BaseRepository<Role> {
  // Singleton instance
  static final RoleRepository _instance = RoleRepository._internal();
  factory RoleRepository() => _instance;
  RoleRepository._internal();

  // Additional role-specific state
  final RxList<Permission> availablePermissions = <Permission>[].obs;
  final RxMap<String, List<String>> rolePermissionMap = <String, List<String>>{}.obs;
  final RxInt customRoleCount = 0.obs;

  @override
  String getItemId(Role item) => item.id;

  @override
  Future<void> create(Role role) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      addToCache(role);
      updateRolePermissionMap(role);
      if (!role.isSystem) {
        customRoleCount.value++;
      }
    });
  }

  @override
  Future<void> update(String id, Role role) async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      updateInCache(id, role);
      updateRolePermissionMap(role);
    });
  }

  @override
  Future<void> delete(String id) async {
    await withLoading(() async {
      final role = await getById(id);
      if (role != null && !role.isSystem) {
        // TODO: Implement API call
        await Future.delayed(const Duration(seconds: 1)); // Simulate API call
        removeFromCache(id);
        rolePermissionMap.remove(id);
        customRoleCount.value--;
      } else {
        throw Exception('Cannot delete system role');
      }
    });
  }

  @override
  Future<Role?> getById(String id) async {
    try {
      setLoading(true);
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      return items.firstWhereOrNull((role) => role.id == id);
    } catch (e) {
      handleError(e);
      return null;
    } finally {
      setLoading(false);
    }
  }

  @override
  Future<List<Role>> getAll() async {
    await withLoading(() async {
      // TODO: Implement API call
      await Future.delayed(const Duration(seconds: 1)); // Simulate API call
      
      // Initialize system roles
      final roles = [
        Role.admin(),
        Role.manager(),
        Role.staff(),
      ];
      
      updateCache(roles);
      initializePermissions();
      updateAllRolePermissionMaps();
      return roles;
    });
    return items;
  }

  // Permission management
  void initializePermissions() {
    availablePermissions.assignAll(Permission.allPermissions());
  }

  Future<void> addPermissionToRole(String roleId, Permission permission) async {
    final role = await getById(roleId);
    if (role != null) {
      final updatedPermissions = [...role.permissions, permission];
      await update(
        roleId,
        role.copyWith(permissions: updatedPermissions),
      );
    }
  }

  Future<void> removePermissionFromRole(String roleId, String permissionId) async {
    final role = await getById(roleId);
    if (role != null) {
      final updatedPermissions = role.permissions
          .where((permission) => permission.id != permissionId)
          .toList();
      await update(
        roleId,
        role.copyWith(permissions: updatedPermissions),
      );
    }
  }

  Future<void> updateRolePermissions(String roleId, List<Permission> permissions) async {
    final role = await getById(roleId);
    if (role != null) {
      await update(
        roleId,
        role.copyWith(permissions: permissions),
      );
    }
  }

  // Role permission mapping
  void updateRolePermissionMap(Role role) {
    rolePermissionMap[role.id] = role.permissions.map((p) => p.id).toList();
  }

  void updateAllRolePermissionMaps() {
    rolePermissionMap.clear();
    customRoleCount.value = 0;
    
    for (final role in items) {
      updateRolePermissionMap(role);
      if (!role.isSystem) {
        customRoleCount.value++;
      }
    }
  }

  // Query methods
  List<Role> getSystemRoles() {
    return items.where((role) => role.isSystem).toList();
  }

  List<Role> getCustomRoles() {
    return items.where((role) => !role.isSystem).toList();
  }

  List<Role> searchRoles(String query) {
    return search(query, (role, query) {
      final searchTerm = query.toLowerCase();
      return role.name.toLowerCase().contains(searchTerm) ||
          role.description.toLowerCase().contains(searchTerm);
    });
  }

  bool hasPermission(String roleId, String permissionName) {
    final role = items.firstWhereOrNull((role) => role.id == roleId);
    return role?.hasPermission(permissionName) ?? false;
  }

  List<Permission> getRolePermissions(String roleId) {
    final role = items.firstWhereOrNull((role) => role.id == roleId);
    return role?.permissions ?? [];
  }

  // Role creation helpers
  Future<Role> createCustomRole({
    required String name,
    required String description,
    List<Permission> permissions = const [],
  }) async {
    final role = Role(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      permissions: permissions,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      isSystem: false,
    );
    
    await create(role);
    return role;
  }

  Future<Role> cloneRole(String roleId, {String? newName}) async {
    final sourceRole = await getById(roleId);
    if (sourceRole == null) throw Exception('Source role not found');

    return createCustomRole(
      name: newName ?? 'Copy of ${sourceRole.name}',
      description: sourceRole.description,
      permissions: sourceRole.permissions,
    );
  }

  // Analytics
  Map<String, dynamic> getRoleAnalytics() {
    return {
      'totalRoles': items.length,
      'systemRoles': getSystemRoles().length,
      'customRoles': customRoleCount.value,
      'totalPermissions': availablePermissions.length,
      'rolePermissionDistribution': rolePermissionMap.map(
        (roleId, permissions) => MapEntry(roleId, permissions.length),
      ),
    };
  }

  // Export/Import
  Future<String> exportToJson() async {
    try {
      final exportData = items.map((role) => role.toJson()).toList();
      // TODO: Implement actual export logic
      return '';
    } catch (e) {
      handleError(e);
      return '';
    }
  }

  Future<void> importFromJson(String jsonData) async {
    try {
      // TODO: Implement actual import logic
      await getAll(); // Refresh data after import
    } catch (e) {
      handleError(e);
    }
  }
}
